import 'package:student_initializer/data/models/markdown_form/markdown_form_model.dart';

abstract class MarkdownRemoteDataSource {
  Future<String> generateMarkdownForm({required int eventId, required int learnerId, String? length});
  Future<MarkdownFormModel> getMarkdownForm({required int reportId});
  Future<List<MarkdownFormModel>> getMarkdownFormsByLearnerAndEvent(
      {required int learnerId, int? eventId, String? sortBy, String? sortOrder, int? timespanInDays});
  Future<MarkdownFormModel> updateMarkdownForm(
      {required int reportId, required String quality});
}
