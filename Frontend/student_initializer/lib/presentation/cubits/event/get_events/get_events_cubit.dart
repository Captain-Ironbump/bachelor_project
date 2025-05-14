import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:student_initializer/domain/entities/event_detail/event_detail_entity.dart';
import 'package:student_initializer/domain/usecases/event/event_usecases.dart';

part 'get_events_state.dart';

class GetEventsCubit extends Cubit<GetEventsState> {
  GetEventsCubit(this._eventUsecases) : super(const GetEventsInitial());

  Future<void> getAllEvents({Map<String, dynamic>? queryParameter}) async {
    try {
      emit(const GetEventsLoading());
      final result = await _eventUsecases.fetchAllEvents(queryParameter: queryParameter);
      result.fold((error) => emit(GetEventsError(message: error.message)),
          (success) {
        print("✅ Emitting GetEventsLoaded with ${success.length} items");
        emit(GetEventsLoaded(events: success));
      });
    } catch (_) {
      rethrow;
    }
  }

  final EventUsecases _eventUsecases;
}
