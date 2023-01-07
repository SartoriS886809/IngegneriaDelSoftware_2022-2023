// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:friendly_neighborhood/core/service/card_service.dart';
import 'package:friendly_neighborhood/utils/exception_widget.dart';

import '../../API_Manager/api_manager.dart';
import '../../cache_manager/profile_db.dart';
import '../../first_page/login_screen.dart';
import '../../model/localuser.dart';
import '../../model/service.dart';

/*
* Classe MyServicePage:
* La seguente classe si occupa di visualizzare la lista dei servizi creati dall'utente corrente
*/
class MyServicePage extends StatefulWidget {
  const MyServicePage({super.key});

  @override
  State<MyServicePage> createState() => _MyServicePageState();
}

class _MyServicePageState extends State<MyServicePage> {
  String token = "";
  LocalUserManager lum = LocalUserManager();
/*
* funzione downloadData
* la seguente funzione si occupa di scaricare i dati relativi ai servizi
* creati dai vicini
*/
  Future downloadData(bool needRefreshGUI) async {
    if (token == "") {
      LocalUser? user = await lum.getUser();
      token = user!.token;
    }
    try {
      data = List<Service>.from(
          await API_Manager.listOfElements(token, ELEMENT_TYPE.SERVICES, true));
    } catch (e) {
      if (e.toString() == "the user does not exist") {
        Navigator.pop(context);
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

/*
* funzione generateList
* la seguente funzione si occupa di generare una ListView sulla base
* dei dati scaricata dalla funzione downloadData
*/
  Future<Widget> generateList() async {
    await downloadData(false);
    if (data.isEmpty) {
      return const Center(
          child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Text("Non hai creato servizi")));
    }
    return SizedBox(
      height: double.infinity,
      child: ListView.builder(
        itemCount: data.length + 1,
        itemBuilder: (context, index) {
          if (index == 0) return Container(height: 40);
          return ServiceCardMe(
              service: data[index - 1], downloadNewDataFunction: downloadData);
        },
      ),
    );
  }

  late List<Service> data;
  @override
  void initState() {
    super.initState();
    data = [];
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
            child: IconButton(
                iconSize: 35,
                onPressed: (() {
                  downloadData(true);
                }),
                icon: const Icon(Icons.refresh))),
      ],
    );
  }
}
