// ignore_for_file: unnecessary_getters_setters
import 'package:flutter/material.dart';
import 'package:friendly_neighborhood/icon_manager/report__icons_icons.dart';

class Report {
  late int _id;
  late DateTime _postDate;
  late String _title;
  late int _priority;
  late String _category;
  late String _address;
  late String _creator;
  final Map<String, IconData> _categoryIcon = {
    'problemi ambientali': Report_Icons.icon_disaster,
    'incidente stradale': Report_Icons.icons_traffic_accident,
    'crimine': Report_Icons.icons_robber,
    'animali': Icons.pets,
    'guasto': Report_Icons.icons_lightning_bolt,
    'lavori in corso': Report_Icons.icons_construction
  };

  Report(int id, DateTime postDate, String title, int priority, String category,
      String address, String creator) {
    _id = id;
    _postDate = postDate;
    _title = title;
    _priority = priority;
    _category = category;
    _address = address;
    _creator = creator;
  }

  Report.fromJSON(Map<String, dynamic> json) {
    _id = json["id"];
    _postDate = json["postDate"];
    _title = json["title"];
    _priority = json["priority"];
    _category = json["category"];
    _address = json["address"];
    _creator = json["creator"];
  }
  //METHODS
  /*
    Il metodo prende in ingresso un colore, può essere anche null. In tal caso l'icona assumerà il colore di default
    Se la categoria non è presente restituisce l'icona error
  */
  Icon getIconFromCategory(Color? iconColor) {
    if (!_category.contains(_category)) {
      return Icon(Icons.error, color: iconColor);
    } else {
      return Icon(_categoryIcon[_category], color: iconColor);
    }
  }

  //GETTER
  int get id => _id;
  DateTime get postDate => _postDate;
  String get title => _title;
  int get priority => _priority;
  String get category => _category;
  String get address => _address;
  String get creator => _creator;

  //CONVERSION TO JSON
  Map<String, dynamic> toJson() => {
        'id': _id,
        'postDate': _postDate,
        'title': _title,
        'priority': _priority,
        'category': _category,
        'address': _address,
        'creator': _creator,
      };
}
