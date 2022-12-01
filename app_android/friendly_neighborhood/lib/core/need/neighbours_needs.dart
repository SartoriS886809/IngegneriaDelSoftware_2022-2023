import 'package:flutter/material.dart';
import 'package:friendly_neighborhood/model/need.dart';

class NeighboursNeeds extends StatefulWidget {

  const NeighboursNeeds({super.key});

  @override
  State<NeighboursNeeds> createState() => _NeighboursNeedsState();
}

class _NeighboursNeedsState extends State<NeighboursNeeds> {

  //TODO implementare interazione API
  //lista di esempio (temporanea)
  List<Need> Needslist=[
      Need(1, new DateTime(2022,11,27,17,30), "spostamento mobili", "via carlevaris 10", "richiedo aiuto per spostare il tavolo e il divano", "" , 0 , "Sebastiano Sartori"),
      Need(2, new DateTime(2022,11,28,11,15), "cambiamento lampadina", "via carlevaris 10", "richiedo aiuto per cambiare la lampadina della cucina", "" , 0 , "Samuele Sartori"),
      Need(3, new DateTime(2022,11,29,10,20), "rimozione erbacce", "via carlevaris 10", "richiedo aiuto per la rimozione delle erbacce sul marciapiede", "" , 0 , "Diego Sartori")
    ];
  //initState() è il costruttore delle classi stato
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //return Text("neighbours needs");
    return (!Needslist.isEmpty) 
    ?ListView.builder(
      itemCount: Needslist.length,
      itemBuilder: (context, index){
        final Need need_i=Needslist.elementAt(index);
        final String date_i=need_i.postDate.day.toString()+"-"+need_i.postDate.month.toString()+"-"+need_i.postDate.year.toString()+" "+need_i.postDate.hour.toString()+":"+need_i.postDate.minute.toString();
        return Card(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Row(
              children:[
              Expanded(
                //width: 150,
                child: 
                ListTile(
                  //leading: Icon(Icons.album),
                  title: Text(need_i.title),
                  subtitle: Text(
                    "Luogo: "+need_i.address+"\n"+
                    "Data creazione: "+date_i+"\n"+//.toString()+"\n"+
                    "Autore: "+need_i.creator),
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  TextButton(
                    child: const Text('Apri descrizione'),
                    onPressed: () {/* ... */},
                  ),
                  const SizedBox(height: 16),
                  TextButton(
                    child: const Text('Soddisfa'),
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.all(8.0)
                    ),
                    onPressed: () {/* ... */},
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ])
          ],
        ),
      );
      } ,
    )
    :
    const Center(
      child:
      Padding(
        padding: EdgeInsets.all(16.0),
        child: Text("Non sono ancora presenti richieste")
      )
    );
  }
}
