import 'package:Remeet/features/authentication/screens/signup/verification_account.dart';
import 'package:Remeet/navigation_menu.dart';
import 'package:Remeet/utils/constants/image_strings.dart';
import 'package:flutter/material.dart';
import 'package:Remeet/features/authentication/controllers/signup/signup_controller.dart';
import 'package:Remeet/generated/l10n.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class FirstSignUp extends StatelessWidget {
  final verificationCodeController = TextEditingController();

  FirstSignUp();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image(
              height: 150,
              image: AssetImage(RImages.lightAppLogo),
            ),
            Text(S.of(context).enterPassword),
            SizedBox(height: 20),
            TextField(
              controller: verificationCodeController,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Get.to(() => VerificationPage(
                      email: 'holla',
                    ));
              },
              child: Text(S.of(context).validate),
            ),
          ],
        ),
      ),
    );
  }
}
