import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:lab_availability_checker/api/issue_api.dart';
import 'package:lab_availability_checker/models/issues/issue.dart';
import 'package:lab_availability_checker/providers/auth_provider.dart';
import 'package:lab_availability_checker/views/admin/user.dart';

class IssuesAdminPage extends StatefulWidget {
  const IssuesAdminPage({Key? key, required this.auth}) : super(key: key);
  final AuthProvider auth;

  @override
  State<StatefulWidget> createState() => _IssuesAdminPageState();
}

class _IssuesAdminPageState extends State<IssuesAdminPage> {
  List<Issue>? issues;
  IssueStatus filter = IssueStatus.NEW;

  @override
  void initState() {
    getIssues();
    super.initState();
  }

  Future<void> getIssues() async {
    final i = await IssueApi().getIssues((await widget.auth.getStoredCredentials())!.accessToken);

    setState(() {
      issues = i;
    });
  }

  void deleteIssue(int id) async {
    final success =
        await IssueApi().deleteIssue((await widget.auth.getStoredCredentials())!.accessToken, id);
    if (!success) {
      return;
    }
    setState(() {
      issues!.removeWhere((e) => e.id == id);
    });
  }

  void completeIssue(int id) async {
    final success = await IssueApi()
        .markIssueCompleted((await widget.auth.getStoredCredentials())!.accessToken, id);
    if (!success) {
      return;
    }
    final index = issues!.indexWhere((e) => e.id == id);
    setState(() {
      issues![index] = issues![index].copyWith(IssueStatus.RESOLVED);
    });
  }

  void markAsNew(int id) async {
    final success = await IssueApi()
        .markIssueAsNew((await widget.auth.getStoredCredentials())!.accessToken, id);
    if (!success) {
      return;
    }
    final index = issues!.indexWhere((e) => e.id == id);
    setState(() {
      issues![index] = issues![index].copyWith(IssueStatus.NEW);
    });
  }

  void inProgressIssue(int id) async {
    final success = await IssueApi()
        .markIssueInProgress((await widget.auth.getStoredCredentials())!.accessToken, id);
    if (!success) {
      return;
    }
    final index = issues!.indexWhere((e) => e.id == id);
    setState(() {
      issues![index] = issues![index].copyWith(IssueStatus.IN_PROGRESS);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: const Text("Issues"),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.of(context).pop(),
            )),
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
          child: issues == null
              ? const Center(child: CircularProgressIndicator())
              : RefreshIndicator(
                  onRefresh: () async => await getIssues(),
                  child: ListView(
                    clipBehavior: Clip.none,
                    physics: const AlwaysScrollableScrollPhysics(),
                    scrollDirection: Axis.vertical,
                    children: [
                      Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                        IntrinsicWidth(
                            child: Padding(
                                padding: const EdgeInsets.all(10),
                                child: DropdownButtonFormField<IssueStatus>(
                                    decoration: const InputDecoration(
                                      border: OutlineInputBorder(),
                                      contentPadding:
                                          EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                                    ),
                                    value: filter,
                                    items: IssueStatus.values
                                        .map((e) => DropdownMenuItem<IssueStatus>(
                                              child: Text(e.string()),
                                              value: e,
                                            ))
                                        .toList(),
                                    onChanged: (value) => setState(() {
                                          filter = value!;
                                        }))))
                      ]),
                      ...issues!
                          .where((e) => e.status == filter)
                          .map((e) => _IssueCard(
                                issue: e,
                                onComplete: () => completeIssue(e.id!),
                                inProgress: () => inProgressIssue(e.id!),
                                onDelete: () => deleteIssue(e.id!),
                                markAsNew: () => markAsNew(e.id!),
                              ))
                          .toList(),
                      if (issues!.where((e) => e.status == filter).isEmpty)
                        const Center(child: Text("No issues found"))
                    ],
                  )),
        ));
  }
}

class _IssueCard extends StatelessWidget {
  const _IssueCard({
    required this.issue,
    required this.onComplete,
    required this.inProgress,
    required this.onDelete,
    required this.markAsNew,
  });
  final void Function()? onComplete;
  final void Function()? inProgress;
  final void Function()? onDelete;
  final void Function()? markAsNew;
  final Issue issue;
  @override
  Widget build(BuildContext context) {
    return Card(
        child: Padding(
      padding: const EdgeInsets.only(top: 20, left: 20, right: 10, bottom: 5),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
              text: TextSpan(children: [
            TextSpan(
              text: "Issue ID: ",
              style: GoogleFonts.openSans(
                  fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurface),
            ),
            TextSpan(
              text: "${issue.id}",
              style: GoogleFonts.openSans(color: Theme.of(context).colorScheme.onSurface),
            )
          ])),
          RichText(
              text: TextSpan(children: [
            TextSpan(
              text: "Status: ",
              style: GoogleFonts.openSans(
                  fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurface),
            ),
            TextSpan(
              text: issue.status!.string(),
              style: GoogleFonts.openSans(color: Theme.of(context).colorScheme.onSurface),
            )
          ])),
          if (issue.dateSubmitted != null)
            RichText(
                text: TextSpan(children: [
              TextSpan(
                text: "Submitted: ",
                style: GoogleFonts.openSans(
                    fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurface),
              ),
              TextSpan(
                text: DateFormat("HH:mm dd/MM/yyyy").format(issue.dateSubmitted!),
                style: GoogleFonts.openSans(color: Theme.of(context).colorScheme.onSurface),
              )
            ])),
          RichText(
              text: TextSpan(children: [
            TextSpan(
              text: "Location: ",
              style: GoogleFonts.openSans(
                  fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurface),
            ),
            TextSpan(
              text: issue.location,
              style: GoogleFonts.openSans(color: Theme.of(context).colorScheme.onSurface),
            )
          ])),
          RichText(
              text: TextSpan(children: [
            TextSpan(
              text: "User: ",
              style: GoogleFonts.openSans(
                  fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurface),
            ),
            TextSpan(
              text: issue.email,
              style: GoogleFonts.openSans(color: Theme.of(context).colorScheme.onSurface),
            )
          ])),
          RichText(
              text: TextSpan(children: [
            TextSpan(
              text: "Category: ",
              style: GoogleFonts.openSans(
                  fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurface),
            ),
            TextSpan(
              text: issue.category.name,
              style: GoogleFonts.openSans(color: Theme.of(context).colorScheme.onSurface),
            )
          ])),
          if (issue.subCategory != null)
            RichText(
                text: TextSpan(children: [
              TextSpan(
                text: "Sub-Category: ",
                style: GoogleFonts.openSans(
                    fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurface),
              ),
              TextSpan(
                text: issue.subCategory!.name,
                style: GoogleFonts.openSans(color: Theme.of(context).colorScheme.onSurface),
              )
            ])),
          if (issue.subSubCategory != null)
            RichText(
                text: TextSpan(children: [
              TextSpan(
                text: "Sub-Sub-Category: ",
                style: GoogleFonts.openSans(
                    fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurface),
              ),
              TextSpan(
                text: issue.subSubCategory!.name,
                style: GoogleFonts.openSans(color: Theme.of(context).colorScheme.onSurface),
              )
            ])),
          if (issue.description != null)
            RichText(
                text: TextSpan(children: [
              TextSpan(
                text: "Description: ",
                style: GoogleFonts.openSans(
                    fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurface),
              ),
              TextSpan(
                text: issue.description,
                style: GoogleFonts.openSans(color: Theme.of(context).colorScheme.onSurface),
              )
            ])),
          if (issue.closedBy != null)
            RichText(
                text: TextSpan(children: [
              TextSpan(
                text: "Updated by: ",
                style: GoogleFonts.openSans(
                    fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurface),
              ),
              TextSpan(
                text: issue.closedBy,
                style: GoogleFonts.openSans(color: Theme.of(context).colorScheme.onSurface),
              )
            ])),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: IconButton(
                      onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => UserAdminPage(email: issue.email))),
                      icon: const Icon(Icons.person))),
              if (issue.status == IssueStatus.NEW && inProgress != null)
                Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child:
                        IconButton(onPressed: inProgress, icon: const Icon(Icons.pending_actions))),
              if (issue.status == IssueStatus.IN_PROGRESS && markAsNew != null)
                Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: IconButton(onPressed: markAsNew, icon: const Icon(Icons.undo))),
              if ([IssueStatus.NEW, IssueStatus.IN_PROGRESS].contains(issue.status) &&
                  onComplete != null)
                Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: IconButton(onPressed: onComplete, icon: const Icon(Icons.check))),
              if (issue.status == IssueStatus.RESOLVED && inProgress != null)
                Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: IconButton(onPressed: inProgress, icon: const Icon(Icons.undo))),
              if (onDelete != null)
                Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: IconButton(onPressed: onDelete, icon: const Icon(Icons.close))),
            ],
          )
        ],
      ),
    ));
  }
}
