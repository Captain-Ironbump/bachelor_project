import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:student_initializer/domain/usecases/event/event_usecases.dart';

part 'add_learners_to_event_state.dart';

class AddLearnersToEventCubit extends Cubit<AddLearnersToEventState> {
  final EventUsecases _eventUsecases;

  AddLearnersToEventCubit(this._eventUsecases) : super(const AddLearnersToEventInitial());

  Future<void> addLearnersToEvent(int eventId, List<int> learnerIds) async {
    try {
      emit(const AddLearnersToEventLoading());
      final result = await _eventUsecases.addLearnersToEvent(eventId: eventId, learnerIds: learnerIds);
      result.fold(
        (error) => emit(AddLearnersToEventError(message: error.message)),
        (success) => emit(const AddLearnersToEventSuccess()),
      );
    } catch (_) {
      rethrow;
    }
  }
}