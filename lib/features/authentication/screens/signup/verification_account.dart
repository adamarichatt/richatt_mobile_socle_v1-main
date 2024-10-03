import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:Remeet/features/authentication/controllers/signup/signup_controller.dart';
import 'package:Remeet/generated/l10n.dart';

class VerificationPage extends StatelessWidget {
  final String email;
  final verificationCodeController = TextEditingController();

  VerificationPage({required this.email});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(S.of(context).Verification)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: verificationCodeController,
              decoration: InputDecoration(labelText: S.of(context).enterCode),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                SignupController.instance
                    .verifyCode(email, verificationCodeController.text);
              },
              child: Text(S.of(context).verif),
            ),
          ],
        ),
      ),
    );
  }
}
