import 'package:flutter/material.dart';
import 'package:friendly_neighborhood/core/service/create_modify_service.dart';
import 'package:friendly_neighborhood/model/service.dart';

import '../../utils/elaborate_data.dart';

class ShowService extends StatefulWidget {
  final Service service;
  final bool myService;
  const ShowService(
      {super.key, required this.service, required this.myService});

  @override
  State<ShowService> createState() => _ShowServiceState();
}

class _ShowServiceState extends State<ShowService> {
  late final BuildContext _context;
  void removeService() {
    //TODO Richiesta di rimuovere al server
    Navigator.pop(_context);
  }

  Future<void> _showConfirmDeleteDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // L'utente deve premere il pulsante
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Eliminazione servizio'),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text("Sei sicuro di voler eliminare il servizio?"),
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
                removeService();
              },
            ),
          ],
        );
      },
    );
  }

  Widget generaLista() {
    List<Pair<String, String>> contact =
        widget.service.getContactMethodsFromLink();
    return ListView.builder(
        key: Key(widget.service.id.toString()),
        itemCount: contact.length,
        itemBuilder: (BuildContext context, int i) {
          return Container(
            margin: const EdgeInsets.only(bottom: 10.0),
            child: widget.service.getWidgetFromContactMethods(contact[i]),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    _context = context;
    //Creazione lista contatti
    return Scaffold(
        appBar: AppBar(title: Text(widget.service.title)),
        body: Column(
          children: [
            Text('Creato da:${widget.service.creator}'),
            Text(
                'Pubblicato il:${widget.service.postDate.day}-${widget.service.postDate.month}-${widget.service.postDate.year}'),
            Text('Descrizione:${widget.service.description}'),
            //Contatti
            if (widget.service.link != "") ...[
              const Text("Contatti:"),
            ],
            Expanded(child: generaLista()),
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
                if (widget.myService)
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
                                          CreationOrModificationService
                                              .modification(
                                                  service: widget.service)));
                            },
                            child: const Center(
                                child: Padding(
                              padding: EdgeInsets.only(top: 16, bottom: 16),
                              child: Text('Modifica'),
                            )),
                          ))),
                if (widget.myService)
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
                          )))
              ],
            )
          ],
        ));
  }
}