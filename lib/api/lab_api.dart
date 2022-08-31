import 'dart:convert';

import 'package:lab_availability_checker/models/lab.dart';
import 'package:http/http.dart' as http;

class LabApi {
  final client = http.Client();
  final String url = "uon-lab-monitor.herokuapp.com";

  Future<List<Lab>?> getLabs() async {
    final response = await client.get(Uri.http(url, 'labs'));

    if (response.statusCode != 200) {
      return null;
    }

    final labs = jsonDecode(response.body) as List<Lab>;
    return labs;
  }
}
