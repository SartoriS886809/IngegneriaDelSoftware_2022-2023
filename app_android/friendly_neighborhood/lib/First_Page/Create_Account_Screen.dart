// ignore_for_file: non_constant_identifier_names, unused_field, constant_identifier_names, prefer_final_fields, file_names

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:friendly_neighborhood/API_Manager/api_manager.dart';
import 'package:friendly_neighborhood/First_Page/login_screen.dart';
import 'package:friendly_neighborhood/configuration/configuration.dart';
import 'package:friendly_neighborhood/utils/check_connection.dart';
import 'package:intl/intl.dart';
import 'package:friendly_neighborhood/utils/elaborate_data.dart';
import 'package:dropdown_search/dropdown_search.dart';

class CreateAccountScreen extends StatefulWidget {
  const CreateAccountScreen({super.key});

  @override
  State<CreateAccountScreen> createState() => _CreateAccountScreenState();
}

class _CreateAccountScreenState extends State<CreateAccountScreen> {
  //Variabile gestione Form
  final _formKey = GlobalKey<FormState>();

  //Variabili per gestire la visibilità del testo nei campi password
  late bool _passwordVisible;
  late IconData _iconPassword;
  late bool _confirmPasswordVisible;
  late IconData _confirmIconPassword;

  //Sezione controller / variabili gestione contenuto campi
  final _controllerUsername = TextEditingController();
  final _controllerEmail = TextEditingController();
  final _controllerPassword = TextEditingController();
  final _controllerName = TextEditingController();
  final _controllerLastname = TextEditingController();
  final _controllerResidence = TextEditingController();
  final _controllerFamily = TextEditingController();
  final _controllerDate = TextEditingController();
  String _choice_house_type = "Scegliere una tipologia";
  String _choice_neighborhood = "Scegli un quartiere";

  //Dati scelta utente
  static const _house_types = [
    "Scegliere una tipologia",
    "Appartamento",
    "Casa singola"
  ];
  List<String> _neighborhood = ["Scegli un quartiere"];

  Future<Widget> makeNeighborhoodMenu() async {
    //TODO gestire errori
    List<String> list = await API_Manager.getNeighborhoods();
    _neighborhood = ["Scegli un quartiere"] + list;
    if (_neighborhood.length > 1) {
      _neighborhood.removeAt(_neighborhood.length - 1);
    }
    return DropdownSearch<String>(
      popupProps: const PopupProps.menu(
        showSelectedItems: true,
      ),
      items: _neighborhood,
      validator: (value) {
        if (value == "Scegliere un quartiere") {
          return "Scegliere un quartiere";
        } else {
          return null;
        }
      },
      dropdownDecoratorProps: const DropDownDecoratorProps(
        dropdownSearchDecoration: InputDecoration(
          labelText: "Quartiere",
        ),
      ),
      onChanged: ((value) => _choice_neighborhood = value!),
      selectedItem: _neighborhood[0],
    );
  }

  @override
  void initState() {
    super.initState();
    _passwordVisible = false;
    _iconPassword = Icons.visibility;
    _confirmPasswordVisible = false;
    _confirmIconPassword = Icons.visibility;
  }

  Future<void> _showAlertDialog({required String text}) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // L'utente deve premere il pulsante
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Avviso'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(text),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Ok'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text("Crea Account"),
        ),
        body: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              //Expanded(child: Container()),
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
                          //Campo Password
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            child: TextFormField(
                              //Parametro per nascondere la password
                              obscureText: !_passwordVisible,
                              controller: _controllerPassword,
                              decoration: InputDecoration(
                                  hintText: 'Inserisci la password',
                                  labelText: 'Password',
                                  //Pulsante per cambiare la visibilità del contenuto del campo password
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      _iconPassword,
                                      color: Theme.of(context).primaryColorDark,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        if (!_passwordVisible) {
                                          _iconPassword = Icons.visibility_off;
                                        } else {
                                          _iconPassword = Icons.visibility;
                                        }
                                        _passwordVisible = !_passwordVisible;
                                      });
                                    },
                                  )),
                              validator: (String? value) {
                                if (value == null || value.isEmpty) {
                                  return "Il campo password non può essere vuoto";
                                } else if (value.length <
                                    Configuration.minLengthPassword) {
                                  return "La password deve essere minimo di ${Configuration.minLengthPassword} caratteri";
                                } else {
                                  return null;
                                }
                              },
                            ),
                          ),
                          //Campo Conferma Password
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            child: TextFormField(
                              //Parametro per nascondere la password
                              obscureText: !_confirmPasswordVisible,
                              decoration: InputDecoration(
                                  hintText: 'Conferma la password inserita',
                                  labelText: 'Conferma password',
                                  //Pulsante per cambiare la visibilità del contenuto del campo password
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      _confirmIconPassword,
                                      color: Theme.of(context).primaryColorDark,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        if (!_confirmPasswordVisible) {
                                          _confirmIconPassword =
                                              Icons.visibility_off;
                                        } else {
                                          _confirmIconPassword =
                                              Icons.visibility;
                                        }
                                        _confirmPasswordVisible =
                                            !_confirmPasswordVisible;
                                      });
                                    },
                                  )),
                              validator: (String? value) {
                                if (value == null ||
                                    value != _controllerPassword.text) {
                                  return "Le password devono corrispondere";
                                } else if (value.length <
                                    Configuration.minLengthPassword) {
                                  return "La password deve essere di almeno {$Configuration.minLengthPassword} caratteri";
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
                                } else if (!RegExp('[a-zA-Z]')
                                    .hasMatch(value)) {
                                  //TODO REGEXP NON FUNZIONA
                                  return "Formato cognome non corretto";
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
                                } else if (!RegExp('[a-zA-Z]')
                                    .hasMatch(value)) {
                                  //TODO REGEXP NON FUNZIONA
                                  return "Formato cognome non corretto";
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
                                    context: context,
                                    locale: const Locale("it", "IT"),
                                    initialDate: DateTime.now(),
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
                                  //TODO inserire se possibile check della residenza
                                } else {
                                  return null;
                                }
                              },
                            ),
                          ),
                          //Tipologia Casa
                          //TODO fix glitch grafico all'apertura del menù
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            child: DropdownSearch<String>(
                              popupProps: const PopupProps.menu(
                                showSelectedItems: true,
                              ),
                              items: _house_types,
                              validator: (value) {
                                if (value == _house_types[0]) {
                                  return "Scegliere una tipologia";
                                } else {
                                  return null;
                                }
                              },
                              dropdownDecoratorProps:
                                  const DropDownDecoratorProps(
                                dropdownSearchDecoration: InputDecoration(
                                  labelText: "Tipologia abitazione",
                                ),
                              ),
                              onChanged: ((value) =>
                                  _choice_house_type = value!),
                              selectedItem: _house_types[0],
                            ),
                          ),
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
                          //TODO fix glitch grafico all'apertura del menù
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            child: FutureBuilder<Widget>(
                                future: makeNeighborhoodMenu(),
                                builder:
                                    (context, AsyncSnapshot<Widget> snapshot) {
                                  if (snapshot.hasData) {
                                    return snapshot.data!;
                                  } else {
                                    return const CircularProgressIndicator();
                                  }
                                }),
                          ),
                          //Pulsante Registrati
                          Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 16.0),
                              child: ElevatedButton(
                                onPressed: () async {
                                  //Controllo se il form è valido
                                  if (_formKey.currentState!.validate()) {
                                    //Controllo connessione internet
                                    bool check = await CheckConnection.check();
                                    if (check) {
                                      //TODO inviare richiesta server
                                    } else {
                                      _showAlertDialog(
                                          text:
                                              "Impossibile connettersi. Verifica la connessione ad internet");
                                    }
                                  }
                                },
                                child: const Center(
                                    child: Padding(
                                  padding: EdgeInsets.only(top: 16, bottom: 16),
                                  child: Text('Registrati'),
                                )),
                              ))
                        ])),
              )),
              //Elemento in fondo alla pagina
              //Expanded(child: Container()),
              //Creo una linea orizzontale per seperare gli elementi
              const Divider(color: Colors.black),
              //Se non si ha un account, c'è questo shortcut per arrivarci
              Row(
                mainAxisAlignment:
                    MainAxisAlignment.center, //Centra gli elementi al centro
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 15, bottom: 15),
                    //RichText: testo cliccabile
                    child: RichText(
                      text: TextSpan(children: [
                        const TextSpan(
                          text: 'Possiedi già un account? ',
                          style: TextStyle(
                            color: Colors.black,
                          ),
                        ),
                        TextSpan(
                            text: 'Accedi',
                            style: const TextStyle(
                              color: Colors.blue,
                            ),
                            //Se il testo viene cliccato
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                //Rimuovo dallo stack la pagina di login e inserisco quella di creazione account
                                Navigator.of(context).pop();
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const LoginScreen()));
                              }),
                      ]),
                    ),
                  )
                ],
              )
            ]));
  }
}
