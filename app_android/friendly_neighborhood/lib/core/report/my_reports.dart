import 'package:flutter/material.dart';
import 'package:friendly_neighborhood/model/report.dart';

class MyReports extends StatefulWidget {
  const MyReports({super.key});

  @override
  State<MyReports> createState() => _MyReportsState();
}

class _MyReportsState extends State<MyReports> {
  // API

  // test list

  List<Report> reportList = [
    Report(
        postDate: DateTime(2022),
        title: 'cane randagio',
        priority: 2,
        category: 'animali',
        address: 'via F. Pannofino',
        creator: 'test')
  ];

  @override
  void initState() {
    super.initState();
  }

  Future<void> _showAlertDialog(
      {required String title,
      required String message,
      required String buttonMessage,
      required Function f}) async {
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
                f();
              },
            ),
          ],
        );
      },
    );
  }

  void deleteReport() {
    //TODO chiamata al database per eliminare segnalazione
  }

  @override
  Widget build(BuildContext context) {
    return (reportList.isNotEmpty)
        ? ListView.builder(
            itemCount: reportList.length,
            itemBuilder: (context, index) {
              final Report reportIter = reportList.elementAt(index);
              final String dateIter =
                  "${reportIter.postDate.day}-${reportIter.postDate.year} ${reportIter.postDate.hour}:${reportIter.postDate.minute}";
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
                                  f: deleteReport);
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
}
