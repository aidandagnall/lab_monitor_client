// ignore_for_file: non_constant_identifier_names

import 'package:flutter_dotenv/flutter_dotenv.dart';

class Constants {
  static String API_URL = dotenv.get('DEBUG', fallback: 'true') == 'true'
      ? dotenv.get('DEBUG_API_URL', fallback: 'localhost')
      : dotenv.env['API_URL']!;
}
