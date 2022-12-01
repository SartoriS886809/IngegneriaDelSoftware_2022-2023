import 'package:flutter/material.dart';
import 'package:friendly_neighborhood/model/service.dart';

// ignore: must_be_immutable
class CreationOrModificationService extends StatefulWidget {
  Service? service;
  late bool modification;
  CreationOrModificationService({super.key}) {
    service = null;
    modification = false;
  }
  CreationOrModificationService.modification({super.key, this.service}) {
    modification = true;
  }

  @override
  State<CreationOrModificationService> createState() =>
      _CreationOrModificationServiceState();
}

class _CreationOrModificationServiceState
    extends State<CreationOrModificationService> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: (widget.modification)
              ? const Text("Modificazione servizio")
              : const Text("Creazione servizio")),
      body: Container(
        child: Text("ciao"),
      ),
    );
  }
}
