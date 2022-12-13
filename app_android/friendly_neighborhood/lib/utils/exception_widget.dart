import 'package:flutter/material.dart';

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
