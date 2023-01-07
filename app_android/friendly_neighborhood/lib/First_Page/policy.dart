import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

/*
* Classe PrivacyPolicy:
* La seguente classe si occupa di mostrare all'utente i termini della policy relativa alla privacy:
* per la visualizzazione si appoggia ad un plug-in chiamato SfPdfViewer
*/
class PrivacyPolicy extends StatefulWidget {
  const PrivacyPolicy({super.key});

  @override
  State<PrivacyPolicy> createState() => _PrivacyPolicyState();
}

class _PrivacyPolicyState extends State<PrivacyPolicy> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SfPdfViewer.asset("assets/PrivacyPolicy.pdf"),
      persistentFooterButtons: [
        Center(
          child: ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text("Torna alla creazione account"),
          ),
        )
      ],
    );
  }
}
