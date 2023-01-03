// ignore_for_file: non_constant_identifier_names, constant_identifier_names, use_build_context_synchronously, file_name

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:friendly_neighborhood/API_Manager/api_manager.dart';
import 'package:friendly_neighborhood/configuration/configuration.dart';
import 'package:friendly_neighborhood/first_page/login_screen.dart';
import 'package:friendly_neighborhood/model/localuser.dart';
import 'package:friendly_neighborhood/model/neighborhood.dart';
import 'package:friendly_neighborhood/utils/alertdialog.dart';
import 'package:friendly_neighborhood/utils/check_connection.dart';
import 'package:intl/intl.dart';
import 'package:friendly_neighborhood/utils/elaborate_data.dart';
import 'package:dropdown_search/dropdown_search.dart';

/*
* Classe CreateAccountScreen e _CreateAccountScreenState:
* La seguente classe gestisce la pagina di creazione account
*/
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
  final _voidNeighborhood =
      Neighborhood(id: -1, area: 0, name: "Scegli un quartiere");
  String _choice_house_type = "Scegliere una tipologia";
  late Neighborhood _choice_neighborhood;
  late bool alreadyOpenAlertDialog = false;

  //Dati scelta utente
  static const _house_types = [
    "Scegliere una tipologia",
    "Appartamento",
    "Casa singola"
  ];
  List<Neighborhood> _neighborhood = [];

/*
* Metodo makeNeighborhoodMenu
* -Scarica dal server i dati riguardanti i vari quartieri
* -Genera il pulsante per cercare e selezionare il quartiere desiderato
*/
  Future<Widget> makeNeighborhoodMenu() async {
    try {
      _neighborhood = await API_Manager.getNeighborhoods();
    } catch (e) {
      return Future.error(e);
    }

    _neighborhood = [_voidNeighborhood] + _neighborhood;
    return Row(
      children: [
        Expanded(
          child: DropdownSearch<Neighborhood>(
            items: _neighborhood,
            compareFn: (i, s) => i.isEqual(s),
            itemAsString: (Neighborhood u) => u.name,
            onChanged: ((value) => _choice_neighborhood = value!),
            selectedItem: _neighborhood[0],
            validator: (value) {
              if (value!.name == _voidNeighborhood.name) {
                return "Scegliere un quartiere";
              } else {
                return null;
              }
            },
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
* Metodo _popupSearchBox
* Mostra a schermo un pop-up che permette di cercare e selezionare un quartiere
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

/*
* Metodo retry
* Metodo per riprovare a scaricare i dati dal server
*/
  void retry() {
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _passwordVisible = false;
    _iconPassword = Icons.visibility;
    _confirmPasswordVisible = false;
    _confirmIconPassword = Icons.visibility;
    _choice_neighborhood = _voidNeighborhood;
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
                                decoration: const InputDecoration(
                                  labelText: 'Tipologia abitazione',
                                ),
                                value: _choice_house_type,
                                hint: const Text('Scegliere una tipologia: '),
                                onChanged: (newValue) {
                                  setState(() {
                                    _choice_house_type = newValue!;
                                  });
                                },
                                validator: (value) {
                                  if (value == _house_types[0]) {
                                    return "Scegliere una tipologia";
                                  } else {
                                    return null;
                                  }
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
                                      LocalUser newUser = LocalUser(
                                          _controllerEmail.text,
                                          _controllerUsername.text,
                                          _controllerName.text,
                                          _controllerLastname.text,
                                          DateFormat('dd-MM-yyyy')
                                              .parse(_controllerDate.text),
                                          _controllerResidence.text,
                                          int.parse(_controllerFamily.text),
                                          _choice_house_type,
                                          _choice_neighborhood.name,
                                          _choice_neighborhood.id,
                                          "");
                                      try {
                                        bool c = await API_Manager.signup(
                                            newUser, _controllerPassword.text);
                                        if (c) {
                                          Navigator.pop(context);
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      LoginScreen.withMessage(
                                                          message:
                                                              "Creazione account avvenuta con successo. Si prega di eseguire l'accesso")));
                                        }
                                      } catch (e) {
                                        notificationAlertDialog(
                                            text: e.toString(),
                                            context: context);
                                      }
                                    } else {
                                      notificationAlertDialog(
                                          text:
                                              "Impossibile connettersi. Verifica la connessione ad internet",
                                          context: context);
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
                                        builder: (context) => LoginScreen()));
                              }),
                      ]),
                    ),
                  )
                ],
              )
            ]));
  }
}
