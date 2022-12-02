import 'package:flutter/material.dart';
import 'package:friendly_neighborhood/core/service/service_show.dart';
import 'package:friendly_neighborhood/model/service.dart';

class ServiceCardNeighborhood extends StatelessWidget {
  final Service service;
  const ServiceCardNeighborhood({super.key, required this.service});

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
                    builder: (context) => ShowService(
                          service: service,
                          myService: false,
                        )));
          },
        ),
        const SizedBox(width: 8),
      ]),
    ]));
  }
}

class ServiceCardMe extends StatelessWidget {
  final Service service;
  const ServiceCardMe({super.key, required this.service});

  @override
  Widget build(BuildContext context) {
    return Card(
        child: Column(children: [
      ListTile(
        title: Text(service.title),
        subtitle: Text(
            "Creata da te il ${service.postDate.day}-${service.postDate.month}-${service.postDate.year}"),
      ),
      Row(mainAxisAlignment: MainAxisAlignment.end, children: <Widget>[
        TextButton(
          child: const Text('Più dettagli'),
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ShowService(
                          service: service,
                          myService: true,
                        )));
          },
        ),
        const SizedBox(width: 8),
      ]),
    ]));
  }
}
