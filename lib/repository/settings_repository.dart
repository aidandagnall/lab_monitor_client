import 'package:lab_availability_checker/models/module_code.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsRepository {
  final SharedPreferences preferences;

  SettingsRepository(this.preferences);
}
