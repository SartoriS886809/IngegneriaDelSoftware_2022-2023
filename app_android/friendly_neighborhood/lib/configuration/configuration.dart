// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';

class Configuration {
  static const int minAge = 16;
  static const int minLengthPassword = 8;
  static const String API_link = "http://neighborhood.azurewebsites.net";

  /*https://blog.logrocket.com/launching-urls-flutter-url_launcher/ */

  //La seguente mappa serve per definire metodi di contatto nella pagina servizi
  static const Map<String, String> supportedContactMethods = {
    "telefono / cellulare": "tel:\$",
    "email": "mailto:\$",
    "whatsapp": " https://api.whatsapp.com/send?phone=",
    "telegram": "https://telegram.me/",
    "sito web": "",
  };
  static const Map<String, IconData> iconFromContactMethods = {
    "telefono / cellulare": Icons.call,
    "email": Icons.email,
    "whatsapp": Icons.whatsapp,
    "telegram": Icons.telegram,
    "sito web": Icons.link,
  };
}
