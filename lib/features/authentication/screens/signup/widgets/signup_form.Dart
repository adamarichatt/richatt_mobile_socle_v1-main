import 'package:flutter/material.dart';
import 'package:richatt_mobile_socle_v1/common/widgets/login_signup/form_divider.dart';
import 'package:richatt_mobile_socle_v1/common/widgets/login_signup/social_buttons.dart';
import 'package:richatt_mobile_socle_v1/utils/constants/colors.dart';
import 'package:richatt_mobile_socle_v1/utils/constants/sizes.dart';
import 'package:iconsax/iconsax.dart';
import 'package:richatt_mobile_socle_v1/features/authentication/controllers/signup/signup_controller.dart';
import 'package:get/get.dart';
import 'package:richatt_mobile_socle_v1/utils/constants/text_strings.dart';
import 'package:richatt_mobile_socle_v1/utils/validators/validation.dart';

class RSignupForm extends StatefulWidget {
  const RSignupForm({
    super.key,
    required this.dark,
  });

  final bool dark;

  @override
  _RSignupFormState createState() => _RSignupFormState();
}

class _RSignupFormState extends State<RSignupForm> {
  final controller = Get.put(SignupController());
  bool _passwordVisible = false;
  bool _confirmPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: controller.signupFormKey,
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: controller.firstName,
                  expands: false,
                  decoration: const InputDecoration(
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFFA8A6A7)),
                    ),
                    labelText: RTexts.firstName,
                    prefixIcon: Icon(Iconsax.user),
                  ),
                  validator: (value) => RValidator.validateEmptyText('First name', value),
                ),
              ),
              const SizedBox(
                width: RSizes.spaceBtwInputFields,
              ),
              Expanded(
                child: TextFormField(
                  controller: controller.lastName,
                  expands: false,
                  decoration: const InputDecoration(
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFFA8A6A7)),
                    ),
                    labelText: RTexts.lastName,
                    prefixIcon: Icon(Iconsax.user),
                  ),
                  validator: (value) => RValidator.validateEmptyText('Last name', value),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: RSizes.spaceBtwInputFields,
          ),
          TextFormField(
            controller: controller.email,
            expands: false,
            decoration: const InputDecoration(
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Color(0xFFA8A6A7)),
              ),
              labelText: RTexts.email,
              prefixIcon: Icon(Iconsax.direct),
            ),
            validator: RValidator.validateEmail,
          ),
          const SizedBox(
            height: RSizes.spaceBtwInputFields,
          ),
          TextFormField(
            controller: controller.phoneNumber,
            expands: false,
            decoration: const InputDecoration(
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Color(0xFFA8A6A7)),
              ),
              labelText: RTexts.phoneNo,
              prefixIcon: Icon(Iconsax.call),
            ),
            validator: RValidator.validatePhoneNumber,
          ),
          const SizedBox(
            height: RSizes.spaceBtwInputFields,
          ),
          TextFormField(
            controller: controller.password,
            obscureText: !_passwordVisible,
            expands: false,
            decoration: InputDecoration(
              enabledBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: Color(0xFFA8A6A7)),
              ),
              labelText: RTexts.password,
              prefixIcon: const Icon(Iconsax.password_check),
              suffixIcon: IconButton(
                icon: Icon(
                  _passwordVisible ? Iconsax.eye : Iconsax.eye_slash,
                ),
                onPressed: () {
                  setState(() {
                    _passwordVisible = !_passwordVisible;
                  });
                },
              ),
            ),
            validator: RValidator.validatePassword,
          ),
          const SizedBox(
            height: RSizes.spaceBtwSections,
          ),
          TextFormField(
            controller: controller.confirmPassword,
            obscureText: !_confirmPasswordVisible,
            expands: false,
            decoration: InputDecoration(
              enabledBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: Color(0xFFA8A6A7)),
              ),
              labelText: RTexts.confirmPassword,
              prefixIcon: const Icon(Iconsax.password_check),
              suffixIcon: IconButton(
                icon: Icon(
                  _confirmPasswordVisible ? Iconsax.eye : Iconsax.eye_slash,
                ),
                onPressed: () {
                  setState(() {
                    _confirmPasswordVisible = !_confirmPasswordVisible;
                  });
                },
              ),
            ),
            validator: (value) => RValidator.validateConfirmPassword(value, controller.password.text),
          ),
          const SizedBox(
            height: RSizes.spaceBtwSections,
          ),
          Row(
            children: [
              SizedBox(
                width: 20,
                height: 20,
                child: Checkbox(value: true, onChanged: (value) {}),
              ),
              const SizedBox(width: RSizes.spaceBtwItems),
              Text.rich(
                TextSpan(children: [
                  TextSpan(
                    text: '${RTexts.iAgreeTo} ',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  TextSpan(
                    text: '${RTexts.privacyPolicy} ',
                    style: Theme.of(context).textTheme.bodyMedium!.apply(
                          color: widget.dark ? RColors.white : RColors.primary,
                          decoration: TextDecoration.underline,
                          decorationColor: widget.dark ? RColors.white : RColors.primary,
                        ),
                  ),
                  TextSpan(
                    text: '${RTexts.and} ',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  TextSpan(
                    text: '${RTexts.termsOfUse} ',
                    style: Theme.of(context).textTheme.bodyMedium!.apply(
                          color: widget.dark ? RColors.white : RColors.primary,
                          decoration: TextDecoration.underline,
                          decorationColor: widget.dark ? RColors.white : RColors.primary,
                        ),
                  ),
                ]),
              ),
            ],
          ),
          const SizedBox(
            height: RSizes.spaceBtwSections,
          ),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => controller.signup(),
              child: const Text(RTexts.createAccount),
            ),
          ),
        ],
      ),
    );
  }
}