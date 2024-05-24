import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:richatt_mobile_socle_v1/navigation_menu.dart';
import 'package:richatt_mobile_socle_v1/features/authentication/screens/signup/verification_account.dart';


class SignupController extends GetxController {
  static SignupController get instance => Get.find();

  final firstName = TextEditingController();
  final lastName = TextEditingController();
  final email = TextEditingController();
  final phoneNumber = TextEditingController();
  final password = TextEditingController();
  final confirmPassword = TextEditingController();
  GlobalKey<FormState> signupFormKey = GlobalKey<FormState>();
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  Future<void> signup() async {
    // Validation des champs
    if (!signupFormKey.currentState!.validate()) {
      return;
    }

    if (password.text != confirmPassword.text) {
      Get.snackbar("Error", "Les mots de passe ne correspondent pas");
      return;
    }

    var headers = {
      'Content-Type': 'application/json',
      'Access-Control-Allow-Origin': 'http://195.35.25.110:8774',
    };

    try {
      // API de vérification
      var verifyUrl = Uri.parse('http://195.35.25.110:8733/api/auth/VerifyAccount');
      Map verifyBody = {
        'email': email.text.trim(),
        'username': lastName.text.trim(),
      };

      http.Response verifyResponse = await http.post(verifyUrl, body: jsonEncode(verifyBody), headers: headers);

      if (verifyResponse.statusCode == 200) {
        // Naviguer vers la page de vérification si l'API de vérification réussit
        final verificationCode = verifyResponse.body;
        debugPrint('Verification Code: $verificationCode');

        // Inscription de l'utilisateur
        var signupUrl = Uri.parse('http://195.35.25.110:8733/api/auth/signup');
        Map signupBody = {
          'firstName': firstName.text.trim(),
          'name': lastName.text.trim(),
          'email': email.text.trim(),
          'phone': phoneNumber.text.trim(),
          'password': password.text,
          'role': ['cust'],
          'username': email.text.trim(),
          'code': verificationCode,
        };

        http.Response signupResponse = await http.post(signupUrl, body: jsonEncode(signupBody), headers: headers);

        if (signupResponse.statusCode == 200) {
          Get.to(() => VerificationPage(email: email.text.trim()));
        } else {
          throw jsonDecode(signupResponse.body)["Message"] ?? "Une erreur inconnue s'est produite";
        }
      } else {
        throw jsonDecode(verifyResponse.body)["Message"] ?? "Une erreur inconnue s'est produite";
      }
    } catch (error) {
      showDialog(
        context: Get.context!,
        builder: (context) {
          return SimpleDialog(
            title: const Text('Erreur'),
            contentPadding: const EdgeInsets.all(20),
            children: [Text(error.toString())],
          );
        },
      );
    }
  }

  Future<void> updateUserCode(String email) async {
    var headers = {
      'Content-Type': 'application/json',
      'Access-Control-Allow-Origin': 'http://195.35.25.110:8774',
    };

    try {
      var updateUrl = Uri.parse('http://195.35.25.110:8733/api/auth/UpdateCode');
      Map updateBody = {
        'email': email,
      };

      http.Response updateResponse = await http.post(updateUrl, body: jsonEncode(updateBody), headers: headers);

      if (updateResponse.statusCode == 200) {
        Get.snackbar("Succès", "Votre compte a été activé avec succès.");
        Get.offAll(() => const NavigationMenu());
      } else {
        throw jsonDecode(updateResponse.body)["Message"] ?? "Une erreur inconnue s'est produite";
      }
    } catch (error) {
      showDialog(
        context: Get.context!,
        builder: (context) {
          return SimpleDialog(
            title: const Text('Erreur'),
            contentPadding: const EdgeInsets.all(20),
            children: [Text(error.toString())],
          );
        },
      );
    }
  }
}

