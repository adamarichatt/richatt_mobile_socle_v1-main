import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
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
        _buildSocialButton(
          image: RImages.google,
          onTap: () => controller.googleSignIn(),
        ),
        const SizedBox(width: RSizes.spaceBtwItems),
        _buildSocialButton(
          image: RImages.facebook,
          onTap: () => controller.signInWithApple(),
        ),
        const SizedBox(width: RSizes.spaceBtwItems),
        _buildSocialButton(
          image: RImages.lightAppLogo, // Assuming you have a fingerprint icon
          onTap: () => _authBio(),
        ),
      ],
    );
  }

  Widget _buildSocialButton(
      {required String image, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: RColors.grey),
          borderRadius: BorderRadius.circular(100),
        ),
        child: Image(
          width: RSizes.iconMd,
          height: RSizes.iconMd,
          image: AssetImage(image),
        ),
      ),
    );
  }

  Future<void> _authenticateWithBiometrics() async {
    final bool canAuthenticateWithBiometrics = await _auth.canCheckBiometrics;
    if (canAuthenticateWithBiometrics) {
      final bool didAuthenticate = await _auth.authenticate(
        localizedReason: 'Please authenticate to access your data',
        options: const AuthenticationOptions(
          biometricOnly: false,
          stickyAuth: true,
        ),
      );
      // Handle the authentication result here
    }
  }

  Future<void> _authBio() async {
    try {
      bool authenticated = await _auth.authenticate(
        localizedReason: 'Please authenticate to access',
        options: const AuthenticationOptions(
          biometricOnly: false,
          stickyAuth: true,
        ),
      );
      print("Authenticated : $authenticated");
    } on PlatformException catch (e) {
      print(e);
    }
  }
}
