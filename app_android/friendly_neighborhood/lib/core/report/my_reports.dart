// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:friendly_neighborhood/model/report.dart';

import '../../API_Manager/api_manager.dart';
import '../../cache_manager/profile_db.dart';
import '../../model/localuser.dart';
import '../../utils/elaborate_data.dart';

class MyReports extends StatefulWidget {
  const MyReports({super.key});

  @override
  State<MyReports> createState() => _MyReportsState();
}

class _MyReportsState extends State<MyReports> {
  String token = "";
  LocalUserManager lum = LocalUserManager();
  // API

  // test list

  List<Report> reportList = [];
  /*
    Report(
        postDate: DateTime(2022),
        title: 'cane randagio',
        priority: 2,
        category: 'animali',
        address: 'via F. Pannofino',
        creator: 'test')
  ];
  */

  @override
  void initState() {
    super.initState();
  }

  Future downloadData(bool needRefreshGUI) async {
    if (token == "") {
      LocalUser? user = await lum.getUser();
      token = user!.token;
    }

    reportList = List<Report>.from(
        await API_Manager.listOfElements(token, ELEMENT_TYPE.REPORTS, true));
    if (needRefreshGUI) setState(() {});
  }

  Future<Widget> generateList() async {
    await downloadData(false);
    return (reportList.isNotEmpty)
        ? ListView.builder(
            itemCount: reportList.length,
            itemBuilder: (context, index) {
              final Report reportIter = reportList.elementAt(index);
              final String dateIter =
                  convertDateTimeToDate(reportIter.postDate);
              return Card(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Row(children: [
                      Expanded(
                        //width: 150,
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
                //TODO
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
  }
}
