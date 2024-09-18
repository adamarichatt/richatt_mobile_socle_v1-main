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
  final image = ''.obs;
  final isGuest = false.obs;
  final _isUserConnected = false.obs;

  @override
  void onInit() {
    super.onInit();
    _checkUserConnection();
  }

  void _checkUserConnection() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? email = prefs.getString('email');

    // Update the _isUserConnected variable based on whether email is null or not

    _isUserConnected.value = email != null;
  }

  void loadGuestData() {
    customerId.value = 'guest123';
    firstName.value = 'Guest';
    lastName.value = 'User';
    email.value = 'guest@example.com';
    phone.value = '+1234567890';
    image.value = ''; // You can set a default guest image URL here if needed
  }

  Future<void> getCustomerByEmail(String email) async {
    if (_isUserConnected.value == false) {
      loadGuestData();
      return;
    }

    var headers = {
      'Content-Type': 'application/json',
      'Access-Control-Allow-Origin': 'http://195.35.25.110:8774',
    };

    var url = Uri.parse(
        APIConstants.apiBackend + 'customer/getCustomerByEmail/$email');

    try {
      http.Response response = await http.get(url);
      debugPrint('response: ${response.body}');

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        final customer = Customer.fromJson(json);
        debugPrint('json: $json');
        customerId.value = customer.id!;
        firstName.value = customer.firstName;
        lastName.value = customer.lastName;
        this.email.value = customer.email;
        phone.value = customer.phone;
        image.value = customer.imageUrl ?? '';
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
    if (isGuest.value) {
      Get.snackbar("Info", "Guest profile cannot be updated");
      return;
    }

    var headers = {
      'Content-Type': 'application/json',
      'Access-Control-Allow-Origin': 'http://195.35.25.110:8774',
    };

    var url = Uri.parse(APIConstants.apiBackend +
        'customer/updateCustomer/${customerId.value}');

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

      debugPrint('customer: ${customer.toJson()}');

      http.Response response = await http.put(
        url,
        headers: headers,
        body: jsonEncode(customer.toJson()),
      );

      debugPrint('body: ${response.body}');

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

  void toggleGuestMode(bool isGuestMode) {
    isGuest.value = isGuestMode;
    if (isGuestMode) {
      loadGuestData();
    } else {
      // Clear data when switching to regular mode
      customerId.value = '';
      firstName.value = '';
      lastName.value = '';
      email.value = '';
      phone.value = '';
      image.value = '';
    }
  }
}
