import 'package:fpdart/fpdart.dart';
import 'package:student_initializer/domain/entities/observation_count_detail/observation_count_detail_entity.dart';
import 'package:student_initializer/domain/entities/observation_detail/observation_detail_entity.dart';
import 'package:student_initializer/util/exceptions/network_excpetion.dart';

abstract class ObservationRepository {
  //* Remote Data Source
  /// Retreives Observation Details from specified Learner Id
  Future<Either<NetworkExcpetion, List<ObservationDetailEntity>>>
      getObservationDetailsByLearnerId({required int learnerId});

  /// Retrievs Observation Counts by query options
  Future<Either<NetworkExcpetion, Map<String, ObservationCountDetailEntity>>>
      getObservationCountWithQueries({int? timespanByDays, List<int>? learner});

  /// Saves the Observation Details to the renote Database.
  Future<Either<NetworkExcpetion, void>> saveObservationDetails(
      {required ObservationDetailEntity? observationDetailEntity});
}
