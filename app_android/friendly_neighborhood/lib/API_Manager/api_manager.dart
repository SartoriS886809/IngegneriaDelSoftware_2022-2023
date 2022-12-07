// ignore_for_file: camel_case_types, constant_identifier_names

import 'dart:convert';

import 'package:friendly_neighborhood/cache_manager/profile_db.dart';
import 'package:friendly_neighborhood/configuration/configuration.dart';
import 'package:friendly_neighborhood/model/localuser.dart';
import 'package:http/http.dart' as http;

enum HTTP_Method { POST, GET }

class API_Manager {

  static Future<bool> login(String email, String password) async {
    String link = '${Configuration.API_link}/login';
    try {
      String json ="{'email':$email,'password':$password}";
      http.Response response = await sendRequest(link, json, HTTP_Method.POST);
      dynamic jsonResponse = jsonDecode(response.body);
      if (jsonResponse["status"] != 'success') {
        throw jsonResponse["reason"].toString();
      }
      String token = jsonResponse["token"].toString();
      //Scaricare dati del profilo collegato
      Map<String,dynamic> profile={};
      try{  
        profile = await getProfile(token);
      }catch (e){
        rethrow;
      }
      //Upload sul dbLocalUser
      profile["token"] = token;
      LocalUser user = LocalUser.fromJSON(profile);
      LocalUserManager l = LocalUserManager();
      await l.insertUser(user);
      return true;
    } catch (e) {
      rethrow;
    }
  }
    static Future<Map<String,dynamic>> getProfile(String token) async {
    String link = '${Configuration.API_link}/profile';
    try {
      String json ="{'token':$token}";
      http.Response response = await sendRequest(link, json, HTTP_Method.POST);
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
  La funzione getNeighborhoods() restituisce una lista di quartieri
  In caso di errore verrà lanciata un eccezione
  */
  static Future<List<String>> getNeighborhoods() async {
    String link = '${Configuration.API_link}/neighborhoods';
    try {
      http.Response response = await sendRequest(link, "", HTTP_Method.GET);
      dynamic json = jsonDecode(response.body);
      if (json["status"] != 'success') {
        throw json["reason"].toString();
      }
      return json["neighborhoods"].toString().split(';');
    } catch (e) {
      rethrow;
    }
  }

  /*
  La funzione sendRequest dato un link e una stringa in formato json, invia una richiesta
  di tipo HTTP POST.method
  In caso di errore verrà lanciata un eccezione 
  */
  static Future<http.Response> sendRequest(
      String link, String json, HTTP_Method type) async {
    http.Response response;
    if (type == HTTP_Method.GET) {
      response = await http.get(
        Uri.parse(link),
      );
      if (response.statusCode != 200) {
        throw "Errore nella richiesta";
      }
      return response;
    } else {
      response = await http.post(
        Uri.parse(link),
        body: json,
      );
      if (response.statusCode != 200) {
        throw "Errore nella richiesta";
      }
      return response;
    }
  }
}
//https://docs.flutter.dev/cookbook/networking/send-data
//https://pub.dev/packages/request_permission