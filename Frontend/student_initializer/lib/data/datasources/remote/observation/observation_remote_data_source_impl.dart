import 'dart:convert';

import 'package:student_initializer/data/datasources/remote/observation/observation_remote_data_source.dart';
import 'package:student_initializer/data/models/observation_count_detail/observation_count_detail_model.dart';
import 'package:student_initializer/data/models/observation_detail/observation_detail_model.dart';
import 'package:http/http.dart' as http;
import 'package:student_initializer/util/plattform_uri.dart';
import 'package:student_initializer/util/simplified_uri.dart';

class ObservationRemoteDataSourceImpl implements ObservationRemoteDataSource {
  @override
  Future<Map<String, ObservationCountDetailModel>> getCountMap(
      {int? timespanInDays, List<int>? learners}) async {
    try {
      final queryParams = {
        "timespanInDays": timespanInDays,
        "learners": learners,
      };

      final Uri uri = SimplifiedUri.uri(
          '${PlattformUri.getUri()}/observations/count-map', queryParams);
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final Map<String, ObservationCountDetailModel> objMap = data.map(
            (key, value) => MapEntry(
                key,
                value is ObservationCountDetailModel
                    ? value
                    : ObservationCountDetailModel.fromJson(value)));
        return objMap;
      }
      return {};
    } catch (_) {
      rethrow;
    }
  }

  @override
  Future<List<ObservationDetailModel>> getObservationsByLearnerId(
      {required int learnerId}) async {
    try {
      final queryParams = {
        "sort": "createdDateTime",
        "learners": "ASC",
      };

      final Uri uri = SimplifiedUri.uri(
          '${PlattformUri.getUri()}/observations/learnerId/$learnerId',
          queryParams);

      final response = await http.get(uri);
      final List<dynamic> items = json.decode(response.body);
      return items
          .map((item) => ObservationDetailModel.fromJson(item))
          .toList();
    } catch (_) {
      rethrow;
    }
  }

  @override
  Future<void> saveObservation(
      {required int learnerId, required String observation}) async {
    try {
      final response = await http
          .post(Uri.parse('${PlattformUri.getUri()}/observations'), headers: {
        "Content-Type": "application/json",
      }, body: {
        "learnerId": learnerId,
        "rawObservation": base64.encode(utf8.encode(observation)),
      });
      if (response.statusCode != 201) {
        throw Exception();
      }
    } catch (_) {
      rethrow;
    }
  }
}
