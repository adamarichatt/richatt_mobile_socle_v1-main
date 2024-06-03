import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import 'package:richatt_mobile_socle_v1/common/widgets/custom_shapes/containers/primary_header_container.dart';
import 'package:richatt_mobile_socle_v1/common/widgets/custom_shapes/containers/search_container.dart';
import 'package:richatt_mobile_socle_v1/common/widgets/doctor/RdoctorCardVertical.dart';
import 'package:richatt_mobile_socle_v1/features/richatt/controllers/professionalController.dart';
import 'package:richatt_mobile_socle_v1/features/richatt/screens/home/widgets/home_appb.dart';

import 'package:richatt_mobile_socle_v1/utils/constants/sizes.dart';
import 'package:richatt_mobile_socle_v1/utils/device/device_utility.dart';

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
            const RPrimaryHeaderContainer(
              child: Column(
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
            ),
            Overlay(
              initialEntries: [
                OverlayEntry(
                  builder: (context) => Positioned(
                    top: 100,
                    left: 100,
                    child: Container(
                      width: 200,
                      height: 200,
                      color: Colors.blue,
                    ),
                  ),
                ),
              ],
            ),
            Container(
              width: RDeviceUtils.getScreenWidth(context),
              height: 300, // Ensure that the container has an explicit height
              child: Obx(
                () => SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: List.generate(
                      controller.featuredProf.length,
                      (index) => RDoctorCardVertical(
                        professional: controller.featuredProf[index],
                      ),
                    ),
                  ),
                ),
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
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: RSizes.gridViewSpacing,
                        crossAxisSpacing: RSizes.gridViewSpacing,
                        mainAxisExtent: 288,
                      ),
                      itemBuilder: (_, index) => RDoctorCardVertical(
                            professional: controller.featuredProf[index],
                          ))),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
