import 'package:flutter/material.dart';
import 'package:friendly_neighborhood/model/service.dart';

// ignore: must_be_immutable
class CreationOrModificationNeed extends StatefulWidget {
  Service? service;
  late bool modification;
  CreationOrModificationNeed({super.key}) {
    service = null;
    modification = false;
  }
  CreationOrModificationNeed.modification({super.key, this.service}) {
    modification = true;
  }

  @override
  State<CreationOrModificationNeed> createState() =>
      _CreationOrModificationNeedState();
}

class _CreationOrModificationNeedState
    extends State<CreationOrModificationNeed> {
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
