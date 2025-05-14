import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:student_initializer/domain/usecases/settings/settings_usecases.dart';

part 'get_settings_bool_state.dart';

class GetSettingsBoolCubit extends Cubit<GetSettingsBoolState> {
  GetSettingsBoolCubit(this._settingsUsecases)
      : super(const GetSettingsBoolInit());

  Future<void> getSettingsValueByKey({required String key}) async {
    try {
      emit(const GetSettingsBoolLoading());

      final result =
          await _settingsUsecases.getSettingsValueBooleanFromKey(key: key);
      result.fold((error) => emit(GetSettingsBoolError(message: error.message)),
          (success) => emit(GetSettingsBoolLoaded(value: success)));
    } catch (_) {
      rethrow;
    }
  }

  final SettingsUsecases _settingsUsecases;
}