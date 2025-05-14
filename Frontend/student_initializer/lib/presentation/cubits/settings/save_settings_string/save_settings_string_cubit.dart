import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:student_initializer/domain/usecases/settings/settings_usecases.dart';

part 'save_settings_string_state.dart';

class SaveSettingsStringCubit extends Cubit<SaveSettingsStringState> {
  SaveSettingsStringCubit(this._settingsUsecases)
      : super(const SaveSettingsStringInit());

  Future<void> saveSettingsKeyValueStringPair(
      {required String key, required String value}) async {
    try {
      emit(const SaveSettingsStringLoading());
      final result = await _settingsUsecases.saveSettingsKeyValueStringPair(
          key: key, value: value);
      result.fold((error) => emit(SaveSettingsStringError(message: error.message)),
          (success) => emit(const SaveSettingsStringSuccess()));
    } catch (_) {
      rethrow;
    }
  }

  final SettingsUsecases _settingsUsecases;
}