import 'package:flutter/material.dart';
import 'package:friendly_neighborhood/core/need/card_need.dart';
import 'package:friendly_neighborhood/model/need.dart';

import '../../API_Manager/api_manager.dart';
import '../../cache_manager/profile_db.dart';
import '../../model/localuser.dart';

class NeighborsNeeds extends StatefulWidget {
  const NeighborsNeeds({super.key});

  @override
  State<NeighborsNeeds> createState() => _NeighborsNeedsState();
}

class _NeighborsNeedsState extends State<NeighborsNeeds> {
  String token = "";
  LocalUserManager lum = LocalUserManager();

  //TODO implementare interazione API
  //lista di esempio (temporanea)
  List<Need> needslist =
      []; /*
    Need(
        id: 1,
        postDate: new DateTime(2022, 11, 27, 17, 30),
        title: "spostamento mobili",
        address: "via carlevaris 10",
        description: "richiedo aiuto per spostare il tavolo e il divano",
        assistant: "",
        idAssistant: 0,
        creator: "Sebastiano Sartori"),
    Need(
        id: 2,
        postDate: new DateTime(2022, 11, 28, 11, 15),
        title: "cambiamento lampadina",
        address: "via carlevaris 10",
        description: "richiedo aiuto per cambiare la lampadina della cucina",
        assistant: "",
        idAssistant: 0,
        creator: "Samuele Sartori"),
    Need(
        id: 3,
        postDate: new DateTime(2022, 11, 29, 10, 20),
        title: "rimozione erbacce",
        address: "via carlevaris 10",
        description:
            "richiedo aiuto per la rimozione delle erbacce sul marciapiede",
        assistant: "",
        idAssistant: 0,
        creator: "Diego Sartori")
  ];*/
  //TODO INSERIRE FUNZIONE DI GESTIONE DI ERRORE IN CASO DEL TOKEN NON PIù VALIDO

  //TODO Controllo connessione ad internet
  Future downloadData(bool needRefreshGUI) async {
    if (token == "") {
      LocalUser? user = await lum.getUser();
      token = user!.token;
    }

    needslist = List<Need>.from(
        await API_Manager.listOfElements(token, ELEMENT_TYPE.NEEDS, false));
    if (needRefreshGUI) setState(() {});
  }

  Future<Widget> generateList() async {
    await downloadData(false);
    return (!needslist.isEmpty)
        ? ListView.builder(
            itemCount: needslist.length,
            itemBuilder: (context, index) {
              final Need need_i = needslist.elementAt(index);
              return NeedCard(need: need_i, isItMine: false);
            },
          )
        : const Center(
            child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Text("Non sono ancora presenti richieste")));
  }

  //initState() è il costruttore delle classi stato
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Widget>(
        future: generateList(),
        builder: (context, AsyncSnapshot<Widget> snapshot) {
          if (snapshot.hasData) {
            return snapshot.data!;
          } else {
            return const CircularProgressIndicator();
          }
        });
    //return Text("neighbours needs");
  }
}
