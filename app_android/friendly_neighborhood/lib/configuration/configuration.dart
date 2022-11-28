class Configuration {
  static const int minAge = 16;
  static const int minLengthPassword = 8;
  /*https://blog.logrocket.com/launching-urls-flutter-url_launcher/ */

  //La seguente mappa serve per definire metodi di contatto nella pagina servizi
  static const Map<String, String> supportedContactMethods = {
    "telefono / cellulare": "tel:\$",
    "email": "mailto:\$",
    "whatsapp": " https://api.whatsapp.com/send?phone=",
    "telegram": "https://telegram.me/",
    "sito web": "",
  };
}
