import 'package:fpdart/fpdart.dart';
import 'package:student_initializer/domain/entities/learner_detail/learner_detail_entity.dart';
import 'package:student_initializer/domain/repositories/learner/learner_repository.dart';
import 'package:student_initializer/util/exceptions/network_excpetion.dart';

class LearnerUsecases {
  final LearnerRepository _learnerRepository;

  const LearnerUsecases(this._learnerRepository);

  //* REMOTE
  /// This method gets Learner Details from the remote data source.
  Future<Either<NetworkExcpetion, LearnerDetailEntity>> getLearnerDetailById(
      {required int learnerId}) async {
    return _learnerRepository.getLearnerDetailById(learnerId: learnerId);
  }

  /// This method gets all Learner Details from the remote data source.
  Future<Either<NetworkExcpetion, List<LearnerDetailEntity>>>
      getAllLearnerDetails() async {
    return _learnerRepository.getAllLearnerDetails();
  }

  /// Save the Learner Details to the remote data source.
  Future<Either<NetworkExcpetion, void>> saveLearnerDetails(
      {required LearnerDetailEntity? learnerDetailEntity}) async {
    return _learnerRepository.saveLearnerDetails(
        learnerDetailEntity: learnerDetailEntity);
  }
}
