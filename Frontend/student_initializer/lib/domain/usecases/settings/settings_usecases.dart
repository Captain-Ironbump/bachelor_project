import 'package:fpdart/fpdart.dart';
import 'package:student_initializer/domain/repositories/settings/settings_repository.dart';
import 'package:student_initializer/util/exceptions/locale_storage_exception.dart';

class SettingsUsecases {
  final SettingsRepository _settingsRepository;

  const SettingsUsecases(this._settingsRepository);

  Future<Either<LocalStorageException, int>> getSettingsValueIntFromKey(
      {required String key}) async {
    return _settingsRepository.getSettingsValueIntFromKey(key: key);
  }

  Future<Either<LocalStorageException, void>> saveSettingsKeyValueIntPair(
      {required String key, required int value}) async {
    return _settingsRepository.saveSettingsKeyValueIntPair(
        key: key, value: value);
  }

  Future<Either<LocalStorageException, String>> getSettingsValueStringFromKey(
      {required String key}) async {
    return _settingsRepository.getSettingsValueStringFromKey(key: key);
  }

  Future<Either<LocalStorageException, void>> saveSettingsKeyValueStringPair(
      {required String key, required String value}) async {
    return _settingsRepository.saveSettingsKeyValueStringPair(
        key: key, value: value);
  }

  Future<Either<LocalStorageException, bool>> getSettingsValueBooleanFromKey(
      {required String key}) async {
    return _settingsRepository.getSettingsValueBooleanFromKey(key: key);
  }

  Future<Either<LocalStorageException, void>> saveSettingsKeyValueBooleanPair(
      {required String key, required bool value}) async {
    return _settingsRepository.saveSettingsKeyValueBooleanPair(
        key: key, value: value);
  }
}
