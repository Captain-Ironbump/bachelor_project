import 'package:fpdart/fpdart.dart';
import 'package:student_initializer/domain/entities/learner_detail/learner_detail_entity.dart';
import 'package:student_initializer/domain/repositories/learner/learner_repository.dart';
import 'package:student_initializer/util/exceptions/network_excpetion.dart';

class LearnerUsecases {
  final LearnerRepository _learnerRepository;

  const LearnerUsecases(this._learnerRepository);

  //* REMOTE
  /// This method gets Learner Details from the remote data source.
  Future<Either<NetworkException, LearnerDetailEntity>> getLearnerDetailById(
      {required int learnerId}) async {
    return _learnerRepository.getLearnerDetailById(learnerId: learnerId);
  }

  /// This method gets all Learner Details from the remote data source.
  Future<Either<NetworkException, List<LearnerDetailEntity>>>
      getAllLearnerDetails() async {
    return _learnerRepository.getAllLearnerDetails();
  }

  /// Save the Learner Details to the remote data source.
  Future<Either<NetworkException, void>> saveLearnerDetails(
      {required LearnerDetailEntity? learnerDetailEntity}) async {
    return _learnerRepository.saveLearnerDetails(
        learnerDetailEntity: learnerDetailEntity);
  }

  Future<Either<NetworkException, List<LearnerDetailEntity>>>
      getLearnersByEventId({required int eventId}) async {
    return _learnerRepository.getLearnersByEventId(eventId: eventId);
  }
}
