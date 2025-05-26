import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:student_initializer/domain/usecases/observation/observation_usecases.dart';

part 'delete_observation_state.dart';

class DeleteObservationCubit extends Cubit<DeleteObservationState> {
  DeleteObservationCubit(this._observationUsecases)
      : super(const DeleteObservationInitial());

  Future<void> deleteObservation({required int observationId}) async {
    try {
      emit(const DeleteObservationLoading());
      final result = await _observationUsecases.deleteObservationById(observationId: observationId);

      result.fold(
        (error) => emit(DeleteObservationError(message: error.message)),
        (success) => emit(const DeleteObservationSuccess()),
      );
    } catch (_) {
      rethrow;
    }
  }

  final ObservationUsecases _observationUsecases;
}