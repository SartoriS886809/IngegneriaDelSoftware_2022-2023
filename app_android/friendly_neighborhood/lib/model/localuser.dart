// ignore_for_file: unnecessary_getters_setters, non_constant_identifier_names

import 'package:friendly_neighborhood/utils/elaborate_data.dart';
import 'package:intl/intl.dart';

/*
* Classe LocalUser:
* Modello per rappresentare un LocalUser
*/

class LocalUser {
  late String _email;
  late String _username;
  late String _name;
  late String _lastname;
  late DateTime _birth_date;
  late String _address;
  late int _family;
  late String _house_type;
  late String _neighborhood;
  late int _id_neighborhoods;
  late String _token;

  LocalUser(
      String email,
      String username,
      String name,
      String lastname,
      DateTime birth_date,
      String address,
      int family,
      String house_type,
      String neighborhood,
      int id_neighborhoods,
      String token) {
    _email = email;
    _username = username;
    _name = name;
    _lastname = lastname;
    _birth_date = birth_date;
    _address = address;
    _family = family;
    _house_type = house_type;
    _neighborhood = neighborhood;
    _id_neighborhoods = id_neighborhoods;
    _token = token;
  }

  //Costruttore per i dati ricevuti dal server
  LocalUser.fromJSON(Map<String, dynamic> json) {
    _email = json['email'];
    _username = json['username'];
    _name = json['name'];
    _lastname = json['lastname'];
    _birth_date = DateFormat('dd-MM-yyyy').parse(json['birth_date']);
    _address = json['address'];
    _family = json['family'];
    _house_type = json['house_type'];
    _neighborhood = json['neighborhood'];
    _id_neighborhoods = json['id_neighborhoods'];
    _token = json['token'];
  }

  //Costruttore per i dati ricevuti dal database locale
  LocalUser.fromDB(Map<String, dynamic> map) {
    _email = map['email'];
    _username = map['username'];
    _name = map['name'];
    _lastname = map['lastname'];
    _birth_date = DateTime.parse(map['birth_date']);
    _address = map['address'];
    _family = map['family'];
    _house_type = map['house_type'];
    _neighborhood = map['neighborhood'];
    _id_neighborhoods = map['id_neighborhoods'];
    _token = map['token'];
  }

  //GETTER
  String get email => _email;
  String get username => _username;
  String get name => _name;
  String get lastname => _lastname;
  DateTime get birth_date => _birth_date;
  String get address => _address;
  int get family => _family;
  String get house_type => _house_type;
  int get id_neighborhoods => _id_neighborhoods;
  String get neighborhood => _neighborhood;
  String get token => _token;

  //SETTER
  set email(String email) => _email = email;
  set username(String username) => _username = username;
  set name(String name) => _name = name;
  set lastname(String lastname) => _lastname = lastname;
  set birthdate(DateTime birth_date) => _birth_date = birth_date;
  set address(String address) => _address = address;
  set family(int family) => _family = family;
  set house_type(String house_type) => _house_type = house_type;
  set neighborhood(String neighborhood) => _neighborhood = neighborhood;
  set id_neighborhoods(int id_neighborhoods) =>
      _id_neighborhoods = id_neighborhoods;

  //CONVERSION TO JSON
  Map<String, dynamic> toJson() => {
        'email': _email,
        'username': _username,
        'name': _name,
        'lastname': _lastname,
        'birth_date': convertDateTimeToDate(birth_date),
        'address': _address,
        'family': _family,
        'house_type': _house_type,
        'id_neighborhoods': _id_neighborhoods,
      };

  //Mappa per database
  Map<String, dynamic> mapForDb() => {
        'email': _email,
        'username': _username,
        'name': _name,
        'lastname': _lastname,
        'birth_date': _birth_date.toString(),
        'address': _address,
        'family': _family,
        'house_type': _house_type,
        'neighborhood': _neighborhood,
        'id_neighborhoods': _id_neighborhoods,
        'token': _token
      };
}
