// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:friendly_neighborhood/API_Manager/api_manager.dart';
import 'package:friendly_neighborhood/cache_manager/profile_db.dart';
import 'package:friendly_neighborhood/core/need/card_need.dart';
import 'package:friendly_neighborhood/model/localuser.dart';
import 'package:friendly_neighborhood/utils/exception_widget.dart';
import '../../model/need.dart';

class MyAssignments extends StatefulWidget {
  const MyAssignments({super.key});

  @override
  State<MyAssignments> createState() => _MyAssignments();
}

class _MyAssignments extends State<MyAssignments> {
  String token = "";
  LocalUserManager lum = LocalUserManager();
  List<Need> needslist = [];
  /*  Need(
        id: 5,
        postDate: new DateTime(2022, 11, 27, 17, 30),
        title: "esempio mio incarico 1",
        address: "via carlevaris 10",
        description: "descrizione mio incarico 1",
        assistant: "Sebastiano Sartori",
        creator: "Samuele Sartori")
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
      needslist = List<Need>.from(await API_Manager.assistList(token));
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
                  isItMine: false,
                  downloadNewDataFunction: downloadData,
                  assistedByMe: true);
            },
          )
        : const Center(
            child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Text("Non hai ancora preso in carico una richiesta")));
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
