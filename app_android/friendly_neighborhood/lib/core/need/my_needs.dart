// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:friendly_neighborhood/API_Manager/api_manager.dart';
import 'package:friendly_neighborhood/cache_manager/profile_db.dart';
import 'package:friendly_neighborhood/core/need/card_need.dart';
import 'package:friendly_neighborhood/model/localuser.dart';
import 'package:friendly_neighborhood/model/need.dart';
import 'package:friendly_neighborhood/utils/exception_widget.dart';

class MyNeeds extends StatefulWidget {
  const MyNeeds({super.key});

  @override
  State<MyNeeds> createState() => _MyNeedsState();
}

class _MyNeedsState extends State<MyNeeds> {
  String token = "";
  LocalUserManager lum = LocalUserManager();
  List<Need> needslist = [];
  /*  Need(
        id: 4,
        postDate: new DateTime(2022, 11, 27, 17, 30),
        title: "esempio mio bisogno 1",
        address: "via carlevaris 10",
        description: "descrizione mio bisogno 1",
        assistant: "",
        creator: "Sebastiano Sartori"),
    Need(
        id: 5,
        postDate: new DateTime(2022, 11, 27, 17, 30),
        title: "esempio mio bisogno 2",
        address: "via carlevaris 10",
        description: "descrizione mio bisogno 2",
        assistant: "Mario Rossi",
        creator: "Sebastiano Sartori"),
  ];*/
  //initState() è il costruttore delle classi stato
  @override
  void initState() {
    super.initState();
  }

  Future downloadData(bool needRefreshGUI) async {
    if (token == "") {
      LocalUser? user = await lum.getUser();
      token = user!.token;
    }
    try {
      needslist = List<Need>.from(
          await API_Manager.listOfElements(token, ELEMENT_TYPE.NEEDS, true));
    } catch (e) {
      rethrow;
    }
    if (needRefreshGUI) setState(() {});
  }

  Future<Widget> generateList() async {
    await downloadData(false);
    return (needslist.isNotEmpty)
        ? ListView.builder(
            itemCount: needslist.length,
            itemBuilder: (context, index) {
              final Need need_i = needslist.elementAt(index);
              return NeedCard(
                  need: need_i,
                  downloadNewDataFunction: downloadData,
                  isItMine: true);
            },
          )
        : const Center(
            child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Text("Non hai ancora pubbllicato richieste")));
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        FutureBuilder<Widget>(
        future: generateList(),
        builder: (context, AsyncSnapshot<Widget> snapshot) {
          if (snapshot.hasData) {
            return snapshot.data!;
          } else if (snapshot.hasError) {
            return printError(snapshot.error!, downloadData);
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        }),
        SizedBox(
          height: 10,
          child: Row(
            children: [
              Expanded(
                  child: Container(
                width: double.infinity,
              )),
              IconButton(
                  onPressed: (() {
                    downloadData(true);
                  }),
                  icon: const Icon(Icons.refresh))
            ],
          ),
        )
      ],
    );
    
  }
}
