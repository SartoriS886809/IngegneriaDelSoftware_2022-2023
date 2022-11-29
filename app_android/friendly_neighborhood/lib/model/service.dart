// ignore_for_file: unnecessary_getters_setters

import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:friendly_neighborhood/configuration/configuration.dart';
import 'package:url_launcher/url_launcher.dart';

import '../utils/elaborate_data.dart';

class Service {
  late int _id;
  late DateTime _postDate;
  late String _title;
  late String _link;
  late String _description;
  late String _creator;

  Service(int id, DateTime postDate, String title, String link,
      String description, String creator) {
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
    _postDate = json["postDate"];
    _title = json["title"];
    _link = json["link"];
    _description = json["description"];
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
        'id': _id,
        'postDate': _postDate,
        'title': _title,
        'link': _link,
        'description': _description,
        'creator': _creator,
      };

  //Il campo link sarà strutturato come segue:
  //ContactMethodsType:data     (formato csv)
  List<Pair<String, String>> getContactMethodsFromLink() {
    List<String> data = link.split(",");
    List<Pair<String, String>> contactMethods = [];
    for (String s in data) {
      //Verranno restituiti due valori
      List<String> values = s.split(":");
      contactMethods.add(Pair(first: values[0], last: values[1]));
    }
    return contactMethods;
  }

  Widget getWidgetFromContactMethods(Pair<String, String> contact) {
    if (!Configuration.supportedContactMethods.containsKey(contact.first)) {
      throw "Metodo non supportato";
    }
    Uri url = Uri.http(
        Configuration.supportedContactMethods[contact.first]! + contact.last);

    return TextButton(
        onPressed: () async {
          if (await canLaunchUrl(url)) {
            await launchUrl(url);
          } else {
            throw 'Could not launch $url';
          }
        },
        child: Text(contact.first + contact.last));
  }
}
