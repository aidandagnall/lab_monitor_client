import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:lab_availability_checker/api/api.dart';
import 'package:lab_availability_checker/models/issues/issue.dart';

class IssueApi {
  final client = http.Client();

  Future<bool> submitReport(Issue issue, String token) async {
    final response = await client.post(UriFactory.getRoute('issue'),
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

  Future<List<Issue>?> getIssues(String token) async {
    final response = await client.get(UriFactory.getRoute('issue'),
        headers: {HttpHeaders.authorizationHeader: "Bearer $token"});

    if (response.statusCode != 200) {
      return null;
    }
    return (jsonDecode(response.body) as List).map((e) => Issue.fromJson(e)).toList();
  }

  Future<bool> markIssueCompleted(String token, int issueId) async {
    final response = await client.post(UriFactory.getRoute('issue/$issueId/complete'),
        headers: {HttpHeaders.authorizationHeader: "Bearer $token"});
    if (response.statusCode == 200) {
      return true;
    }
    return false;
  }

  Future<bool> markIssueInProgress(String token, int issueId) async {
    final response = await client.post(UriFactory.getRoute('issue/$issueId/in-progress'),
        headers: {HttpHeaders.authorizationHeader: "Bearer $token"});
    if (response.statusCode == 200) {
      return true;
    }
    return false;
  }

  Future<bool> markIssueAsNew(String token, int issueId) async {
    final response = await client.post(UriFactory.getRoute('issue/$issueId/new'),
        headers: {HttpHeaders.authorizationHeader: "Bearer $token"});
    if (response.statusCode == 200) {
      return true;
    }
    return false;
  }

  Future<bool> deleteIssue(String token, int issueId) async {
    final response = await client.delete(UriFactory.getRoute('issue/$issueId'),
        headers: {HttpHeaders.authorizationHeader: "Bearer $token"});

    if (response.statusCode == 200) {
      return true;
    }
    return false;
  }
}
