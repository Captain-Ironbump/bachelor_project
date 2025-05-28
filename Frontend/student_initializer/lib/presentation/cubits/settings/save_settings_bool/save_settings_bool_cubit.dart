import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:student_initializer/domain/usecases/settings/settings_usecases.dart';
import 'package:student_initializer/presentation/cubits/settings/save_settings_int/save_settings_int_cubit.dart';

part 'save_settings_bool_state.dart';

class SaveSettingsBoolCubit extends Cubit<SaveSettingsBoolState> {
  SaveSettingsBoolCubit(this._settingsUsecases)
      : super(const SaveSettingsBoolInit());

  Future<void> saveSettingsKeyValueBoolPair(
      {required String key, required bool value}) async {
    try {
      emit(const SaveSettingsBoolLoading());
      final result = await _settingsUsecases.saveSettingsKeyValueBooleanPair(
          key: key, value: value);
      result.fold((error) => emit(SaveSettingsBoolError(message: error.message)),
          (success) => emit(const SaveSettingsBoolSuccess()));
    } catch (_) {
      rethrow;
    }
  }

  final SettingsUsecases _settingsUsecases;
}