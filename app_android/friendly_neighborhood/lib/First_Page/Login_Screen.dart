// ignore_for_file: use_build_context_synchronously, must_be_immutable

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:friendly_neighborhood/API_Manager/api_manager.dart';
import 'package:friendly_neighborhood/First_Page/Create_Account_Screen.dart';
import 'package:friendly_neighborhood/configuration/configuration.dart';
import 'package:friendly_neighborhood/core/core.dart';
import 'package:friendly_neighborhood/utils/check_connection.dart';

/*
Lista di todo:
//TODO Gestire errori da richiesta
//TODO se possibile utilizzare un testo per notifiche di errori riguardanti email/password
*/
class LoginScreen extends StatefulWidget {
  String message = "";
  LoginScreen({super.key}) {
    message = "";
  }

  LoginScreen.withMessage({super.key, required this.message});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  late bool _passwordVisible;
  late IconData _iconPassword;
  final _controllerEmail = TextEditingController();
  final _controllerPassword = TextEditingController();

  @override
  void initState() {
    super.initState();
    _passwordVisible = false;
    _iconPassword = Icons.visibility;
    //TODO TEMP
    _controllerEmail.text = "prova2@prova.com";
    _controllerPassword.text = "passpass";
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
          title: const Text("Login"),
        ),
        body: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(widget.message),
              Expanded(child: Container()),
              Form(
                  key: _formKey,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        //Campo Email
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: TextFormField(
                            decoration: const InputDecoration(
                              hintText: "Inserisci l'email",
                              labelText: 'Email',
                            ),
                            controller: _controllerEmail,
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
                            controller: _controllerPassword,
                            //Parametro per nascondere la password
                            obscureText: !_passwordVisible,
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
                        //Pulsante Accedi
                        Padding(
                            padding: const EdgeInsets.symmetric(vertical: 16.0),
                            child: ElevatedButton(
                              onPressed: () async {
                                widget.message = "";
                                //Controllo se il form è valido
                                if (_formKey.currentState!.validate()) {
                                  //Controllo connessione internet
                                  bool check = await CheckConnection.check();
                                  if (check) {
                                    try {
                                      await API_Manager.login(
                                          _controllerEmail.text,
                                          _controllerPassword.text);
                                      Navigator.pop(context);
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const Core()));
                                    } catch (e) {
                                      _showAlertDialog(text: e.toString());
                                    }
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
              //Elemento in fondo alla pagina
              Expanded(child: Container()),
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
                          text: 'Non hai un account? ',
                          style: TextStyle(
                            color: Colors.black,
                          ),
                        ),
                        TextSpan(
                            text: 'Crea account',
                            style: const TextStyle(
                              color: Colors.blue,
                            ),
                            //Se il testo viene cliccato
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                widget.message = "";
                                //Rimuovo dallo stack la pagina di login e inserisco quella di creazione account
                                Navigator.of(context).pop();
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const CreateAccountScreen()));
                              }),
                      ]),
                    ),
                  )
                ],
              )
            ]));
  }
}
