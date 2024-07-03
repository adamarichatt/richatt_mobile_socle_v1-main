import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:richatt_mobile_socle_v1/common/widgets/custom_shapes/containers/primary_header_container.dart';
import 'package:richatt_mobile_socle_v1/common/widgets/custom_shapes/containers/search_container.dart';
import 'package:richatt_mobile_socle_v1/common/widgets/doctor/RProfileCard.dart';
import 'package:richatt_mobile_socle_v1/common/widgets/doctor/RProfileCardVertical.dart';
import 'package:richatt_mobile_socle_v1/common/widgets/doctor/RdoctorCardVertical.dart';
import 'package:richatt_mobile_socle_v1/features/richatt/controllers/professionalController.dart';
import 'package:richatt_mobile_socle_v1/features/richatt/screens/home/widgets/AppointmentDetailsPage.dart';
import 'package:richatt_mobile_socle_v1/features/richatt/screens/home/widgets/home_appb.dart';

import 'package:richatt_mobile_socle_v1/utils/constants/sizes.dart';
import 'package:richatt_mobile_socle_v1/utils/device/device_utility.dart';
import 'package:richatt_mobile_socle_v1/utils/helpers/helper_functions.dart';

class HomeScreen extends StatelessWidget {
  final String email;
  const HomeScreen({required this.email});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ProfessionalController());

    // Appeler getCustomerByEmail lors de l'initialisation de la page
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.getProf();
      controller.getNextAppointmentByEmail(email);
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

Obx(() {
  final appointment = controller.nextAppointment.value;
  if (appointment != null) {
    List<String> dateTimeParts = appointment.dateTime!.split('T');
    String datePart = dateTimeParts.first;
    String timePart = dateTimeParts.last.split('-').first;
    String combinedDateTime = '$datePart $timePart';

    DateTime dateTime = DateTime.parse(combinedDateTime);
    final formattedDate = DateFormat('dd/MM/yyyy').format(dateTime);
    final formattedTime = DateFormat('HH:mm').format(dateTime);

    return InkWell(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => AppointmentDetailsPage(
            appointment: appointment,
          ),
        ));
      },
      child: Card(
        margin: EdgeInsets.all(8.0),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Upcoming appointment',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              Text('$formattedDate - $formattedTime',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              Text('Patient: ${appointment.firstName!} ${appointment.lastName!}',
                  style: TextStyle(fontSize: 16)),
              SizedBox(height: 8),
              Text('Dr: ${appointment.professional!.firstName} ${appointment.professional!.name}',
                  style: TextStyle(fontSize: 16)),
              SizedBox(height: 4),
              Text('Adresse: ${appointment.address!}',
                  style: TextStyle(fontSize: 14)),
              SizedBox(height: 8),
              Text('Service: ${appointment.reason!}',
                  style: TextStyle(fontSize: 14)),
              SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  } else {
    return Center(
      child: Text('No upcoming appointments',
          style: TextStyle(
              fontSize: 16, fontWeight: FontWeight.bold)),
    );
  }
}),


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
