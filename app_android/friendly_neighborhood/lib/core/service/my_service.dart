import 'package:flutter/material.dart';
import 'package:friendly_neighborhood/core/service/card_service.dart';

import '../../model/service.dart';

class MyServicePage extends StatefulWidget {
  const MyServicePage({super.key});

  @override
  State<MyServicePage> createState() => _MyServicePageState();
}

class _MyServicePageState extends State<MyServicePage> {
  late List<Service> data;
  @override
  void initState() {
    super.initState();
    //TODO: Temporaneo
    data = [
      Service(
          postDate: DateTime.now(),
          title: "Pasticcere",
          link:
              "telefono / cellulare:+396666888,telefono / cellulare:+396666888,telefono / cellulare:+396666888",
          description: "Torte su ordinazione",
          creator: "Beppe"),
      Service(
          postDate: DateTime.now(),
          title: "Idraulico",
          link: "telefono / cellulare:+396666888",
          description: "Se perde acqua è da riparare",
          creator: "Beppe"),
      Service(
          postDate: DateTime.now(),
          title: "Pasticcere",
          link: "telefono / cellulare:+396666888",
          description: "Torte su ordinazione",
          creator: "Beppe"),
      Service(
          postDate: DateTime.now(),
          title: "Idraulico",
          link: "telefono / cellulare:+396666888",
          description: "Se perde acqua è da riparare",
          creator: "Beppe"),
      Service(
          postDate: DateTime.now(),
          title: "Pasticcere",
          link: "telefono / cellulare:+396666888",
          description: "Torte su ordinazione",
          creator: "Beppe"),
      Service(
          postDate: DateTime.now(),
          title: "Idraulico",
          link: "telefono / cellulare:+396666888",
          description: "Se perde acqua è da riparare",
          creator: "Beppe")
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SizedBox(
          height: double.infinity,
          child: ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, index) {
              return ServiceCardMe(service: data[index]);
            },
          ),
        ),
        SizedBox(
          height: 10,
          child: Row(
            children: [
              Expanded(
                  child: Container(
                width: double.infinity,
              )),
              IconButton(
                  onPressed: (() {
                    //TODO Aggiornamento dati
                    return;
                  }),
                  icon: const Icon(Icons.refresh))
            ],
          ),
        ),
      ],
    );
  }
}
