import 'package:flutter/material.dart';
import 'package:friendly_neighborhood/model/need.dart';

// ignore: must_be_immutable
class CreationOrModificationNeed extends StatefulWidget {
  Need? need;
  late bool modification;
  CreationOrModificationNeed({super.key}) {
    need = null;
    modification = false;
  }
  CreationOrModificationNeed.modification({super.key, this.need}) {
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
