import 'package:flutter/material.dart';
import 'package:friendly_neighborhood/core/service/card_service.dart';
import 'package:friendly_neighborhood/model/service.dart';

class NeighborhoodServicePage extends StatefulWidget {
  const NeighborhoodServicePage({super.key});

  @override
  State<NeighborhoodServicePage> createState() =>
      _NeighborhoodServicePageState();
}

class _NeighborhoodServicePageState extends State<NeighborhoodServicePage> {
  late List<Service> data;
  @override
  void initState() {
    super.initState();
    //TODO: Temporaneo
    data = [
      Service(
          postDate: DateTime.now(),
          title: "Pasticcere",
          link: "telefono / cellulare:+396666888",
          description: "Torte su ordinazione",
          creator: "Luigina"),
      Service(
          postDate: DateTime.now(),
          title: "Idraulico",
          link: "telefono / cellulare:+396666888",
          description: "Se perde acqua è da riparare",
          creator: "Luigi"),
      Service(
          postDate: DateTime.now(),
          title: "Pasticcere",
          link: "telefono / cellulare:+396666888",
          description: "Torte su ordinazione",
          creator: "Luigina"),
      Service(
          postDate: DateTime.now(),
          title: "Idraulico",
          link: "telefono / cellulare:+396666888",
          description: "Se perde acqua è da riparare",
          creator: "Luigi"),
      Service(
          postDate: DateTime.now(),
          title: "Pasticcere",
          link: "telefono / cellulare:+396666888",
          description: "Torte su ordinazione",
          creator: "Luigina"),
      Service(
          postDate: DateTime.now(),
          title: "Idraulico",
          link: "telefono / cellulare:+396666888",
          description: "Se perde acqua è da riparare",
          creator: "Luigi")
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
              return ServiceCardNeighborhood(service: data[index]);
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
