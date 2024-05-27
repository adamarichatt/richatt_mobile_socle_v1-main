import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:richatt_mobile_socle_v1/navigation_menu.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  static LoginController get instance => Get.find();

  final email = TextEditingController();
  final password = TextEditingController();
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  Future<void> loginWithEmail() async {
    print('test login');
    var headers = {
      'Content-Type': 'application/json',
      'Access-Control-Allow-Origin': '*'
    };
    try {
      var url = Uri.parse('http://195.35.25.110:8733/api/auth/signin');
      Map body = {'username': email.text.trim(), 'password': password.text};
      http.Response response =
          await http.post(url, body: jsonEncode(body), headers: headers);
      print(response.body);
      if (response.statusCode == 200) {
        print(response.statusCode);
        final json = jsonDecode(response.body);

        var token = json['accessToken'];
        var email = json['email'];
        final SharedPreferences? prefs = await _prefs;
        await prefs?.setString('token', token);
        await prefs?.setString('email', email);

        print(prefs);

        //email.clear();
        //password.clear();
        Get.offAll(() => const NavigationMenu());
      } else {
        throw jsonDecode(response.body)["Message"] ?? "Unknown Error Occured";
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
}
