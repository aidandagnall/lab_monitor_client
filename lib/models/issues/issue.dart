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

enum IssueStatus { NEW, IN_PROGRESS, RESOLVED }

extension IssueStatusString on IssueStatus {
  String string() {
    switch (this) {
      case IssueStatus.NEW:
        return "New";
      case IssueStatus.IN_PROGRESS:
        return "In Progress";
      case IssueStatus.RESOLVED:
        return "Resolved";
    }
  }
}

class Issue {
  final int? id;
  final String location;
  final String email;
  final IssueCategory category;
  final IssueSubCategory? subCategory;
  final IssueSubSubCategory? subSubCategory;
  final String? description;
  final IssueStatus? status;
  final DateTime? dateSubmitted;
  final String? closedBy;

  Issue({
    this.id,
    required this.location,
    required this.email,
    required this.category,
    this.subCategory,
    this.subSubCategory,
    this.description,
    this.status,
    this.dateSubmitted,
    this.closedBy,
  });

  Map<String, dynamic> toJson() => {
        "location": location,
        "email": email,
        "category": category.name,
        "subCategory": subCategory?.name,
        "subSubCategory": subSubCategory?.name,
        "description": description
      };

  factory Issue.fromJson(Map<String, dynamic> json) {
    final cat = issueCategories.firstWhere((e) => e.name == json['category']);
    final subCat = cat.subIssues?.firstWhere((e) => e.name == json['subCategory']);
    final subSubCat = subCat?.subIssues?.firstWhere((e) => e.name == json['subSubCategory']);
    final dateValues = (json['dateSubmitted'] as List).map((e) => e as int).toList();
    return Issue(
      id: json['id'],
      location: json['location'],
      email: json['email'],
      category: cat,
      subCategory: subCat,
      subSubCategory: subSubCat,
      description: json['description'],
      status: IssueStatus.values.firstWhere((e) => e.name == json['status']),
      dateSubmitted:
          DateTime(dateValues[0], dateValues[1], dateValues[2], dateValues[3], dateValues[4]),
      closedBy: json['closedBy'],
    );
  }

  Issue copyWith(IssueStatus status) {
    return Issue(
      id: id,
      location: location,
      email: email,
      category: category,
      subCategory: subCategory,
      subSubCategory: subSubCategory,
      description: description,
      status: status,
    );
  }
}
