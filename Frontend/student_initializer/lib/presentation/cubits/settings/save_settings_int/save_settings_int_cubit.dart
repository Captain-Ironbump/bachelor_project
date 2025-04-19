import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:student_initializer/domain/usecases/settings/settings_usecases.dart';

part 'save_settings_int_state.dart';

class SaveSettingsIntCubit extends Cubit<SaveSettingsIntState> {
  SaveSettingsIntCubit(this._settingsUsecases)
      : super(const SaveSettingsIntInit());

  Future<void> saveSettingsKeyValueIntPair(
      {required String key, required int value}) async {
    try {
      emit(const SaveSettingsIntLoading());
      final result = await _settingsUsecases.saveSettingsKeyValueIntPair(
          key: key, value: value);
      result.fold((error) => emit(SaveSettingsIntError(message: error.message)),
          (success) => emit(const SaveSettingsIntSuccess()));
    } catch (_) {
      rethrow;
    }
  }

  final SettingsUsecases _settingsUsecases;
}
