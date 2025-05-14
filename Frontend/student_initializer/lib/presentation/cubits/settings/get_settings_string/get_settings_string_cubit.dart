import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:student_initializer/domain/usecases/settings/settings_usecases.dart';

part 'get_settings_string_state.dart';

class GetSettingsStringCubit extends Cubit<GetSettingsStringState> {
  GetSettingsStringCubit(this._settingsUsecases)
      : super(const GetSettingsStringInit());

  Future<void> getSettingsValueByKey({required String key}) async {
    try {
      emit(const GetSettingsStringLoading());

      final result =
          await _settingsUsecases.getSettingsValueStringFromKey(key: key);
      result.fold((error) => emit(GetSettingsStringError(message: error.message)),
          (success) => emit(GetSettingsStringLoaded(value: success)));
    } catch (_) {
      rethrow;
    }
  }

  final SettingsUsecases _settingsUsecases;
}