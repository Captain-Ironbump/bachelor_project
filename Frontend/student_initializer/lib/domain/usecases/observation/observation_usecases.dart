import 'package:fpdart/fpdart.dart';
import 'package:student_initializer/domain/entities/observation_count_detail/observation_count_detail_entity.dart';
import 'package:student_initializer/domain/entities/observation_detail/observation_detail_entity.dart';
import 'package:student_initializer/domain/repositories/observation/observation_repository.dart';
import 'package:student_initializer/util/exceptions/network_excpetion.dart';

class ObservationUsecases {
  final ObservationRepository _observationRepository;

  const ObservationUsecases(this._observationRepository);

  //* REMOTE
  Future<Either<NetworkExcpetion, List<ObservationDetailEntity>>>
      getObservationDetailsByLearnerId({required int learnerId}) async {
    return _observationRepository.getObservationDetailsByLearnerId(
        learnerId: learnerId);
  }

  Future<Either<NetworkExcpetion, Map<String, ObservationCountDetailEntity>>>
      getObserationCountWithQueries(
          {int? timespanInDays, List<int>? learners}) async {
    return _observationRepository.getObservationCountWithQueries(
        timespanByDays: timespanInDays, learner: learners);
  }

  Future<Either<NetworkExcpetion, void>> saveObservationDetail(
      {required ObservationDetailEntity? observationDetailEntity}) async {
    return _observationRepository.saveObservationDetails(
        observationDetailEntity: observationDetailEntity);
  }
}
