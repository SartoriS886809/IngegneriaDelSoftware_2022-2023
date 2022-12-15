// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:friendly_neighborhood/API_Manager/api_manager.dart';
import 'package:friendly_neighborhood/cache_manager/profile_db.dart';
import 'package:friendly_neighborhood/model/localuser.dart';
import 'package:friendly_neighborhood/model/need.dart';

// ignore: must_be_immutable
class CreationOrModificationNeed extends StatefulWidget {
  Need? need;
  late bool modification;
  CreationOrModificationNeed({super.key}) {
    need = null;
    modification = false;
  }
  CreationOrModificationNeed.modification({super.key, this.need}) {
    modification = true;
  }

  @override
  State<CreationOrModificationNeed> createState() =>
      _CreationOrModificationNeedState();
}

class _CreationOrModificationNeedState
    extends State<CreationOrModificationNeed> {
  final _formKey = GlobalKey<FormState>();
  final _controllerTitle = TextEditingController();
  final _controllerDescription = TextEditingController();
  final _controllerAddress = TextEditingController();
  late BuildContext _context;

  String token = "";
  LocalUserManager lum = LocalUserManager();

  @override
  void initState() {
    super.initState();
    //Il metodo viene invocato una volta finito il build
    if (widget.modification && widget.need != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _controllerTitle.text = widget.need!.title;
        _controllerDescription.text = widget.need!.description;
        _controllerAddress.text = widget.need!.address;
      });
    }
  }

  void updateNeed() async {
    widget.need!.title = _controllerTitle.text;
    widget.need!.description = _controllerDescription.text;
    widget.need!.address = _controllerAddress.text;
    //TODO: invia al server
    LocalUser? user = await lum.getUser();
    token = user!.token;
    await API_Manager.updateElement(token, widget.need, ELEMENT_TYPE.NEEDS);
    //
    Navigator.pop(_context);
  }

  void createNeed() async {
    //TODO Creator da assegnare
    widget.need = Need(
        postDate: DateTime.now(),
        title: _controllerTitle.text,
        address: _controllerAddress.text,
        description: _controllerDescription.text,
        assistant: "",
        creator: ""); //TODO: creator preso da profilo
    //TODO: invia al server
    LocalUser? user = await lum.getUser();
    token = user!.token;
    await API_Manager.createElement(token, widget.need, ELEMENT_TYPE.NEEDS);
    //
    Navigator.pop(_context);
  }

  Future<void> _showAlertDialog() async {
    String title = (widget.modification) ? "Aggiornamento" : "Creazione";
    String message = (widget.modification)
        ? "Sei sicuro di voler aggiornare il bisogno?"
        : "Sei sicuro di voler creare il bisogno?";
    String buttonMessage = (widget.modification) ? "Aggiorna" : "Crea";
    Function f = (widget.modification) ? updateNeed : createNeed;
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // L'utente deve premere il pulsante
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(message),
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
              child: Text(buttonMessage),
              onPressed: () {
                Navigator.of(context).pop();
                f();
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
    return Scaffold(
      appBar: AppBar(
          title: (widget.modification)
              ? const Text("Modificazione bisogno")
              : const Text("Creazione bisogno")),
      body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Form(
                  key: _formKey,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        //Campo Titolo
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: TextFormField(
                            controller: _controllerTitle,
                            decoration: const InputDecoration(
                              hintText: "Inserisci il titolo",
                              labelText: 'Titolo',
                            ),
                            //Validatore input username
                            validator: (String? value) {
                              //Se è vuoto dice di inserire il titolo
                              if (value == null || value.isEmpty) {
                                return "Il campo titolo non può essere vuoto";
                              } else {
                                return null;
                              }
                            },
                          ),
                        ),
                        //Campo Descrizione
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: TextFormField(
                            controller: _controllerDescription,
                            maxLines: null,
                            decoration: const InputDecoration(
                              hintText: "Inserisci una descrizione",
                              labelText: 'Descrizione',
                            ),
                            //Validatore input descrizione
                            validator: (String? value) {
                              //Se è vuoto dice di inserire la descrizione
                              if (value == null || value.isEmpty) {
                                return "Il campo descrizione non può essere vuoto";
                              } else {
                                return null;
                              }
                            },
                          ),
                        ),
                        //Campo Indirizzo
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: TextFormField(
                            controller: _controllerAddress,
                            maxLines: null,
                            decoration: const InputDecoration(
                              hintText: "Inserisci un indirizzo",
                              labelText: 'Indirizzo',
                            ),
                            //Validatore input indirizzo
                            validator: (String? value) {
                              //Se è vuoto dice di inserire l'indirizzo
                              if (value == null || value.isEmpty) {
                                return "Il campo indirizzo non può essere vuoto";
                              } else {
                                return null;
                              }
                            },
                          ),
                        ),
                        Expanded(child: Container()),
                        Row(
                          children: [
                            Expanded(
                                child: //Pulsante Annulla
                                    Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 16.0),
                                        child: ElevatedButton(
                                          onPressed: () async {
                                            Navigator.pop(context);
                                          },
                                          child: const Center(
                                              child: Padding(
                                            padding: EdgeInsets.only(
                                                top: 16, bottom: 16),
                                            child: Text("Annulla"),
                                          )),
                                        ))),
                            Expanded(
                                child: //Pulsante Registrati
                                    Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 16.0),
                                        child: ElevatedButton(
                                          onPressed: () async {
                                            //Controllo se il form è valido
                                            if (_formKey.currentState!
                                                .validate()) {
                                              _showAlertDialog();
                                            }
                                          },
                                          child: Center(
                                              child: Padding(
                                            padding: const EdgeInsets.only(
                                                top: 16, bottom: 16),
                                            child: (widget.modification)
                                                ? const Text("Aggiorna")
                                                : const Text("Crea"),
                                          )),
                                        ))),
                          ],
                        )
                      ])),
            ),
          ]),
    );
  }
}
