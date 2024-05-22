import 'package:flutter/foundation.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:richatt_mobile_socle_v1/features/authentication/screens/login/login.dart';
import 'package:richatt_mobile_socle_v1/features/authentication/screens/onboarding/onboarding.dart';

class AuthenticationRepository extends GetxController{
  static AuthenticationRepository get instance => Get.find();

  final deviseStorage = GetStorage();


  @override 
  void onReady(){
    FlutterNativeSplash.remove();
    screenRedirect();
  }


  screenRedirect() async {
    //local Storage 
    if(kDebugMode){
      print('=========================GET STORAGE +++++++++++++++++++++++');
      print(deviseStorage.read('IsFirstTime'));
    }
    deviseStorage.writeIfNull('IsFirstTime', true);
    deviseStorage.read('IsFirstTime') != true ? Get.offAll(()=>const LoginScreen()) :  Get.offAll(const OnBoardingScreen());
  }
}