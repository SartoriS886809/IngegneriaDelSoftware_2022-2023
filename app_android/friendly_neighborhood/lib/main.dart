// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:friendly_neighborhood/API_Manager/api_manager.dart';
import 'package:friendly_neighborhood/cache_manager/profile_db.dart';
import 'package:friendly_neighborhood/core/core.dart';
import 'package:friendly_neighborhood/first_page/login_screen.dart';
import 'package:friendly_neighborhood/model/localuser.dart';
import 'package:friendly_neighborhood/notificationsystem.dart/notificationsystem.dart';
import 'package:friendly_neighborhood/utils/alertdialog.dart';
import 'package:friendly_neighborhood/utils/check_connection.dart';
import 'package:workmanager/workmanager.dart';

@pragma(
    'vm:entry-point') // Mandatory if the App is obfuscated or using Flutter 3.1+
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    //print("Native called background task: $task with $inputData"); //simpleTask will be emitted here.
    FlutterLocalNotificationsPlugin flip = FlutterLocalNotificationsPlugin();
    var android = const AndroidInitializationSettings('@mipmap/ic_launcher');
    var settings = InitializationSettings(android: android);
    flip.initialize(settings);
    try {
      switch (task) {
        case "Check-New-Reports":
          NotificationSystem n = NotificationSystem();
          await n.elaborateDataList(flip);
          return Future.value(true);
        case "Start-Worker":
          /*print("prova");
          NotificationSystem n = NotificationSystem();
          await n
              .sendNotification("L'applicazione è in esecuzione in background");*/
          NotificationSystem.showNotificationWithDefaultSound(
            flip,
            "Avviso",
            "L'applicazione è in esecuzione in background",
          );
          return Future.value(true);
        default:
          return Future.value(true);
      }
    } catch (e) {
      return Future.error(e);
    }
  });
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    //Nascondo i controlli del sistema
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    //Blocco la visualizzazione dell'app solo in verticale
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MaterialApp(
      title: 'Flutter Demo',
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('it'), Locale('en')],
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const LoadingScreen(),
    );
  }
}

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key});

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  LocalUserManager lum = LocalUserManager();
  late BuildContext _context;

  void startingProcess() async {
    Workmanager().cancelAll();
    Workmanager().registerOneOffTask("Run service", "Start-Worker",
        inputData: {}, initialDelay: const Duration(seconds: 10));
    // Periodic task registration
    Workmanager().registerPeriodicTask(
        "NotificationSystem", "Check-New-Reports",
        // When no frequency is provided the default 15 minutes is set.
        // Minimum frequency is 15 min. Android will automatically change your frequency to 15 min if you have configured a lower frequency.
        frequency: const Duration(minutes: 15),
        initialDelay: const Duration(seconds: 10),
        existingWorkPolicy: ExistingWorkPolicy.append,
        backoffPolicy: BackoffPolicy.exponential,
        //outOfQuotaPolicy: OutOfQuotaPolicy.drop_work_request,
        constraints: Constraints(
            requiresDeviceIdle: false, networkType: NetworkType.connected));
    LocalUser? user = await lum.getUser();
    if (user == null) {
      Navigator.pop(_context);
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => LoginScreen()));
      return;
    }
    if (await CheckConnection.check()) {
      bool check = await API_Manager.checkToken(user.email, user.token);
      if (check) {
        NotificationSystem().start();
        Navigator.pop(_context);
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => const Core()));
      } else {
        lum.deleteUser(user);
        Navigator.pop(_context);
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => LoginScreen.withMessage(
                    message:
                        "Sessione non più valida, si prega di rieseguire il login")));
      }
    } else {
      simpleAlertDialog(
          text:
              "Connessione ad internet richiesta. Controllare la connessione e riprovare",
          f: startingProcess,
          context: _context);
    }
  }

  @override
  Widget build(BuildContext context) {
    Workmanager().initialize(
        callbackDispatcher, // The top level function, aka callbackDispatcher
        isInDebugMode:
            false // If enabled it will post a notification whenever the task is running. Handy for debugging tasks
        );
    Workmanager().cancelAll();
    _context = context;
    startingProcess();
    return const Scaffold(
        body: Center(
            child: SizedBox(
                child: Image(
      image: AssetImage('assets/app_icon.png'),
      width: 100,
      height: 100,
    ))));
  }
}
