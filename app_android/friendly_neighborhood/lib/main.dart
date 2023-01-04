// ignore_for_file: use_build_context_synchronously

/*
* FILE: main.dart
* Il seguente file gestisce il login automatico e la gestione del thread in background con le varie funzioni di notifica.
*/

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

/*
* Funzione di gestione dei task in background
* Input: task (Una stringa che identifica il task da eseguire), inputData (parametro opzionale, corrisponde ai dati
*        che verranno usati dal task).
*/
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
          NotificationSystem.showNotificationWithDefaultSound(flip, "Avviso",
              "L'applicazione è in esecuzione in background", false);
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

/*
* Classe che inizializza l'applicazione:
* -Imposta le modalità di visualizzazione
* -Genera il MaterialApp, necessario per far funzionare l'UI
*/
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
      title: 'Friendly Neighborhood',
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('it'), Locale('en')],
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const LoadingScreen(),
    );
  }
}

/*
* Classe LoadingScreen:
* La seguente classe gestisce due processi principali:
* -Avvio dell'applicazione in background per gestire il processo di notifiche
* -Caricamento dell'utente salvato in locale (se esiste) e indirizzamento alla pagina
*  di login o dashboard a seconda della validità della sessione
*/
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
    // Workmanager().registerOneOffTask("Run service", "Start-Worker",
    //     inputData: {}, initialDelay: const Duration(seconds: 10));
    // Periodic task registration
    Workmanager().registerPeriodicTask(
        "NotificationSystem", "Check-New-Reports",
        // When no frequency is provided the default 15 minutes is set.
        // Minimum frequency is 15 min. Android will automatically change your frequency to 15 min if you have configured a lower frequency.
        frequency: const Duration(minutes: 15),
        initialDelay: const Duration(minutes: 15),
        existingWorkPolicy: ExistingWorkPolicy.append,
        backoffPolicy: BackoffPolicy.exponential,
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
