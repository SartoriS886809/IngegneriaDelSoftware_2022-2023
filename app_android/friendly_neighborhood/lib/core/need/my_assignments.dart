import 'package:flutter/material.dart';
import 'package:friendly_neighborhood/core/need/card_need.dart';
import '../../model/need.dart';

class MyAssignments extends StatefulWidget {

  const MyAssignments({super.key});

  @override
  State<MyAssignments> createState() => _MyAssignments();
}

class _MyAssignments extends State<MyAssignments> {

  List<Need> Needslist=[Need(5, new DateTime(2022,11,27,17,30), "esempio mio incarico 1", "via carlevaris 10", "descrizione mio incarico 1", "Sebastiano Sartori" , 1 , "Samuele Sartori")];
  //initState() è il costruttore delle classi stato
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //return Text("my assignments");
    return (!Needslist.isEmpty)
    ?
    ListView.builder(
      itemCount: Needslist.length,
      itemBuilder: (context, index){
        final Need need_i=Needslist.elementAt(index);
        return NeedCard(need: need_i, isItMine: false, assistedByMe: true);
      } ,
    )
    :
    const Center(
      child:
      Padding(
        padding: EdgeInsets.all(16.0),
        child: Text("Non hai ancora preso in carico una richiesta")
      )
    );
  }
}
