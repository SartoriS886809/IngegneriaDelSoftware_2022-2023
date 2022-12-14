// ignore_for_file: list_remove_unrelated_type, use_build_context_synchronously

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:friendly_neighborhood/API_Manager/api_manager.dart';
import 'package:friendly_neighborhood/cache_manager/profile_db.dart';
import 'package:friendly_neighborhood/configuration/configuration.dart';
import 'package:friendly_neighborhood/model/localuser.dart';
import 'package:friendly_neighborhood/model/service.dart';
import 'package:friendly_neighborhood/utils/alertdialog.dart';

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
  LocalUserManager lum = LocalUserManager();
  LocalUser? user;

  void updateService() async {
    user ??= await lum.getUser();
    widget.service!.title = _controllerTitle.text;
    widget.service!.description = _controllerDescription.text;
    widget.service!.link = Service.getLinkFromContactMethods(_listContact);
    try {
      await API_Manager.updateElement(
          user!.token, widget.service, ELEMENT_TYPE.SERVICES);
      Navigator.pop(_context);
    } catch (e) {
      advancedAlertDialog(
          title: "Errore",
          message: e.toString(),
          buttonMessage: "Riprova",
          f: updateService,
          context: context);
    }
  }

  void createService() async {
    user ??= await lum.getUser();
    widget.service = Service(
        postDate: DateTime.now(),
        title: _controllerTitle.text,
        link: Service.getLinkFromContactMethods(_listContact),
        description: _controllerDescription.text,
        creator: "");
    try {
      await API_Manager.createElement(
          user!.token, widget.service, ELEMENT_TYPE.SERVICES);
      Navigator.pop(_context);
    } catch (e) {
      advancedAlertDialog(
          buttonMessage: "Riprova",
          title: "Errore",
          message: e.toString(),
          f: createService,
          context: context);
    }
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
                onChanged: (value) {
                  _listContact[index].last = value;
                },
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
                      _listContact[index].first != "email" &&
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
                          const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 15),
                              child: Text("Metodi di contatto:")),
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

                                                advancedAlertDialog(
                                                    title: "Aggiornamento",
                                                    message:
                                                        "Sei sicuro di voler aggiornare il servizio?",
                                                    buttonMessage: "Aggiorna",
                                                    f: updateService,
                                                    context: context);
                                              } else {
                                                //creare da zero
                                                advancedAlertDialog(
                                                    title: "Creazione",
                                                    message:
                                                        "Sei sicuro di voler creare il servizio?",
                                                    buttonMessage: "Crea",
                                                    f: createService,
                                                    context: context);
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
