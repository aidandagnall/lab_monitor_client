import 'package:lab_availability_checker/models/issues/issue.dart';

class AccessoriesIssue extends IssueCategory {
  @override
  bool get descriptionRequired => false;

  @override
  String get name => "Accessories";

  @override
  List<IssueSubCategory>? get subIssues => const [
        IssueSubCategory(name: "Keyboard", subIssues: [
          IssueSubSubCategory(name: "Missing"),
          IssueSubSubCategory(name: "Keys not working"),
          IssueSubSubCategory(name: "Broken"),
          IssueSubSubCategory(name: "Keyboard legs broken"),
          IssueSubSubCategory(name: "Other", descriptionRequired: true),
        ]),
        IssueSubCategory(name: "Mouse", subIssues: [
          IssueSubSubCategory(name: "Missing"),
          IssueSubSubCategory(name: "Buttons not working"),
          IssueSubSubCategory(name: "Broken"),
          IssueSubSubCategory(name: "Other", descriptionRequired: true),
        ]),
        IssueSubCategory(name: "Cables", subIssues: [
          IssueSubSubCategory(name: "Missing, please specify", descriptionRequired: true),
          IssueSubSubCategory(name: "Broken, please specify", descriptionRequired: true)
        ]),
        IssueSubCategory(name: "Other", descriptionRequired: true)
      ];
}
