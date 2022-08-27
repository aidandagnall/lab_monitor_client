class Module {
  final String code;
  final String name;
  final List<String> convenor;

  Module({required this.code, required this.name, required this.convenor});

  factory Module.fromJson(Map<String, dynamic> json) {
    print("module");
    print(json);
    return Module(
      code: json['code'],
      name: json['name'],
      convenor: json['convenor'].map<String>((json) => json.toString()).toList(),
    );
  }
}
