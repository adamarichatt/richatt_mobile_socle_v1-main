import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:richatt_mobile_socle_v1/features/authentication/controllers/login/login_controller.dart';
import 'package:richatt_mobile_socle_v1/features/authentication/screens/signup/ResetPasswordPage.dart';
import 'package:richatt_mobile_socle_v1/features/authentication/screens/signup/signup.dart';
import 'package:richatt_mobile_socle_v1/navigation_menu.dart';
import 'package:richatt_mobile_socle_v1/utils/constants/sizes.dart';
import 'package:richatt_mobile_socle_v1/utils/constants/text_strings.dart';
import 'package:richatt_mobile_socle_v1/utils/validators/validation.dart';

class RLoginForm extends StatelessWidget {
  const RLoginForm({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    LoginController controller = Get.put(LoginController());
    return Form(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: RSizes.spaceBtwSections),
        child: Column(
          children: [
            //Email
            TextFormField(
              controller: controller.email,
              decoration: const InputDecoration(
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.cyan),
                ),
                prefixIcon: Icon(Iconsax.direct_right),
                labelText: RTexts.email,
                
              ),
               validator: (value) => RValidator.validateEmptyText('Email', value),
            ),
            const SizedBox(
              height: RSizes.spaceBtwInputFields,
            ),
            Obx(
              () {
                IconData visibilityIcon = controller.isPasswordVisible.value
                    ? Icons.visibility
                    : Icons.visibility_off;
                return TextFormField(
                  obscureText: !controller.isPasswordVisible.value,
                  controller: controller.password,
                  decoration: InputDecoration(
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.cyan),
                    ),
                    prefixIcon: Icon(Iconsax.password_check),
                    labelText: RTexts.password,
                    suffixIcon: IconButton(
                      icon: Icon(visibilityIcon),
                      onPressed: () {
                        controller.togglePasswordVisibility();
                      },
                    ),
                  ),
                  validator: (value) => RValidator.validateEmptyText('Password', value),
                );
              },
            ),

            const SizedBox(
              height: RSizes.spaceBtwInputFields / 2,
            ),

            //Remenber Me et Forget Password
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                //remember me
                Row(
                  children: [
                    Checkbox(value: true, onChanged: (value) {}),
                    const Text(RTexts.rememberMe),
                  ],
                ),

                // Forget Password
                 TextButton(
                  onPressed: () {
                    Get.to(() => ResetPasswordPage());  // Naviguez vers la page de réinitialisation
                  },
                  child: const Text(RTexts.forgetPassword),
                ),
              ],
            ),
            const SizedBox(
              height: RSizes.spaceBtwSections,
            ),

            //sign In Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                //onPressed: () => Get.offAll(() => const NavigationMenu()),
                onPressed: () => controller.loginWithEmail(),
                child: const Text(RTexts.signIn),
              ),
            ),
            const SizedBox(
              height: RSizes.spaceBtwItems,
            ),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () => Get.to(() => const SignupScreen()),
                child: const Text(RTexts.createAccount),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
