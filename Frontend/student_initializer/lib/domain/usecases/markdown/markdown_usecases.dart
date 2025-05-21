import 'package:fpdart/fpdart.dart';
import 'package:student_initializer/domain/entities/markdown_from/markdown_form_entity.dart';
import 'package:student_initializer/domain/repositories/markdown/markdown_repository.dart';
import 'package:student_initializer/util/exceptions/network_excpetion.dart';

class MarkdownUsecases {
  final MarkdownRepository _markdownRepository;

  const MarkdownUsecases(this._markdownRepository);

  Future<Either<NetworkException, String>> generateMarkdownForm(
      {required int eventId, required int learnerId, String? length}) async {
    return _markdownRepository.generateMarkdownForm(
        eventId: eventId, learnerId: learnerId, length: length);
  }

  Future<Either<NetworkException, MarkdownFormEntity>> getMarkdownForm(
      {required int reportId}) async {
    return _markdownRepository.getMarkdownForm(reportId: reportId);
  }

  Future<Either<NetworkException, List<MarkdownFormEntity>>>
      getMarkdownFormsByLearnerAndEvent(
          {required int learnerId,
          int? eventId,
          String? sortBy,
          String? sortOrder,
          int? timespanInDays}) async {
    return _markdownRepository.getMarkdownFormsByLearnerAndEvent(
        learnerId: learnerId,
        eventId: eventId,
        sortBy: sortBy,
        sortOrder: sortOrder,
        timespanInDays: timespanInDays);
  }

  Future<Either<NetworkException, MarkdownFormEntity>> updateMarkdownForm(
      {required int reportId, required String quality}) async {
    return _markdownRepository.updateMarkdownForm(
        reportId: reportId, quality: quality);
  }
}
