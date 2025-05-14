import 'package:shared_preferences/shared_preferences.dart';
import 'package:student_initializer/data/datasources/locale/settings/settings_locale_data_source.dart';

class SettingsLocaleDataSourceImpl implements SettingsLocaleDataSource {
  @override
  Future<String> getValueStringFromKey({required String key}) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final value = prefs.getString(key);
      return value!;
    } catch (_) {
      rethrow;
    }
  }

  @override
  Future<void> saveKeyValueStringPair(
      {required String key, required String value}) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(key, value);
    } catch (_) {
      rethrow;
    }
  }

  @override
  Future<int> getValueIntFromKey({required String key}) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final value = prefs.getInt(key);
      return value!;
    } catch (_) {
      rethrow;
    }
  }

  @override
  Future<void> saveKeyValueIntPair(
      {required String key, required int value}) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(key, value);
    } catch (_) {
      rethrow;
    }
  }

  @override
  Future<bool> getValueBooleanFromKey({required String key}) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final value = prefs.getBool(key);
      return value!;
    } catch (_) {
      rethrow;
    }
  }

  @override
  Future<void> saveKeyValueBooleanPair(
      {required String key, required bool value}) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(key, value);
    } catch (_) {
      rethrow;
    }
  }
}
