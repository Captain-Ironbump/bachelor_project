import 'package:fpdart/fpdart.dart';
import 'package:student_initializer/data/datasources/remote/markdown/markdown_remote_data_source.dart';
import 'package:student_initializer/domain/entities/markdown_from/markdown_form_entity.dart';
import 'package:student_initializer/domain/repositories/markdown/markdown_repository.dart';
import 'package:student_initializer/util/exceptions/network_excpetion.dart';

class MarkdownRepositoryImpl implements MarkdownRepository {
  final MarkdownRemoteDataSource _markdownRemoteDataSource;

  MarkdownRepositoryImpl(this._markdownRemoteDataSource);

  @override
  Future<Either<NetworkException, MarkdownFormEntity>> generateMarkdownForm(
      {required int eventId, required int learnerId, String? length}) async {
    try {
      final result = await _markdownRemoteDataSource.generateMarkdownForm(
          eventId: eventId, learnerId: learnerId, length: length);
      return Right(result.toEntity());
    } on Exception catch (e) {
      return Left(NetworkException.fromHttpError(e));
    }
  }
}
