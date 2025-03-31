import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';

import 'package:student_initializer/data/local/models/student.dart'; // To decode the JSON response

class LlmTextService {
  final Uri uri;

  LlmTextService() : uri = Uri.parse('${LlmTextService.getUri()}/hello/test');

  Future<http.Response> getLlmRequest(Student student, String query) async {
    final response = await http.post(
      uri,
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(<String, dynamic>{
        'student': student.toJson(),
        'query': query,
      })
    );

    return response;
  }

  static String getUri() {
    if (Platform.isAndroid) {
      return dotenv.env['ANDROID_BASE_HTTP']!;
    }
    if (Platform.isIOS) {
      return dotenv.env['IOS_BASE_HTTP']!;
    }
    throw UnsupportedError('Platform not supported');
  } 
}