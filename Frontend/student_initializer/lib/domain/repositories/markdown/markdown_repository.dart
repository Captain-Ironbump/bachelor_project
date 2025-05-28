import 'package:fpdart/fpdart.dart';
import 'package:student_initializer/domain/entities/markdown_from/markdown_form_entity.dart';
import 'package:student_initializer/util/exceptions/network_excpetion.dart';

abstract class MarkdownRepository {
  Future<Either<NetworkException, String>> generateMarkdownForm(
      {required int eventId, required int learnerId, String? length, required String endpoint});
  Future<Either<NetworkException, MarkdownFormEntity>> getMarkdownForm(
      {required int reportId});
  Future<Either<NetworkException, List<MarkdownFormEntity>>>
      getMarkdownFormsByLearnerAndEvent(
          {required int learnerId,
          int? eventId,
          String? sortBy,
          String? sortOrder,
          int? timespanInDays});
  Future<Either<NetworkException, MarkdownFormEntity>> updateMarkdownForm(
      {required int reportId, required String quality});
}
