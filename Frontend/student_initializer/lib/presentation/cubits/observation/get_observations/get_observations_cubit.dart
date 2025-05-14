import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:student_initializer/domain/entities/observation_detail/observation_detail_entity.dart';
import 'package:student_initializer/domain/usecases/observation/observation_usecases.dart';

part 'get_observations_state.dart';

class GetObservationsCubit extends Cubit<GetObservationsState> {
  GetObservationsCubit(this._observationUsecases)
      : super(const GetObservationsInitial());

  Future<void> getObservationDetailsByLearnerId(
      {required int learnerId, required Map<String, dynamic> queryParams}) async {
    try {
      //if (state is! GetObservationsLoaded) {
      emit(const GetObservationsLoading());
      print("loading");
      //}
      final result = await _observationUsecases
          .getObservationDetailsByLearnerId(learnerId: learnerId, queryParams: queryParams);
      result.fold((error) => emit(GetObservationsError(message: error.message)),
          (success) {
        print("✅ Emitting GetObservationsLoaded with ${success.length} items");
        emit(GetObservationsLoaded(observations: List.from(success)));
      });
    } catch (_) {
      rethrow;
    }
  }

  final ObservationUsecases _observationUsecases;
}
