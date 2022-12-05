import 'package:flutter/material.dart';
import 'package:friendly_neighborhood/core/need/create_modify_need.dart';
import 'package:friendly_neighborhood/model/need.dart';


class ShowNeed extends StatefulWidget {
  final Need need;
  final bool isItMine;//indica se l'utente corrente è il creatore del bisogno visualizzato
  final bool assistedByMe;//indica se l'utente corrente è attualmente in carico del bisogno visualizzato
  const ShowNeed({super.key, required this.need, required this.isItMine, required this.assistedByMe});

//la seguente funzione crea una finestra di dialogo per gestire la conferma di cambiamenti nella disponibilità all'assistenza di una richiesta
//parametro callFromList indica se la funzione è stata chiamata dalla lista nella sezione "My assignments"
  Future<void> showConfirmAssistanceChangeDialog(BuildContext context, [bool callFromMyAssignments=false]) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // L'utente deve premere il pulsante
      builder: (BuildContext context) {
        return AlertDialog(
          title: (assistedByMe)?Text('Ritiro disponibilità'):Text('Soddisfazione richiesta'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                (assistedByMe)?Text("Sei sicuro di voler ritirare la disponibilità all'assistenza?"):Text("Sei sicuro di voler soddisfare la richiesta?"),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Annulla'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: (assistedByMe)?Text('Ritira disponibilità'):Text('Soddisfa'),
              onPressed: () {

                Navigator.of(context).pop();
                changeAssistanceAvailability(context,callFromMyAssignments);
              },
            ),
          ],
        );
      },
    );
  }

//questa funzione si occupa della richiesta al server di modifica del campo relativo all'assistente del bisogno visualizzato
  void changeAssistanceAvailability(BuildContext context, [bool callFromMyAssignments=false]) {
    if(assistedByMe){
      //TODO Richiesta al server di rimozione del proprio id come assistente dal bisogno
    }else{
      //TODO Richiesta al server di inserimento del proprio id come assistente dal bisogno
    }
    if(!callFromMyAssignments) Navigator.pop(context);
  }

  @override
  State<ShowNeed> createState() => _ShowNeedState();
}

class _ShowNeedState extends State<ShowNeed> {
  late BuildContext _context;

  void removeNeed() {
    //TODO Richiesta di rimozione bisogno al server
    Navigator.pop(_context);
  }

  Future<void> _showConfirmDeleteDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // L'utente deve premere il pulsante
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Eliminazione bisogno'),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text("Sei sicuro di voler eliminare la richiesta?"),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Annulla'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Elimina'),
              onPressed: () {
                Navigator.of(context).pop();
                removeNeed();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    _context = context;
    //Creazione lista contatti
    return Scaffold(
        appBar: AppBar(title: Text(widget.need.title)),
        body: Column(
          children: [
            Text('Creato da: ${widget.need.creator}'),
            Text('Pubblicato il: ${widget.need.postDate.day}-${widget.need.postDate.month}-${widget.need.postDate.year}'),
            Text('Luogo associato: ${widget.need.address}'),
            if(widget.isItMine && widget.need.assistant!="") Text('Richiesta presa in carico da: ${widget.need.assistant}'),
            if(widget.isItMine && widget.need.assistant=="") Text('La richiesta non è ancora stata presa in carico'),
            Text('Descrizione: ${widget.need.description}'),
             
            Expanded(child:Container()),
            Row(
              children: [
                Expanded(
                    child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        child: ElevatedButton(
                          onPressed: () async {
                            Navigator.pop(context);
                          },
                          child: const Center(
                              child: Padding(
                            padding: EdgeInsets.only(top: 16, bottom: 16),
                            child: Text('Torna indietro'),
                          )),
                        ))),
                if (widget.isItMine)
                  Expanded(
                      child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16.0),
                          child: ElevatedButton(
                            onPressed: () async {
                              Navigator.pop(context);
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          CreationOrModificationNeed
                                              .modification(
                                                  need: widget.need)));
                            },
                            child: const Center(
                                child: Padding(
                              padding: EdgeInsets.only(top: 16, bottom: 16),
                              child: Text('Modifica'),
                            )),
                          ))),
                if (widget.isItMine)
                  Expanded(
                      child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16.0),
                          child: ElevatedButton(
                            onPressed: () async {
                              _showConfirmDeleteDialog();
                              //La pagina si chiude se solo se viene eliminita il servizio
                            },
                            child: const Center(
                                child: Padding(
                              padding: EdgeInsets.only(top: 16, bottom: 16),
                              child: Text('Elimina'),
                            )),
                          ))),
                if (!widget.isItMine)//se il bisogno non è dell'utente corrente, questo deve poter soddisfarlo o ritirare la disponibilità
                  Expanded(
                      child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16.0),
                          child: ElevatedButton(
                            onPressed: () async {
                              widget.showConfirmAssistanceChangeDialog(context);
                              //La pagina si chiude se solo se viene eliminita il servizio
                            },
                            child: Center(
                                child: Padding(
                              padding: EdgeInsets.only(top: 16, bottom: 16),
                              child: (widget.assistedByMe)?Text('Ritira disponibilità'):Text('Soddisfa'),
                            )),
                          ))),
              ],
            )
          ],
        ));
  }
}
