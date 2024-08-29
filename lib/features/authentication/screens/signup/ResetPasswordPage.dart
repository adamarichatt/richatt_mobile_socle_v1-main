import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:richatt_mobile_rimeet/features/authentication/controllers/signup/signup_controller.dart';
import 'package:richatt_mobile_rimeet/utils/validators/validation.dart';

class ResetPasswordPage extends StatelessWidget {
  final emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final controller = Get.put(SignupController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Reset Password')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: 'Enter your email',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
                validator: RValidator.validateEmail,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    debugPrint(
                        'emailController.text:  ' + emailController.text);
                    controller.sendResetPasswordEmail(emailController.text);
                  } else {
                    Get.snackbar("Erreur", "Veuillez entrer un email valide.");
                  }
                },
                child: Text('Send Reset Password'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
