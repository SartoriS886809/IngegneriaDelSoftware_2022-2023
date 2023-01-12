import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

import '../dashboard/dashboard.dart';

/*
* Classe GuidePage:
* La seguente classe si occupa di mostrare all'utente la guida sull'utilizzo dell'applicazione:
* per la visualizzazione si appoggia ad un plug-in chiamato SfPdfViewer
*/

class GuidePage extends StatefulWidget {
  final CoreCallback switchBody;
  const GuidePage({super.key, required this.switchBody});

  @override
  State<GuidePage> createState() => _GuidePageState();
}

class _GuidePageState extends State<GuidePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SfPdfViewer.asset("assets/Istruzioni_ per_l'utente.pdf"),
      persistentFooterButtons: [
        Center(
          child: ElevatedButton(
            onPressed: () {
              widget.switchBody("Dashboard");
            },
            child: const Text("Torna alla dashboard"),
          ),
        )
      ],
    );
  }
}
