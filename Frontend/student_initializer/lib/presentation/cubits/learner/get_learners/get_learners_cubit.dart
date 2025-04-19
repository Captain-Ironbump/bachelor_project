import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:student_initializer/domain/entities/learner_detail/learner_detail_entity.dart';
import 'package:student_initializer/domain/usecases/learner/learner_usecases.dart';

part 'get_learners_state.dart';

class GetLearnersCubit extends Cubit<GetLearnersState> {
  GetLearnersCubit(this._learnerUsecases) : super(const GetLearnersInitial());

  Future<void> getAllLearnerDetails() async {
    try {
      //if (state is! GetLearnersLoaded) {
      emit(const GetLearnersLoading());
      //}
      final result = await _learnerUsecases.getAllLearnerDetails();
      result.fold((error) => emit(GetLearnersError(message: error.message)),
          (success) => emit(GetLearnersLoaded(learners: success)));
    } catch (_) {
      rethrow;
    }
  }

  final LearnerUsecases _learnerUsecases;
}
