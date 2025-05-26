import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:student_initializer/domain/usecases/event/event_usecases.dart';

part 'save_event_state.dart';

class SaveEventCubit extends Cubit<SaveEventState> {
  final EventUsecases _eventUsecases;

  SaveEventCubit(this._eventUsecases) : super(const SaveEventInitial());

  Future<void> saveEvent({required String name}) async {
    try {
      emit(const SaveEventLoading());
      final result = await _eventUsecases.saveEvent(name: name);
      result.fold(
        (error) => emit(SaveEventError(message: error.message)),
        (success) => emit(const SaveEventSuccess()),
      );
    } catch (_) {
      rethrow;
    }
  }
}