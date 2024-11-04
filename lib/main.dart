import 'package:Remeet/features/authentication/screens/login/login.dart';
import 'package:Remeet/features/authentication/service/navigationService.dart';
import 'package:Remeet/features/richatt/screens/home/widgets/AppointmentPage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:Remeet/app.dart';
import 'package:Remeet/data/repositories/authentication_repository.dart';
import 'package:Remeet/firebase_options.dart';
import 'package:Remeet/notification/notification.dart';
import 'package:timezone/data/latest.dart' as tz;

Future<void> main() async {
//Widget Binding
  final WidgetsBinding widgetsBinding =
      WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

// local storage
  await GetStorage.init();
  await NotificationService.init();

  tz.initializeTimeZones();

//await splach intul other items load
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  Get.put(AuthenticationRepository());
  Get.put(NavigationService());

  runApp(const App());
}
