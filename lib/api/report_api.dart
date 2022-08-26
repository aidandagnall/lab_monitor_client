import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:lab_availability_checker/models/report.dart';
import 'package:lab_availability_checker/models/room.dart';

class ReportApi {
  final client = http.Client();
  final String url = "localhost:8080";

  Future<void> submitReport(Report report) async {
    await client.post(Uri.http(url, 'report'),
        headers: {"Accept": "application/json", "content-type": "application/json"},
        body: jsonEncode(report));
  }
}
