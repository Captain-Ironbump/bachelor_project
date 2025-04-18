import 'package:student_initializer/data/models/observation_count_detail/observation_count_detail_model.dart';
import 'package:student_initializer/data/models/observation_detail/observation_detail_model.dart';

abstract class ObservationRemoteDataSource {
  Future<List<ObservationDetailModel>> getObservationsByLearnerId({required int learnerId});

  Future<Map<String, ObservationCountDetailModel>> getCountMap({int? timespanInDays, List<int>? learners});

  Future<void> saveObservation({required int learnerId, required String observation});
}
