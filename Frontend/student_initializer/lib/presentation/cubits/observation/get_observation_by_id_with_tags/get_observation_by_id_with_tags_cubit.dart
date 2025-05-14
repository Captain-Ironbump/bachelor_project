import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:student_initializer/domain/entities/observation_detail/observation_detail_entity.dart';
import 'package:student_initializer/domain/usecases/observation/observation_usecases.dart';
import 'package:student_initializer/domain/entities/observation_detail_with_tags/observation_detail_with_tags_entity.dart';

part 'get_observation_by_id_with_tags_state.dart';

class GetObservationByIdWithTagsCubit extends Cubit<GetObservationDetailByIdWithTagsState> {
  GetObservationByIdWithTagsCubit(this._observationUsecases)
      : super(const GetObservationDetailByIdWithTagsInitial());

  Future<void> getObservationByIdWithTags({required int observationId}) async {
    try {
      emit(const GetObservationDetailByIdWithTagsLoading());
      final result = await _observationUsecases.getObservationWithTagsById(
          observationId: observationId);
      result.fold(
          (error) =>
              emit(GetObservationDetailByIdWithTagsError(message: error.message)),
          (success) {
        print(
            "✅ Emitting GetObservationDetailByIdWithTagsLoaded with ${success.toString()}");
        emit(GetObservationDetailByIdWithTagsLoaded(observation: success));
      });
    } catch (_) {
      rethrow;
    }
  }

  final ObservationUsecases _observationUsecases;
}
