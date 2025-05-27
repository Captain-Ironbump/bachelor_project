import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:student_initializer/domain/entities/learner_detail/learner_detail_entity.dart';
import 'package:student_initializer/domain/usecases/learner/learner_usecases.dart';

part 'get_learners_by_event_id_state.dart';

class GetLearnersByEventIdCubit extends Cubit<GetLearnersByEventIdState> {
  GetLearnersByEventIdCubit(this._learnerUsecases)
      : super(const GetLearnersByEventIdInitial());

  Future<void> getLearnersByEventId(
      {required int eventId,
      int? timespanInDays,
      String? sortBy,
      String? sortOrder}) async {
    try {
      emit(const GetLearnersByEventIdLoading());
      final result = await _learnerUsecases.getLearnersByEventId(
          eventId: eventId,
          timespanInDays: timespanInDays,
          sortBy: sortBy,
          sortOrder: sortOrder);
      result.fold(
          (error) => emit(GetLearnersByEventIdError(message: error.message)),
          (success) {
        print("✅ Emitting GetLearnersByEventIdLoaded with $success items");
        emit(GetLearnersByEventIdLoaded(learners: success));
      });
    } catch (_) {
      rethrow;
    }
  }

  final LearnerUsecases _learnerUsecases;
}
