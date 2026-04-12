import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mister_twister/core/routes/app_routes.dart';
import 'package:mister_twister/presentation/app.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mister_twister/service_locator.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final router = await AppRouter.createRouter();
  // await bootStrap();
  setupServiceLocator();
  runApp(MisterTwister(router: router));
}

Future<void> bootStrap() async {
  // env variables
  if (kDebugMode) {
    await dotenv.load(fileName: ".env.dev");
  } else {
    await dotenv.load(fileName: ".env");
  }
  // full screen
  // SystemChrome.setEnabledSystemUIMode(
  //   SystemUiMode.manual,
  //   overlays: [SystemUiOverlay.top],
  // );
}
