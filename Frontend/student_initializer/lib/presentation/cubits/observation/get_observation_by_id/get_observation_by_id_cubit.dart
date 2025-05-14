import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:student_initializer/domain/entities/observation_detail/observation_detail_entity.dart';
import 'package:student_initializer/domain/usecases/observation/observation_usecases.dart';

part 'get_observation_by_id_state.dart';

class GetObservationByIdCubit extends Cubit<GetObservationDetailByIdState> {
  GetObservationByIdCubit(this._observationUsecases)
      : super(const GetObservationDetailByIdInitial());

  Future<void> getObservationById({required int observationId}) async {
    try {
      emit(const GetObservationDetailByIdLoading());
      final result = await _observationUsecases.getObservationDetailById(
          observationId: observationId);
      result.fold(
          (error) =>
              emit(GetObservationDetailByIdError(message: error.message)),
          (success) {
        print(
            "✅ Emitting GetObservationDetailByIdLoaded with ${success.toString()}");
        emit(GetObservationDetailByIdLoaded(observation: success));
      });
    } catch (_) {
      rethrow;
    }
  }

  final ObservationUsecases _observationUsecases;
}
