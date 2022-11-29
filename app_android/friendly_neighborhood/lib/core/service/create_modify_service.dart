import 'package:flutter/cupertino.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:friendly_neighborhood/model/service.dart';

// ignore: must_be_immutable
class CreationOrModificationService extends StatefulWidget {
  Service? service;
  CreationOrModificationService({super.key}) {
    service = null;
  }
  CreationOrModificationService.modification({super.key, this.service});

  @override
  State<CreationOrModificationService> createState() =>
      _CreationOrModificationServiceState();
}

class _CreationOrModificationServiceState
    extends State<CreationOrModificationService> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text("ciao"),
    );
  }
}
