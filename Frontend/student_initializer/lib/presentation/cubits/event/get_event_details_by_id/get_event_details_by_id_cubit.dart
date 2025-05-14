import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:student_initializer/domain/entities/event_detail/event_detail_entity.dart';
import 'package:student_initializer/domain/usecases/event/event_usecases.dart';

part 'get_event_details_by_id_state.dart';

class GetEventDetailsByIdCubit extends Cubit<GetEventDetailsByIdState> {
  GetEventDetailsByIdCubit(this._eventUsecases)
      : super(const GetEventDetailsByIdInitial());

  Future<void> getEventDetailsById({required int? eventId}) async {
    try {
      emit(const GetEventDetailsByIdLoading());
      final result =
          await _eventUsecases.fetchEventDetailsById(eventId: eventId);
      result.fold(
          (error) => emit(GetEventDetailsByIdError(message: error.message)),
          (success) {
        print("✅ Emitting GetEventDetailsByIdLoaded");
        emit(GetEventDetailsByIdLoaded(event: success));
      });
    } catch (_) {
      rethrow;
    }
  }

  final EventUsecases _eventUsecases;
}
