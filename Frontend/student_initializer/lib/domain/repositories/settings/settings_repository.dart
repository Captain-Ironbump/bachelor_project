import 'package:fpdart/fpdart.dart';
import 'package:student_initializer/util/exceptions/locale_storage_exception.dart';

abstract class SettingsRepository {
  //* Locale Data Source
  Future<Either<LocalStorageException, String>> getSettingsValueStringFromKey(
      {required String key});
  Future<Either<LocalStorageException, int>> getSettingsValueIntFromKey(
      {required String key});
  Future<Either<LocalStorageException, void>> saveSettingsKeyValueStringPair(
      {required String key, required String value});
  Future<Either<LocalStorageException, void>> saveSettingsKeyValueIntPair(
      {required String key, required int value});
}
