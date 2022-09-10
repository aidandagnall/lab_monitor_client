import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:lab_availability_checker/models/issues/issue.dart';
import 'package:lab_availability_checker/util/constants.dart';

class IssueApi {
  final client = http.Client();

  Future<void> submitReport(Issue issue) async {
    await client.post(Uri.http(Constants.API_URL, 'issue'),
        headers: {"Accept": "application/json", "content-type": "application/json"},
        body: jsonEncode(issue));
  }
}
