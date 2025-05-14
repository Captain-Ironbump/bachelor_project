abstract class SettingsLocaleDataSource {
  Future<void> saveKeyValueStringPair(
      {required String key, required String value});
  Future<String> getValueStringFromKey({required String key});
  Future<int> getValueIntFromKey({required String key});
  Future<void> saveKeyValueIntPair({required String key, required int value});
  Future<void> saveKeyValueBooleanPair(
      {required String key, required bool value});
  Future<bool> getValueBooleanFromKey({required String key});
}
