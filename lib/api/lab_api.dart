import 'dart:convert';
import 'dart:io';

import 'package:lab_availability_checker/models/lab.dart';
import 'package:http/http.dart' as http;
import 'package:lab_availability_checker/util/constants.dart';

class LabApi {
  final client = http.Client();

  Future<List<Lab>?> getLabs(String token) async {
    final response = await client.get(Uri.http(Constants.API_URL, 'labs'),
        headers: {HttpHeaders.authorizationHeader: "Bearer $token"});

    if (response.statusCode != 200) {
      return null;
    }

    final labs = (jsonDecode(response.body) as List).map((e) => Lab.fromJson(e)).toList();
    return labs;
  }

  Future<bool> postLab(String token, Lab lab) async {
    final response = await client.post(Uri.http(Constants.API_URL, 'labs'),
        headers: {
          "Accept": "application/json",
          "content-type": "application/json",
          HttpHeaders.authorizationHeader: "Bearer $token",
        },
        body: jsonEncode(lab));

    if (response.statusCode != 201) {
      print(response.reasonPhrase);
      return false;
    }

    return true;
  }

  Future<bool> deleteLab(String token, int id) async {
    final response = await client.delete(
      Uri.http(Constants.API_URL, 'labs/$id'),
      headers: {
        HttpHeaders.authorizationHeader: "Bearer $token",
      },
    );

    print(response.reasonPhrase);

    if (response.statusCode != 200) {
      return false;
    }

    return true;
  }
}
