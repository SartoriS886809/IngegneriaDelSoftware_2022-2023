import 'package:flutter/material.dart';
import 'package:friendly_neighborhood/model/report.dart';

class CreationReport extends StatefulWidget {
  Report? service;
  late bool modification;
  CreationReport({super.key}) {
    service = null;
    modification = false;
  }
  CreationReport.modification({super.key, this.service}) {
    modification = true;
  }

  @override
  State<CreationReport> createState() => _CreationReportState();
}

class _CreationReportState extends State<CreationReport> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: (widget.modification)
              ? const Text("Modificazione bisogno")
              : const Text("Creazione bisogno")),
      body: Container(
        child: Text("ciao"),
      ),
    );
  }
}
