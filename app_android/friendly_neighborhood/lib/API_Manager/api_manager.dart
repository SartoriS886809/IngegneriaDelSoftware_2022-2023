// ignore_for_file: camel_case_types, constant_identifier_names

import 'dart:convert';

import 'package:friendly_neighborhood/cache_manager/profile_db.dart';
import 'package:friendly_neighborhood/configuration/configuration.dart';
import 'package:friendly_neighborhood/model/localuser.dart';
import 'package:friendly_neighborhood/model/neighborhood.dart';
import 'package:friendly_neighborhood/utils/elaborate_data.dart';
import 'package:http/http.dart' as http;

import '../model/need.dart';
import '../model/report.dart';
import '../model/service.dart';

enum HTTP_Method { POST, GET, DELETE }

enum ELEMENT_TYPE { SERVICES, NEEDS, REPORTS }

class API_Manager {
  //Funzione per castare un elemento
  static T? _cast<T>(x) => x is T ? x : null;
  /*
  Funzione di registrazione, richiede in ingresso l'utente da registrare
  Se l'esito della registrazione è positivo verrà ritornato true, in caso
  di errore verrà lanciata un'eccezione
  */
  static Future<bool> signup(LocalUser user, String password) async {
    String link = '${Configuration.API_link}/signup';
    Map<String, dynamic> json = user.toJson();
    json["password"] = password;
    //Fix Date Format
    json["birth_date"] = convertDateTimeToDate(json["birth_date"]);
    http.Response response =
        await sendRequest(link, jsonEncode(json), HTTP_Method.POST);
    dynamic jsonResponse = jsonDecode(response.body);
    if (jsonResponse["status"] != 'success') {
      throw jsonResponse["reason"].toString();
    }
    return true;
  }

  static Future<String> login(String email, String password) async {
    String link = '${Configuration.API_link}/login';
    try {
      //String json = "{'email':$email,'password':$password}";
      Map<String, dynamic> j = {};
      j["email"] = email;
      j["password"] = password;
      http.Response response =
          await sendRequest(link, jsonEncode(j), HTTP_Method.POST);
      dynamic jsonResponse = jsonDecode(response.body);
      if (jsonResponse["status"] != 'success') {
        throw jsonResponse["reason"].toString();
      }
      String token = jsonResponse["token"].toString();
      //Scaricare dati del profilo collegato
      Map<String, dynamic> profile = {};
      try {
        profile = await getProfile(token);
      } catch (e) {
        rethrow;
      }
      profile["birth_date"] = extractDataFromDBString(profile["birth_date"]);
      //Upload sul dbLocalUser
      profile["token"] = token;
      //TODO TEMP
      profile['id_neighborhoods'] = 1;
      LocalUser user = LocalUser.fromJSON(profile);
      LocalUserManager l = LocalUserManager();
      await l.insertUser(user);
      return token;
    } catch (e) {
      rethrow;
    }
  }

  /* 
  Funzione di logout, richiede in ingresso l'email dell'utente loggato
  Se l'esito dell'operazione è positivo verrà ritornato true, in caso
  di errore verrà lanciata un'eccezione
  */
  static Future<bool> logout(String email) async {
    String link = '${Configuration.API_link}/logout';
    Map<String, dynamic> json = {};
    json["email"] = email;
    http.Response response =
        await sendRequest(link, jsonEncode(json), HTTP_Method.POST);
    dynamic jsonResponse = jsonDecode(response.body);
    if (jsonResponse["status"] != 'success') {
      throw jsonResponse["reason"].toString();
    }
    return true;
  }

  /* 
  Funzione di eliminazione account, richiede in ingresso l'email dell'utente
  Se l'esito dell'operazione è positivo verrà ritornato true, in caso
  di errore verrà lanciata un'eccezione
  */
  static Future<bool> deleteAccount(String token) async {
    String link = '${Configuration.API_link}/delete-account';
    Map<String, dynamic> json = {};
    json["token"] = token;
    http.Response response =
        await sendRequest(link, jsonEncode(json), HTTP_Method.DELETE);
    dynamic jsonResponse = jsonDecode(response.body);
    if (jsonResponse["status"] != 'success') {
      throw jsonResponse["reason"].toString();
    }
    return true;
  }

  /* 
  Funzione di controllo della validità del token, se è ancora valido ritorna
  true, altrimenti ritorna false.
  */
  static Future<bool> checkToken(String email, String token) async {
    String link = '${Configuration.API_link}/token';
    Map<String, dynamic> json = {};
    json["email"] = email;
    json["token"] = token;
    http.Response response =
        await sendRequest(link, jsonEncode(json), HTTP_Method.POST);
    dynamic jsonResponse = jsonDecode(response.body);
    if (jsonResponse["status"] != 'success') {
      return false;
    }
    return true;
  }

  /*
  La funzione getNeighborhoods() restituisce una lista di quartieri
  In caso di errore verrà lanciata un eccezione
  */
  static Future<List<Neighborhood>> getNeighborhoods() async {
    String link = '${Configuration.API_link}/neighborhoods';
    http.Response response = await sendRequest(link, "", HTTP_Method.GET);
    dynamic json = jsonDecode(response.body);
    if (json["status"] != 'success') {
      throw json["reason"].toString();
    }
    List<Neighborhood> list = [];
    for (Map<String, dynamic> x in json["neighborhoods"]) {
      list.add(Neighborhood.fromJSON(x));
    }
    return list;
  }

  static Future<Map<String, dynamic>> getProfile(String token) async {
    String link = '${Configuration.API_link}/profile';
    try {
      Map<String, dynamic> json = {};
      json["token"] = token;
      http.Response response =
          await sendRequest(link, jsonEncode(json), HTTP_Method.POST);
      dynamic jsonResponse = jsonDecode(response.body);
      if (jsonResponse["status"] != 'success') {
        throw jsonResponse["reason"].toString();
      }
      return jsonResponse;
    } catch (e) {
      rethrow;
    }
  }

/*
La funzione listOfElements restituisce una lista dynamic. Il contenuto della lista
dipende dal tipo passato come parametro (SERVICES, NEEDS, REPORTS).
La variabile isItMine serve a specificare se la lista da scaricare corrisponde alla mia
(es. Miei Servizi) oppure quella generica (es. Servizi). Il metodo scaricherà
la lista in base alla tipologia richiesta.
*/
  static Future<List<dynamic>> listOfElements(
      String token, ELEMENT_TYPE type, bool isItMine) async {
    String link = "";
    if (isItMine) {
      link = "/mylist/";
    } else {
      link = "/list/";
    }
    Map<String, dynamic> json = {};
    json["token"] = token;
    switch (type) {
      case ELEMENT_TYPE.NEEDS:
        link += "needs";
        break;
      case ELEMENT_TYPE.REPORTS:
        link += "reports";
        break;
      case ELEMENT_TYPE.SERVICES:
        link += "services";
        break;
      default:
        break;
    }
    http.Response response =
        await sendRequest(link, jsonEncode(json), HTTP_Method.POST);
    dynamic jsonResponse = jsonDecode(response.body);
    if (jsonResponse["status"] != 'success') {
      throw jsonResponse["reason"].toString();
    }
    List<dynamic> res = [];
    for (Map<String, dynamic> x in jsonResponse["list"]) {
      switch (type) {
        case ELEMENT_TYPE.NEEDS:
          res.add(Need.fromJSON(x));
          break;
        case ELEMENT_TYPE.REPORTS:
          res.add(Report.fromJSON(x));
          break;
        case ELEMENT_TYPE.SERVICES:
          res.add(Service.fromJSON(x));
          break;
        default:
          break;
      }
    }
    return res;
  }

/*
La funzione updateElement aggiorna il contenuto di una entry di una tabella specificata dal parametro type (SERVICES, NEEDS, REPORTS). 
Questa ritornerà true se l'operazione andrà a buon fine, altrimenti lancerà un'eccezione. La funzione richiede in input l'elemento da modificare (elem) 
e il token (token) dell'utente corrente.
*/
//TODO Guardare parametri passati al server
  static Future<bool> updateElement(
      String token, dynamic elem, ELEMENT_TYPE type) async {
    String link = "/mylist/";
    Map<String, dynamic> map = {};
    switch (type) {
      case ELEMENT_TYPE.NEEDS:
        Need? n = _cast<Need>(elem);
        map = n!.toJson();
        link += "needs";
        break;
      case ELEMENT_TYPE.REPORTS:
        Report? r = _cast<Report>(elem);
        map = r!.toJson();
        link += "reports";
        break;
      case ELEMENT_TYPE.SERVICES:
        Service? s = _cast<Service>(elem);
        map = s!.toJson();
        link += "services";
        break;
      default:
        break;
    }
    map["token"] = token;
    http.Response response =
        await sendRequest(link, jsonEncode(map), HTTP_Method.POST);
    dynamic jsonResponse = jsonDecode(response.body);
    if (jsonResponse["status"] != 'success') {
      throw jsonResponse["reason"].toString();
    }
    return true;
  }

/*
La funzione createElement aggiunge una entry in una tabella specificata dal parametro type (SERVICES, NEEDS, REPORTS). 
Questa ritornerà true se l'operazione andrà a buon fine, altrimenti lancerà un'eccezione. La funzione richiede in input l'elemento da modificare (elem) 
e il token (token) dell'utente corrente.
*/
  static Future<bool> createElement(
      String token, dynamic elem, ELEMENT_TYPE type) async {
    String link = "/new/";
    Map<String, dynamic> map = {};
    switch (type) {
      case ELEMENT_TYPE.NEEDS:
        Need? n = _cast<Need>(elem);
        map = n!.toJson();
        link += "needs";
        break;
      case ELEMENT_TYPE.REPORTS:
        Report? r = _cast<Report>(elem);
        map = r!.toJson();
        link += "reports";
        break;
      case ELEMENT_TYPE.SERVICES:
        Service? s = _cast<Service>(elem);
        map = s!.toJson();
        link += "services";
        break;
      default:
        break;
    }
    map["token"] = token;
    http.Response response =
        await sendRequest(link, jsonEncode(map), HTTP_Method.POST);
    dynamic jsonResponse = jsonDecode(response.body);
    if (jsonResponse["status"] != 'success') {
      throw jsonResponse["reason"].toString();
    }
    return true;
  }

/*
La funzione deleteElement rimuove una entry in una tabella specificata dal parametro type (SERVICES, NEEDS, REPORTS). 
Questa ritornerà true se l'operazione andrà a buon fine, altrimenti lancerà un'eccezione. La funzione richiede in input l'elemento da modificare (elem) 
e il token (token) dell'utente corrente.
*/
  static Future<bool> deleteElement(
      String token, int id, ELEMENT_TYPE type) async {
    String link = "/delete/";
    switch (type) {
      case ELEMENT_TYPE.NEEDS:
        link += "needs/";
        break;
      case ELEMENT_TYPE.REPORTS:
        link += "reports/";
        break;
      case ELEMENT_TYPE.SERVICES:
        link += "services/";
        break;
      default:
        break;
    }
    link += "$id";
    Map<String, dynamic> json = {};
    json['token'] = token;
    http.Response response =
        await sendRequest(link, jsonEncode(json), HTTP_Method.DELETE);
    dynamic jsonResponse = jsonDecode(response.body);
    if (jsonResponse["status"] != 'success') {
      throw jsonResponse["reason"].toString();
    }
    return true;
  }

  /*
  La funzione sendRequest dato un link e una stringa in formato json, invia una richiesta
  di tipo HTTP POST.method
  In caso di errore verrà lanciata un eccezione 
  */
  static Future<http.Response> sendRequest(
      String link, String json, HTTP_Method type) async {
    Map<String, String> headers = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
    };

    http.Response response;
    if (type == HTTP_Method.GET) {
      response = await http.get(Uri.parse(link), headers: headers);
      if (response.statusCode != 200) {
        throw "Errore nella richiesta";
      }
      return response;
    } else if (type == HTTP_Method.POST) {
      response = await http.post(
        Uri.parse(link),
        headers: headers,
        body: json,
      );

      if (response.statusCode != 200) {
        throw "Errore nella richiesta";
      }
      return response;
    } else {
      response =
          await http.delete(Uri.parse(link), body: json, headers: headers);
      return response;
    }
  }
  //TODO route assist
  //TODO undo assist
  //TODO lista da soddisfare

}
//https://docs.flutter.dev/cookbook/networking/send-data
//https://pub.dev/packages/request_permission