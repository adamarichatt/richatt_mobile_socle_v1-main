import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:Remeet/common/widgets/login_signup/form_divider.dart';
import 'package:Remeet/common/widgets/login_signup/social_buttons.dart';
import 'package:Remeet/generated/l10n.dart';
import 'package:Remeet/utils/constants/sizes.dart';
import 'package:Remeet/utils/helpers/helper_functions.dart';
import 'package:Remeet/features/authentication/screens/signup/widgets/signup_form.dart';

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
                S.of(context).signUp,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(
                height: RSizes.spaceBtwItems,
              ),
              Text(S.of(context).signupSubTitle,
                  style: TextStyle(fontSize: RSizes.md)),
              const SizedBox(height: RSizes.spaceBtwSections + 10),
              //Form
              RSignupForm(dark: dark),
              const SizedBox(height: RSizes.spaceBtwSections + 10),
              RFormDivider(dividerText: S.of(context).signUpWith.capitalize!),
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
