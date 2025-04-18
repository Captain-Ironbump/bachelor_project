import 'dart:io';

import 'package:flutter_dotenv/flutter_dotenv.dart';

class PlattformUri {
  static String getUri() {
    if (Platform.isAndroid) {
      return dotenv.env['ANDROID_BASE_PERSISTANT_HTTP']!;
    }
    if (Platform.isIOS) {
      return dotenv.env['IOS_BASE_PERSISTANT_HTTP']!;
    }
    throw UnsupportedError('Platform not supported');
  }
}