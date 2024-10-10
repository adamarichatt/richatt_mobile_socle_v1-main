import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:Remeet/features/authentication/screens/login/login.dart';
import 'package:Remeet/navigation_menu.dart';
import 'package:Remeet/utils/constants/api_constants.dart';
import 'package:Remeet/utils/helpers/helper_functions.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class LoginController extends GetxController {
  static LoginController get instance => Get.find();

  final email = TextEditingController();
  final password = TextEditingController();
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  var isLoggedIn = false.obs;
  RxBool isPasswordVisible = false.obs;
  final isGoogleLoading = false.obs;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  @override
  void onInit() {
    super.onInit();
    _checkLoginStatus();
  }

  Future<void> loginWithEmail() async {
    RHelperFunctions.showLoader();

    print('test login');
    var headers = {
      'Content-Type': 'application/json',
      'Access-Control-Allow-Origin': '*'
    };
    try {
      var url = Uri.parse(APIConstants.apiBackend + 'auth/signin');
      Map body = {'username': email.text.trim(), 'password': password.text};
      http.Response response =
          await http.post(url, body: jsonEncode(body), headers: headers);
      print(response.body);
      if (response.statusCode == 200) {
        print(response.statusCode);
        final json = jsonDecode(response.body);

        var token = json['accessToken'];
        var email = json['email'];
        var phone = json['phone'];
        var roles = json['roles'];
        final SharedPreferences? prefs = await _prefs;
        await prefs?.setString('token', token);
        await prefs?.setString('email', email);
        await prefs?.setString('phone', phone);

        print(prefs);
        print('le role $roles');

        isLoggedIn.value = true;
        Get.offAll(() => const NavigationMenu());
      } else {
        throw jsonDecode(response.body)["Message"] ??
            "Nom d'utilisateur ou mot de passe incorrect.";
      }
    } catch (error) {
      Get.back();
      showDialog(
          context: Get.context!,
          builder: (context) {
            return SimpleDialog(
              title: const Text('Error'),
              contentPadding: const EdgeInsets.all(20),
              children: [Text(error.toString())],
            );
          });
    }
  }

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  Future<void> _checkLoginStatus() async {
    final SharedPreferences prefs = await _prefs;
    var token = prefs.getString('token');
    if (token != null) {
      isLoggedIn.value = true;
      Get.offAll(() => const NavigationMenu());
    }
  }

  Future<void> logout() async {
    RHelperFunctions.showLoader();

    final SharedPreferences prefs = await SharedPreferences.getInstance();

    // Sauvegarder l'état de Face ID dans une variable temporaire
    bool faceIdEnabled = prefs.getBool('face_id_enabled') ?? false;

    // Effacer toutes les préférences sauf Face ID
    await prefs.clear();

    // Restaurer l'état de Face ID
    await prefs.setBool('face_id_enabled', faceIdEnabled);

    isLoggedIn.value = false;

    // Rediriger vers l'écran de connexion
    Get.offAll(() => const LoginScreen());
  }

  Future<void> googleSignIn() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return;

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await _auth.signInWithCredential(credential);
      // Handle successful sign-in (e.g., navigate to home screen)
    } catch (error) {
      print('Error during Google Sign-In: $error');
      // Handle the error (e.g., show an error message to the user)
      Get.snackbar('Error', 'Failed to sign in with Google. Please try again.');
    }
  }

  Future<UserCredential> signInWithFacebook() async {
    // Trigger the sign-in flow
    final LoginResult loginResult = await FacebookAuth.instance.login();

    // Check if the login was successful
    if (loginResult.status == LoginStatus.success) {
      // Create a credential from the access token
      final AccessToken? accessToken = loginResult.accessToken;

      if (accessToken != null) {
        final OAuthCredential facebookAuthCredential =
            FacebookAuthProvider.credential(accessToken.tokenString);

        // Once signed in, return the UserCredential
        return await FirebaseAuth.instance
            .signInWithCredential(facebookAuthCredential);
      } else {
        throw Exception("Access token is null.");
      }
    } else {
      // Handle the login failure
      throw Exception("Facebook login failed: ${loginResult.message}");
    }
  }

  Future<void> signInWithApple() async {
    print("Début de la fonction signInWithApple");
    try {
      print("Vérification de la disponibilité de Sign In with Apple");
      final isAvailable = await SignInWithApple.isAvailable();
      print("Sign In with Apple est disponible: $isAvailable");

      if (!isAvailable) {
        print("Sign In with Apple n'est pas disponible sur cet appareil");
        return;
      }

      print("Tentative d'obtention des credentials Apple");
      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );
      print("Credentials Apple obtenus");

      print("Création des credentials OAuth");
      final oauthCredential = OAuthProvider("apple.com").credential(
        idToken: appleCredential.identityToken,
        accessToken: appleCredential.authorizationCode,
      );
      print("Credentials OAuth créés");

      print("Tentative de connexion à Firebase");
      final userCredential =
          await FirebaseAuth.instance.signInWithCredential(oauthCredential);
      print("Connexion à Firebase réussie : ${userCredential.user?.uid}");
    } catch (e) {
      print('Erreur capturée dans signInWithApple: $e');
      if (e is SignInWithAppleAuthorizationException) {
        print('Code d\'erreur SignInWithApple: ${e.code}');
        print('Message d\'erreur SignInWithApple: ${e.message}');
      }
    }
    print("Fin de la fonction signInWithApple");
  }
}
