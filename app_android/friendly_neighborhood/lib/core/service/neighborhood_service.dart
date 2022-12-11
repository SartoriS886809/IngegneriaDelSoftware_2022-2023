import 'package:flutter/material.dart';
import 'package:friendly_neighborhood/API_Manager/api_manager.dart';
import 'package:friendly_neighborhood/cache_manager/profile_db.dart';
import 'package:friendly_neighborhood/core/service/card_service.dart';
import 'package:friendly_neighborhood/model/localuser.dart';
import 'package:friendly_neighborhood/model/service.dart';

class NeighborhoodServicePage extends StatefulWidget {
  const NeighborhoodServicePage({super.key});

  @override
  State<NeighborhoodServicePage> createState() =>
      _NeighborhoodServicePageState();
}

class _NeighborhoodServicePageState extends State<NeighborhoodServicePage> {
  late List<Service> data;
  String token = "";
  LocalUserManager lum = LocalUserManager();
  //TODO INSERIRE FUNZIONE DI GESTIONE DI ERRORE IN CASO DEL TOKEN NON PIù VALIDO

  //TODO Controllo connessione ad internet
  Future downloadData(bool needRefreshGUI) async {
    if (token == "") {
      LocalUser? user = await lum.getUser();
      token = user!.token;
    }

    data = List<Service>.from(
        await API_Manager.listOfElements(token, ELEMENT_TYPE.SERVICES, false));
    if (needRefreshGUI) setState(() {});
  }

  Future<Widget> generateList() async {
    await downloadData(false);
    return SizedBox(
      height: double.infinity,
      child: ListView.builder(
        itemCount: data.length,
        itemBuilder: (context, index) {
          return ServiceCardNeighborhood(service: data[index]);
        },
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    //TODO: Temporaneo
    data = [];
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        FutureBuilder<Widget>(
            future: generateList(),
            builder: (context, AsyncSnapshot<Widget> snapshot) {
              if (snapshot.hasData) {
                return snapshot.data!;
              } else {
                return const CircularProgressIndicator();
              }
            }),
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
                    downloadData(true);
                  }),
                  icon: const Icon(Icons.refresh))
            ],
          ),
        ),
      ],
    );
  }
}
