import 'package:shared_preferences/shared_preferences.dart';

Future<void> initializeDefaults() async {
  final prefs = await SharedPreferences.getInstance();

  if (!prefs.containsKey('timespanInDays')) {
    await prefs.setInt('timespanInDays', 0);
  }

  if (!prefs.containsKey('sortOrder')) {
    await prefs.setString('sortOrder', 'DESC');
  }

  if (!prefs.containsKey('sortParameter')) {
    await prefs.setString('sortParameter', 'createdDateTime');
  }

  if (!prefs.containsKey('withLearnerCount')) {
    await prefs.setBool('withLearnerCount', true);
  }

  if (!prefs.containsKey('eventSortReason')) {
    await prefs.setString('eventSortReason', 'alpabeticASC');
  }

  if (!prefs.containsKey('learnerSortBy')) {
    await prefs.setString('learnerSortBy', 'lastname');
  }

  if (!prefs.containsKey('learnerSortOrder')) {
    await prefs.setString('learnerSortOrder', 'ASC');
  }

  if (!prefs.containsKey('markdownUsedEndpoint')) {
    await prefs.setString('markdownUsedEndpoint', 'Standard');
  }
}
