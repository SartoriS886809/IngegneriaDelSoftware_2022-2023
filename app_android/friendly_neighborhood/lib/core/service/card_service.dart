import 'package:flutter/material.dart';
import 'package:friendly_neighborhood/core/core.dart';
import 'package:friendly_neighborhood/core/service/service_show.dart';
import 'package:friendly_neighborhood/model/service.dart';

/*
* Classe ServiceCardNeighborhood:
* La seguente classe si occupa di generare una card con i pulsanti per un servizio
* creato da un vicino
*/
class ServiceCardNeighborhood extends StatelessWidget {
  final DownloadNewDataFunction downloadNewDataFunction;
  final Service service;
  const ServiceCardNeighborhood(
      {super.key,
      required this.service,
      required this.downloadNewDataFunction});

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
                        ))).then((value) => downloadNewDataFunction(true));
          },
        ),
        const SizedBox(width: 8),
      ]),
    ]));
  }
}

/*
* Classe ServiceCardMe:
* La seguente classe si occupa di generare una card con i pulsanti per un servizio
* creato dall'utente corrente
*/
class ServiceCardMe extends StatelessWidget {
  final Service service;
  final DownloadNewDataFunction downloadNewDataFunction;
  const ServiceCardMe(
      {super.key,
      required this.service,
      required this.downloadNewDataFunction});

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
                        ))).then((value) => downloadNewDataFunction(true));
          },
        ),
        const SizedBox(width: 8),
      ]),
    ]));
  }
}
