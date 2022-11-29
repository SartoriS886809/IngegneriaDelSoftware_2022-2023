import 'package:flutter/material.dart';
import 'package:friendly_neighborhood/model/service.dart';

import 'create_modify_service.dart';

class ServiceCard extends StatelessWidget {
  final Service service;
  const ServiceCard({super.key, required this.service});

  Future<void> _showMyDialog(BuildContext context, Service s) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(s.title),
          //Da completare con lista contatti e resto
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text('This is a demo alert dialog.'),
                Text('Would you like to approve of this message?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Chiudi'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
        child: Column(children: [
      ListTile(
        title: Text(service.title),
        subtitle: Text('Creato da ${service.creator}'),
      ),
      Row(mainAxisAlignment: MainAxisAlignment.end, children: <Widget>[
        TextButton(
          child: const Text('Più dettagli'),
          onPressed: () {},
        ),
        const SizedBox(width: 8),
      ]),
    ]));
  }
}
