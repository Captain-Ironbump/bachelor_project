import 'package:shared_preferences/shared_preferences.dart';

Future<void> initializeDefaults() async {
  final prefs = await SharedPreferences.getInstance();

  if (!prefs.containsKey('timespanInDays')) {
    await prefs.setInt('timespanInDays', 0);
  }
}