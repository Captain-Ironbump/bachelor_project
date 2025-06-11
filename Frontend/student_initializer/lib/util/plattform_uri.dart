import 'dart:io';

import 'package:flutter_dotenv/flutter_dotenv.dart';

class PlattformUri {
  static String getUri() {
    const bool kIsWeb = bool.fromEnvironment('dart.library.js_util');
    if (kIsWeb) {
      return 'http://127.0.0.1:8081/api';
    }
    if (Platform.isAndroid) {
      return dotenv.env['ANDROID_BASE_PERSISTANT_HTTP']!;
    }
    if (Platform.isIOS) {
      return dotenv.env['IOS_BASE_PERSISTANT_HTTP']!;
    }
    throw UnsupportedError('Platform not supported');
  }

  static String getLlUri() {
    if (Platform.isAndroid) {
      return dotenv.env['ANDROID_BASE_LLM_HTTP']!;
    }
    if (Platform.isIOS) {
      return dotenv.env['IOS_BASE_LLM_HTTP']!;
    }
    throw UnsupportedError('Platform not supported');
  }
}
