import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:richatt_mobile_rimeet/app.dart';
import 'package:richatt_mobile_rimeet/data/repositories/authentication_repository.dart';
import 'package:richatt_mobile_rimeet/notification/notification.dart';
import 'package:timezone/data/latest.dart' as tz;

Future<void> main() async {
//Widget Binding
  final WidgetsBinding widgetsBinding =
      WidgetsFlutterBinding.ensureInitialized();

// local storage
  await GetStorage.init();
  await NotificationService.init();
  tz.initializeTimeZones();

//await splach intul other items load
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  Get.put(AuthenticationRepository());

  runApp(const App());
}
