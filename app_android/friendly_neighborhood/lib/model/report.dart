// ignore_for_file: unnecessary_getters_setters
import 'package:flutter/material.dart';
import 'package:friendly_neighborhood/icon_manager/report__icons_icons.dart';
import 'package:intl/intl.dart';

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

  Report(
      {int id = -1,
      required DateTime postDate,
      required String title,
      required int priority,
      required String category,
      required String address,
      required String creator}) {
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
    _postDate = DateFormat('dd-MM-yyyy').parse(json["postdate"]);
    _title = json["title"];
    _priority = json["priority"];
    _category = json["category"];
    _address = json["address"];
    _creator = json["creator"];
  }

  Report.fromDB(Map<String, dynamic> map) {
    _id = map["id"];
    _postDate = DateTime.parse(map["postDate"]);
    _title = map["title"];
    _priority = map["priority"];
    _category = map["category"];
    _address = map["address"];
    _creator = map["creator"];
  }
  //METHODS
  /*
    Il metodo prende in ingresso un colore e un double che possono essere anche null. In tal caso l'icona assumerà il colore e dimensione di default
    Se la categoria non è presente restituisce l'icona error
  */
  Icon getIconFromCategory(Color? iconColor, double? sizeIcon) {
    if (!_category.contains(_category)) {
      return Icon(Icons.error, color: iconColor);
    } else {
      return Icon(_categoryIcon[_category], color: iconColor, size: sizeIcon);
    }
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is Report && runtimeType == other.runtimeType && _id == other._id;
  }

  @override
  int get hashCode => _id.hashCode;

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
        'title': _title,
        'priority': _priority,
        'category': _category,
        'address': _address,
      };

  //Conversione per database
  Map<String, dynamic> toDb() => {
        'id': _id,
        'postDate': _postDate.toString(),
        'title': _title,
        'priority': _priority,
        'category': _category,
        'address': _address,
        'creator': _creator,
      };
}
