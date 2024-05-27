import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:richatt_mobile_socle_v1/features/authentication/controllers/signup/signup_controller.dart';



class VerificationPage extends StatelessWidget {
  final String email;
  final verificationCodeController = TextEditingController();

  VerificationPage({required this.email});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Verification')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: verificationCodeController,
              decoration: InputDecoration(labelText: 'Entrez le code de vérification'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                SignupController.instance.updateUserCode(email);
              },
              child: Text('Vérifier'),
            ),
          ],
        ),
      ),
    );
  }
}

