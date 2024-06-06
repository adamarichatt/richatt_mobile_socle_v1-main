import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import 'package:richatt_mobile_socle_v1/common/widgets/custom_shapes/containers/primary_header_container.dart';
import 'package:richatt_mobile_socle_v1/common/widgets/custom_shapes/containers/search_container.dart';
import 'package:richatt_mobile_socle_v1/common/widgets/doctor/RProfileCard.dart';
import 'package:richatt_mobile_socle_v1/common/widgets/doctor/RProfileCardVertical.dart';
import 'package:richatt_mobile_socle_v1/common/widgets/doctor/RdoctorCardVertical.dart';
import 'package:richatt_mobile_socle_v1/features/richatt/controllers/professionalController.dart';
import 'package:richatt_mobile_socle_v1/features/richatt/screens/home/widgets/home_appb.dart';

import 'package:richatt_mobile_socle_v1/utils/constants/sizes.dart';
import 'package:richatt_mobile_socle_v1/utils/device/device_utility.dart';
import 'package:richatt_mobile_socle_v1/utils/helpers/helper_functions.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ProfessionalController());

    // Appeler getCustomerByEmail lors de l'initialisation de la page
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.getProf();
    });

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Column(
              children: [
                RHomeAppBar(),
                SizedBox(
                  height: RSizes.spaceBtwSections,
                ),
                RSearchContainer(
                  text: 'Search a doctor!',
                ),
                SizedBox(
                  height: RSizes.spaceBtwSections,
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(RSizes.defaultSpace),
              child: Column(
                children: [
                  Obx(
                    () => SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: List.generate(
                          controller.featuredProf.length,
                          (index) => Padding(
                            padding: const EdgeInsets.only(
                                right: 16.0), // Espace entre les cartes
                            child: ProfileCardVertical(
                              professional: controller.featuredProf[index],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(RSizes.defaultSpace),
              child: Column(
                children: [
                  Obx(() => GridView.builder(
                      itemCount: controller.featuredProf.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 1,
                        mainAxisSpacing: RSizes.gridViewSpacing,
                        crossAxisSpacing: RSizes.gridViewSpacing,
                        mainAxisExtent: 130,
                      ),
                      itemBuilder: (_, index) => profileCard(
                          professional: controller.featuredProf[index]))),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
