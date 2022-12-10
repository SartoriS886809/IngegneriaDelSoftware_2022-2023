// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:friendly_neighborhood/API_Manager/api_manager.dart';
import 'package:friendly_neighborhood/cache_manager/profile_db.dart';
import 'package:friendly_neighborhood/core/core.dart';
import 'package:friendly_neighborhood/first_page/login_screen.dart';
import 'package:friendly_neighborhood/model/localuser.dart';
import 'package:friendly_neighborhood/utils/check_connection.dart';

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

  Future<void> _showAlertDialog(
      {required String text, required Function f}) async {
    return showDialog<void>(
      context: _context,
      barrierDismissible: false, // L'utente deve premere il pulsante
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Avviso'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(text),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Riprova'),
              onPressed: () {
                Navigator.of(context).pop();
                f();
              },
            ),
          ],
        );
      },
    );
  }

  void startingProcess() async {
    LocalUser? user = await lum.getUser();
    if (user == null) {
      Navigator.pop(_context);
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => LoginScreen()));
    }
    if (await CheckConnection.check()) {
      bool check = await API_Manager.checkToken(user!.email, user.token);
      if (check) {
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
      _showAlertDialog(
          text:
              "Connessione ad internet richiesta. Controllare la connessione e riprovare",
          f: startingProcess);
    }
  }

  @override
  Widget build(BuildContext context) {
    _context = context;
    startingProcess();
    return const Scaffold(
      //TODO Icona temporanea, da utilizzare quella ufficiale dell'app
      body: Center(child: Icon(Icons.people)),
    );
  }
}
