import 'package:fpdart/fpdart.dart';
import 'package:student_initializer/domain/entities/learner_detail/learner_detail_entity.dart';
import 'package:student_initializer/util/exceptions/network_excpetion.dart';

abstract class LearnerRepository {
  //* Remote Data Source
  /// Retreives Learner Details from specified Id
  Future<Either<NetworkException, LearnerDetailEntity>> getLearnerDetailById(
      {required int learnerId});

  /// Retreives all Learner Details
  Future<Either<NetworkException, List<LearnerDetailEntity>>>
      getAllLearnerDetails();

  /// Saves the Learner Details to the remote Database
  Future<Either<NetworkException, void>> saveLearnerDetails(
      {required LearnerDetailEntity? learnerDetailEntity});

  Future<Either<NetworkException, List<LearnerDetailEntity>>>
      getLearnersByEventId({required int eventId, int? timespanInDays, String? sortBy, String? sortOrder});
}
