import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:lab_availability_checker/models/report.dart';
import 'package:lab_availability_checker/util/constants.dart';

class ReportApi {
  final client = http.Client();

  Future<void> submitReport(Report report, String token) async {
    final response = await client.post(Uri.http(Constants.API_URL, 'report'),
        headers: {
          "Accept": "application/json",
          "content-type": "application/json",
          HttpHeaders.authorizationHeader: "Bearer $token",
        },
        body: jsonEncode(report));
  }

  Future<List<Report>?> getReports(String token) async {
    final response = await client.get(Uri.http(Constants.API_URL, 'report'),
        headers: {HttpHeaders.authorizationHeader: "Bearer $token"});
    if (response.statusCode != 200) {
      return null;
    }

    final reports = (jsonDecode(response.body) as List).map((e) => Report.fromJson(e)).toList();
    return reports;
  }

  Future<bool> deleteReport(String token, int id) async {
    final response = await client.delete(Uri.http(Constants.API_URL, 'report/$id'),
        headers: {HttpHeaders.authorizationHeader: "Bearer $token"});

    if (response.statusCode != 202) {
      return false;
    }
    return true;
  }
}
