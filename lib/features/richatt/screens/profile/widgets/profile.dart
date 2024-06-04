import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:richatt_mobile_socle_v1/common/widgets/appbar/appbar.dart';
import 'package:richatt_mobile_socle_v1/features/richatt/screens/profile/widgets/profile_update.dart';
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
        title: Text('Professional Details'),
      ),

      //body: profile_update(controller: controller),
      body: SingleChildScrollView(
        child: Column(
          children: [],
        ),
      ),
    );
  }
}
