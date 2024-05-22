import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:richatt_mobile_socle_v1/common/widgets/login_signup/form_divider.dart';
import 'package:richatt_mobile_socle_v1/common/widgets/login_signup/social_buttons.dart';
import 'package:richatt_mobile_socle_v1/utils/constants/sizes.dart';
import 'package:richatt_mobile_socle_v1/utils/constants/text_strings.dart';
import 'package:richatt_mobile_socle_v1/utils/helpers/helper_functions.dart';
import 'package:richatt_mobile_socle_v1/features/authentication/screens/signup/widgets/signup_form.dart';


class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = RHelperFunctions.isDarkMode(context);
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(RSizes.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                RTexts.signupTitle,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(
                height: RSizes.spaceBtwSections,
              ),

              //Form
              RSignupForm(dark: dark),
              const SizedBox(height: RSizes.spaceBtwSections),
              RFormDivider(dividerText: RTexts.orSignUpWith.capitalize!),
              const SizedBox(height: RSizes.spaceBtwSections),

              //social buttons

              const RSocialButtons(),
              
            ],
          ),
        ),
      ),
    );
  }
}
