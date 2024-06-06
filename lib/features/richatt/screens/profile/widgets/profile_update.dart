import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:richatt_mobile_socle_v1/features/richatt/screens/profile/controllers/profile_controller.dart';
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
