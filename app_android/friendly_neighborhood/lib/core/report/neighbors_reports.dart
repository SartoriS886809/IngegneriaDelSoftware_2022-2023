import 'package:flutter/material.dart';
import 'package:friendly_neighborhood/model/report.dart';

class NeighborsReports extends StatefulWidget {
  const NeighborsReports({super.key});

  @override
  State<NeighborsReports> createState() => _NeighborsReportsState();
}

class _NeighborsReportsState extends State<NeighborsReports> {
  //API

  //test list

  List<Report> reportList = [
    Report(
        postDate: DateTime(2022, 11, 23, 14, 20),
        title: 'Albero caduto',
        priority: 1,
        category: 'problemi ambientali',
        address: 'via papa luciani',
        creator: 'paolino'),
    Report(
        postDate: DateTime(2022, 11, 23, 14, 20),
        title: 'tombino rotto',
        priority: 1,
        category: 'problemi ambientali',
        address: 'via cristo',
        creator: 'creator'),
    Report(
        postDate: DateTime(2022, 11, 23, 14, 20),
        title: 'ladri in casa',
        priority: 3,
        category: 'crimine',
        address: 'via Col Vento',
        creator: 'Lucio Wolf')
  ];

  //initState() è il costruttore delle classi stato

  @override
  void initState() {
    super.initState();
  }

  //TODO implementare la lista di segnalazioni

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
                        child: ListTile(
                          leading: reportIter.getIconFromCategory(
                              const Color.fromARGB(255, 0, 0, 0), 40.0),
                          title: Text(reportIter.title),
                          subtitle: Text(
                              "Categoria: ${reportIter.category}\nLuogo: ${reportIter.address}\nData Segnalazione: $dateIter\nCreata da: ${reportIter.creator}"),
                        ),
                      ),
                    ])
                  ],
                ),
              );
            })
        : const Center(
            child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Text("Non sono ancora presenti Segnalazioni")));
  }
}
