import 'package:lab_availability_checker/models/module_code.dart';

class Module {
  final int? id;
  final String code;
  final String name;
  final String abbreviation;
  final List<String> convenor;

  Module(
      {this.id,
      required this.code,
      required this.name,
      required this.abbreviation,
      required this.convenor});

  factory Module.fromJson(Map<String, dynamic> json) {
    return Module(
      id: json['id'],
      code: json['code'],
      name: json['name'],
      abbreviation: json['abbreviation'],
      convenor: json['convenor'].map<String>((json) => json.toString()).toList(),
    );
  }

  Map<String, dynamic> toJson() =>
      {'code': code, 'name': name, 'abbreviation': abbreviation, 'convenor': convenor};

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
