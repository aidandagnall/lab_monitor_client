import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:lab_availability_checker/models/report.dart';
import 'package:lab_availability_checker/util/constants.dart';

class ReportApi {
  final client = http.Client();

  Future<void> submitReport(Report report) async {
    await client.post(Uri.http(Constants.API_URL, 'report'),
        headers: {"Accept": "application/json", "content-type": "application/json"},
        body: jsonEncode(report));
  }
}
