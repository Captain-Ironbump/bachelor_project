import 'dart:convert';

import 'package:student_initializer/data/datasources/remote/observation/observation_remote_data_source.dart';
import 'package:student_initializer/data/models/observation_count_detail/observation_count_detail_model.dart';
import 'package:student_initializer/data/models/observation_detail/observation_detail_model.dart';
import 'package:http/http.dart' as http;
import 'package:student_initializer/data/models/observation_detail_with_tags/observation_detail_with_tags_model.dart';
import 'package:student_initializer/domain/entities/tag_detail/tag_detail_entity.dart';
import 'package:student_initializer/util/plattform_uri.dart';
import 'package:student_initializer/util/simplified_uri.dart';

class ObservationRemoteDataSourceImpl implements ObservationRemoteDataSource {
  @override
  Future<Map<String, ObservationCountDetailModel>> getCountMap(
      {int? timespanInDays, List<int>? learners, int? eventId}) async {
    try {
      final queryParams = {
        "timespanInDays": timespanInDays,
        "learners": learners,
      };

      if (eventId != null) {
        queryParams.addEntries([MapEntry('eventId', eventId)]);
      }

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
      {required int learnerId,
      required Map<String, dynamic> queryParams}) async {
    try {
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
      {required int learnerId,
      required int eventId,
      required String observation,
      required List<TagDetailEntity> selectedTags}) async {
    try {
      final body = jsonEncode({
        "observationDTO": {
          "learnerId": learnerId,
          "eventId": eventId,
          "rawObservation": observation,
        },
        "tags": selectedTags
            .map((tag) => {
                  "tag": tag.tag,
                  "color": tag.tagColor,
                })
            .toList(),
      });
      final response = await http.post(
          Uri.parse('${PlattformUri.getUri()}/observations/tags'),
          headers: {
            "Content-Type": "application/json",
          },
          body: body);
      if (response.statusCode != 201) {
        throw Exception();
      }
    } catch (_) {
      rethrow;
    }
  }

  @override
  Future<ObservationDetailModel> getObservationDetailById(
      {required int observationId}) async {
    try {
      final Uri uri = SimplifiedUri.uri(
          '${PlattformUri.getUri()}/observations/observationId/$observationId',
          null);
      final response = await http.get(uri);
      return ObservationDetailModel.fromJson(json.decode(response.body));
    } catch (_) {
      rethrow;
    }
  }

  @override
  Future<List<ObservationDetailWithTagsModel>>
      getObservationsWithTagsByLearnerId({
    required int learnerId,
    required Map<String, dynamic> queryParams,
  }) async {
    try {
      final Uri uri = SimplifiedUri.uri(
          '${PlattformUri.getUri()}/observations/tags/learner/$learnerId',
          queryParams);

      final response = await http.get(uri);
      final List<dynamic> items = json.decode(response.body);
      return items
          .map((item) => ObservationDetailWithTagsModel.fromJson(item))
          .toList();
    } catch (_) {
      rethrow;
    }
  }
  
  @override
  Future<ObservationDetailWithTagsModel> getObservationWithTagsById({required int observationId}) async{
    try {
      final Uri uri = SimplifiedUri.uri(
          '${PlattformUri.getUri()}/observations/tags/observation/$observationId',
          null);
      final response = await http.get(uri);
      return ObservationDetailWithTagsModel.fromJson(json.decode(response.body));
    } catch (_) {
      rethrow;
    }
  }
}
