//Singlenton class
import 'dart:async';

//import 'package:flutter/material.dart';
import 'package:friendly_neighborhood/API_Manager/api_manager.dart';
import 'package:friendly_neighborhood/cache_manager/profile_db.dart';
import 'package:friendly_neighborhood/cache_manager/report_db.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
//import 'package:friendly_neighborhood/configuration/configuration.dart';
import 'package:friendly_neighborhood/model/localuser.dart';
import 'package:friendly_neighborhood/model/report.dart';
//import 'package:timezone/timezone.dart' as tz;
//import 'package:timezone/data/latest.dart' as tz;

class NotificationSystem {
  static final NotificationSystem _instance = NotificationSystem._internal();
  final LocalUserManager lum = LocalUserManager();
  final ReportDataManager rdm = ReportDataManager();
  // final FlutterLocalNotificationsPlugin _localNotificationsPlugin =
  //    FlutterLocalNotificationsPlugin();
  /*Stream timer = Stream<bool>.periodic(
      Configuration.NotificationRefreshTimer, ((clock) => true));
  StreamSubscription? event;*/

  List<Report> _downloadedList = [];
  // int _idNot = 0;
  bool isStarted = false;
  //Per migliorare le performance dell'app
  String _userToken = "";

  factory NotificationSystem() {
    return _instance;
  }
  NotificationSystem._internal() {
    /*   _setup();
    tz.initializeTimeZones();
    _localNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()!
        .requestPermission();*/
  }
/*
  Future<void> _setup() async {
    const androidSetting = AndroidInitializationSettings('@mipmap/ic_launcher');

    const initSettings = InitializationSettings(android: androidSetting);

    await _localNotificationsPlugin.initialize(
        initSettings); /*.then((_) {
      print('setupPlugin: setup success');
    }).catchError((Object error) {
      print('Error: $error');
    });*/
  }
*/
  Future start() async {
    if (!isStarted) {
      LocalUser? user = await lum.getUser();
      if (user == null) return;
      bool isValidSession = false;
      try {
        isValidSession = await API_Manager.checkToken(user.email, user.token);
      } catch (e) {
        return;
      }
      if (!isValidSession) return;
      _userToken = user.token;
      isStarted = true;
      return Future.value(true);
      /* event = timer.listen((event) {
        elaborateDataList();
      });*/
    }
  }

  /*
  void stop() {
    isStarted = false;
    _userToken = "";
    _downloadedList = [];
if (event != null) {
      event!.cancel();
      event = null;
    }
  }
*/
  //Può generare eccezioni, se viene il messaggio "user does not exist" terminare il servizio
  Future<bool> downloadReports() async {
    await start();
    if (_userToken == "") {
      _downloadedList = [];
      return false;
    }
    try {
      _downloadedList = List<Report>.from(await API_Manager.listOfElements(
          _userToken, ELEMENT_TYPE.REPORTS, false));
    } catch (e) {
      rethrow;
    }
    return true;
  }

  Future<void> elaborateDataList(FlutterLocalNotificationsPlugin flnp) async {
    try {
      if (!await downloadReports()) {
        showNotificationWithDefaultSound(
            flnp, "Errore", "Errore nel download segnalazioni", true);
      }
    } catch (e) {
      showNotificationWithDefaultSound(flnp, "Errore", e.toString(), true);
      if (e.toString() == "the user does not exist") {
        showNotificationWithDefaultSound(
            flnp,
            "Errore",
            "Rieseguire il login, per rimanere sintonizzati con le nuove segnalazioni del quartiere",
            true);
        //stop();
      }
      return;
    }
    List<Report> fromDB = await rdm.getReport();

    if (_downloadedList.isNotEmpty) {
      if (fromDB.isEmpty) {
        for (Report r in _downloadedList) {
          sendNotificationReport(r, flnp);
        }
      } else {
        for (Report r in _downloadedList) {
          if (!fromDB.contains(r)) {
            sendNotificationReport(r, flnp);
          } else {
            break;
          }
        }
      }
    }
    await rdm.cleanDB();
    rdm.insertListOfReports(_downloadedList);
  }

  void sendNotificationReport(Report r, FlutterLocalNotificationsPlugin flnp) {
    String message =
        "Categoria: ${r.category}\nIndirizzo:${r.address}\nCreato da: ${r.creator}";
    showNotificationWithDefaultSound(
        flnp, r.title, message, true); //da cambiare configurazione
  }

/*
  Future sendNotificationReport(Report r) async {
    bool? permission = await _localNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()!
        .requestPermission();
    //Se non ci sono i permessi, non invia nessuna notifica
    if (permission != null && !permission) return;

    const androidDetail = AndroidNotificationDetails(
        "1", // channel Id
        "Segnalazioni" // channel Name
        //largeIcon:  
        );

    const noticeDetail = NotificationDetails(
      android: androidDetail,
    );

    await _localNotificationsPlugin.zonedSchedule(
      _idNot++,
      r.title,
      r.address,
      tz.TZDateTime.now(tz.local).add(const Duration(seconds: 1)),
      noticeDetail,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      androidAllowWhileIdle: true,
    );
  }

  Future sendNotification(String message) async {
    print("here");
    bool? permission = await _localNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()!
        .requestPermission();
    //Se non ci sono i permessi, non invia nessuna notifica
    if (permission != null && !permission) return;

    const androidDetail = AndroidNotificationDetails(
        "2", // channel Id
        "Avvisi" // channel Name
        );

    const noticeDetail = NotificationDetails(
      android: androidDetail,
    );

    await _localNotificationsPlugin.zonedSchedule(
      _idNot++,
      "Avviso",
      message,
      tz.TZDateTime.now(tz.local).add(const Duration(seconds: 1)),
      noticeDetail,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      androidAllowWhileIdle: true,
    );
  }
*/
  static Future showNotificationWithDefaultSound(
      FlutterLocalNotificationsPlugin flnp,
      String title,
      String message,
      bool withSound) async {
    AndroidNotificationDetails androidPlatformChannelSpecifics;
    if (withSound) {
      androidPlatformChannelSpecifics = const AndroidNotificationDetails(
          "0", "FriendlyNeighoborhood",
          importance: Importance.high,
          priority: Priority.high,
          playSound: true);
    } else {
      androidPlatformChannelSpecifics = const AndroidNotificationDetails(
          "0", "FriendlyNeighoborhood-no-sound",
          importance: Importance.high,
          priority: Priority.high,
          playSound: false);
    }

    var platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
    );
    await flnp.show(0, title, message, platformChannelSpecifics,
        payload: 'Default_Sound');
  }
}
