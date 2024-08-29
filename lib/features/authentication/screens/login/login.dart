import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:richatt_mobile_rimeet/common/styles/spacing_styles.dart';
import 'package:richatt_mobile_rimeet/common/widgets/login_signup/form_divider.dart';
import 'package:richatt_mobile_rimeet/common/widgets/login_signup/social_buttons.dart';
import 'package:richatt_mobile_rimeet/features/authentication/screens/login/widgets/login_form.dart';
import 'package:richatt_mobile_rimeet/features/authentication/screens/login/widgets/login_header.dart';
import 'package:richatt_mobile_rimeet/utils/constants/sizes.dart';
import 'package:richatt_mobile_rimeet/utils/constants/text_strings.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: RSpacingStyle.paddingWithAppBarHeight,
          child: Column(
            children: [
              // Logo Titre et sous tittre
              const RLoginHeader(),
              //Form
              const RLoginForm(),

              //divider

              RFormDivider(dividerText: RTexts.orSignInWith.capitalize!),

              const SizedBox(
                height: RSizes.spaceBtwSections,
              ),
              //Footer
              const RSocialButtons(),
            ],
          ),
        ),
      ),
    );
  }
}
