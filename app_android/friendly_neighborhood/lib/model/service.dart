// ignore_for_file: unnecessary_getters_setters
import 'package:flutter/material.dart';
import 'package:friendly_neighborhood/configuration/configuration.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../utils/elaborate_data.dart';

/*
* Classe Service:
* Modello per rappresentare un Service
*/
class Service {
  late int _id;
  late DateTime _postDate;
  late String _title;
  late String _link;
  late String _description;
  late String _creator;

  //Il campo id verrà assegnato dal server, usare il valore di default a -1 se creata dall'applicazione
  Service(
      {int id = -1,
      required DateTime postDate,
      required String title,
      required String link,
      required String description,
      required String creator}) {
    _id = id;
    _postDate = postDate;
    _title = title;
    _link = link;
    _description = description;
    _creator = creator;
  }
  //JSON constructor
  Service.fromJSON(Map<String, dynamic> json) {
    _id = json["id"];
    _postDate = DateFormat('dd-MM-yyyy').parse(json["postdate"]);
    _title = json["title"];
    _link = json["link"];
    _description = json["desc"];
    _creator = json["creator"];
  }

  //GETTER
  int get id => _id;
  DateTime get postDate => _postDate;
  String get title => _title;
  String get link => _link;
  String get description => _description;
  String get creator => _creator;

  //SETTER
  set title(String title) => _title = title;
  set link(String link) => _link = link;
  set description(String description) => _description = description;

  //CONVERSION TO JSON
  Map<String, dynamic> toJson() => {
        'title': _title,
        'link': _link,
        'desc': _description,
      };

/*
* Metodo getContactMethodsFromLink
* Trasforma la stringa _link (che è in formato csv) in una lista di Pair (metodo di contatto:dati)
*/
  List<Pair<String, String>> getContactMethodsFromLink() {
    List<String> data = link.split(",");
    List<Pair<String, String>> contactMethods = [];
    for (String s in data) {
      //Verranno restituiti due valori
      if (s != "") {
        List<String> values = s.split(":");
        contactMethods.add(Pair(first: values[0], last: values[1]));
      }
    }
    return contactMethods;
  }

/*
* Metodo getLinkFromContactMethods
* Trasforma una lista di Pair (metodo di contatto:dati) in una stringa (che è in formato csv)
*/
  static String getLinkFromContactMethods(List<Pair<String, String>> contact) {
    String c = "";
    for (Pair<String, String> s in contact) {
      c += "${s.first}:${s.last},";
    }
    return c;
  }

/*
* Metodo getWidgetFromContactMethods
* Data una lista di Pair contenente i metodi di contatto genera una lista di pulsanti per avviare l'applicazione
* corrispondente al metodo di contatto
*/
  static Widget getWidgetFromContactMethods(Pair<String, String> contact) {
    if (!Configuration.supportedContactMethods.containsKey(contact.first)) {
      throw "Metodo non supportato";
    }
    Uri url = Uri.parse(
        Configuration.supportedContactMethods[contact.first]! + contact.last);

    return TextButton.icon(
        icon: Icon(Configuration.iconFromContactMethods[contact.first]),
        style: ButtonStyle(
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                    side: const BorderSide(color: Colors.blue)))),
        onPressed: () async {
          if (await canLaunchUrl(url)) {
            await launchUrl(url, mode: LaunchMode.externalApplication);
          } else {
            throw 'Could not launch $url';
          }
        },
        label: Text(
          "${contact.first}: ${contact.last}",
        ));
  }
}
