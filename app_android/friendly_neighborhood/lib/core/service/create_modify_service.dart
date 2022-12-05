// ignore_for_file: list_remove_unrelated_type

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:friendly_neighborhood/configuration/configuration.dart';
import 'package:friendly_neighborhood/model/service.dart';

import '../../utils/elaborate_data.dart';

// ignore: must_be_immutable
class CreationOrModificationService extends StatefulWidget {
  Service? service;
  late bool modification;
  CreationOrModificationService({super.key}) {
    service = null;
    modification = false;
  }
  CreationOrModificationService.modification({super.key, this.service}) {
    modification = true;
  }

  @override
  State<CreationOrModificationService> createState() =>
      _CreationOrModificationServiceState();
}

class _CreationOrModificationServiceState
    extends State<CreationOrModificationService> {
  //Variabile gestione Form
  final _formKey = GlobalKey<FormState>();
  final _controllerTitle = TextEditingController();
  final _controllerDescription = TextEditingController();
  late List<Pair<String, String>> _listContact;
  late BuildContext _context;

  Future<void> _showAlertDialog(
      {required String title,
      required String message,
      required String buttonMessage,
      required Function f}) async {
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

  void updateService() {
    widget.service!.title = _controllerTitle.text;
    widget.service!.description = _controllerDescription.text;
    widget.service!.title = Service.getLinkFromContactMethods(_listContact);
    Navigator.pop(_context);
  }

  void createService() {
    //TODO Creator da assegnare
    widget.service = Service(
        postDate: DateTime.now(),
        title: _controllerTitle.text,
        link: Service.getLinkFromContactMethods(_listContact),
        description: _controllerDescription.text,
        creator: "creator");
    Navigator.pop(_context);
  }

  Widget makeList() {
    List<String> contactTypes =
        Configuration.supportedContactMethods.keys.toList();
    return ListView.builder(
        key: const Key("2"),
        itemCount: _listContact.length,
        itemBuilder: (context, index) {
          return Row(
            children: [
              //Tipo di contatto
              Expanded(
                  child: DropdownSearch<String>(
                popupProps: const PopupProps.menu(
                  showSelectedItems: true,
                ),
                items: contactTypes,
                dropdownDecoratorProps: const DropDownDecoratorProps(
                  dropdownSearchDecoration: InputDecoration(
                    labelText: "Metodo",
                  ),
                ),
                onChanged: ((value) {
                  setState(() {
                    _listContact[index].first = value!;
                    setState(() {});
                  });
                }),
                selectedItem: _listContact[index].first,
              )),
              //Contatto
              Expanded(
                  child: TextFormField(
                initialValue: _listContact[index].last,
                keyboardType: (_listContact[index].first != "email" &&
                        _listContact[index].first != "sito web")
                    ? TextInputType.phone
                    : TextInputType.url,
                decoration: const InputDecoration(
                  labelText: "Contatto",
                  hintText: "Inserisci il contatto",
                ),
                //Validatore input username
                validator: (String? value) {
                  //Se è vuoto dice di inserire il titolo
                  if (value == null || value.isEmpty) {
                    return "Il campo non può essere vuoto";
                  } else if ((_listContact[index].first == "email" &&
                      !RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                          .hasMatch(value))) {
                    return "Formato email non corretto";
                  } else if (_listContact[index].first != "sito web" &&
                      !RegExp(r'^(?:[+0][1-9])?[0-9]{10,12}$')
                          .hasMatch(value)) {
                    return "Formato non corretto";
                  } else {
                    return null;
                  }
                },
              )),
              //Remove Row
              Container(
                  decoration: BoxDecoration(
                    border: Border.all(width: 0.5, color: Colors.black),
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.remove),
                    onPressed: (() {
                      _listContact.removeAt(index);
                      setState(() {});
                    }),
                  )),
            ],
          );
        });
  }

  @override
  void initState() {
    super.initState();
    if (widget.modification) {
      _listContact = widget.service!.getContactMethodsFromLink();
    } else {
      _listContact = [];
    }
    //Il metodo viene invocato una volta finito il build
    if (widget.modification && widget.service != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _controllerTitle.text = widget.service!.title;
        _controllerDescription.text = widget.service!.description;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    _context = context;
    return Scaffold(
      appBar: AppBar(
          title: (widget.modification)
              ? const Text("Modificazione servizio")
              : const Text("Creazione servizio")),
      body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //Expanded(child: Container()),
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

                        Row(children: [
                          Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 15),
                              child: Container(
                                child: const Text("Metodi di contatto:"),
                              )),
                          Expanded(child: Container()),
                          Container(
                              decoration: BoxDecoration(
                                border:
                                    Border.all(width: 0.5, color: Colors.black),
                                shape: BoxShape.circle,
                              ),
                              child: IconButton(
                                  onPressed: (() {
                                    setState(() {
                                      _listContact.add(Pair(
                                          first: Configuration
                                              .supportedContactMethods.keys
                                              .toList()[0],
                                          last: ""));
                                    });
                                  }),
                                  icon: const Icon(Icons.add))),
                        ]),
                        //Metodi di contatto
                        Expanded(child: makeList()),
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
                                              if (widget.modification) {
                                                //aggiornare
                                                _showAlertDialog(
                                                    title: "Aggiornamento",
                                                    message:
                                                        "Sei sicuro di voler aggiornare il servizio?",
                                                    buttonMessage: "Aggiorna",
                                                    f: updateService);
                                              } else {
                                                //creare da zero
                                                _showAlertDialog(
                                                    title: "Creazione",
                                                    message:
                                                        "Sei sicuro di voler creare il servizio?",
                                                    buttonMessage: "Crea",
                                                    f: createService);
                                              }
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
