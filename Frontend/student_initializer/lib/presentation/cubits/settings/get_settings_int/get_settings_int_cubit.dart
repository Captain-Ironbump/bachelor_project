import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:student_initializer/domain/usecases/settings/settings_usecases.dart';

part 'get_settings_int_state.dart';

class GetSettingsIntCubit extends Cubit<GetSettingsIntState> {
  GetSettingsIntCubit(this._settingsUsecases)
      : super(const GetSettingsIntInit());

  Future<void> getSettingsValueByKey({required String key}) async {
    try {
      emit(const GetSettingsIntLoading());

      final result =
          await _settingsUsecases.getSettingsValueIntFromKey(key: key);
      result.fold((error) => emit(GetSettingsIntError(message: error.message)),
          (success) => emit(GetSettingsIntLoaded(value: success)));
    } catch (_) {
      rethrow;
    }
  }

  final SettingsUsecases _settingsUsecases;
}
