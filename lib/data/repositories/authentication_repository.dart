import 'package:flutter/foundation.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:richatt_mobile_rimeet/features/authentication/screens/login/login.dart';
import 'package:richatt_mobile_rimeet/features/authentication/screens/onboarding/onboarding.dart';
import 'package:richatt_mobile_rimeet/navigation_menu.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthenticationRepository extends GetxController {
  static AuthenticationRepository get instance => Get.find();

  final deviseStorage = GetStorage();
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  @override
  void onReady() {
    FlutterNativeSplash.remove();
    screenRedirect();
  }

  screenRedirect() async {
    // Local Storage
    if (kDebugMode) {
      print('=========================GET STORAGE +++++++++++++++++++++++');
      print(deviseStorage.read('IsFirstTime'));
    }
    deviseStorage.writeIfNull('IsFirstTime', true);

    final SharedPreferences prefs = await _prefs;
    var token = prefs.getString('token');

    if (deviseStorage.read('IsFirstTime') == true) {
      Get.offAll(const OnBoardingScreen());
    } else if (token != null) {
      Get.offAll(() => const NavigationMenu());
    } else {
      Get.offAll(() => const LoginScreen());
    }
  }
}
