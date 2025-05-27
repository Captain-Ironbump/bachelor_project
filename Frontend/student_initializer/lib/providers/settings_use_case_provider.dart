import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:student_initializer/data/datasources/locale/settings/settings_locale_data_source.dart';
import 'package:student_initializer/data/datasources/locale/settings/settings_locale_data_source_impl.dart';
import 'package:student_initializer/domain/repositories/settings/settings_repository.dart';
import 'package:student_initializer/domain/repositories/settings/settings_repository_impl.dart';
import 'package:student_initializer/domain/usecases/settings/settings_usecases.dart';
import 'package:student_initializer/presentation/cubits/settings/get_settings_bool/get_settings_bool_cubit.dart';
import 'package:student_initializer/presentation/cubits/settings/get_settings_int/get_settings_int_cubit.dart';
import 'package:student_initializer/presentation/cubits/settings/get_settings_string/get_settings_string_cubit.dart';
import 'package:student_initializer/presentation/cubits/settings/save_settings_int/save_settings_int_cubit.dart';
import 'package:student_initializer/presentation/cubits/settings/save_settings_string/save_settings_string_cubit.dart';

final settingsUsecasesProvider = Provider<SettingsUsecases>((ref) {
  final settingsRepository = ref.read(settingsRepositoryProvider);
  return SettingsUsecases(settingsRepository);
});

final settingsRepositoryProvider = Provider<SettingsRepository>((ref) {
  final settingsLocaleDataSource = ref.read(settingsLocaleDataSourceProvider);
  return SettingsRepositoryImpl(settingsLocaleDataSource);
});

final settingsLocaleDataSourceProvider =
    Provider<SettingsLocaleDataSource>((ref) {
  return SettingsLocaleDataSourceImpl();
});

final saveSettingsIntCubitProvider =
    Provider.autoDispose<SaveSettingsIntCubit>((ref) {
  final settingsUsecases = ref.read(settingsUsecasesProvider);
  return SaveSettingsIntCubit(settingsUsecases);
});

final getSettingsIntCubitProvider =
    Provider.autoDispose<GetSettingsIntCubit>((ref) {
  return GetSettingsIntCubit(ref.read(settingsUsecasesProvider));
});

final saveSettingsStringCubitProvider =
    Provider.autoDispose<SaveSettingsStringCubit>((ref) {
  final settingsUsecases = ref.read(settingsUsecasesProvider);
  return SaveSettingsStringCubit(settingsUsecases);
});

class SortOrderCubit extends GetSettingsStringCubit {
  SortOrderCubit(super.settingsUsecases);
}

class SortParameterCubit extends GetSettingsStringCubit {
  SortParameterCubit(super.settingsUsecases);
}

class EventSortReasonCubit extends GetSettingsStringCubit {
  EventSortReasonCubit(super.settingsUsecases);
}

final getSettingsStringSortOrderCubitProvider =
    Provider.autoDispose<SortOrderCubit>((ref) {
  return SortOrderCubit(ref.read(settingsUsecasesProvider));
});

final getSettingsStringSortParameterCubitProvider =
    Provider.autoDispose<SortParameterCubit>((ref) {
  return SortParameterCubit(ref.read(settingsUsecasesProvider));
});

final getEventSettingsStringSortReasonCubitProvider =
    Provider.autoDispose<EventSortReasonCubit>((ref) {
  return EventSortReasonCubit(ref.read(settingsUsecasesProvider));
});

class EventWithLearnerCountCubit extends GetSettingsBoolCubit {
  EventWithLearnerCountCubit(super.settingsUsecases);
}

final getSettingsBoolWithLearnerCountCubitProvider =
    Provider.autoDispose<EventWithLearnerCountCubit>((ref) {
  return EventWithLearnerCountCubit(ref.read(settingsUsecasesProvider));
});

class LearnerSortByCubit extends GetSettingsStringCubit {
  LearnerSortByCubit(super.settingsUsecases);
}

final getSettingsStringLearnerSortByCubitProvider =
    Provider.autoDispose<LearnerSortByCubit>((ref) {
  return LearnerSortByCubit(ref.read(settingsUsecasesProvider));
});

class LearnerSortOrderCubit extends GetSettingsStringCubit {
  LearnerSortOrderCubit(super.settingsUsecases);
}

final getSettingsStringLearnerSortOrderCubitProvider =
    Provider.autoDispose<LearnerSortOrderCubit>((ref) {
  return LearnerSortOrderCubit(ref.read(settingsUsecasesProvider));
});