import 'package:flutter/material.dart';
import 'package:friendly_neighborhood/API_Manager/api_manager.dart';
import 'package:friendly_neighborhood/internal_test/stress_test.dart';
import 'package:friendly_neighborhood/model/localuser.dart';
import 'package:friendly_neighborhood/model/neighborhood.dart';

/*
* Classe Test:
* La seguente classe esegue dei test sulle varie operazioni con il server
*/
class Test extends StatefulWidget {
  const Test({super.key});

  @override
  State<Test> createState() => _TestState();
}

class _TestState extends State<Test> {
  String token = "";
  LocalUser u = LocalUser("prova@prova.com", "gree", "gino", "paolino",
      DateTime.now(), "ciao", 1, "prova", "provaQuart", 1, "");
  String password = "prova";
  String creationResult = "in attesa di essere avviato";
  String loginResult = "in attesa di essere avviato";
  String deleteResult = "in attesa di essere avviato";
  String getProfileResult = "in attesa di essere avviato";

/*
* funzione testNeighborhoods
* Prova ad eseguire il download dei vari neighborhoods 
*/
  Future<Widget> testNeighborhoods() async {
    List<Neighborhood> l = await API_Manager.getNeighborhoods();
    String s = "";
    for (Neighborhood n in l) {
      s += "$n, ";
    }
    return Text(s);
  }

/*
* funzione testAccountCreation
* Prova a creare un nuovo account
*/
  void testAccountCreation() async {
    setState(() {
      creationResult = "test avviato";
    });
    try {
      bool check = await API_Manager.signup(u, password);
      if (check) {
        setState(() {
          creationResult = "Test creazione completato con successo";
        });
      }
    } catch (e) {
      setState(() {
        creationResult = e.toString();
        loginResult = "errore nei test precedenti, impossibile avviare";
        deleteResult = "errore nei test precedenti, impossibile avviare";
        getProfileResult = "errore nei test precedenti, impossibile avviare";
      });
      return;
    }
    testLogin();
  }

/*
* funzione testAccountCreation
* Prova ad accedere con l'account appena creato
*/
  void testLogin() async {
    setState(() {
      loginResult = "test avviato";
    });

    try {
      token = await API_Manager.login("prova@prova.com", "prova");
      setState(() {
        loginResult = "Login completato";
      });
    } catch (e) {
      setState(() {
        loginResult = e.toString();
        deleteResult = "errore nei test precedenti, impossibile avviare";
        getProfileResult = "errore nei test precedenti, impossibile avviare";
      });
    }
    testgetProfile();
  }

/*
* funzione testgetProfile
* Prova a scaricare le informazioni del profilo appena creato
*/
  void testgetProfile() async {
    try {
      await API_Manager.getProfile(token);
      setState(() {
        getProfileResult = "get profile completato";
      });
    } catch (e) {
      setState(() {
        getProfileResult = e.toString();
        deleteResult = "errore nei test precedenti, impossibile avviare";
      });
    }
    testremoveProfile();
  }

/*
* funzione testremoveProfile
* Prova ad eliminare il profilo creato
*/
  void testremoveProfile() async {
    try {
      await API_Manager.deleteAccount(token);
      setState(() {
        deleteResult = "rimozione profilo completata";
      });
    } catch (e) {
      setState(() {
        deleteResult = e.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          //TEST NEIGHBORHOOD
          FutureBuilder<Widget>(
              future: testNeighborhoods(),
              builder: (context, AsyncSnapshot<Widget> snapshot) {
                if (snapshot.hasData) {
                  return snapshot.data!;
                } else {
                  return const Text("Reciving data...");
                }
              }),
          //TEST CREAZIONE ACCOUNT
          Text("Test creazione account: $creationResult"),
          //TEST LOGIN
          Text("Test login: $loginResult"),
          //TEST GET PROFILE
          Text("Test get profile: $getProfileResult"),
          //TEST DELETE PROFILE
          Text("Test eliminazione profilo: $deleteResult"),
          TextButton(
              onPressed: (() {
                token = "";
                creationResult = "in attesa di essere avviato";
                loginResult = "in attesa di essere avviato";
                deleteResult = "in attesa di essere avviato";
                getProfileResult = "in attesa di essere avviato";
                testAccountCreation();
              }),
              child: const Text("Avvia / Riavvia test")),
          TextButton(
              onPressed: (() {
                Navigator.pop(context);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const StressTest()));
              }),
              child: const Text("Vai a stress test")),
        ],
      ),
    );
  }
}
