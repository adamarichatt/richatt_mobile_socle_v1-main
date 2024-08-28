import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:richatt_mobile_socle_v1/common/widgets/custom_shapes/containers/rounded_image.dart';
import 'package:richatt_mobile_socle_v1/features/richatt/controllers/professionalController.dart';
import 'package:richatt_mobile_socle_v1/features/richatt/models/professional.dart';
import 'package:richatt_mobile_socle_v1/features/richatt/screens/home/widgets/professionalDetails.dart';
import 'package:richatt_mobile_socle_v1/features/richatt/screens/profile/controllers/profile_controller.dart';
import 'package:richatt_mobile_socle_v1/generated/l10n.dart';
import 'package:richatt_mobile_socle_v1/utils/constants/image_strings.dart';
import 'package:richatt_mobile_socle_v1/utils/constants/sizes.dart';
import 'package:richatt_mobile_socle_v1/utils/helpers/helper_functions.dart';
import 'package:richatt_mobile_socle_v1/features/richatt/controllers/FavoriteController.dart';

class ProfileCardVertical extends StatelessWidget {
  ProfileCardVertical({
    super.key,
    required this.professional,
    required this.emailCustomer,
  });
  final Professional professional;
  final String emailCustomer;
  var image64;
  @override
  Widget build(BuildContext context) {
    final controller = ProfessionalController.instance;
    final dark = RHelperFunctions.isDarkMode(context);
    final ProfileController customer = Get.put(ProfileController());
    try {
      if (professional.imageUrl != null) {
        image64 =
            base64Decode(professional.imageUrl?.split(',').last as String);
      }
    } catch (e) {
      print('Erreur lors de la conversion de l\'image: $e');
      image64 = '';
    }
    final favoriteController = Get.put(FavoriteController());
    // Appeler getCustomerByEmail lors de l'initialisation de la page
    WidgetsBinding.instance.addPostFrameCallback((_) {
      customer.getCustomerByEmail(emailCustomer);
    });

    return GestureDetector(
      onTap: () async {
        await controller.getProfessionalById(professional.id!);
        Get.to(() => ProfessionalDetailsPage(
              professionalId: professional.id!,
              professional: professional,
              emailCustomer: emailCustomer,
            ));
      },
      child: Container(
        width: 157,
        padding: const EdgeInsets.all(RSizes.sm),
        decoration: BoxDecoration(
          border: Border.all(color: Color(0xFFC5C5C5)),
          borderRadius: BorderRadius.circular(28),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(2.0),
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
                  Obx(() {
                    bool isFavorite =
                        favoriteController.isFavorite(professional);
                    return IconButton(
                      icon: Icon(
                        isFavorite ? Iconsax.heart5 : Iconsax.heart,
                        color: isFavorite ? Colors.blue : Colors.grey,
                        size: 16,
                      ),
                      onPressed: () async {
                        await favoriteController.toggleFavorite(
                            professional, customer.customerId.value);
                      },
                    );
                  }),
                ],
              ),
            ),
            Container(
              child: RRoundedImage(
                  imageUrl: RImages.doctor1,
                  imageProvider: image64 != null
                      ? MemoryImage(image64)
                      : AssetImage(RImages.doctor1) as ImageProvider,
                  applyImageRadius: true,
                  width: 60,
                  height: 60,
                  fit: BoxFit.fill,
                  borderRadius: 100),
            ),
            SizedBox(height: 12),
            Text(
              '${professional.firstName} ${professional.name}',
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
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
              professional.businessSector ?? 'N/A',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.black.withOpacity(0.5),
                fontSize: 12,
                fontFamily: 'Nunito',
                fontWeight: FontWeight.w400,
                letterSpacing: -0.23,
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Container(
              width: 125,
              height: 40,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
              decoration: BoxDecoration(
                color: Color(0xFF0B9AD3),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Text(
                  S.of(context).Schedule,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontFamily: 'FONTSPRING DEMO - Proxima Nova',
                    fontWeight: FontWeight.w700,
                    height: 0,
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
