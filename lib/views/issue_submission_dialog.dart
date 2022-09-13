import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lab_availability_checker/api/issue_api.dart';
import 'package:lab_availability_checker/models/issues/issue.dart';

class IssueSubmissionDialog extends StatelessWidget {
  const IssueSubmissionDialog({Key? key, required this.issue})
      : super(key: key);
  final Issue issue;

  Future<bool> submitReport() async {
    await Future.delayed(const Duration(seconds: 1));
    return IssueApi().submitReport(issue);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: FractionallySizedBox(
            widthFactor: 0.8,
            child: Card(
                child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: AnimatedSize(
                        duration: const Duration(milliseconds: 200),
                        curve: Curves.ease,
                        child: FutureBuilder<bool>(
                            future: submitReport(),
                            builder: (ctx, snapshot) {
                              if (!snapshot.hasData) {
                                return const IntrinsicHeight(
                                    child: Center(
                                        child: Padding(
                                            padding: EdgeInsets.all(20),
                                            child:
                                                CircularProgressIndicator())));
                              }
                              return Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 10),
                                      child: Text(
                                        snapshot.data!
                                            ? "Issue Submitted"
                                            : "Submission Failed",
                                        textAlign: TextAlign.center,
                                        style:
                                            GoogleFonts.openSans(fontSize: 20),
                                      )),
                                  Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 10),
                                      child: Text(
                                        snapshot.data!
                                            ? "You will receive an email once it has been received and then resolved."
                                            : "Please try again, or contact support directly.",
                                        textAlign: TextAlign.center,
                                        style:
                                            GoogleFonts.openSans(fontSize: 16),
                                      )),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 10),
                                    child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          elevation: 4,
                                          shape: const RoundedRectangleBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(5))),
                                          backgroundColor: Theme.of(context)
                                              .colorScheme
                                              .primary,
                                          foregroundColor: Theme.of(context)
                                              .colorScheme
                                              .onPrimary,
                                        ),
                                        onPressed: () => Navigator.pop(
                                            context, snapshot.data!),
                                        child: const Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 20),
                                            child: Text("OK"))),
                                  )
                                ],
                              );
                            }))))));
  }
}
