import 'package:flutter/material.dart';
import 'package:friendly_neighborhood/core/service/card_service.dart';

import '../../API_Manager/api_manager.dart';
import '../../cache_manager/profile_db.dart';
import '../../model/localuser.dart';
import '../../model/service.dart';

class MyServicePage extends StatefulWidget {
  const MyServicePage({super.key});

  @override
  State<MyServicePage> createState() => _MyServicePageState();
}

class _MyServicePageState extends State<MyServicePage> {
  String token = "";
  LocalUserManager lum = LocalUserManager();
  //TODO Controllo connessione ad internet
  Future downloadData(bool needRefreshGUI) async {
    if (token == "") {
      LocalUser? user = await lum.getUser();
      token = user!.token;
    }

    data = List<Service>.from(
        await API_Manager.listOfElements(token, ELEMENT_TYPE.SERVICES, true));
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

  late List<Service> data;
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
