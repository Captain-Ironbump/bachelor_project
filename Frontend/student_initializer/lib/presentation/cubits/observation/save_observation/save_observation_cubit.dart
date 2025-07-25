import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:student_initializer/domain/entities/observation_detail/observation_detail_entity.dart';
import 'package:student_initializer/domain/entities/tag_detail/tag_detail_entity.dart';
import 'package:student_initializer/domain/usecases/observation/observation_usecases.dart';

part 'save_observation_state.dart';

class SaveObservationCubit extends Cubit<SaveObservationState> {
  SaveObservationCubit(this._observationUsecases)
      : super(const SaveObservationInitial());

  Future<void> saveObservation({
    required ObservationDetailEntity? observationDetailEntity,
    required List<TagDetailEntity> selectedTags, // Add selectedTags parameter
  }) async {
    try {
      emit(const SaveObservationLoading());
      final result = await _observationUsecases.saveObservationDetail(
        observationDetailEntity: observationDetailEntity,
        selectedTags: selectedTags, // Pass selectedTags to use case
      );

      result.fold(
        (error) => emit(SaveObservationError(message: error.message)),
        (_) => emit(const SaveObservationSuccess()),
      );
    } catch (_) {
      rethrow;
    }
  }

  final ObservationUsecases _observationUsecases;
}
