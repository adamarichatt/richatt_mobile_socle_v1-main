import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:richatt_mobile_socle_v1/features/richatt/screens/profile/controllers/profile_controller.dart';
import 'package:richatt_mobile_socle_v1/features/richatt/screens/profile/widgets/profile.dart';
import 'package:richatt_mobile_socle_v1/utils/constants/sizes.dart';
import 'package:richatt_mobile_socle_v1/utils/constants/text_strings.dart';

class profile_update extends StatelessWidget {
  const profile_update({
    super.key,
    required this.controller,
  });

  final ProfileController controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile update'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: TextEditingController(text: controller.firstName.value),
              onChanged: (value) => controller.firstName.value = value,
              decoration: const InputDecoration(
                labelText: RTexts.firstName,
                prefixIcon: Icon(Iconsax.user),
              ),
            ),
            const SizedBox(
              height: RSizes.spaceBtwInputFields,
            ),
            TextField(
              controller: TextEditingController(text: controller.lastName.value),
              onChanged: (value) => controller.lastName.value = value,
              decoration: const InputDecoration(
                labelText: RTexts.lastName,
                prefixIcon: Icon(Iconsax.user),
              ),
            ),
            const SizedBox(
              height: RSizes.spaceBtwInputFields,
            ),
            TextField(
              controller: TextEditingController(text: controller.email.value),
              onChanged: (value) => controller.email.value = value,
              decoration: const InputDecoration(
                prefixIcon: Icon(Iconsax.direct_right),
                labelText: RTexts.email,
              ),
            ),
            const SizedBox(
              height: RSizes.spaceBtwInputFields,
            ),
            TextField(
              controller: TextEditingController(text: controller.phone.value),
              onChanged: (value) => controller.phone.value = value,
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
                Get.to(() => ProfilePage(email: controller.email.value));
              },
              child: Text('Update'),
            ),
          ],
        ),
      ),
    );
  }
}
