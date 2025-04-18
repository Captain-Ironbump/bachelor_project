import 'package:fpdart/fpdart.dart';
import 'package:student_initializer/data/datasources/remote/learner/learner_remote_data_source.dart';
import 'package:student_initializer/domain/entities/learner_detail/learner_detail_entity.dart';
import 'package:student_initializer/domain/repositories/learner/learner_repository.dart';
import 'package:student_initializer/util/exceptions/network_excpetion.dart';

class LearnerRepositoryImpl implements LearnerRepository {
  final LearnerRemoteDataSource _learnerRemoteDataSource;

  LearnerRepositoryImpl(this._learnerRemoteDataSource);

  @override
  Future<Either<NetworkExcpetion, List<LearnerDetailEntity>>>
      getAllLearnerDetails() async {
    try {
      late List<LearnerDetailEntity> data = [];
      final result = await _learnerRemoteDataSource.getAllLearners();
      for (var element in result) {
        data.add(element.toEntity());
      }
      return Right(data);
    } on Exception catch (e) {
      return Left(NetworkExcpetion.fromHttpError(e));
    }
  }

  @override
  Future<Either<NetworkExcpetion, LearnerDetailEntity>> getLearnerDetailById(
      {required int learnerId}) {
    // TODO: implement getLearnerDetailById
    throw UnimplementedError();
  }

  @override
  Future<Either<NetworkExcpetion, void>> saveLearnerDetails(
      {required LearnerDetailEntity? learnerDetailEntity}) async {
    try {
      await _learnerRemoteDataSource.saveLearnerDetails(
          firstName: learnerDetailEntity!.firstName!,
          lastName: learnerDetailEntity.lastName!);
      return const Right(null);
    } on Exception catch (e) {
      return Left(NetworkExcpetion.fromHttpError(e));
    }
  }
}
