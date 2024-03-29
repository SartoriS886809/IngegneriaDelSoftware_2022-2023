import 'package:flutter/material.dart';
import 'package:friendly_neighborhood/core/core.dart';
import 'package:friendly_neighborhood/model/need.dart';
import 'package:friendly_neighborhood/core/need/need_show.dart';

import '../../utils/elaborate_data.dart';


// ignore: slash_for_doc_comments
/** 
 * La classe NeedCard rappresenta il riquadro relativo ad un bisogno visualizzato in una delle liste della sezione dei bisogni.
 * Il contenuto varia in base alla lista di appartenenza
*/
class NeedCard extends StatelessWidget {
  final DownloadNewDataFunction downloadNewDataFunction;
  final Need need;
  final bool
      isItMine; //indica se la card rappresenta un bisogno dell'utente corrente
  final bool
      assistedByMe; //indica se la card rappresenta un bisogno preso in carico dall'utente corrente
  const NeedCard(
      {super.key,
      required this.need,
      required this.isItMine,
      required this.downloadNewDataFunction,
      this.assistedByMe = false});

  @override
  Widget build(BuildContext context) {
    String date = convertDateTimeToDate(need.postDate);
    //"${need.postDate.day}-${need.postDate.month}-${need.postDate.year} ${need.postDate.hour}:${need.postDate.minute}";
    String author = (!isItMine) ? ("\nAutore: ${need.creator}") : "";
    String assistant = (!isItMine)
        ? ""
        : ((need.assistant != "")
            ? "\nRichiesta presa in carico da: ${need.assistant}"
            : "\nLa richiesta non è ancora stata presa in carico");
    ShowNeed
        showNeedPage = //riferimento alla pagina di visualizzazione bisogno collegata al rispettivo pulsante nella card
        ShowNeed(
      need: need,
      isItMine: isItMine,
      assistedByMe: assistedByMe,
    );

    final TextButton showNeedButton = TextButton( //pulsante per la visualizzazione del bisogno
        child: const Text('Apri descrizione'),
        onPressed: () {
          Navigator.push(context,
                  MaterialPageRoute(builder: (context) => showNeedPage))
              .then((value) => downloadNewDataFunction(true));
        });

    final TextButton satisfyButton = TextButton(  //pulsante per prendere in carico il bisogno
        style: TextButton.styleFrom(
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.all(8.0)),
        onPressed: () async {
          //aggiunge il proprio id come assistente se viene data conferma
          await showNeedPage.showConfirmAssistanceChangeDialog(context, true);
          downloadNewDataFunction(true);
        },
        child: const Text('Soddisfa'));

    final TextButton withdrawButton = TextButton( //pulsante per ritirare la disponibilità   
        style: TextButton.styleFrom(
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.all(8.0)),
        onPressed: () async {
          //rimuove il proprio id come assistente se viene data conferma
          await showNeedPage.showConfirmAssistanceChangeDialog(context, true);
          downloadNewDataFunction(true);
        },
        child: const Text('Ritira disponibilità'));

    final List<Widget> cardButtons = (!isItMine)
        ? ((!assistedByMe)
            ? //neighbors_needs
            [
                showNeedButton,
                const SizedBox(height: 16),
                satisfyButton,
              ]
            : //my_assignments
            [
                showNeedButton,
                const SizedBox(height: 16),
                withdrawButton,
              ])
        : //my_needs
        [
            showNeedButton,
          ];

    return Card(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const SizedBox(height: 16),
          Row(children: [
            Expanded(
              child: ListTile(
                title: Text(need.title),
                subtitle: Text(
                    "Luogo: ${need.address}\nData creazione: $date$author$assistant"),
              ),
            ),
            Column(children: cardButtons)
          ]),
          const SizedBox(height: 16)
        ],
      ),
    );
  }
}
