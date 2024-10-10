import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:Remeet/features/authentication/screens/onboarding/onboarding.dart';
import 'package:Remeet/navigation_menu.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthenticationRepository extends GetxController {
  static AuthenticationRepository get instance => Get.find();

  final deviseStorage = GetStorage();
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  // Add a flag to track if the user is authenticated
  final RxBool _isAuthenticated = false.obs;
  bool get isAuthenticated => _isAuthenticated.value;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  var verificationId = ''.obs;

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

  Future<UserCredential> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  Future<void> phoneAuthentication(String phoneNo) async {
    await _auth.verifyPhoneNumber(
      phoneNumber: phoneNo,
      verificationCompleted: (credential) async {
        await _auth.signInWithCredential(credential);
      },
      verificationFailed: (e) {
        if (e.code == 'invalid-phone-number') {
          Get.snackbar('Error', 'numero invalid');
        } else {
          Get.snackbar('Error', 'something wrong');
        }
      },
      codeSent: (verificationId, resendToken) {
        this.verificationId.value = verificationId;
      },
      codeAutoRetrievalTimeout: (verificationId) {
        this.verificationId.value = verificationId;
      },
    );
  }

  Future<bool> verifyOtp(String otp) async {
    var credentials = await _auth.signInWithCredential(
        PhoneAuthProvider.credential(
            verificationId: this.verificationId.value, smsCode: otp));
    return credentials.user != null ? true : false;
  }
}
