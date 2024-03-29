// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';

/*
* Classe Configuration:
* Classe contenente parametri di configurazione
*/
class Configuration {
  static const int minAge = 16;
  static const int minLengthPassword = 8;
  static const String API_link = "https://neighborhood.azurewebsites.net";
  // static const Duration NotificationRefreshTimer = Duration(seconds: 15);

  /*https://blog.logrocket.com/launching-urls-flutter-url_launcher/ */

  //La seguente mappa serve per definire metodi di contatto nella pagina servizi
  static const Map<String, String> supportedContactMethods = {
    "telefono / cellulare": "tel:\$",
    "email": "mailto:",
    "whatsapp": "https://wa.me/send?phone=",
    "telegram": "https://telegram.me/",
    "sito web": "https:",
  };
  static const Map<String, IconData> iconFromContactMethods = {
    "telefono / cellulare": Icons.call,
    "email": Icons.email,
    "whatsapp": Icons.whatsapp,
    "telegram": Icons.telegram,
    "sito web": Icons.link,
  };
}
