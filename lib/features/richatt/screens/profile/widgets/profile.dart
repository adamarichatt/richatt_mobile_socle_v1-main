import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/profile_controller.dart';
import 'package:richatt_mobile_socle_v1/utils/constants/sizes.dart';
import 'package:richatt_mobile_socle_v1/utils/constants/text_strings.dart';
import 'package:richatt_mobile_socle_v1/utils/validators/validation.dart';
import 'package:iconsax/iconsax.dart'; 

class ProfilePage extends StatelessWidget {
  final String email;

  ProfilePage({required this.email});

  @override
  Widget build(BuildContext context) {
    final ProfileController controller = Get.put(ProfileController());

    // Appeler getCustomerByEmail lors de l'initialisation de la page
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.getCustomerByEmail(email);
    });

    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: controller.firstName,
               decoration: const InputDecoration(
                    labelText: RTexts.firstName,
                    prefixIcon: Icon(Iconsax.user),
                  ),
            ),
             const SizedBox(
              height: RSizes.spaceBtwInputFields,
            ),
            TextField(
              controller: controller.lastName,
               decoration: const InputDecoration(
                    labelText: RTexts.lastName,
                    prefixIcon: Icon(Iconsax.user),
                  ),
            ),
             const SizedBox(
              height: RSizes.spaceBtwInputFields,
            ),
            TextField(
              controller: controller.email,
               decoration: const InputDecoration(
                prefixIcon: Icon(Iconsax.direct_right),
                labelText: RTexts.email,
              ),
            ),
             const SizedBox(
              height: RSizes.spaceBtwInputFields,
            ),
            TextField(
              controller: controller.phone,
                  decoration: const InputDecoration(
              labelText: RTexts.phoneNo,
              prefixIcon: Icon(Iconsax.call),
            ),
            ),
           
             const SizedBox(
              height: RSizes.spaceBtwInputFields,
            ),
            ElevatedButton(
              onPressed: () {
                controller.updateCustomer();
              },
              child: Text('Update'),
            ),
          ],
        ),
      ),
    );
  }
}
