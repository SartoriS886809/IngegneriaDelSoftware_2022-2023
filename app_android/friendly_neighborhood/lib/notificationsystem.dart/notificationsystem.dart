//Singlenton class
import 'dart:async';

import 'package:friendly_neighborhood/API_Manager/api_manager.dart';
import 'package:friendly_neighborhood/cache_manager/profile_db.dart';
import 'package:friendly_neighborhood/cache_manager/report_db.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:friendly_neighborhood/model/localuser.dart';
import 'package:friendly_neighborhood/model/report.dart';

/*
* Classe NotificationSystem:
* Gestisce il funzionamento del sistema di notifica
*/
class NotificationSystem {
  static final NotificationSystem _instance = NotificationSystem._internal();
  final LocalUserManager lum = LocalUserManager();
  final ReportDataManager rdm = ReportDataManager();

  List<Report> _downloadedList = [];
  // int _idNot = 0;
  bool isStarted = false;
  //Per migliorare le performance dell'app
  String _userToken = "";

  factory NotificationSystem() {
    return _instance;
  }
  NotificationSystem._internal();

/*
* Metodo start
* Carica i dati salvati in locale ed esegue il test sulla validità del token 
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
    }
  }

/*
* Metodo downloadReports
* Scarica i dati dei reports nel proprio quartiere
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

/*
* Metodo elaborateDataList
* Esegue il confronto tra i dati salvati in locale e quelli appena scaricati.
* Invia una notifica per ogni nuova segnalazione
*/
  Future<void> elaborateDataList(FlutterLocalNotificationsPlugin flnp) async {
    try {
      if (!await downloadReports()) {
        /*showNotificationWithDefaultSound(
            flnp, "Errore", "Errore nel download segnalazioni", true);*/
        return;
      }
    } catch (e) {
      showNotificationWithDefaultSound(flnp, "Errore", e.toString(), true);
      if (e.toString() == "the user does not exist") {
        showNotificationWithDefaultSound(
            flnp,
            "Errore",
            "Rieseguire il login, per rimanere sintonizzati con le nuove segnalazioni del quartiere",
            true);
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

/*
* Metodo sendNotificationReport
* Formatta la notifica per mostrare la segnalazione
*/
  void sendNotificationReport(Report r, FlutterLocalNotificationsPlugin flnp) {
    String message =
        "Categoria: ${r.category}\nIndirizzo:${r.address}\nCreato da: ${r.creator}";
    showNotificationWithDefaultSound(flnp, r.title, message, true);
  }

/*
* Metodo showNotificationWithDefaultSound
* Invia la notifica con le informazioni passate per parametro
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
