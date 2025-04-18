import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:student_initializer/data_old/remote/models/observation.dart';

class ObservationService {
  final Uri uri;

  ObservationService()
      : uri = Uri.parse('${ObservationService.getUri()}/observations');

  Future<List<ObservationModel>> getAllObservationsByLearnerId(
      int learnerId) async {
    List<ObservationModel> data = [];
    try {
      Uri url = Uri.parse(
          "${ObservationService.getUri()}/observations/learnerId/$learnerId");
      final response = await http.get(url);
      if (response.statusCode == 200) {
        print(response.body);
        final List<dynamic> items = json.decode(response.body);
        data = items.map((item) => ObservationModel.fromJson(item)).toList();
      }
    } catch (e) {
      print('Error fetching Observation by Learner data: $e');
    }
    return data;
  }

  Future<void> saveObservation(int learnerId, String observation) async {
    Map<String, dynamic> data = {
      "learnerId": learnerId,
      "rawObservation": base64.encode(utf8.encode(observation)),
    };

    try {
      final response = await http.post(uri,
          headers: {
            "Content-Type": "application/json",
          },
          body: jsonEncode(data));
      if (response.statusCode != 201) {
        throw Exception("Error sending to Backend");
      }
    } catch (_) {
      rethrow;
    }
  }

  Future<Map<String, int>> fetchCountMap() async {
    Uri url =
        Uri.parse("${ObservationService.getUri()}/observations/count-map");
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final Map<String, int> intMap = data.map((key, value) =>
            MapEntry(key, value is int ? value : int.parse(value.toString())));
        return intMap;
      }
      return {};
    } catch (_) {
      rethrow;
    }
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
