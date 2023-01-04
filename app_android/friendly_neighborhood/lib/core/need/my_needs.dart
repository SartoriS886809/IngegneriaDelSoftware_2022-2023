// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:friendly_neighborhood/API_Manager/api_manager.dart';
import 'package:friendly_neighborhood/cache_manager/profile_db.dart';
import 'package:friendly_neighborhood/core/need/card_need.dart';
import 'package:friendly_neighborhood/first_page/login_screen.dart';
import 'package:friendly_neighborhood/model/localuser.dart';
import 'package:friendly_neighborhood/model/need.dart';
import 'package:friendly_neighborhood/utils/exception_widget.dart';

// ignore: slash_for_doc_comments
/**
 * La classe MyNeeds rappresenta la sezione della pagina dei bisogni relativa alle richieste create dall'utente corrente
 */
class MyNeeds extends StatefulWidget {
  const MyNeeds({super.key});

  @override
  State<MyNeeds> createState() => _MyNeedsState();
}

class _MyNeedsState extends State<MyNeeds> {
  String token = "";
  LocalUserManager lum = LocalUserManager();
  List<Need> needslist = [];
  //initState() è il costruttore delle classi stato
  @override
  void initState() {
    super.initState();
  }

  //funzione di aggiornamento della lista locale
  Future downloadData(bool needRefreshGUI) async {
    if (token == "") {
      LocalUser? user = await lum.getUser();
      token = user!.token;
    }
    try {
      needslist = List<Need>.from(
          await API_Manager.listOfElements(token, ELEMENT_TYPE.NEEDS, true));
    } catch (e) {
      if (e.toString() == "the user does not exist") {
        // ignore: use_build_context_synchronously
        Navigator.pop(context);
        // ignore: use_build_context_synchronously
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => LoginScreen.withMessage(
                    message:
                        "Sessione non più valida, si prega di rieseguire il login")));
      }
      rethrow;
    }
    if (needRefreshGUI) setState(() {});
  }

  //funzione che genera il widget della lista
  Future<Widget> generateList() async {
    await downloadData(false);
    return (needslist.isNotEmpty)
        ? ListView.builder(
            itemCount: needslist.length+1,
            itemBuilder: (context, index) {
              if(index==0) return Container(height:40);
              final Need need_i = needslist.elementAt(index-1);
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
        Align(
              alignment: Alignment.topRight,
              child:
              IconButton(
              iconSize: 35,
                onPressed: (() {
                  downloadData(true);
                }),
                icon: const Icon(Icons.refresh))
          ),
      ],
    );
  }
}
