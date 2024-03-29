// ignore_for_file: must_be_immutable, use_build_context_synchronously, non_constant_identifier_names, constant_identifier_names

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:friendly_neighborhood/cache_manager/profile_db.dart';
import 'package:friendly_neighborhood/first_page/login_screen.dart';
import 'package:friendly_neighborhood/model/localuser.dart';
import 'package:friendly_neighborhood/utils/alertdialog.dart';
import 'package:intl/intl.dart';

import '../../API_Manager/api_manager.dart';
import '../../configuration/configuration.dart';
import '../../model/neighborhood.dart';
import '../../utils/elaborate_data.dart';

/*
* Classe ModifyProfile:
* La seguente classe si occupa di generare l'interfaccia e gestisce le operazioni
* di modifica del profilo
*/

class ModifyProfile extends StatefulWidget {
  LocalUser user;
  ModifyProfile({super.key, required this.user});

  @override
  State<ModifyProfile> createState() => _ModifyProfileState();
}

class _ModifyProfileState extends State<ModifyProfile> {
  //Variabile gestione Form
  final _formKey = GlobalKey<FormState>();

  //Sezione controller / variabili gestione contenuto campi
  final _controllerUsername = TextEditingController();
  final _controllerEmail = TextEditingController();
  final _controllerName = TextEditingController();
  final _controllerLastname = TextEditingController();
  final _controllerResidence = TextEditingController();
  final _controllerFamily = TextEditingController();
  final _controllerDate = TextEditingController();
  String _choice_house_type = "Scegliere una tipologia";
  late Neighborhood _choice_neighborhood;
  //Dati scelta utente
  static const _house_types = ["Appartamento", "Casa singola"];
  late List<Neighborhood> _neighborhood = [];

  late BuildContext _context;
  late bool alreadyOpenAlertDialog = false;
  LocalUserManager lum = LocalUserManager();
  @override
  void initState() {
    super.initState();
    _controllerUsername.text = widget.user.username;
    _controllerEmail.text = widget.user.email;
    _controllerName.text = widget.user.name;
    _controllerLastname.text = widget.user.lastname;
    _controllerResidence.text = widget.user.address;
    _controllerFamily.text = widget.user.family.toString();
    _controllerDate.text =
        DateFormat('dd-MM-yyyy').format(widget.user.birth_date);
    _choice_house_type = widget.user.house_type;
    _choice_neighborhood = Neighborhood(
        id: widget.user.id_neighborhoods,
        area: 0,
        name: widget.user.neighborhood);
  }

/*
* funzione setChoiceNeighborhood
* la seguente funzione si occupa di selezionare il quartiere in base all'id 
*/
  void setChoiceNeighborhood() {
    for (Neighborhood n in _neighborhood) {
      if (n.id == _choice_neighborhood.id) {
        _choice_neighborhood = n;
        return;
      }
    }
  }

/*
* funzione updateProfile
* la seguente funzione si occupa di aggiornare le informazioni sul server
*/
  void updateProfile() async {
    LocalUser updatedUser = LocalUser(
        _controllerEmail.text,
        _controllerUsername.text,
        _controllerName.text,
        _controllerLastname.text,
        DateFormat('dd-MM-yyyy').parse(_controllerDate.text),
        _controllerResidence.text,
        int.parse(_controllerFamily.text),
        _choice_house_type,
        _choice_neighborhood.name,
        _choice_neighborhood.id,
        widget.user.token);
    try {
      await API_Manager.updateProfile(updatedUser);
      await lum.updateUser(updatedUser);
      Navigator.pop(context);
    } catch (e) {
      advancedAlertDialog(
          title: "Errore",
          message: e.toString(),
          buttonMessage: "Riprova",
          f: updateProfile,
          context: _context);
    }
  }

/*
* funzione retry
* la seguente funzione si occupa di rigenerare la pagina
*/
  void retry() {
    setState(() {});
  }

/*
* funzione makeNeighborhoodMenu
* la seguente funzione si occupa di scaricare e generare il menu con i vari
* quartieri
*/
  Future<Widget> makeNeighborhoodMenu() async {
    try {
      _neighborhood = await API_Manager.getNeighborhoods();
    } catch (e) {
      return Future.error(e);
    }
    //Controllo sessione valida
    if (!await API_Manager.checkToken(widget.user.email, widget.user.token)) {
      Navigator.pop(context);
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => LoginScreen.withMessage(
                  message:
                      "Sessione non più valida, si prega di rieseguire il login")));
    }
    setChoiceNeighborhood();
    return Row(
      children: [
        Expanded(
          child: DropdownSearch<Neighborhood>(
            items: _neighborhood,
            compareFn: (i, s) => i.isEqual(s),
            itemAsString: (Neighborhood u) => u.name,
            onChanged: ((value) => _choice_neighborhood = value!),
            selectedItem: _neighborhood[0],
            filterFn: ((item, filter) =>
                item.functionFilterForNeighborhoods(filter)),
            dropdownDecoratorProps: const DropDownDecoratorProps(
              dropdownSearchDecoration: InputDecoration(
                labelText: "Quartiere",
              ),
            ),
            popupProps: PopupPropsMultiSelection.modalBottomSheet(
              isFilterOnline: true,
              showSelectedItems: true,
              showSearchBox: true,
              itemBuilder: _popupSearchBox,
            ),
          ),
        )
      ],
    );
  }

/*
* funzione _popupSearchBox
* la seguente funzione si occupa di mostrare a schermo un pop-up per selezionare
* il quartiere desiderato
*/
  Widget _popupSearchBox(
    BuildContext context,
    Neighborhood? item,
    bool isSelected,
  ) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      decoration: !isSelected
          ? null
          : BoxDecoration(
              border: Border.all(color: Theme.of(context).primaryColor),
              borderRadius: BorderRadius.circular(5),
              color: Colors.white,
            ),
      child: ListTile(
        selected: isSelected,
        title: Text(item?.name ?? ''),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    _context = context;
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text("Modifica profilo"),
        ),
        body: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                  child: SingleChildScrollView(
                child: Form(
                    key: _formKey,
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          //Campo Username
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            child: TextFormField(
                              controller: _controllerUsername,
                              decoration: const InputDecoration(
                                hintText: "Inserisci l'username",
                                labelText: 'Username',
                              ),
                              //Validatore input username
                              validator: (String? value) {
                                //Se è vuoto dice di inserire l'username
                                if (value == null || value.isEmpty) {
                                  return "Il campo username non può essere vuoto";
                                } else {
                                  return null;
                                }
                              },
                            ),
                          ),
                          //Campo Email
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            child: TextFormField(
                              controller: _controllerEmail,
                              decoration: const InputDecoration(
                                hintText: "Inserisci l'email",
                                labelText: 'Email',
                              ),
                              //Validatore input email
                              validator: (String? value) {
                                //Se è vuoto dice di inserire l'email
                                if (value == null || value.isEmpty) {
                                  return "Il campo email non può essere vuoto";
                                  //Controlla che l'email sia stata inserita nel formato corretto
                                } else if (!RegExp(
                                        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                    .hasMatch(value)) {
                                  return "Formato email non corretto";
                                  //Email inserita correttamente
                                } else {
                                  return null;
                                }
                              },
                            ),
                          ),
                          //Campo Nome
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            child: TextFormField(
                              controller: _controllerName,
                              keyboardType: TextInputType.name,
                              decoration: const InputDecoration(
                                hintText: "Inserisci il nome",
                                labelText: 'Nome',
                              ),
                              //Validatore input nome
                              validator: (String? value) {
                                //Se è vuoto dice di inserire il nome
                                if (value == null || value.isEmpty) {
                                  return "Il campo nome non può essere vuoto";
                                  //Controlla che il nome sia stato inserito nel formato corretto
                                } else {
                                  return null;
                                }
                              },
                            ),
                          ),
                          //Campo Cognome
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            child: TextFormField(
                              keyboardType: TextInputType.name,
                              controller: _controllerLastname,
                              decoration: const InputDecoration(
                                hintText: "Inserisci il cognome",
                                labelText: 'Cognome',
                              ),
                              //Validatore input cognome
                              validator: (String? value) {
                                //Se è vuoto dice di inserire il cognome
                                if (value == null || value.isEmpty) {
                                  return "Il campo cognome non può essere vuoto";
                                  //Controlla che il nome sia stato inserito nel formato corretto
                                } else {
                                  return null;
                                }
                              },
                            ),
                          ),
                          //Campo Data di nascita
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            child: TextFormField(
                              controller: _controllerDate,
                              keyboardType: TextInputType.datetime,
                              validator: (String? value) {
                                //Se è vuoto dice di inserire la data
                                if (value == null || value.isEmpty) {
                                  return "Il campo data non può essere vuoto";
                                }
                                int age = calculateAge(_controllerDate.text);
                                //Data futura o età inferiore al limite
                                if (age < Configuration.minAge || age > 120) {
                                  return "Scegliere una data valida";
                                } else {
                                  return null;
                                }
                              },
                              decoration: const InputDecoration(
                                  labelText: "Data di nascita"),
                              //il testo non può essere modificato direttamente
                              readOnly: true,
                              onTap: () async {
                                DateTime? pickedDate = await showDatePicker(
                                    keyboardType: TextInputType.datetime,
                                    context: context,
                                    locale: const Locale("it", "IT"),
                                    initialDate: (_controllerDate.text != "")
                                        ? DateFormat('dd-MM-yyyy')
                                            .parse(_controllerDate.text)
                                        : DateTime.now(),
                                    firstDate: DateTime(1900),
                                    //Blocco le date future.
                                    lastDate: DateTime.now());

                                if (pickedDate != null) {
                                  String formattedDate =
                                      DateFormat('dd-MM-yyyy')
                                          .format(pickedDate);
                                  setState(() {
                                    _controllerDate.text =
                                        formattedDate; //set output date to TextField value.
                                  });
                                }
                              },
                            ),
                          ),
                          //Campo Residenza
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            child: TextFormField(
                              controller: _controllerResidence,
                              decoration: const InputDecoration(
                                hintText: "Inserisci la residenza",
                                labelText: 'Residenza',
                              ),
                              //Validatore Residenza
                              validator: (String? value) {
                                //Se è vuoto dice di inserire la residenza
                                if (value == null || value.isEmpty) {
                                  return "Il campo residenza non può essere vuoto";
                                } else {
                                  return null;
                                }
                              },
                            ),
                          ),
                          //Tipologia Casa
                          Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 15),
                              child: DropdownButtonFormField<String>(
                                value: _choice_house_type,
                                hint: const Text('Scegliere una tipologia: '),
                                onChanged: (newValue) {
                                  setState(() {
                                    _choice_house_type = newValue!;
                                  });
                                },
                                items: _house_types.map((valueItem) {
                                  return DropdownMenuItem<String>(
                                    value: valueItem,
                                    child: Text(valueItem),
                                  );
                                }).toList(),
                              )),
                          //Campo Nucleo familiare
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            child: TextFormField(
                              controller: _controllerFamily,
                              decoration: const InputDecoration(
                                hintText:
                                    "Inserisci il numero di membri nel nucleo familiare",
                                labelText: 'Nucleo familiare',
                              ),
                              keyboardType: TextInputType.number,
                              //Validatore Residenza
                              validator: (String? value) {
                                //Se è vuoto dice di inserire la residenza
                                if (value == null || value.isEmpty) {
                                  return "Il campo nucleo familiare non può essere vuoto";
                                } else if (int.parse(value) <= 0 ||
                                    int.parse(value) > 10) {
                                  return "Inserisci un numero valido";
                                } else {
                                  return null;
                                }
                              },
                            ),
                          ),
                          //Quartiere
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            child: FutureBuilder<Widget>(
                                future: makeNeighborhoodMenu(),
                                builder:
                                    (context, AsyncSnapshot<Widget> snapshot) {
                                  if (snapshot.hasData) {
                                    return snapshot.data!;
                                  } else if (snapshot.hasError) {
                                    WidgetsBinding.instance
                                        .addPostFrameCallback((_) {
                                      if (!alreadyOpenAlertDialog) {
                                        alreadyOpenAlertDialog = true;
                                        simpleAlertDialog(
                                            text: "${snapshot.error!}",
                                            f: () {
                                              alreadyOpenAlertDialog = false;
                                              retry();
                                            },
                                            context: context);
                                      }
                                    });

                                    return const Text(
                                        "Si è verificato un errore");
                                  } else {
                                    return const CircularProgressIndicator();
                                  }
                                }),
                          ),
                          //Pulsante Aggiorna dati
                          Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 16.0, horizontal: 50),
                              child: ElevatedButton.icon(
                                icon: const Icon(Icons.upload),
                                onPressed: () async {
                                  //Controllo se il form è valido
                                  if (_formKey.currentState!.validate()) {
                                    advancedAlertDialog(
                                        title: "Conferma aggiornamento",
                                        message:
                                            "Sei sicuro di voler aggiornare i dati del profilo",
                                        buttonMessage: "Sì",
                                        f: updateProfile,
                                        context: context);
                                  }
                                },
                                label: const Center(
                                    child: Padding(
                                  padding: EdgeInsets.only(top: 16, bottom: 16),
                                  child: Text('Aggiorna profilo'),
                                )),
                              )),
                          Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 16.0, horizontal: 50),
                              child: ElevatedButton.icon(
                                icon: const Icon(Icons.cancel),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                label: const Center(
                                    child: Padding(
                                  padding: EdgeInsets.only(top: 16, bottom: 16),
                                  child: Text('Annulla'),
                                )),
                              ))
                        ])),
              ))
            ]));
  }
}
