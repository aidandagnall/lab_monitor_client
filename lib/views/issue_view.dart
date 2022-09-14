import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lab_availability_checker/models/issues/issue.dart';
import 'package:lab_availability_checker/providers/token_provider.dart';
import 'package:lab_availability_checker/views/issue_submission_dialog.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:provider/provider.dart';

class IssueView extends StatefulWidget {
  const IssueView({Key? key}) : super(key: key);

  @override
  createState() => _IssueViewState();
}

class _IssueViewState extends State<IssueView> {
  TextEditingController locationIdController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  IssueCategory? category;
  IssueSubCategory? subCategory;
  IssueSubSubCategory? subSubCategory;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Form(
            key: _formKey,
            child: SingleChildScrollView(
                child: Column(
              children: [
                Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Text(
                      "Submit a Lab Issue",
                      style: GoogleFonts.openSans(fontSize: 30, fontWeight: FontWeight.w300),
                    )),
                Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Text(
                      "Scan or manually enter a location",
                      style: GoogleFonts.openSans(fontSize: 16, fontWeight: FontWeight.w400),
                    )),
                Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: IntrinsicHeight(
                        child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Expanded(
                            child: Padding(
                                padding: const EdgeInsets.only(right: 20),
                                child: TextFormField(
                                  initialValue: null,
                                  controller: locationIdController,
                                  style: GoogleFonts.openSans(fontSize: 16),
                                  cursorHeight: 20,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return "Please enter a Location ID";
                                    }
                                    if (RegExp(r'^[0-2][0-9]{5,5}$').hasMatch(value)) {
                                      return null;
                                    }
                                    return "Please enter a valid Location ID";
                                  },
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: "Location ID",
                                    contentPadding:
                                        EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                                  ),
                                ))),
                        ElevatedButton(
                            onPressed: () async =>
                                locationIdController.text = (await openScanner(context))!,
                            style: ElevatedButton.styleFrom(
                              elevation: 4,
                              shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(5))),
                              primary: Theme.of(context).colorScheme.primary,
                              onPrimary: Theme.of(context).colorScheme.onPrimary,
                            ),
                            child: const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                                child: Icon(
                                  Icons.qr_code_scanner_rounded,
                                  size: 28,
                                )))
                      ],
                    ))),
                Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: DropdownButtonFormField<IssueCategory>(
                        decoration: InputDecoration(
                          border: const OutlineInputBorder(),
                          labelStyle: GoogleFonts.openSans(fontSize: 16),
                          alignLabelWithHint: true,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                          labelText: "Category",
                        ),
                        validator: ((value) {
                          if (value == null) {
                            return "Please select a category";
                          }
                          return null;
                        }),
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        value: category,
                        items: issueCategories
                            .map((e) => DropdownMenuItem<IssueCategory>(
                                  child: Text(
                                    e.name,
                                    style: GoogleFonts.openSans(fontSize: 16),
                                  ),
                                  value: e,
                                ))
                            .toList(),
                        onChanged: (IssueCategory? _category) => setState(() {
                              category = _category!;
                              subCategory = null;
                            }))),
                if (category?.subIssues != null)
                  Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: DropdownButtonFormField<IssueSubCategory>(
                          decoration: InputDecoration(
                            border: const OutlineInputBorder(),
                            labelStyle: GoogleFonts.openSans(fontSize: 16),
                            alignLabelWithHint: true,
                            contentPadding:
                                const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                            labelText: "Sub-Category",
                          ),
                          value: subCategory,
                          validator: ((value) {
                            if (value == null) {
                              return "Please select a category";
                            }
                            return null;
                          }),
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          items: category!.subIssues!
                              .map((e) => DropdownMenuItem<IssueSubCategory>(
                                    child: Text(
                                      e.name,
                                      style: GoogleFonts.openSans(fontSize: 16),
                                    ),
                                    value: e,
                                  ))
                              .toList(),
                          onChanged: (IssueSubCategory? _subCategory) {
                            setState(() {
                              subCategory = _subCategory!;
                              subSubCategory = null;
                            });
                          })),
                if (category?.subIssues != null && subCategory?.subIssues != null)
                  Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: DropdownButtonFormField<IssueSubSubCategory>(
                          decoration: InputDecoration(
                            border: const OutlineInputBorder(),
                            labelStyle: GoogleFonts.openSans(fontSize: 16),
                            alignLabelWithHint: true,
                            contentPadding:
                                const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                            labelText: "Select your Issue",
                          ),
                          value: subSubCategory,
                          validator: (value) {
                            if (value == null) {
                              return "Please select a category";
                            }
                            return null;
                          },
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          items: subCategory!.subIssues!
                              .map((e) => DropdownMenuItem<IssueSubSubCategory>(
                                    child: Text(
                                      e.name,
                                      style: GoogleFonts.openSans(fontSize: 16),
                                    ),
                                    value: e,
                                  ))
                              .toList(),
                          onChanged: (IssueSubSubCategory? _subSubCategory) =>
                              setState(() => subSubCategory = _subSubCategory!))),
                Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: TextFormField(
                        controller: descriptionController,
                        validator: (value) {
                          if (category?.descriptionRequired == true ||
                              subCategory?.descriptionRequired == true ||
                              subSubCategory?.descriptionRequired == true) {
                            if (value == null || value.isEmpty) {
                              return "An issue description is required";
                            }
                          }
                          return null;
                        },
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        decoration: InputDecoration(
                          border: const OutlineInputBorder(),
                          labelStyle: GoogleFonts.openSans(fontSize: 16),
                          alignLabelWithHint: true,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                          labelText: category?.descriptionRequired == true ||
                                  subCategory?.descriptionRequired == true ||
                                  subSubCategory?.descriptionRequired == true
                              ? "Describe the Issue"
                              : "Describe the Issue (optional)",
                        ),
                        keyboardType: TextInputType.multiline,
                        maxLines: 5)),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Text(
                    "Disclaimer: Your email will be included in the issue submission in case we need to contact you for more information.",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.openSans(fontSize: 14, fontStyle: FontStyle.italic),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Consumer<TokenProvider>(
                      builder: (context, provider, child) => ElevatedButton(
                            onPressed: () async {
                              FocusScope.of(context).unfocus();
                              if (_formKey.currentState!.validate()) {
                                final bool? clearForm = await showDialog<bool>(
                                    context: context,
                                    builder: ((context) => IssueSubmissionDialog(
                                        issue: Issue(
                                            location: locationIdController.text.substring(0, 3) +
                                                "-" +
                                                locationIdController.text.substring(3),
                                            email: provider.email!,
                                            category: category!,
                                            subCategory: subCategory,
                                            subSubCategory: subSubCategory,
                                            description: descriptionController.text))));
                                if (clearForm == true) {
                                  setState(() {
                                    _formKey.currentState!.reset();
                                    locationIdController.value = TextEditingValue.empty;
                                    descriptionController.value = TextEditingValue.empty;
                                    category = null;
                                    subCategory = null;
                                    subSubCategory = null;
                                  });
                                }
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              elevation: 4,
                              shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(5))),
                              primary: Theme.of(context).colorScheme.primary,
                              onPrimary: Theme.of(context).colorScheme.onPrimary,
                            ),
                            child: const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 20),
                                child: Text("Submit Issue")),
                          )),
                )
              ],
            ))));
  }

  Future<String?> openScanner(BuildContext context) async {
    final String? code = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (ctx) => Scaffold(
                appBar: AppBar(title: const Text("Scan a location tag")),
                body: MobileScanner(
                  allowDuplicates: false,
                  onDetect: (barcode, args) => Navigator.pop(context, barcode.rawValue),
                ))));
    if (code == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Failed to read code. Try entering manually."),
      ));
      return "";
    }
    return code.replaceAll("-", "");
  }
}
