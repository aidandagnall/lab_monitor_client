import 'package:lab_availability_checker/models/issues/issue.dart';

class MonitorIssue extends IssueCategory {
  @override
  bool get descriptionRequired => false;

  @override
  String get name => "Monitor";

  @override
  List<IssueSubCategory>? get subIssues => const [
        IssueSubCategory(name: "No Display"),
        IssueSubCategory(name: "No Power"),
        IssueSubCategory(name: "Missing Cables"),
        IssueSubCategory(name: "Screen Damaged"),
        IssueSubCategory(name: "Other", descriptionRequired: true),
      ];
}
