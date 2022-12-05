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

  List<Report> ReportList = [
    Report(2, DateTime(2022), 'Cane randagio', 2, 'animali', 'via F. Pannofino',
        'Alessandro')
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return (ReportList.isNotEmpty)
        ? ListView.builder(
            itemCount: ReportList.length,
            itemBuilder: (context, index) {
              final Report reportIter = ReportList.elementAt(index);
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
                          leading: Icon(
                            reportIter.getIconFromCategory(Colors.black).icon,
                            color: Colors.black,
                            size: 40.0,
                          ),
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
                child: Text("Non sono ancora presenti richieste")));
  }
}
