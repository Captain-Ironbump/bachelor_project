
import 'package:fpdart/fpdart.dart';
import 'package:student_initializer/data/datasources/locale/settings/settings_locale_data_source.dart';
import 'package:student_initializer/domain/repositories/settings/settings_repository.dart';
import 'package:student_initializer/util/exceptions/locale_storage_exception.dart';

class SettingsRepositoryImpl implements SettingsRepository {
  final SettingsLocaleDataSource _settingsLocaleDataSource;

  SettingsRepositoryImpl(this._settingsLocaleDataSource);

  @override
  Future<Either<LocalStorageException, int>> getSettingsValueIntFromKey(
      {required String key}) async {
    try {
      final result =
          await _settingsLocaleDataSource.getValueIntFromKey(key: key);
      return Right(result);
    } on Exception catch (e) {
      return Left(LocalStorageException.fromError(e));
    }
  }

  @override
  Future<Either<LocalStorageException, String>> getSettingsValueStringFromKey(
      {required String key}) async {
    try {
      final result =
          await _settingsLocaleDataSource.getValueStringFromKey(key: key);
      return Right(result);
    } on Exception catch (e) {
      return Left(LocalStorageException.fromError(e));
    }
  }

  @override
  Future<Either<LocalStorageException, void>> saveSettingsKeyValueIntPair(
      {required String key, required int value}) async {
    try {
      await _settingsLocaleDataSource.saveKeyValueIntPair(
          key: key, value: value);
      return const Right(null);
    } on Exception catch (e) {
      return Left(LocalStorageException.fromError(e));
    }
  }

  @override
  Future<Either<LocalStorageException, void>> saveSettingsKeyValueStringPair(
      {required String key, required String value}) async {
    try {
      await _settingsLocaleDataSource.saveKeyValueStringPair(
          key: key, value: value);
      return const Right(null);
    } on Exception catch (e) {
      return Left(LocalStorageException.fromError(e));
    }
  }
  
  @override
  Future<Either<LocalStorageException, bool>> getSettingsValueBooleanFromKey({required String key}) async {
    try {
      final result =
          await _settingsLocaleDataSource.getValueBooleanFromKey(key: key);
      return Right(result);
    } on Exception catch (e) {
      return Left(LocalStorageException.fromError(e));
    }
  }
  
  @override
  Future<Either<LocalStorageException, void>> saveSettingsKeyValueBooleanPair({required String key, required bool value}) async {
    try {
      await _settingsLocaleDataSource.saveKeyValueBooleanPair(
          key: key, value: value);
      return const Right(null);
    } on Exception catch (e) {
      return Left(LocalStorageException.fromError(e));
    }
  }
}
