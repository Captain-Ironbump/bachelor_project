import 'package:fpdart/fpdart.dart';
import 'package:student_initializer/domain/entities/observation_count_detail/observation_count_detail_entity.dart';
import 'package:student_initializer/domain/entities/observation_detail/observation_detail_entity.dart';
import 'package:student_initializer/domain/entities/observation_detail_with_tags/observation_detail_with_tags_entity.dart';
import 'package:student_initializer/domain/entities/tag_detail/tag_detail_entity.dart';
import 'package:student_initializer/util/exceptions/network_excpetion.dart';
import 'package:student_initializer/data/models/observation_detail_with_tags/observation_detail_with_tags_model.dart';

abstract class ObservationRepository {
  //* Remote Data Source
  /// Retreives Observation Details from specified Learner Id
  Future<Either<NetworkException, List<ObservationDetailEntity>>>
      getObservationDetailsByLearnerId(
          {required int learnerId, required Map<String, dynamic> queryParams});

  /// Retrievs Observation Counts by query options
  Future<Either<NetworkException, Map<String, ObservationCountDetailEntity>>>
      getObservationCountWithQueries(
          {int? timespanByDays, List<int>? learner, int? eventId});

  /// Saves the Observation Details to the renote Database.
  Future<Either<NetworkException, void>> saveObservationDetails({
    required ObservationDetailEntity? observationDetailEntity,
    required List<TagDetailEntity> selectedTags, // Add selectedTags parameter
  });

  /// Retrieves Observation Detail by the specified Observation Id
  Future<Either<NetworkException, ObservationDetailEntity>>
      getObservationDetailById({required int observationId});

  Future<Either<NetworkException, List<ObservationDetailWithTagsEntity>>>
      getObservationsWithTagsByLearnerId({
    required int learnerId,
    required Map<String, dynamic> queryParams,
  });

  Future<Either<NetworkException, ObservationDetailWithTagsEntity>>
      getObservationWithTagsById({
    required int observationId,
  });

  Future<Either<NetworkException, void>> deleteObservationById({
    required int observationId,
  });
}
