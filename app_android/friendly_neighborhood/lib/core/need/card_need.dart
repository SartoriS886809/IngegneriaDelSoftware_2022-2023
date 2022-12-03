import 'package:flutter/material.dart';
import 'package:friendly_neighborhood/model/need.dart';

//import 'package:friendly_neighborhood/core/need/need_show.dart';
/*
onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ShowNeed(
                          need: service,
                          myService: false,
                        )));
          },
*/

class NeedCard extends StatelessWidget {
  final Need need;
  final bool isItMine; 
  final bool assistedByMe;
  const NeedCard({super.key, required this.need, required this.isItMine, this.assistedByMe=false});

  @override
  Widget build(BuildContext context) {
    String date="${need.postDate.day}-${need.postDate.month}-${need.postDate.year} ${need.postDate.hour}:${need.postDate.minute}";
    String author=(!isItMine)?("\nAutore: "+need.creator):"";
    String assistant=(!isItMine)?"":((need.assistant!="")?"\nRichiesta presa in carico da: "+need.assistant:"\nLa richiesta non è ancora stata presa in carico");
    
    final TextButton showNeedButton=
    TextButton(
      child: const Text('Apri descrizione'),
      onPressed: () {
        (isItMine)?{
          //mostra desc
        }:{
          //mostra desc e permetti modifiche
        };
      }
    );

    final TextButton satisfyButton=
    TextButton(
      child: const Text('Soddisfa'),
      style: TextButton.styleFrom(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.all(8.0)
      ),
      onPressed: () {
        //aggiunge il proprio id come assistente
      }
    );

    final TextButton withdrawButton=
    TextButton(
      child: const Text('Ritira disponibilità'),
      style: TextButton.styleFrom(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.all(8.0)
      ),
      onPressed: () {
        //rimuove il proprio id come assistente
      }
    );

    final List<Widget> cardButtons=(!isItMine)
    ?
    ((!assistedByMe)
    ?//neighbors_needs
    [
      showNeedButton,
      const SizedBox(height: 16),
      satisfyButton,
    ]
    ://my_assignments
    [ 
      showNeedButton,
      const SizedBox(height: 16),
      withdrawButton,
    ])
    ://my_needs
    [ 
      showNeedButton,
    ]
    ;

    return Card(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const SizedBox(height: 16),
          Row(
            children:[
            Expanded(
              child: 
              ListTile(
                title: Text(need.title),
                subtitle: Text(
                  "Luogo: "+need.address+"\n"+
                  "Data creazione: "+date+
                  author+
                  assistant
                ),
              ),
            ),
            Column(
              children: cardButtons
            )
          ]),
          const SizedBox(height: 16)
        ],
      ),
    );
  }
}