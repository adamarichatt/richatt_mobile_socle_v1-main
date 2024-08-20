import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:richatt_mobile_socle_v1/common/widgets/custom_shapes/containers/primary_header_container.dart';
import 'package:richatt_mobile_socle_v1/common/widgets/custom_shapes/containers/search_container.dart';
import 'package:richatt_mobile_socle_v1/common/widgets/doctor/RProfileCard.dart';
import 'package:richatt_mobile_socle_v1/common/widgets/doctor/RProfileCardVertical.dart';
import 'package:richatt_mobile_socle_v1/common/widgets/doctor/RdoctorCardVertical.dart';
import 'package:richatt_mobile_socle_v1/features/richatt/controllers/FavoriteController.dart';
import 'package:richatt_mobile_socle_v1/features/richatt/controllers/professionalController.dart';
import 'package:richatt_mobile_socle_v1/features/richatt/screens/home/widgets/AppointmentDetailsPage.dart';
import 'package:richatt_mobile_socle_v1/features/richatt/screens/home/widgets/AppointmentsList.dart';
import 'package:richatt_mobile_socle_v1/features/richatt/screens/home/widgets/FavoriteProfessionalsPage.dart';
import 'package:richatt_mobile_socle_v1/features/richatt/screens/home/widgets/edit_appointment_page.dart';
import 'package:richatt_mobile_socle_v1/features/richatt/screens/home/widgets/home_appb.dart';
import 'package:richatt_mobile_socle_v1/generated/l10n.dart';
import 'package:richatt_mobile_socle_v1/utils/constants/image_strings.dart';

import 'package:richatt_mobile_socle_v1/utils/constants/sizes.dart';
import 'package:richatt_mobile_socle_v1/utils/device/device_utility.dart';
import 'package:richatt_mobile_socle_v1/utils/helpers/helper_functions.dart';

class HomeScreen extends StatelessWidget {
  final String email;
  final String phone;
  const HomeScreen({required this.email, required this.phone});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ProfessionalController());
    final FavoriteController favoriteController = Get.put(FavoriteController());
    // Appeler getCustomerByEmail lors de l'initialisation de la page
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.getProf();
      controller.getNextAppointmentByEmail(email);
      // controller.getFavoriteProfessionals(email);
      favoriteController.getFavoriteProfessionals(email);
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
                  emailCustomer: email,
                ),
                SizedBox(
                  height: RSizes.spaceBtwSections,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Upcoming Appointment',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.w500,
                          height: 0.07,
                          letterSpacing: -0.38,
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          print('InkWell tapped');
                          Get.to(() => AppointmentsList(
                                email: email,
                                phone: phone,
                              ));
                        },
                        child: Text(
                          'See All',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Color(0xFF0B9AD3),
                            fontSize: 14,
                            fontFamily: 'Nunito',
                            fontWeight: FontWeight.w400,
                            height: 0.11,
                            letterSpacing: -0.27,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: RSizes.spaceBtwSections,
                ),
                Obx(() {
                  if (controller.nextAppointment.value != null) {
                    final appointment = controller.nextAppointment.value!;

                    List<String> dateTimeParts =
                        appointment.dateTime!.split('T');
                    String datePart = dateTimeParts.first;
                    String timePart = dateTimeParts.last.split('-').first;
                    String combinedDateTime = '$datePart $timePart';

                    DateTime dateTime = DateTime.parse(combinedDateTime);
                    final formattedDate =
                        DateFormat('dd/MM/yyyy').format(dateTime);
                    final formattedTime = DateFormat('HH:mm').format(dateTime);

                    return Column(children: [
                      Stack(clipBehavior: Clip.none, children: [
                        Container(
                          width: 396,
                          height: 156,
                          padding: const EdgeInsets.symmetric(
                              vertical: 8, horizontal: 21),
                          decoration: BoxDecoration(
                            color: Color(0xFF0B9AD3),
                            borderRadius: BorderRadius.circular(28),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Next appointment',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontFamily: 'Nunito',
                                  fontWeight: FontWeight.w600,
                                  height: 1.2,
                                  letterSpacing: -0.38,
                                ),
                              ),
                              const SizedBox(height: 9),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Icon(Icons.circle,
                                              size: 16, color: Colors.white),
                                          const SizedBox(width: 7),
                                          Text(
                                            '$formattedDate ',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 16,
                                              fontFamily: 'Nunito',
                                              fontWeight: FontWeight.w500,
                                              height: 1.2,
                                              letterSpacing: -0.30,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 13),
                                      Row(
                                        children: [
                                          Icon(Icons.circle,
                                              size: 16, color: Colors.white),
                                          const SizedBox(width: 7),
                                          Text(
                                            '$formattedTime',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 16,
                                              fontFamily: 'Nunito',
                                              fontWeight: FontWeight.w500,
                                              height: 1.2,
                                              letterSpacing: -0.30,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  Spacer(),
                                  Row(
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.of(context)
                                              .push(MaterialPageRoute(
                                            builder: (context) =>
                                                EditAppointmentPage(
                                              appointment: appointment,
                                              email: email,
                                              phone: phone,
                                            ),
                                          ));
                                        },
                                        child: CircleAvatar(
                                          radius: 16,
                                          backgroundColor: Colors.white,
                                          child: Icon(
                                            Icons.edit,
                                            color: Color(0xFF0B9AD3),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 16),
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.of(context)
                                              .push(MaterialPageRoute(
                                            builder: (context) =>
                                                AppointmentDetailsPage(
                                              appointment: appointment,
                                            ),
                                          ));
                                        },
                                        child: CircleAvatar(
                                          radius: 16,
                                          backgroundColor: Colors.white,
                                          child: Icon(
                                            Icons.remove_red_eye_sharp,
                                            color: Color(0xFF0B9AD3),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Positioned(
                          bottom:
                              -31, // Positionné à moitié dans le premier Container
                          left: 59,
                          child: Container(
                            width: 278,
                            height: 62,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(28),
                              boxShadow: [
                                BoxShadow(
                                  color: Color(0x3F000000),
                                  blurRadius: 4,
                                  offset: Offset(0, 4),
                                  spreadRadius: 0,
                                )
                              ],
                            ),
                            child: Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Container(
                                    width: 42,
                                    height: 42,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(18),
                                      image: DecorationImage(
                                        image: AssetImage(RImages.doctor1),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Dr. ${appointment.professional!.firstName} ${appointment.professional!.name}',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 20,
                                        fontFamily: 'Roboto',
                                        fontWeight: FontWeight.w500,
                                        letterSpacing: 0.80,
                                      ),
                                    ),
                                    SizedBox(height: 5),
                                    Text(
                                      '${appointment.professional!.businessSector}',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Colors.black.withOpacity(0.5),
                                        fontSize: 14,
                                        fontFamily: 'Nunito',
                                        fontWeight: FontWeight.w400,
                                        letterSpacing: -0.27,
                                      ),
                                    ),
                                  ],
                                ),
                                Spacer(),
                                Padding(
                                  padding: const EdgeInsets.only(right: 16),
                                  child: FlutterLogo(size: 18),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 60,
                        ),
                      ]),
                    ]);
                  } else {
                    return Center(
                      child: Text(
                        S.of(context).no_upcoming_app,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    );
                  }
                }),
              ],
            ),
            SizedBox(
              height: 60,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    S.of(context).Favorite,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.w500,
                      height: 0.07,
                      letterSpacing: -0.38,
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      print('InkWell tapped');
                      Get.to(() =>
                          FavoriteProfessionalsPage(emailCustomer: email));
                    },
                    child: Text(
                      'See All',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color(0xFF0B9AD3),
                        fontSize: 14,
                        fontFamily: 'Nunito',
                        fontWeight: FontWeight.w400,
                        height: 0.11,
                        letterSpacing: -0.27,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 35,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Obx(
                () {
                  if (favoriteController.favoriteProfessionals.isEmpty) {
                    return Center(
                      child: Text(
                        'No favorites yet',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    );
                  } else {
                    return SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: List.generate(
                          favoriteController.favoriteProfessionals.length,
                          (index) => Padding(
                            padding: const EdgeInsets.only(
                                right: 16.0), // Espace entre les cartes
                            child: ProfileCardVertical(
                              professional: favoriteController
                                  .favoriteProfessionals
                                  .elementAt(index),
                              emailCustomer: email,
                            ),
                          ),
                        ),
                      ),
                    );
                  }
                },
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
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

                  // Add a small, controlled space
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
                        itemBuilder: (_, index) => ProfileCard(
                          professional: controller.featuredProf[index],
                          emailCustomer: email,
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
