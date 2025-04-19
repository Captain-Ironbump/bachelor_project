import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:student_initializer/data/datasources/locale/settings/settings_locale_data_source.dart';
import 'package:student_initializer/data/datasources/locale/settings/settings_locale_data_source_impl.dart';
import 'package:student_initializer/domain/repositories/settings/settings_repository.dart';
import 'package:student_initializer/domain/repositories/settings/settings_repository_impl.dart';
import 'package:student_initializer/domain/usecases/settings/settings_usecases.dart';
import 'package:student_initializer/presentation/cubits/settings/get_settings_int/get_settings_int_cubit.dart';
import 'package:student_initializer/presentation/cubits/settings/save_settings_int/save_settings_int_cubit.dart';

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

final saveSettingsIntCubitProvider = Provider.autoDispose<SaveSettingsIntCubit>((ref) {
  final settingsUsecases = ref.read(settingsUsecasesProvider);
  return SaveSettingsIntCubit(settingsUsecases);
});

final getSettingsIntCubitProvider = Provider.autoDispose<GetSettingsIntCubit>((ref) {
  return GetSettingsIntCubit(ref.read(settingsUsecasesProvider));
});