import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
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
      Service(0, DateTime.now(), "Pasticcere", "tel:+396666888",
          "Torte su ordinazione", "Luigina"),
      Service(1, DateTime.now(), "Idraulico", "tel:+396666888",
          "Se perde acqua è da riparare", "Luigi"),
      Service(2, DateTime.now(), "Pasticcere", "tel:+396666888",
          "Torte su ordinazione", "Luigina"),
      Service(3, DateTime.now(), "Idraulico", "tel:+396666888",
          "Se perde acqua è da riparare", "Luigi"),
      Service(2, DateTime.now(), "Pasticcere", "tel:+396666888",
          "Torte su ordinazione", "Luigina"),
      Service(3, DateTime.now(), "Idraulico", "tel:+396666888",
          "Se perde acqua è da riparare", "Luigi")
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
              return ServiceCard(service: data[index]);
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
                    //TODO
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
