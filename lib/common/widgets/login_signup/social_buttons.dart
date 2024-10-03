import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:local_auth/local_auth.dart';
import 'package:Remeet/features/authentication/controllers/login/login_controller.dart';
import 'package:Remeet/utils/constants/colors.dart';
import 'package:Remeet/utils/constants/image_strings.dart';
import 'package:Remeet/utils/constants/sizes.dart';

class RSocialButtons extends StatelessWidget {
  static final _auth = LocalAuthentication();
  const RSocialButtons({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    LoginController controller = Get.put(LoginController());

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: RColors.grey),
            borderRadius: BorderRadius.circular(100),
          ),
          child: const Image(
            width: RSizes.iconMd,
            height: RSizes.iconMd,
            image: AssetImage(RImages.google),
          ),
        ),
        const SizedBox(
          width: RSizes.spaceBtwItems,
        ),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: RColors.grey),
            borderRadius: BorderRadius.circular(100),
          ),
          child: const Image(
            width: RSizes.iconMd,
            height: RSizes.iconMd,
            image: AssetImage(RImages.facebook),
          ),
        ),
        ElevatedButton(
          onPressed: () => controller.googleSignIn(),
          child: Text('tesst'),
        ),
        ElevatedButton(
          onPressed: () async {
            final bool canAuthenticateWithBiometrics =
                await _auth.canCheckBiometrics;
            if (canAuthenticateWithBiometrics) {
              final bool didAuthenticate = await _auth.authenticate(
                localizedReason: 'please authenticate to access ur data ',
                options: const AuthenticationOptions(
                  biometricOnly: false,
                ),
              );
            }
          },
          child: Text('face id'),
        ),
        ElevatedButton(
          onPressed: () => controller.signInWithApple(),
          child: Text('facebook'),
        ),
      ],
    );
  }
}
