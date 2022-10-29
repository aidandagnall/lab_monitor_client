import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:lab_availability_checker/api/api.dart';
import 'package:lab_availability_checker/models/report.dart';

class ReportApi {
  final client = http.Client();

  Future<void> submitReport(Report report, String token) async {
    final response = await client.post(UriFactory.getRoute('report'),
        headers: {
          "Accept": "application/json",
          "content-type": "application/json",
          HttpHeaders.authorizationHeader: "Bearer $token",
        },
        body: jsonEncode(report));
  }

  Future<List<Report>?> getReports(String token) async {
    final response = await client.get(UriFactory.getRoute('report'),
        headers: {HttpHeaders.authorizationHeader: "Bearer $token"});
    if (response.statusCode != 200) {
      return null;
    }

    final reports = (jsonDecode(response.body) as List).map((e) => Report.fromJson(e)).toList();
    return reports;
  }

  Future<bool> deleteReport(String token, int id) async {
    final response = await client.delete(UriFactory.getRoute('report/$id'),
        headers: {HttpHeaders.authorizationHeader: "Bearer $token"});

    if (response.statusCode != 202) {
      return false;
    }
    return true;
  }
}
