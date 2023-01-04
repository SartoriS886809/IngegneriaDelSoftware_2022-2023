import 'package:flutter/material.dart';

/*
* Funzione printError
* Funzione che genera un AlertDialog per gestire un errore
* Input: exception (eccezione che si è verificata) e refreshFunction (funzione utilizzata per riprovare ad rieseguire
         la parte di codice)
*/
Widget printError(Object exception, Function refreshFunction) {
  return Center(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("Si è verificato un errore:${exception.toString()}"),
        ElevatedButton(
          onPressed: () {
            refreshFunction(true);
          },
          child: const Text('Riprova'),
        )
      ],
    ),
  );
}
