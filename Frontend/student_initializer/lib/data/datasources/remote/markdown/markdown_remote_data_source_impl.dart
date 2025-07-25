import 'dart:convert';

import 'package:student_initializer/data/datasources/remote/markdown/markdown_remote_data_source.dart';
import 'package:student_initializer/data/models/markdown_form/markdown_form_model.dart';
import 'package:student_initializer/util/plattform_uri.dart';
import 'package:student_initializer/util/simplified_uri.dart';
import 'package:http/http.dart' as http;

class MarkdownRemoteDataSourceImpl implements MarkdownRemoteDataSource {
  @override
  Future<String> generateMarkdownForm(
      {required int eventId,
      required int learnerId,
      String? length,
      required String endpoint}) async {
    try {
      var queryParam = {};
      if (length != null) {
        queryParam = Map.of({"length": length});
      }

      Uri uri = SimplifiedUri.uri(
          '${PlattformUri.getLlUri()}/reporttrigger/new/event/$eventId/learner/$learnerId',
          queryParam);

      if (endpoint.toLowerCase().contains("competence")) {
        queryParam.addEntries([MapEntry("eventId", eventId)]);
        uri = SimplifiedUri.uri(
            '${PlattformUri.getLlUri()}/tag-concept/competence/learners/$learnerId',
            queryParam);
      }
      if (endpoint.toLowerCase().contains("general")) {
        queryParam.addEntries([MapEntry("eventId", eventId)]);
        uri = SimplifiedUri.uri(
            '${PlattformUri.getLlUri()}/tag-concept/general/learners/$learnerId',
            queryParam);
      }

      final response = await http.get(uri);
      return response.body.toString();
    } catch (_) {
      rethrow;
    }
  }

  @override
  Future<MarkdownFormModel> getMarkdownForm({required int reportId}) async {
    try {
      final Uri uri =
          SimplifiedUri.uri('${PlattformUri.getUri()}/reports/$reportId', null);
      final response = await http.get(uri);
      dynamic decodedJson = json.decode(response.body);
      return MarkdownFormModel.fromJson(decodedJson);
    } catch (_) {
      rethrow;
    }
  }

  @override
  Future<List<MarkdownFormModel>> getMarkdownFormsByLearnerAndEvent(
      {required int learnerId,
      int? eventId,
      String? sortBy,
      String? sortOrder,
      int? timespanInDays}) async {
    try {
      var queryParams = {
        "eventId": eventId,
        "sort": sortBy,
        "order": sortOrder,
        "timespanInDays": timespanInDays
      };
      final Uri uri = SimplifiedUri.uri(
          '${PlattformUri.getUri()}/reports/learner/$learnerId', queryParams);

      final response = await http.get(uri);
      List<dynamic> decodedJson = json.decode(response.body);
      return decodedJson
          .map((item) => MarkdownFormModel.fromJson(item))
          .toList();
    } catch (_) {
      rethrow;
    }
  }

  @override
  Future<MarkdownFormModel> updateMarkdownForm(
      {required int reportId, required String quality}) async {
    try {
      final Uri uri =
          SimplifiedUri.uri('${PlattformUri.getUri()}/reports/$reportId', null);
      final body = json.encode({"quality": quality});
      final response = await http.patch(
        uri,
        headers: {
          "Content-Type": "application/json",
        },
        body: body,
      );
      return MarkdownFormModel.fromJson(json.decode(response.body));
    } catch (_) {
      rethrow;
    }
  }
}
