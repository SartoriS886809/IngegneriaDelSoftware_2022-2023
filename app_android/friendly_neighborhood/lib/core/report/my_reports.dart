// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:friendly_neighborhood/model/report.dart';
import 'package:friendly_neighborhood/utils/exception_widget.dart';

import '../../API_Manager/api_manager.dart';
import '../../cache_manager/profile_db.dart';
import '../../first_page/login_screen.dart';
import '../../model/localuser.dart';
import '../../utils/elaborate_data.dart';

// ignore: slash_for_doc_comments
/**
 * La classe MyReports rappresenta la sezione della pagina delle segnalazioni create dall'utente corrente
 */

class MyReports extends StatefulWidget {
  const MyReports({super.key});

  @override
  State<MyReports> createState() => _MyReportsState();
}

class _MyReportsState extends State<MyReports> {
  String token = "";
  LocalUserManager lum = LocalUserManager();
  List<Report> reportList = [];
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
      reportList = List<Report>.from(
          await API_Manager.listOfElements(token, ELEMENT_TYPE.REPORTS, true));
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

  //funzione che genera il widget della lista
  Future<Widget> generateList() async {
    await downloadData(false);
    return (reportList.isNotEmpty)
        ? ListView.builder(
            itemCount: reportList.length + 1,
            itemBuilder: (context, index) {
              if (index == 0) return Container(height: 40);
              final Report reportIter = reportList.elementAt(index - 1);
              final String dateIter =
                  convertDateTimeToDate(reportIter.postDate);
              return Card(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Row(children: [
                      Expanded(
                        child: ListTile(
                          //controllare la funzione delle icone ( il colore non va)
                          leading: reportIter.getIconFromCategory(
                              const Color.fromARGB(255, 0, 0, 0), 40.0),
                          title: Text(reportIter.title),
                          subtitle: Text(
                              "Categoria: ${reportIter.category}\nLuogo: ${reportIter.address}\nData Segnalazione: $dateIter\nCreata da: ${reportIter.creator}"),
                        ),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          InkWell(
                            child: const Icon(
                              Icons.delete_forever,
                              color: Colors.black,
                              size: 40.0,
                            ),
                            onTap: () {
                              //action code when clicked
                              _showAlertDialog(
                                  title: 'cancellazione',
                                  message:
                                      'sei sicuro di voler cancellare la segnalazione',
                                  buttonMessage: 'cancella',
                                  f: deleteReport,
                                  report: reportIter);
                            },
                          )
                        ],
                      ),
                    ])
                  ],
                ),
              );
            },
          )
        : const Center(
            child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Text("Non hai pubblicato segnalazioni")));
  }

  Future<void> _showAlertDialog(
      {required String title,
      required String message,
      required String buttonMessage,
      required Function f,
      required Report report}) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // L'utente deve premere il pulsante
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(message),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Annulla'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text(buttonMessage),
              onPressed: () {
                Navigator.of(context).pop();
                f(report);
              },
            ),
          ],
        );
      },
    );
  }

  void deleteReport(Report report) async {
    await API_Manager.deleteElement(token, report.id, ELEMENT_TYPE.REPORTS);
    downloadData(true);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
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
    ]);
  }
}
