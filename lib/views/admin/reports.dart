import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:lab_availability_checker/api/report_api.dart';
import 'package:lab_availability_checker/models/report.dart';
import 'package:lab_availability_checker/providers/auth_provider.dart';
import 'package:lab_availability_checker/views/admin/user.dart';

class ReportAdminPage extends StatefulWidget {
  const ReportAdminPage({Key? key, required this.auth}) : super(key: key);
  final AuthProvider auth;

  @override
  createState() => _ReportAdminPageState();
}

class _ReportAdminPageState extends State<ReportAdminPage> {
  List<Report>? reports;

  @override
  void initState() {
    getReports();
    super.initState();
  }

  Future<void> getReports() async {
    final r = await ReportApi().getReports((await widget.auth.getStoredCredentials())!.accessToken);
    setState(() {
      reports = r;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: const Text("Reports"),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.of(context).pop(),
            )),
        body: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
            child: reports == null
                ? const Center(child: CircularProgressIndicator())
                : RefreshIndicator(
                    onRefresh: () async => await getReports(),
                    child: ListView.builder(
                        shrinkWrap: true,
                        clipBehavior: Clip.none,
                        itemCount: reports!.length,
                        itemBuilder: (context, index) {
                          final e = reports![index];
                          return Card(
                              child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Email: " + e.email),
                                  Text("Room: " + e.room),
                                  Text("Time: " + DateFormat("HH:mm dd/MM/yyyy").format(e.time!)),
                                  Text("Popularity: " + (e.popularity?.name ?? "null")),
                                  Text("Removal Chance: " + (e.removalChance?.name ?? "null")),
                                  Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      IconButton(
                                          onPressed: () => Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      UserAdminPage(email: e.email))),
                                          icon: const Icon(Icons.person)),
                                      IconButton(
                                          onPressed: () async {
                                            final success = await ReportApi().deleteReport(
                                                (await widget.auth.getStoredCredentials())!
                                                    .accessToken,
                                                e.id!);
                                            if (success) {
                                              setState(() {
                                                reports!.remove(e);
                                              });
                                            }
                                          },
                                          icon: const Icon(Icons.close))
                                    ],
                                  )
                                ]),
                          ));
                        }))));
  }
}
