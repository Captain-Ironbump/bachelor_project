import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'app_animated.dart';

void main() async {
  // This app is designed only to work vertically, so we limit
  // orientations to portrait up and down.
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: CupertinoColors.transparent,
      systemNavigationBarColor: CupertinoColors.transparent,
  ));

  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load();
  return runApp(const MyCupertinoApp());
}