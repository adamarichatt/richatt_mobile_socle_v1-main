import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:richatt_mobile_socle_v1/common/widgets/custom_shapes/containers/rounded_image.dart';

import 'package:richatt_mobile_socle_v1/features/richatt/controllers/professionalController.dart';
import 'package:richatt_mobile_socle_v1/features/richatt/models/professional.dart';
import 'package:richatt_mobile_socle_v1/features/richatt/screens/home/widgets/professionalDetails.dart';
import 'package:richatt_mobile_socle_v1/utils/constants/image_strings.dart';
import 'package:richatt_mobile_socle_v1/utils/constants/sizes.dart';
import 'package:richatt_mobile_socle_v1/utils/helpers/helper_functions.dart';

class ProfileCardVertical extends StatelessWidget {
  const ProfileCardVertical({super.key, required this.professional});
  final Professional professional;

  @override
  Widget build(BuildContext context) {
    final controller = ProfessionalController.instance;
    final dark = RHelperFunctions.isDarkMode(context);
    return GestureDetector(
      onTap: () async {
        await controller.getProfessionalById(professional.id!);
        Get.to(() => ProfessionalDetailsPage(professionalId: professional.id!));
      },
      child: Container(
        width: 157,
        height: 222,
        padding: const EdgeInsets.all(RSizes.sm),
        decoration: BoxDecoration(
          border: Border.all(color: Color(0xFFC5C5C5)),
          borderRadius: BorderRadius.circular(28),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    child: Center(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Color(0xD6169774),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ),
                  FlutterLogo(size: 16),
                ],
              ),
            ),
            Container(
              child: RRoundedImage(
                  imageUrl: RImages.doctor1,
                  applyImageRadius: true,
                  width: 60,
                  height: 60,
                  fit: BoxFit.fill,
                  borderRadius: 100),
            ),
            SizedBox(height: 12),
            Text(
              'Dr. Savia Zein',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontFamily: 'Roboto',
                fontWeight: FontWeight.w500,
                letterSpacing: 0.64,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Pediatrician',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.black.withOpacity(0.5),
                fontSize: 12,
                fontFamily: 'Nunito',
                fontWeight: FontWeight.w400,
                letterSpacing: -0.23,
              ),
            ),
            Spacer(),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Color(0xFF0B9AD3),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    'Book Now',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontFamily: 'FONTSPRING DEMO - Proxima Nova',
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
