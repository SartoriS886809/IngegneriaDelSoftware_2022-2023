import 'package:flutter/material.dart';

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
