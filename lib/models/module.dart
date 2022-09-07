import 'package:lab_availability_checker/models/module_code.dart';

class Module {
  final String code;
  final String name;
  final String abbreviation;
  final List<String> convenor;

  Module(
      {required this.code, required this.name, required this.abbreviation, required this.convenor});

  factory Module.fromJson(Map<String, dynamic> json) {
    return Module(
      code: json['code'],
      name: json['name'],
      abbreviation: json['abbreviation'],
      convenor: json['convenor'].map<String>((json) => json.toString()).toList(),
    );
  }

  String getModuleCodeWithStyle(ModuleCodeStyle style) {
    switch (style) {
      case ModuleCodeStyle.modern:
        return code;
      case ModuleCodeStyle.old:
        return abbreviation;
      case ModuleCodeStyle.mixed:
        return code.substring(4) + abbreviation;
      case ModuleCodeStyle.oldWithYear:
        return "Y${code[4]} - $abbreviation";
    }
  }
}
