import 'package:student_initializer/data/models/learner_detail/learner_detail_model.dart';

abstract class LearnerRemoteDataSource {
  Future<LearnerDetailModel> getLearnerById({required int learnerId});

  Future<List<LearnerDetailModel>> getAllLearners();

  Future<void> saveLearnerDetails(
      {required String firstName, required String lastName});

  Future<List<LearnerDetailModel>> getLearnersByEventId({required int eventId, int? timespanInDays, String? sortBy, String? sortOrder});
}
