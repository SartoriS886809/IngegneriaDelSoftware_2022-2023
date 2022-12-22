// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:friendly_neighborhood/model/report.dart';
import 'package:friendly_neighborhood/utils/alertdialog.dart';

import '../../API_Manager/api_manager.dart';
import '../../cache_manager/profile_db.dart';
import '../../first_page/login_screen.dart';
import '../../model/localuser.dart';

//ignore: must_be_immutable
class CreationReport extends StatefulWidget {
  Report? report;
  CreationReport({super.key}) {
    report = null;
  }

  @override
  State<CreationReport> createState() => _CreationReportState();
}

class _CreationReportState extends State<CreationReport> {
  final _formKey = GlobalKey<FormState>();
  final _controllerTitle = TextEditingController();
  final _controllerAddress = TextEditingController();
  String? _valueChoose;
  late int _priority = 1;
  final List<String> listItem = [
    'Problemi ambientali',
    'Incidente stradale',
    'Crimine',
    'Animali',
    'Guasto',
    'Lavori in corso'
  ];
  String token = "";
  LocalUserManager lum = LocalUserManager();

  late BuildContext _context;

  Future<void> createReport() async {
    widget.report = Report(
        postDate: DateTime.now(),
        title: _controllerTitle.text,
        priority: _priority,
        category: _valueChoose.toString().toLowerCase(),
        address: _controllerAddress.text,
        creator: '');
    LocalUser? user = await lum.getUser();
    token = user!.token;
    API_Manager.createElement(token, widget.report, ELEMENT_TYPE.REPORTS);
    Navigator.pop(_context);
  }

  Future<bool> checkSession() async {
    LocalUser? user = await lum.getUser();
    if (user == null) {
      Navigator.pop(context);
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => LoginScreen.withMessage(
                  message: "Errore interno, si prega di rieseguire il login")));
      return false;
    }
    if (!await API_Manager.checkToken(user.email, user.token)) {
      Navigator.pop(context);
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => LoginScreen.withMessage(
                  message:
                      "Sessione non più valida, si prega di rieseguire il login")));
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    _context = context;
    checkSession();
    return Scaffold(
        //Evita l'overflow una volta aperta la tastiera
        resizeToAvoidBottomInset: false,
        appBar: AppBar(title: const Text("Creazione Segnalazione")),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
                child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: DropdownButtonFormField<String>(
                      value: _valueChoose,
                      hint: const Text('Tipo Segnalazione: '),
                      onChanged: (newValue) {
                        setState(() {
                          _valueChoose = newValue;
                        });
                      },
                      validator: (value) => value == null
                          ? 'il campo di Segnalazione non può essere vuoto'
                          : null,
                      items: listItem.map((valueItem) {
                        return DropdownMenuItem<String>(
                          value: valueItem,
                          child: Text(valueItem),
                        );
                      }).toList(),
                    ),
                  ),
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
                  const Padding(
                    padding: EdgeInsets.all(15),
                    child: Text('Livello di allarme'),
                  ),
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: ListTile(
                          title: const Text('Basso'),
                          leading: Radio<int>(
                            value: 1,
                            groupValue: _priority,
                            onChanged: (value) {
                              setState(() {
                                _priority = value!;
                              });
                            },
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: ListTile(
                          title: const Text('Medio'),
                          leading: Radio<int>(
                            value: 2,
                            groupValue: _priority,
                            onChanged: (value) {
                              setState(() {
                                _priority = value!;
                              });
                            },
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: ListTile(
                          title: const Text('Alto'),
                          leading: Radio<int>(
                            value: 3,
                            groupValue: _priority,
                            onChanged: (value) {
                              setState(() {
                                _priority = value!;
                              });
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                  Expanded(child: Container()),
                  Row(
                    mainAxisSize: MainAxisSize.max,
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
                                      padding:
                                          EdgeInsets.only(top: 16, bottom: 16),
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
                                      //debug
                                      debugPrint(_valueChoose?.toLowerCase());
                                      //Controllo se il form è valido
                                      if (_formKey.currentState!.validate()) {
                                        bool check = await checkSession();
                                        if (!check) return;
                                        //implementa il pop up
                                        advancedAlertDialog(
                                            title: "Creazione",
                                            message:
                                                "Sei sicuro di voler creare la segnalazione?",
                                            buttonMessage: "Crea",
                                            f: createReport,
                                            context: context);
                                      }
                                    },
                                    child: const Center(
                                        child: Padding(
                                            padding: EdgeInsets.only(
                                                top: 16, bottom: 16),
                                            child: Text('Crea'))),
                                  ))),
                    ],
                  )
                ],
              ),
            ))
          ],
        ));
  }
}
