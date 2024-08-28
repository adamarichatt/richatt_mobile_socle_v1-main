import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:richatt_mobile_socle_v1/common/widgets/custom_shapes/containers/rounded_image.dart';
import 'package:intl/intl.dart';
import 'package:richatt_mobile_socle_v1/features/richatt/controllers/professionalController.dart';
import 'package:richatt_mobile_socle_v1/features/richatt/models/Schedule.dart';
import 'package:richatt_mobile_socle_v1/features/richatt/models/professional.dart';
import 'package:richatt_mobile_socle_v1/features/richatt/screens/home/widgets/professionalDetails.dart';
import 'package:richatt_mobile_socle_v1/features/richatt/screens/profile/controllers/profile_controller.dart';
import 'package:richatt_mobile_socle_v1/utils/constants/image_strings.dart';
import 'package:richatt_mobile_socle_v1/utils/helpers/helper_functions.dart';
import 'package:richatt_mobile_socle_v1/features/richatt/controllers/FavoriteController.dart';

class ProfileCard extends StatelessWidget {
  const ProfileCard({
    super.key,
    required this.professional,
    required this.emailCustomer,
  });

  final Professional professional;
  final String emailCustomer;
  @override
  Widget build(BuildContext context) {
    final controller = ProfessionalController.instance;
    final dark = RHelperFunctions.isDarkMode(context);
    final ProfileController customer = Get.put(ProfileController());
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
        width: RHelperFunctions.screenWidth(),
        height: 130,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Color(0x7FC5C5C5), width: 0.5),
          borderRadius: BorderRadius.circular(28),
        ),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: RRoundedImage(
                  imageUrl: RImages.doctor1,
                  applyImageRadius: true,
                  width: 80,
                  height: 90,
                  fit: BoxFit.fill,
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(
                      '${professional.firstName} ${professional.name}',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      professional.businessSector ?? 'N/A',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 10,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    Text(
                      professional.entityName ?? 'N/A',
                      style: TextStyle(
                        color: Color(0xFF0B9AD3),
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    // FutureBuilder pour afficher la prochaine disponibilité
                    FutureBuilder<Schedule?>(
                      future: controller.getNextAvailability(professional.id!),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Text('Chargement...');
                        } 
                        // else if (snapshot.hasError) {
                        //   return Text(
                        //       'Erreur de chargement des disponibilités');
                        // }
                         else if (snapshot.hasData && snapshot.data != null) {
                          // Extraire et formater la date
                          String datePart =
                              snapshot.data!.dateTime.split('T').first;
                          DateTime parsedDate = DateTime.parse(datePart);
                          String formattedDate =
                              DateFormat('dd/MM/yyyy').format(parsedDate);

                          return Text(
                            'Prochaine disponibilité: Le $formattedDate',
                            style: TextStyle(
                              color: Colors.green,
                              fontSize: 10,
                              fontWeight: FontWeight.w400,
                            ),
                          );
                        } else {
                          return Text(
                            'Pas de disponibilité prochaine!',
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: 10,
                              fontWeight: FontWeight.w400,
                            ),
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 1, horizontal: 5),
              child: Column(
                children: [
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
                  SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Container(
                      child: Center(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Color(0xD6D9E1E7),
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Text(
                    '+10 Years of Experience',
                    style: TextStyle(
                      color: Color(0xFF848482),
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
