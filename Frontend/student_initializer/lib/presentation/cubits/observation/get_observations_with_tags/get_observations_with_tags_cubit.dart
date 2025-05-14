import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:student_initializer/domain/entities/observation_detail/observation_detail_entity.dart';
import 'package:student_initializer/domain/entities/observation_detail_with_tags/observation_detail_with_tags_entity.dart';
import 'package:student_initializer/domain/usecases/observation/observation_usecases.dart';

part 'get_observations_with_tags_state.dart';

class GetObservationsWithTagsCubit extends Cubit<GetObservationsWithTagsState> {
  GetObservationsWithTagsCubit(this._observationUsecases)
      : super(const GetObservationsWithTagsInitial());

  Future<void> getObservationDetailsByLearnerId(
      {required int learnerId, required Map<String, dynamic> queryParams}) async {
    try {
      //if (state is! GetObservationsLoaded) {
      emit(const GetObservationsWithTagsLoading());
      print("loading");
      //}
      final result = await _observationUsecases
          .getObservationsWithTagsByLearnerId(learnerId: learnerId, queryParams: queryParams);
      result.fold((error) => emit(GetObservationsWithTagsError(message: error.message)),
          (success) {
        print("✅ Emitting GetObservationsWithTagsLoaded with ${success.length} items");
        emit(GetObservationsWithTagsLoaded(observations: List.from(success)));
      });
    } catch (_) {
      rethrow;
    }
  }

  final ObservationUsecases _observationUsecases;
}
