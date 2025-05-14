import 'package:student_initializer/data/models/markdown_form/markdown_form_model.dart';

abstract class MarkdownRemoteDataSource {
  Future<MarkdownFormModel> generateMarkdownForm({required int eventId, required int learnerId, String? length});
}
