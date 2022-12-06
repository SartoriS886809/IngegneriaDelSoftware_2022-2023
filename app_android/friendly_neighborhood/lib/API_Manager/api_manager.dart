// ignore_for_file: camel_case_types, constant_identifier_names

import 'dart:convert';

import 'package:friendly_neighborhood/configuration/configuration.dart';
import 'package:http/http.dart' as http;

enum HTTP_Method { POST, GET }

class API_Manager {
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
  di tipo HTTP POST.
  method 
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