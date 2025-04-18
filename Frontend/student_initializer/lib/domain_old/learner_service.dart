import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:student_initializer/data_old/remote/models/learner.dart';

class LearnerService {
  final Uri uri;

  LearnerService() : uri = Uri.parse('${LearnerService.getUri()}/learners');

  Future<List<LearnerModel>> getAllLearners() async {
    List<LearnerModel> data = [];
    try {
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        final List<dynamic> items = json.decode(response.body);
        data = items.map((item) => LearnerModel.fromJson(item)).toList();
      }
    } catch (e) {
      print('Error fetching Learners data$e');
    }
    return data;
  }

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
