import 'package:lab_availability_checker/models/issues/categories/accessories.dart';
import 'package:lab_availability_checker/models/issues/categories/computer.dart';
import 'package:lab_availability_checker/models/issues/categories/monitor.dart';
import 'package:lab_availability_checker/models/issues/categories/other.dart';

abstract class IssueCategory {
  abstract final String name;
  abstract final List<IssueSubCategory>? subIssues;
  abstract final bool descriptionRequired;
}

class IssueSubCategory {
  final String name;
  final List<IssueSubSubCategory>? subIssues;
  final bool descriptionRequired;

  const IssueSubCategory({required this.name, this.subIssues, this.descriptionRequired = false});
}

class IssueSubSubCategory {
  final String name;
  final bool descriptionRequired;
  const IssueSubSubCategory({required this.name, this.descriptionRequired = false});
}

final List<IssueCategory> issueCategories = [
  MonitorIssue(),
  ComputerIssue(),
  AccessoriesIssue(),
  OtherIssue(),
];

class Issue {
  final String location;
  final String email;
  final IssueCategory category;
  final IssueSubCategory? subCategory;
  final IssueSubSubCategory? subSubCategory;
  final String? description;

  const Issue(
      {required this.location,
      required this.email,
      required this.category,
      this.subCategory,
      this.subSubCategory,
      this.description});

  Map<String, dynamic> toJson() => {
        "location": location,
        "email": email,
        "category": category.name,
        "subcategory": subCategory?.name,
        "subsubcategory": subSubCategory?.name,
        "description": description
      };
}
