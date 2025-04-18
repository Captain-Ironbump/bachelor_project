import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:student_initializer/domain/entities/learner_detail/learner_detail_entity.dart';
import 'package:student_initializer/domain/usecases/learner/learner_usecases.dart';

part 'save_learner_state.dart';

class SaveLearnerCubit extends Cubit<SaveLearnerState> {
  SaveLearnerCubit(this._learnerUsecases) : super(const SaveLearnerInitial());

  Future<void> saveLearnerDetail(
      {required String firstName, required String lastName}) async {
    try {
      if (state is! SaveLearnerLoaded) {
        emit(const SaveLearnerLoading());
      }
      final result = await _learnerUsecases.saveLearnerDetails(
          learnerDetailEntity:
              LearnerDetailEntity(firstName: firstName, lastName: lastName));

      result.fold((error) => emit(SaveLearnerError(message: error.message)),
          (success) => emit(const SaveLearnerLoaded()));
    } catch (_) {
      rethrow;
    }
  }

  final LearnerUsecases _learnerUsecases;
}
