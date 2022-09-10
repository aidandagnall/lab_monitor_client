import 'package:lab_availability_checker/models/issues/issue.dart';

class OtherIssue extends IssueCategory {
  @override
  bool get descriptionRequired => true;

  @override
  String get name => "Other";

  @override
  List<IssueSubCategory>? get subIssues => null;
}
