import 'package:flutter/material.dart';
import 'package:friendly_neighborhood/model/service.dart';

import 'create_modify_service.dart';

class ServiceCard extends StatelessWidget {
  final Service service;
  const ServiceCard({super.key, required this.service});

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
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      CreationOrModificationService.modification(
                        service: service,
                      )),
            );
          },
        ),
        const SizedBox(width: 8),
      ]),
    ]));
  }
}
