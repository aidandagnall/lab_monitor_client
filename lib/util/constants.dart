// ignore_for_file: non_constant_identifier_names

import 'dart:io' show Platform;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class Constants {
  static bool DEBUG = dotenv.get('DEBUG', fallback: 'true') == 'true';
  static String API_URL = dotenv.get('DEBUG', fallback: 'true') == 'true'
      ? dotenv.get('DEBUG_API_URL', fallback: 'localhost')
      : dotenv.env['API_URL']!;
  static String AUTH0_CALLBACK_URL = Platform.isAndroid
      ? dotenv.env['ANDROID_AUTH0_CALLBACK_URL']!
      : dotenv.env['IOS_AUTH0_CALLBACK_URL']!;
  static String AUTHORITY = dotenv.env['AUTHORITY']!;
  static String PATH = dotenv.env['PATH']!;
  static String AUDIENCE = dotenv.env['AUDIENCE']!;
}
