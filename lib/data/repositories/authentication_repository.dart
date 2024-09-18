import 'package:flutter/foundation.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:richatt_mobile_socle_v1/features/authentication/screens/login/login.dart';
import 'package:richatt_mobile_socle_v1/features/authentication/screens/onboarding/onboarding.dart';
import 'package:richatt_mobile_socle_v1/navigation_menu.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthenticationRepository extends GetxController {
  static AuthenticationRepository get instance => Get.find();

  final deviseStorage = GetStorage();
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  // Add a flag to track if the user is authenticated
  final RxBool _isAuthenticated = false.obs;
  bool get isAuthenticated => _isAuthenticated.value;

  @override
  void onReady() {
    FlutterNativeSplash.remove();
    screenRedirect();
  }

  screenRedirect() async {
    if (kDebugMode) {
      print('=========================GET STORAGE +++++++++++++++++++++++');
      print(deviseStorage.read('IsFirstTime'));
    }
    deviseStorage.writeIfNull('IsFirstTime', true);

    final SharedPreferences prefs = await _prefs;
    var token = prefs.getString('token');

    if (deviseStorage.read('IsFirstTime') == true) {
      Get.offAll(const OnBoardingScreen());
    } else {
      // Allow access to the app regardless of authentication status
      _isAuthenticated.value = token != null;
      Get.offAll(() => const NavigationMenu());
    }
  }

  // Add a method to handle login
  Future<void> login(String token) async {
    final SharedPreferences prefs = await _prefs;
    await prefs.setString('token', token);
    _isAuthenticated.value = true;
  }

  // Add a method to handle logout
  Future<void> logout() async {
    final SharedPreferences prefs = await _prefs;
    await prefs.remove('token');
    _isAuthenticated.value = false;
  }
}
