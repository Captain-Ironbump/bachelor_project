import 'package:fpdart/fpdart.dart';
import 'package:student_initializer/domain/entities/observation_count_detail/observation_count_detail_entity.dart';
import 'package:student_initializer/domain/entities/observation_detail/observation_detail_entity.dart';
import 'package:student_initializer/domain/entities/observation_detail_with_tags/observation_detail_with_tags_entity.dart';
import 'package:student_initializer/domain/entities/tag_detail/tag_detail_entity.dart';
import 'package:student_initializer/domain/repositories/observation/observation_repository.dart';
import 'package:student_initializer/util/exceptions/network_excpetion.dart';
import 'package:student_initializer/data/models/observation_detail_with_tags/observation_detail_with_tags_model.dart';

class ObservationUsecases {
  final ObservationRepository _observationRepository;

  const ObservationUsecases(this._observationRepository);

  //* REMOTE
  Future<Either<NetworkException, List<ObservationDetailEntity>>>
      getObservationDetailsByLearnerId(
          {required int learnerId,
          required Map<String, dynamic> queryParams}) async {
    return _observationRepository.getObservationDetailsByLearnerId(
        learnerId: learnerId, queryParams: queryParams);
  }

  Future<Either<NetworkException, Map<String, ObservationCountDetailEntity>>>
      getObserationCountWithQueries(
          {int? timespanInDays, List<int>? learners, int? eventId}) async {
    return _observationRepository.getObservationCountWithQueries(
        timespanByDays: timespanInDays, learner: learners, eventId: eventId);
  }

  Future<Either<NetworkException, void>> saveObservationDetail({
    required ObservationDetailEntity? observationDetailEntity,
    required List<TagDetailEntity> selectedTags, // Add selectedTags parameter
  }) async {
    return _observationRepository.saveObservationDetails(
      observationDetailEntity: observationDetailEntity,
      selectedTags: selectedTags, // Pass selectedTags to repository
    );
  }

  Future<Either<NetworkException, ObservationDetailEntity>>
      getObservationDetailById({required int observationId}) async {
    return _observationRepository.getObservationDetailById(
        observationId: observationId);
  }

  Future<Either<NetworkException, List<ObservationDetailWithTagsEntity>>>
      getObservationsWithTagsByLearnerId({
    required int learnerId,
    required Map<String, dynamic> queryParams,
  }) async {
    return _observationRepository.getObservationsWithTagsByLearnerId(
        learnerId: learnerId, queryParams: queryParams);
  }

  Future<Either<NetworkException, ObservationDetailWithTagsEntity>>
      getObservationWithTagsById({
    required int observationId,
  }) async {
    return _observationRepository.getObservationWithTagsById(
        observationId: observationId);
  }
}
