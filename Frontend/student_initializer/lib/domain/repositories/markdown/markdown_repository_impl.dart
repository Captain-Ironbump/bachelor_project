import 'package:fpdart/fpdart.dart';
import 'package:student_initializer/data/datasources/remote/markdown/markdown_remote_data_source.dart';
import 'package:student_initializer/domain/entities/markdown_from/markdown_form_entity.dart';
import 'package:student_initializer/domain/repositories/markdown/markdown_repository.dart';
import 'package:student_initializer/util/exceptions/network_excpetion.dart';

class MarkdownRepositoryImpl implements MarkdownRepository {
  final MarkdownRemoteDataSource _markdownRemoteDataSource;

  MarkdownRepositoryImpl(this._markdownRemoteDataSource);

  @override
  Future<Either<NetworkException, String>> generateMarkdownForm(
      {required int eventId, required int learnerId, String? length}) async {
    try {
      final result = await _markdownRemoteDataSource.generateMarkdownForm(
          eventId: eventId, learnerId: learnerId, length: length);
      return Right(result);
    } on Exception catch (e) {
      return Left(NetworkException.fromHttpError(e));
    }
  }
  
  @override
  Future<Either<NetworkException, MarkdownFormEntity>> getMarkdownForm({required int reportId}) async {
    try {
      final result = await _markdownRemoteDataSource.getMarkdownForm(reportId: reportId);
      return Right(result.toEntity());
    } on Exception catch (e) {
      return Left(NetworkException.fromHttpError(e));
    }
  }
  
  @override
  Future<Either<NetworkException, List<MarkdownFormEntity>>> getMarkdownFormsByLearnerAndEvent({required int learnerId, int? eventId, String? sortBy, String? sortOrder, int? timespanInDays}) async {
    try {
      final result = await _markdownRemoteDataSource.getMarkdownFormsByLearnerAndEvent(
          learnerId: learnerId, eventId: eventId, sortBy: sortBy, sortOrder: sortOrder, timespanInDays: timespanInDays);
      return Right(result.map((e) => e.toEntity()).toList());
    } on Exception catch (e) {
      return Left(NetworkException.fromHttpError(e));
    }
  }
}
