import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:student_initializer/domain/entities/observation_count_detail/observation_count_detail_entity.dart';
import 'package:student_initializer/domain/usecases/observation/observation_usecases.dart';

part 'get_observations_count_state.dart';

class GetObservationsCountCubit extends Cubit<GetObservationsCountState> {
  GetObservationsCountCubit(this._observationUsecases)
      : super(const GetObservationsCountInitial());

  Future<void> getObservationCountWithQueries(
      {int? timespanInDays, List<int>? learners, int? eventId}) async {
    try {
      if (state is! GetObservationsCountLoaded) {
        emit(const GetObservationsCountLoading());
      }
      final result = await _observationUsecases.getObserationCountWithQueries(
          timespanInDays: timespanInDays, learners: learners, eventId: eventId);
      result.fold(
          (error) => emit(GetObservationsCountError(message: error.message)),
          (success) {
        print("✅ Emitting GetObservationsCountLoaded with ${success.toString()}");
        emit(GetObservationsCountLoaded(countMap: success));
      });
    } catch (_) {
      rethrow;
    }
  }

  final ObservationUsecases _observationUsecases;
}
