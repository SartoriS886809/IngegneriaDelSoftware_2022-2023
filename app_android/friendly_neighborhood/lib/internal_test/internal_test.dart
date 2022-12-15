import 'package:flutter/material.dart';
import 'package:friendly_neighborhood/API_Manager/api_manager.dart';
import 'package:friendly_neighborhood/model/localuser.dart';
import 'package:friendly_neighborhood/model/neighborhood.dart';

class Test extends StatefulWidget {
  const Test({super.key});

  @override
  State<Test> createState() => _TestState();
}

class _TestState extends State<Test> {
  String token = "";
  Map<String, dynamic> utente = {};
  Future<Widget> testNeighborhoods() async {
    List<Neighborhood> l = await API_Manager.getNeighborhoods();
    String s = "";
    for (Neighborhood n in l) {
      s += "$n, ";
    }
    return Text(s);
  }

  Future<Widget> testAccountCreation() async {
    LocalUser u = LocalUser("prova@prova.com", "gree", "gino", "paolino",
        DateTime.now(), "ciao", 1, "prova", "provaQuart", 1, "");
    String s = "";
    try {
      await API_Manager.signup(u, "prova");
      s = "Test creazione completato con successo";
    } catch (e) {
      s = e.toString();
    }
    return Text(s);
  }

  Future<Widget> testLogin() async {
    String s = "";
    try {
      token = await API_Manager.login("prova@prova.com", "prova");
      s = "Login completato";
    } catch (e) {
      s = e.toString();
    }
    return Text(s);
  }

  Future<Widget> testgetProfile() async {
    String s = "";
    try {
      utente = await API_Manager.getProfile(token);
      s = utente.toString();
    } catch (e) {
      s = e.toString();
    }
    return Text(s);
  }

  Future<Widget> testremoveProfile() async {
    String s = "";
    try {
      await API_Manager.deleteAccount(utente["email"]);
      s = "Rimozione avvenuta";
    } catch (e) {
      s = e.toString();
    }
    return Text(s);
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
          FutureBuilder<Widget>(
              future: testAccountCreation(),
              builder: (context, AsyncSnapshot<Widget> snapshot) {
                if (snapshot.hasData) {
                  return snapshot.data!;
                } else {
                  return const Text("Reciving data...");
                }
              }),
          //TEST LOGIN
          FutureBuilder<Widget>(
              future: testLogin(),
              builder: (context, AsyncSnapshot<Widget> snapshot) {
                if (snapshot.hasData) {
                  return snapshot.data!;
                } else {
                  return const Text("Reciving data...");
                }
              }), //TEST GET PROFILE
          FutureBuilder<Widget>(
              future: testgetProfile(),
              builder: (context, AsyncSnapshot<Widget> snapshot) {
                if (snapshot.hasData) {
                  return snapshot.data!;
                } else {
                  return const Text("Reciving data...");
                }
              }),
          //TEST DELETE PROFILE
          FutureBuilder<Widget>(
              future: testremoveProfile(),
              builder: (context, AsyncSnapshot<Widget> snapshot) {
                if (snapshot.hasData) {
                  return snapshot.data!;
                } else {
                  return const Text("Reciving data...");
                }
              }),
        ],
      ),
    );
  }
}
