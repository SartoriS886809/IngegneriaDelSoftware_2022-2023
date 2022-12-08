import 'package:flutter/material.dart';
import 'package:friendly_neighborhood/model/report.dart';

class NeighboursReports extends StatefulWidget {
  const NeighboursReports({super.key});

  @override
  State<NeighboursReports> createState() => _NeighboursReportsState();
}

class _NeighboursReportsState extends State<NeighboursReports> {
  //API

  //test list

  List<Report> ReportList = [
    Report(1, DateTime(2022, 11, 23, 14, 20), 'Albero caduto', 1,
        'problemi ambientali', 'via papa luciani', 'paolino'),
    Report(2, DateTime(2022, 11, 23, 14, 20), 'tombino rotto', 1,
        'problemi ambientali', 'via cristo', 'creator'),
    Report(3, DateTime(2022, 11, 23, 14, 20), 'ladri in casa', 1, 'crimine',
        'via Col Vento', 'Lucio Wolf'),
    Report(4, DateTime(2022, 11, 23, 14, 20), 'Cane randagio nel quartiere', 1,
        'animali', 'via Montalbano', 'Zaia Luca'),
    Report(65, DateTime(2022, 02, 02, 2, 2), 'Strada chiusa per lavori', 3,
        'lavori in corso', 'via Monte Marmolada', 'Sandro')
  ];

  //initState() è il costruttore delle classi stato

  @override
  void initState() {
    super.initState();
  }

  //TODO implementare la lista di segnalazioni

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
                          leading: Icon(
                              reportIter.getIconFromCategory(Colors.black).icon,
                              color: Colors.black,
                              size: 40.0),
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
