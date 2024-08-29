import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:richatt_mobile_rimeet/features/authentication/screens/login/login.dart';
import 'package:richatt_mobile_rimeet/navigation_menu.dart';
import 'package:richatt_mobile_rimeet/utils/constants/api_constants.dart';
import 'package:richatt_mobile_rimeet/utils/helpers/helper_functions.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  static LoginController get instance => Get.find();

  final email = TextEditingController();
  final password = TextEditingController();
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  var isLoggedIn = false.obs;
  RxBool isPasswordVisible = false.obs;

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
        final SharedPreferences? prefs = await _prefs;
        await prefs?.setString('token', token);
        await prefs?.setString('email', email);
        await prefs?.setString('phone', phone);

        print(prefs);

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
    final SharedPreferences prefs = await _prefs;
    await prefs.clear();
    isLoggedIn.value = false;
    Get.offAll(() => const LoginScreen());
  }
}
