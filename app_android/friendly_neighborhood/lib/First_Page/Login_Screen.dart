import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:friendly_neighborhood/First_Page/Create_Account_Screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  late bool _passwordVisible;
  late IconData _iconPassword;

  @override
  void initState() {
    super.initState();
    _passwordVisible = false;
    _iconPassword = Icons.visibility;
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
                        //Pulsante Accedi
                        Padding(
                            padding: const EdgeInsets.symmetric(vertical: 16.0),
                            child: ElevatedButton(
                              onPressed: () {
                                //Controllo se il form è valido
                                if (_formKey.currentState!.validate()) {
                                  //TODO inviare richiesta server

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
