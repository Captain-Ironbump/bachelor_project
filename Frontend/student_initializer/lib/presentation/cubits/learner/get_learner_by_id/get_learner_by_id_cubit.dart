import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:student_initializer/domain/entities/learner_detail/learner_detail_entity.dart';
import 'package:student_initializer/domain/usecases/learner/learner_usecases.dart';

part 'get_learner_by_id_state.dart';

class GetLearnerByIdCubit extends Cubit<GetLearnerByIdState> {
  GetLearnerByIdCubit(this._learnerUsecases)
      : super(const GetLearnerByIdInitial());

  Future<void> getLearnerDetailsById({required int learnerId}) async {
    try {
      emit(const GetLearnerByIdLoading());
      final result =
          await _learnerUsecases.getLearnerDetailById(learnerId: learnerId);
      result.fold((error) => emit(GetLearnerByIdError(message: error.message)),
          (success) => emit(GetLearnerByIdLoaded(learner: success)));
    } catch (_) {
      rethrow;
    }
  }

  final LearnerUsecases _learnerUsecases;
}
