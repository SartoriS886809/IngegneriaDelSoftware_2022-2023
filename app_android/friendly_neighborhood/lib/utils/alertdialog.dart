import 'package:flutter/material.dart';

/*
* Funzione simpleAlertDialog
* Funzione che genera un AlertDialog standard che accetta una descrizione e una funzione
* Input: text(descrizione dell'alert), f (funzione usata dal pulsante "Riprova", context
*/
Future<void> simpleAlertDialog(
    {required String text,
    required Function f,
    required BuildContext context}) async {
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
            child: const Text('Riprova'),
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

/*
* Funzione notificationAlertDialog
* Funzione che genera un AlertDialog per mostrare un avviso
* Input: text(descrizione dell'alert), context
*/
Future<void> notificationAlertDialog(
    {required String text, required BuildContext context}) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: true, // L'utente deve premere il pulsante
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

/*
* Funzione advancedAlertDialog
* Funzione che genera un AlertDialog che accetta un titolo, una descrizione, il testo del pulsante e una funzione
* Input: title(titolo dell' alert), message(descrizione dell'alert),buttonMessage(messaggio nel pulsante)
         f (funzione usata dal pulsante di conferma), context
*/
Future<void> advancedAlertDialog(
    {required String title,
    required String message,
    required String buttonMessage,
    required Function f,
    required BuildContext context}) async {
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
