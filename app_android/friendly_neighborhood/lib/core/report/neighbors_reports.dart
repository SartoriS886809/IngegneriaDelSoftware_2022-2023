// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:friendly_neighborhood/model/report.dart';
import 'package:friendly_neighborhood/utils/exception_widget.dart';

import '../../API_Manager/api_manager.dart';
import '../../cache_manager/profile_db.dart';
import '../../first_page/login_screen.dart';
import '../../model/localuser.dart';
import '../../utils/elaborate_data.dart';

class NeighborsReports extends StatefulWidget {
  const NeighborsReports({super.key});

  @override
  State<NeighborsReports> createState() => _NeighborsReportsState();
}

class _NeighborsReportsState extends State<NeighborsReports> {
  String token = "";
  LocalUserManager lum = LocalUserManager();

  // Lista delle segnalazioni
  List<Report> reportList = [];

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
      reportList = List<Report>.from(
          await API_Manager.listOfElements(token, ELEMENT_TYPE.REPORTS, false));
    } catch (e) {
      if (e.toString() == "user does not exist") {
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
      ),
    ]);
  }
}
