import 'package:flutter/material.dart';
import 'package:friendly_neighborhood/core/need/card_need.dart';
import 'package:friendly_neighborhood/model/need.dart';

class MyNeeds extends StatefulWidget {

  const MyNeeds({super.key});

  @override
  State<MyNeeds> createState() => _MyNeedsState();
}

class _MyNeedsState extends State<MyNeeds> {

//TODO implementare interazione API
  //lista di esempio (temporanea)
  List<Need> Needslist=[
    Need(id: 4, postDate: new DateTime(2022,11,27,17,30), title: "esempio mio bisogno 1", address: "via carlevaris 10", description: "descrizione mio bisogno 1", assistant: "" , idAssistant: 0 , creator: "Sebastiano Sartori"),
    Need(id: 5, postDate: new DateTime(2022,11,27,17,30), title: "esempio mio bisogno 2", address: "via carlevaris 10", description: "descrizione mio bisogno 2", assistant: "Mario Rossi" , idAssistant: 1 , creator: "Sebastiano Sartori"),
  ];
  //initState() è il costruttore delle classi stato
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return (!Needslist.isEmpty)
    ?
    ListView.builder(
      itemCount: Needslist.length,
      itemBuilder: (context, index){
        final Need need_i=Needslist.elementAt(index);
        return NeedCard(need: need_i, isItMine: true);
      } ,
    )
    :
    const Center(
      child:
      Padding(
        padding: EdgeInsets.all(16.0),
        child: Text("Non hai ancora pubblicato una richiesta")
      )
    );
  }
}
