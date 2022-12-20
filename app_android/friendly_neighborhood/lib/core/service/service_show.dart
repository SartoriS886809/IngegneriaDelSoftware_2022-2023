// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:friendly_neighborhood/cache_manager/profile_db.dart';
import 'package:friendly_neighborhood/core/service/create_modify_service.dart';
import 'package:friendly_neighborhood/model/service.dart';
import 'package:friendly_neighborhood/utils/alertdialog.dart';

import '../../API_Manager/api_manager.dart';
import '../../model/localuser.dart';
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
  late BuildContext _context;
  LocalUserManager lum = LocalUserManager();
  LocalUser? user;

  Future<void> removeService() async {
    user ??= await lum.getUser();
    try {
      await API_Manager.deleteElement(
          user!.token, widget.service.id, ELEMENT_TYPE.SERVICES);
      Navigator.pop(_context);
    } catch (e) {
      advancedAlertDialog(
          title: "Errore",
          message: e.toString(),
          buttonMessage: "Riprova",
          f: removeService,
          context: context);
    }
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
            child: Service.getWidgetFromContactMethods(contact[i]),
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
            ListTile(
                title: const Text("Autore"),
                subtitle: Text(widget.service.creator)),
            //Text('Creato da:${widget.service.creator}'),
            ListTile(
                title: const Text("Data pubblicazione"),
                subtitle: Text(
                    "${widget.service.postDate.day}-${widget.service.postDate.month}-${widget.service.postDate.year}")),
            //Text('Pubblicato il:${widget.service.postDate.day}-${widget.service.postDate.month}-${widget.service.postDate.year}'),
            ListTile(
                title: const Text("Descrizione"),
                subtitle: Text(widget.service.description)),
            //Text('Descrizione:${widget.service.description}'),
            //Contatti
            if (widget.service.link != "") ...[
              const ListTile(title: Text("Contatti")),
              //const Text("Contatti:"),
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
                              advancedAlertDialog(
                                  title: 'Eliminazione servizio',
                                  message:
                                      "Sei sicuro di voler eliminare il servizio?",
                                  buttonMessage: "Elimina",
                                  f: removeService,
                                  context: context);
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
