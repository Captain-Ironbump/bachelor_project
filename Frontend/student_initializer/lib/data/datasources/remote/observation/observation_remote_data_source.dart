import 'package:student_initializer/data/models/observation_count_detail/observation_count_detail_model.dart';
import 'package:student_initializer/data/models/observation_detail/observation_detail_model.dart';
import 'package:student_initializer/domain/entities/tag_detail/tag_detail_entity.dart';
import 'package:student_initializer/data/models/observation_detail_with_tags/observation_detail_with_tags_model.dart';

abstract class ObservationRemoteDataSource {
  Future<List<ObservationDetailModel>> getObservationsByLearnerId(
      {required int learnerId, required Map<String, dynamic> queryParams});

  Future<Map<String, ObservationCountDetailModel>> getCountMap(
      {int? timespanInDays, List<int>? learners, int? eventId});

  Future<void> saveObservation(
      {required int learnerId,
      required int eventId,
      required String observation,
      required List<TagDetailEntity> selectedTags});

  Future<ObservationDetailModel> getObservationDetailById(
      {required int observationId});

  Future<List<ObservationDetailWithTagsModel>>
      getObservationsWithTagsByLearnerId({
    required int learnerId,
    required Map<String, dynamic> queryParams,
  });

  Future<ObservationDetailWithTagsModel> getObservationWithTagsById({
    required int observationId,
  });

  Future<void> deleteObservationById({required int observationId});
}
