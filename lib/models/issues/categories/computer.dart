import 'package:lab_availability_checker/models/issues/issue.dart';

class ComputerIssue extends IssueCategory {
  @override
  bool get descriptionRequired => false;

  @override
  String get name => "Computer";

  @override
  List<IssueSubCategory>? get subIssues => const [
        IssueSubCategory(name: "Hardware", subIssues: [
          IssueSubSubCategory(name: "RAM Failure"),
          IssueSubSubCategory(name: "Missing Cable (please specify)", descriptionRequired: true),
          IssueSubSubCategory(name: "Graphics Card Problem"),
          IssueSubSubCategory(name: "No Power"),
          IssueSubSubCategory(name: "USB Ports"),
          IssueSubSubCategory(name: "Other", descriptionRequired: true)
        ]),
        IssueSubCategory(name: "Software", subIssues: [
          IssueSubSubCategory(name: "Missing Software"),
          IssueSubSubCategory(name: "Failed Update"),
          IssueSubSubCategory(name: "Not Booting"),
          IssueSubSubCategory(name: "Blue Screened"),
          IssueSubSubCategory(name: "Unable to Log In"),
          IssueSubSubCategory(name: "Bad Performance"),
          IssueSubSubCategory(name: "Other", descriptionRequired: true),
        ]),
        IssueSubCategory(name: "Other", descriptionRequired: true)
      ];
}
