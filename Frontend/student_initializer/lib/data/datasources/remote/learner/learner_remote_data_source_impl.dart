import 'dart:convert';

import 'package:student_initializer/data/datasources/remote/learner/learner_remote_data_source.dart';
import 'package:student_initializer/data/models/learner_detail/learner_detail_model.dart';
import 'package:http/http.dart' as http;
import 'package:student_initializer/util/plattform_uri.dart';
import 'package:student_initializer/util/simplified_uri.dart';

class LearnerRemoteDataSourceImpl implements LearnerRemoteDataSource {
  @override
  Future<List<LearnerDetailModel>> getAllLearners() async {
    try {
      final response =
          await http.get(Uri.parse('${PlattformUri.getUri()}/learners'));
      final List<dynamic> items = json.decode(response.body);
      return items.map((item) => LearnerDetailModel.fromJson(item)).toList();
    } catch (_) {
      rethrow;
    }
  }

  @override
  Future<LearnerDetailModel> getLearnerById({required int learnerId}) async {
    try {
      final response = await http
          .get(Uri.parse('${PlattformUri.getUri()}/learners/$learnerId'));
      final object = json.decode(response.body);
      return LearnerDetailModel.fromJson(object);
    } catch (_) {
      rethrow;
    }
  }

  @override
  Future<void> saveLearnerDetails(
      {required String firstName, required String lastName}) async {
    try {
      final response = await http
          .post(Uri.parse('${PlattformUri.getUri()}/learners'), headers: {
        "Content-Type": "application/json",
      }, body: json.encode({
        "firstName": firstName,
        "lastName": lastName,
      }));
      if (response.statusCode != 201) {
        throw Exception();
      }
    } catch (_) {
      rethrow;
    }
  }

  @override
  Future<List<LearnerDetailModel>> getLearnersByEventId(
      {required int eventId}) async {
    try {
      final Uri uri = SimplifiedUri.uri(
          '${PlattformUri.getUri()}/learners/event/$eventId', null);
      final response = await http.get(uri);
      final List<dynamic> items = json.decode(response.body);
      return items.map((item) => LearnerDetailModel.fromJson(item)).toList();
    } catch (_) {
      rethrow;
    }
  }
}
