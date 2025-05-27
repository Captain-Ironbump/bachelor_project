import 'package:fpdart/fpdart.dart';
import 'package:student_initializer/data/datasources/remote/learner/learner_remote_data_source.dart';
import 'package:student_initializer/domain/entities/learner_detail/learner_detail_entity.dart';
import 'package:student_initializer/domain/repositories/learner/learner_repository.dart';
import 'package:student_initializer/util/exceptions/network_excpetion.dart';

class LearnerRepositoryImpl implements LearnerRepository {
  final LearnerRemoteDataSource _learnerRemoteDataSource;

  LearnerRepositoryImpl(this._learnerRemoteDataSource);

  @override
  Future<Either<NetworkException, List<LearnerDetailEntity>>>
      getAllLearnerDetails() async {
    try {
      late List<LearnerDetailEntity> data = [];
      final result = await _learnerRemoteDataSource.getAllLearners();
      for (var element in result) {
        data.add(element.toEntity());
      }
      return Right(data);
    } on Exception catch (e) {
      return Left(NetworkException.fromHttpError(e));
    }
  }

  @override
  Future<Either<NetworkException, LearnerDetailEntity>> getLearnerDetailById(
      {required int learnerId}) async {
    try {
      final result =
          await _learnerRemoteDataSource.getLearnerById(learnerId: learnerId);
      return Right(result.toEntity());
    } on Exception catch (e) {
      return Left(NetworkException.fromHttpError(e));
    }
  }

  @override
  Future<Either<NetworkException, void>> saveLearnerDetails(
      {required LearnerDetailEntity? learnerDetailEntity}) async {
    try {
      await _learnerRemoteDataSource.saveLearnerDetails(
          firstName: learnerDetailEntity!.firstName!,
          lastName: learnerDetailEntity.lastName!);
      return const Right(null);
    } on Exception catch (e) {
      return Left(NetworkException.fromHttpError(e));
    }
  }

  @override
  Future<Either<NetworkException, List<LearnerDetailEntity>>>
      getLearnersByEventId({required int eventId, int? timespanInDays, String? sortBy, String? sortOrder}) async {
    try {
      late List<LearnerDetailEntity> data = [];
      final result =
          await _learnerRemoteDataSource.getLearnersByEventId(eventId: eventId, 
              timespanInDays: timespanInDays, sortBy: sortBy, sortOrder: sortOrder);
      for (var element in result) {
        data.add(element.toEntity());
      }
      return Right(data);
    } on Exception catch (e) {
      return Left(NetworkException.fromHttpError(e));
    }
  }
}
