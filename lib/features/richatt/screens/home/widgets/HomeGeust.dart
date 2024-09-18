import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:richatt_mobile_socle_v1/common/widgets/custom_shapes/containers/search_container.dart';
import 'package:richatt_mobile_socle_v1/common/widgets/doctor/RProfileCard.dart';
import 'package:richatt_mobile_socle_v1/features/richatt/controllers/professionalController.dart';
import 'package:richatt_mobile_socle_v1/features/richatt/screens/home/widgets/home_appb.dart';
import 'package:richatt_mobile_socle_v1/generated/l10n.dart';
import 'package:richatt_mobile_socle_v1/utils/constants/sizes.dart';
import 'package:richatt_mobile_socle_v1/utils/device/device_utility.dart';

class HomeGeustScreen extends StatelessWidget {
  const HomeGeustScreen();

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ProfessionalController());

    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.getProf();
    });

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            RHomeAppBar(),
            SizedBox(height: RSizes.spaceBtwSections),
            RSearchContainer(
              text: S.of(context).search,
              emailCustomer: '',
            ),
            SizedBox(height: RSizes.spaceBtwSections),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 2.0,
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        S.of(context).available_now,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.w500,
                          letterSpacing: -0.38,
                        ),
                      ),
                      Text(
                        S.of(context).SeeAll,
                        style: TextStyle(
                          color: Color(0xFF0B9AD3),
                          fontSize: 14,
                          fontFamily: 'Nunito',
                          fontWeight: FontWeight.w400,
                          letterSpacing: -0.27,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: RSizes.spaceBtwItems),
                  Obx(() => ListView.builder(
                        itemCount: controller.featuredProf.length,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (_, index) => Padding(
                          padding:
                              EdgeInsets.only(bottom: RSizes.spaceBtwItems),
                          child: ProfileCard(
                            professional: controller.featuredProf[index],
                            emailCustomer: '',
                          ),
                        ),
                      )),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
