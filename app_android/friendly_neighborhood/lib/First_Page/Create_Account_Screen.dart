import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:friendly_neighborhood/First_Page/Login_Screen.dart';
import 'package:friendly_neighborhood/configuration/configuration.dart';
import 'package:friendly_neighborhood/utils/checkConnection.dart';
import 'package:intl/intl.dart';
import 'package:friendly_neighborhood/utils/elaborateData.dart';

class CreateAccountScreen extends StatefulWidget {
  const CreateAccountScreen({super.key});

  @override
  State<CreateAccountScreen> createState() => _CreateAccountScreenState();
}

class _CreateAccountScreenState extends State<CreateAccountScreen> {
  final _formKey = GlobalKey<FormState>();
  late bool _passwordVisible;
  late IconData _iconPassword;
  late bool _confirmPasswordVisible;
  late IconData _confirmIconPassword;
  final _controllerPassword = TextEditingController();
  final _controllerDate = TextEditingController();

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
                                //TODO INSERIRE MIN LUNGHEZZA PASSWORD
                                if (value == null || value.isEmpty) {
                                  return "Il campo password non può essere vuoto";
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
                                  //Controlla che il nome sia stato inserito nel formato corretto
                                }
                                //TODO CONVERTIRE TESTO IN DATA
                                DateTime d = DateTime.parse(value);
                                int age = calculateAge(d);
                                //Data futura o età inferiore al limite
                                if (d.compareTo(DateTime.now()) > 0 ||
                                    age < Configuration.minAge ||
                                    age > 120) {
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
                                    firstDate: DateTime(
                                        1900), //DateTime.now() - not to allow to choose before today.
                                    lastDate: DateTime(2100));

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

                          //Pulsante Accedi
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
                                  child: Text('Accedi'),
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
