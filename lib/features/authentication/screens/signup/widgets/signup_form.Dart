import 'package:flutter/material.dart';
import 'package:richatt_mobile_socle_v1/common/widgets/login_signup/form_divider.dart';
import 'package:richatt_mobile_socle_v1/common/widgets/login_signup/social_buttons.dart';
import 'package:richatt_mobile_socle_v1/utils/constants/colors.dart';
import 'package:richatt_mobile_socle_v1/utils/constants/sizes.dart';
import 'package:iconsax/iconsax.dart';
import 'package:richatt_mobile_socle_v1/features/authentication/controllers/signup/signup_controller.dart';
import 'package:get/get.dart';
import 'package:richatt_mobile_socle_v1/utils/constants/text_strings.dart';
import 'package:richatt_mobile_socle_v1/utils/helpers/helper_functions.dart';

class RSignupForm extends StatelessWidget {
  const RSignupForm({
    super.key,
    required this.dark,
  });

  final bool dark;

  @override
  Widget build(BuildContext context) {
    final controller= Get.put(SignupController());
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
                    labelText: RTexts.firstName,
                    prefixIcon: Icon(Iconsax.user),
                  ),
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
                    labelText: RTexts.lastName,
                    prefixIcon: Icon(Iconsax.user),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: RSizes.spaceBtwInputFields,
          ),
          TextFormField(
            controller: controller.username,
           
            expands: false,
            decoration: const InputDecoration(
              labelText: RTexts.username,
              prefixIcon: Icon(Iconsax.user_edit),
            ),
          ),
          const SizedBox(
            height: RSizes.spaceBtwInputFields,
          ),
          TextFormField(
            controller: controller.email,
            
            expands: false,
            decoration: const InputDecoration(
              labelText: RTexts.email,
              prefixIcon: Icon(Iconsax.direct),
            ),
          ),
          const SizedBox(
            height: RSizes.spaceBtwInputFields,
          ),
          TextFormField(
            controller: controller.phoneNumber,
            
            expands: false,
            decoration: const InputDecoration(
              labelText: RTexts.phoneNo,
              prefixIcon: Icon(Iconsax.call),
            ),
          ),
          const SizedBox(
            height: RSizes.spaceBtwInputFields,
          ),
          TextFormField(
            controller: controller.password,
           
            obscureText: true,
            expands: false,
            decoration: const InputDecoration(
              labelText: RTexts.password,
              prefixIcon: Icon(Iconsax.password_check),
              suffixIcon: Icon(Iconsax.eye_slash),
            ),
          ),
          const SizedBox(
            height: RSizes.spaceBtwSections,
          ),
    
          // Terms and Condition Checkbox
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
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium!
                        .apply(
                          color:
                              dark ? RColors.white : RColors.primary,
                          decoration: TextDecoration.underline,
                          decorationColor:
                              dark ? RColors.white : RColors.primary,
                        ),
                  ),
                  TextSpan(
                    text: '${RTexts.and} ',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  TextSpan(
                    text: '${RTexts.termsOfUse} ',
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium!
                        .apply(
                          color:
                              dark ? RColors.white : RColors.primary,
                          decoration: TextDecoration.underline,
                          decorationColor:
                              dark ? RColors.white : RColors.primary,
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
                child: const Text(RTexts.createAccount)),
          ),
        ],
      ),
    );
  }
}
