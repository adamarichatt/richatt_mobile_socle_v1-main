import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:email_validator/email_validator.dart';

class FirstSignUpController extends GetxController {
  late TextEditingController inputController;
  final isEmail = true.obs;
  final formKey = GlobalKey<FormState>();

  @override
  void onInit() {
    super.onInit();
    inputController = TextEditingController();
  }

  @override
  void onClose() {
    inputController.dispose();
    super.onClose();
  }

  void toggleInputType() {
    isEmail.value = !isEmail.value;
  }

  String? validateInput(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter ${isEmail.value ? 'an email' : 'a phone number'}';
    }
    if (isEmail.value && !EmailValidator.validate(value)) {
      return 'Please enter a valid email';
    }
    if (!isEmail.value && !RegExp(r'^\+?[0-9]{10,14}$').hasMatch(value)) {
      return 'Please enter a valid phone number';
    }
    return null;
  }

  void createAccount() {
    if (formKey.currentState!.validate()) {
      // TODO: Implement account creation logic
      print('Valid input: ${inputController.text}');
      Get.snackbar(
        'Success',
        'Account created with ${isEmail.value ? 'email' : 'phone'}: ${inputController.text}',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
}
