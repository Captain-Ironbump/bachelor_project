import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:student_initializer/data_old/providers/count_map_provider.dart';
import 'package:student_initializer/data_old/providers/learner_provider.dart';
import 'package:student_initializer/data_old/providers/observation_provider.dart';
import 'app_animated.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // This app is designed only to work vertically, so we limit
  // orientations to portrait up and down.
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: CupertinoColors.transparent,
    systemNavigationBarColor: CupertinoColors.transparent,
  ));
  await dotenv.load();
  return runApp(
    const ProviderScope(
      child: MyCupertinoApp(),
      ),
  );
}
