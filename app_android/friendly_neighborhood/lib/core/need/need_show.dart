// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:friendly_neighborhood/API_Manager/api_manager.dart';
import 'package:friendly_neighborhood/cache_manager/profile_db.dart';
import 'package:friendly_neighborhood/core/need/create_modify_need.dart';
import 'package:friendly_neighborhood/model/localuser.dart';
import 'package:friendly_neighborhood/model/need.dart';

import '../../utils/alertdialog.dart';

class ShowNeed extends StatefulWidget {
  final Need need;
  final bool
      isItMine; //indica se l'utente corrente è il creatore del bisogno visualizzato
  final bool
      assistedByMe; //indica se l'utente corrente è attualmente in carico del bisogno visualizzato
  const ShowNeed(
      {super.key,
      required this.need,
      required this.isItMine,
      required this.assistedByMe});

//la seguente funzione crea una finestra di dialogo per gestire la conferma di cambiamenti nella disponibilità all'assistenza di una richiesta
//parametro callFromList indica se la funzione è stata chiamata dalla lista nella sezione "My assignments"
  Future<void> showConfirmAssistanceChangeDialog(BuildContext context,
      [bool callFromMyAssignments = false]) async {
    return (assistedByMe)
        ? advancedAlertDialog(
            title: 'Ritiro disponibilità',
            message:
                "Sei sicuro di voler ritirare la disponibilità all'assistenza?",
            buttonMessage: 'Ritira disponibilità',
            f: () {
              // Navigator.of(context).pop();
              changeAssistanceAvailability(context, callFromMyAssignments);
            },
            context: context)
        : advancedAlertDialog(
            title: 'Soddisfazione richiesta',
            message: "Sei sicuro di voler soddisfare la richiesta?",
            buttonMessage: 'Soddisfa',
            f: () {
              //Navigator.of(context).pop();
              changeAssistanceAvailability(context, callFromMyAssignments);
            },
            context: context);
    /*return showDialog<void>(
      context: context,
      barrierDismissible: false, // L'utente deve premere il pulsante
      builder: (BuildContext context) {
        return AlertDialog(
          title: (assistedByMe)
              ? const Text('Ritiro disponibilità')
              : const Text('Soddisfazione richiesta'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                (assistedByMe)
                    ? const Text(
                        "Sei sicuro di voler ritirare la disponibilità all'assistenza?")
                    : const Text(
                        "Sei sicuro di voler soddisfare la richiesta?"),
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
              child: (assistedByMe)
                  ? const Text('Ritira disponibilità')
                  : const Text('Soddisfa'),
              onPressed: () {
                Navigator.of(context).pop();
                changeAssistanceAvailability(context, callFromMyAssignments);
              },
            ),
          ],
        );
      },
    );*/
  }

//questa funzione si occupa della richiesta al server di modifica del campo relativo all'assistente del bisogno visualizzato
  void changeAssistanceAvailability(BuildContext context,
      [bool callFromMyAssignments = false]) async {
    String token = "";
    LocalUserManager lum = LocalUserManager();
    LocalUser? user = await lum.getUser();
    token = user!.token;

    if (assistedByMe) {
      // Richiesta al server di rimozione del proprio id come assistente dal bisogno
      await API_Manager.assistanceNeed(token, need.id, false);
    } else {
      // Richiesta al server di inserimento del proprio id come assistente dal bisogno
      await API_Manager.assistanceNeed(token, need.id, true);
    }
    if (!callFromMyAssignments) Navigator.pop(context);
  }

  @override
  State<ShowNeed> createState() => _ShowNeedState();
}

class _ShowNeedState extends State<ShowNeed> {
  late BuildContext _context;

  void removeNeed() async {
    String token = "";
    LocalUserManager lum = LocalUserManager();
    LocalUser? user = await lum.getUser();
    token = user!.token;
    await API_Manager.deleteElement(token, widget.need.id, ELEMENT_TYPE.NEEDS);
    Navigator.pop(_context);
  }

  Future<void> _showConfirmDeleteDialog(BuildContext context) async {
    return advancedAlertDialog(
        title: "Eliminazione bisogno",
        message: "Sei sicuro di voler eliminare la richiesta?",
        buttonMessage: "Elimina",
        f: () {
          //Navigator.of(context).pop();
          removeNeed();
        },
        context: context);
    /*return showDialog<void>(
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
    );*/
  }

  @override
  Widget build(BuildContext context) {
    _context = context;
    //Creazione lista contatti
    return Scaffold(
        appBar: AppBar(title: Text(widget.need.title)),
        body: Column(
          children: [
            ListTile(
                title: const Text("Autore"),
                subtitle: Text(widget.need.creator)),
            //Text('Creato da: ${widget.need.creator}'),
            ListTile(
                title: const Text("Data pubblicazione"),
                subtitle: Text(
                    "${widget.need.postDate.day}-${widget.need.postDate.month}-${widget.need.postDate.year}")),
            //Text('Pubblicato il: ${widget.need.postDate.day}-${widget.need.postDate.month}-${widget.need.postDate.year}'),
            ListTile(
                title: const Text("Luogo"),
                subtitle: Text(widget.need.address)),
            //Text('Luogo associato: ${widget.need.address}'),
            if (widget.isItMine && widget.need.assistant != "")
              ListTile(
                  title: const Text("Assistente volontario"),
                  subtitle: Text(widget.need.assistant)),
            //Text('Richiesta presa in carico da: ${widget.need.assistant}'),
            if (widget.isItMine && widget.need.assistant == "")
              const ListTile(
                  title: Text("Autore"),
                  subtitle:
                      Text("La richiesta non è ancora stata presa in carico")),
            //const Text('La richiesta non è ancora stata presa in carico'),
            ListTile(
              title: const Text("Descrizione"),
              subtitle: Text(widget.need.description),
            ),
            //Text('Descrizione: ${widget.need.description}'),

            Expanded(child: Container()),
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
                              Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              CreationOrModificationNeed
                                                  .modification(
                                                      need: widget.need)))
                                  .then((value) => Navigator.pop(context));
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
                              _showConfirmDeleteDialog(context);
                              //La pagina si chiude se solo se viene eliminita il servizio
                            },
                            child: const Center(
                                child: Padding(
                              padding: EdgeInsets.only(top: 16, bottom: 16),
                              child: Text('Elimina'),
                            )),
                          ))),
                if (!widget
                    .isItMine) //se il bisogno non è dell'utente corrente, questo deve poter soddisfarlo o ritirare la disponibilità
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
                              padding:
                                  const EdgeInsets.only(top: 16, bottom: 16),
                              child: (widget.assistedByMe)
                                  ? const Text('Ritira disponibilità')
                                  : const Text('Soddisfa'),
                            )),
                          ))),
              ],
            )
          ],
        ));
  }
}
