import 'dart:convert';

import 'package:lab_availability_checker/models/lab.dart';
import 'package:http/http.dart' as http;
import 'package:lab_availability_checker/util/constants.dart';

class LabApi {
  final client = http.Client();

  Future<List<Lab>?> getLabs() async {
    final response = await client.get(Uri.http(Constants.API_URL, 'labs'));

    if (response.statusCode != 200) {
      return null;
    }

    final labs = jsonDecode(response.body) as List<Lab>;
    return labs;
  }
}
