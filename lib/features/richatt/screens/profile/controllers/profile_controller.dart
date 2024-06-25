import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:richatt_mobile_socle_v1/utils/constants/api_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/customer.dart';

class ProfileController extends GetxController {
  static ProfileController get instance => Get.find();

 final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  final customerId = ''.obs;
  final firstName = ''.obs;
  final lastName = ''.obs;
  final email = ''.obs;
  final phone = ''.obs;
  

  Future<void> getCustomerByEmail(String email) async {
    var headers = {
      'Content-Type': 'application/json',
      'Access-Control-Allow-Origin': 'http://195.35.25.110:8774',
    };
     
    var url = Uri.parse(APIConstants.apiBackend + 'customer/getCustomerByEmail/$email');

    try {
      http.Response response = await http.get(url);
      debugPrint('response:'+response.body);

      if (response.statusCode == 200) {
       final json = jsonDecode(response.body);
        final customer = Customer.fromJson(json);
        debugPrint('json:' + json.toString());
        customerId.value = customer.id!;
        firstName.value = customer.firstName;
        lastName.value = customer.lastName;
        this.email.value = customer.email;
        phone.value = customer.phone;
        
      } else {
        throw Exception('Failed to load customer');
      }
    } catch (error) {
      showDialog(
        context: Get.context!,
        builder: (context) {
          return SimpleDialog(
            title: const Text('Error'),
            contentPadding: const EdgeInsets.all(20),
            children: [Text(error.toString())],
          );
        },
      );
    }
  }

   Future<void> updateCustomer() async {
    var headers = {
      'Content-Type': 'application/json',
      'Access-Control-Allow-Origin': 'http://195.35.25.110:8774',
    };

    var url = Uri.parse(APIConstants.apiBackend + 'customer/updateCustomer/${customerId.value}');

    try {
      Customer customer = Customer(
        id: customerId.value,
        firstName: firstName.value.trim(),
        lastName: lastName.value.trim(),
        email: email.value.trim(),
        phone: phone.value.trim(),
        name: email.value.trim(),
        lange: null,
        presentation: null,
        imageUrl: null,
       
      );

      debugPrint('cust:' + customer.toJson().toString());

      http.Response response = await http.put(
        url,
        headers: headers,
        body: jsonEncode(customer.toJson()),
      );

      debugPrint('body:' + response.body);

      if (response.statusCode == 200) {
        Get.snackbar("Success", "Customer updated successfully");
      } else {
        throw Exception('Failed to update customer');
      }
    } catch (error) {
      showDialog(
        context: Get.context!,
        builder: (context) {
          return SimpleDialog(
            title: const Text('Error'),
            contentPadding: const EdgeInsets.all(20),
            children: [Text(error.toString())],
          );
        },
      );
    }
  }
}
