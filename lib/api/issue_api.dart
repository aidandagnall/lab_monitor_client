import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:lab_availability_checker/models/issues/issue.dart';
import 'package:lab_availability_checker/util/constants.dart';

class IssueApi {
  final client = http.Client();

  Future<bool> submitReport(Issue issue, String token) async {
    final response = await client.post(Uri.http(Constants.API_URL, 'issue'),
        headers: {
          "Accept": "application/json",
          "content-type": "application/json",
          HttpHeaders.authorizationHeader: "Bearer $token",
        },
        body: jsonEncode(issue));
    if (response.statusCode == 201) {
      return true;
    }

    return false;
  }
}
