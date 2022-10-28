import 'dart:convert';
import 'dart:io';

import 'package:lab_availability_checker/api/api.dart';
import 'package:lab_availability_checker/models/lab.dart';
import 'package:http/http.dart' as http;

class LabApi {
  final client = http.Client();

  Future<List<Lab>?> getLabs(String token) async {
    final response = await client.get(UriFactory.getRoute('labs'),
        headers: {HttpHeaders.authorizationHeader: "Bearer $token"});

    if (response.statusCode != 200) {
      return null;
    }

    final labs = (jsonDecode(response.body) as List).map((e) => Lab.fromJson(e)).toList();
    return labs;
  }

  Future<bool> postLab(String token, Lab lab) async {
    final response = await client.post(UriFactory.getRoute('labs'),
        headers: {
          "Accept": "application/json",
          "content-type": "application/json",
          HttpHeaders.authorizationHeader: "Bearer $token",
        },
        body: jsonEncode(lab));

    if (response.statusCode != 201) {
      return false;
    }

    return true;
  }

  Future<bool> deleteLab(String token, int id) async {
    final response = await client.delete(
      UriFactory.getRoute('labs/$id'),
      headers: {
        HttpHeaders.authorizationHeader: "Bearer $token",
      },
    );

    if (response.statusCode != 200) {
      return false;
    }

    return true;
  }
}
