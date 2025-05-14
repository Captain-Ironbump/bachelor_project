import 'dart:convert';

import 'package:student_initializer/data/datasources/remote/markdown/markdown_remote_data_source.dart';
import 'package:student_initializer/data/models/markdown_form/markdown_form_model.dart';
import 'package:student_initializer/util/plattform_uri.dart';
import 'package:student_initializer/util/simplified_uri.dart';
import 'package:http/http.dart' as http;

class MarkdownRemoteDataSourceImpl implements MarkdownRemoteDataSource {
  @override
  Future<MarkdownFormModel> generateMarkdownForm(
      {required int eventId, required int learnerId, String? length}) async {
    try {
      var queryParam = {};
      if (length != null) {
        queryParam = Map.of({"length": length});
      }
      final Uri uri = SimplifiedUri.uri(
          '${PlattformUri.getLlUri()}/reporttrigger/new/event/$eventId/learner/$learnerId',
          queryParam);
      final response = await http.get(uri);
      return MarkdownFormModel(markdownText: response.body);
    } catch (_) {
      rethrow;
    }
  }
}
