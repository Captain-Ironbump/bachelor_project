import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:student_initializer/domain/entities/observation_detail/observation_detail_entity.dart';
import 'package:student_initializer/domain/usecases/observation/observation_usecases.dart';

part 'get_observations_state.dart';

class GetObservationsCubit extends Cubit<GetObservationsState> {
  GetObservationsCubit(this._observationUsecases)
      : super(const GetObservationsInitial());

  Future<void> getObservationDetailsByLearnerId(
      {required int learnerId}) async {
    try {
      if (state is! GetObservationsLoaded) {
        emit(const GetObservationsLoading());
      }
      final result = await _observationUsecases
          .getObservationDetailsByLearnerId(learnerId: learnerId);
      result.fold((error) => emit(GetObservationsError(message: error.message)),
          (success) => emit(GetObservationsLoaded(observations: success)));
    } catch (_) {
      rethrow;
    }
  }

  final ObservationUsecases _observationUsecases;
}
