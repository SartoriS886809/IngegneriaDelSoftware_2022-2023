import 'package:flutter/material.dart';
import '../../model/need.dart';

class MyAssignments extends StatefulWidget {

  const MyAssignments({super.key});

  @override
  State<MyAssignments> createState() => _MyAssignments();
}

class _MyAssignments extends State<MyAssignments> {

  List<Need> Needslist=[];
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
              TextButton(
                child: const Text('Apri descrizione'),
                onPressed: () {/* ... */},
              )
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
        child: Text("Non hai ancora preso in carico una richiesta")
      )
    );
  }
}
