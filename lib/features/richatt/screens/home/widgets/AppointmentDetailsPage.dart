import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';
import 'package:richatt_mobile_socle_v1/common/widgets/custom_shapes/containers/rounded_image.dart';
import 'package:richatt_mobile_socle_v1/features/richatt/models/Appointment.dart';
import 'package:richatt_mobile_socle_v1/generated/l10n.dart';
import 'package:richatt_mobile_socle_v1/navigation_menu.dart';
import 'package:richatt_mobile_socle_v1/utils/constants/image_strings.dart';
import 'package:richatt_mobile_socle_v1/utils/device/device_utility.dart';

class AppointmentDetailsPage extends StatelessWidget {
  final Appointment appointment;
  var image64;
  AppointmentDetailsPage({required this.appointment});

  @override
  Widget build(BuildContext context) {
    List<String> dateTimeParts = appointment.dateTime!.split('T');
    String datePart = dateTimeParts.first;
    String timePart = dateTimeParts.last.split('-').first;
    String combinedDateTime = '$datePart $timePart';

    DateTime dateTime = DateTime.parse(combinedDateTime);
    final formattedDate = DateFormat('dd/MM/yyyy').format(dateTime);
    final formattedTime = DateFormat('HH:mm').format(dateTime);
    try {
      if (appointment.professional!.imageUrl != null) {
        image64 = base64Decode(
            appointment.professional!.imageUrl?.split(',').last as String);
      }
    } catch (e) {
      print('Erreur lors de la conversion de l\'image: $e');
      image64 = '';
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Détails du Rendez-vous'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section des informations du professionnel
            Container(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  // Image du professionnel
                  Container(
                    width: 100,
                    height: 100,
                    child: RRoundedImage(
                      imageUrl: RImages.doctor1,
                      imageProvider: image64 != null
                          ? MemoryImage(image64)
                          : AssetImage(RImages.doctor1) as ImageProvider,
                      applyImageRadius: true,
                    ),
                  ),
                  SizedBox(width: 16),
                  // Informations du professionnel
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Dr. ${appointment.professional!.firstName} ${appointment.professional!.name}',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 24,
                            fontFamily: 'Roboto',
                            fontWeight: FontWeight.w500,
                            letterSpacing: -0.24,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          '${appointment.professional!.businessSector!}',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontFamily: 'Nunito',
                            fontWeight: FontWeight.w400,
                            letterSpacing: -0.27,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          '${appointment.professional!.entityName!} - ${appointment.professional!.address!}',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontFamily: 'Nunito',
                            fontWeight: FontWeight.w400,
                            letterSpacing: -0.27,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16),
            // Divider
            Divider(
              color: Colors.grey[300],
              thickness: 1,
            ),
            SizedBox(height: 16),
            // Section des informations du rendez-vous
            Container(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildInfoRow(S.of(context).patient,
                      '${appointment.firstName} ${appointment.lastName}'),
                  _buildInfoRow(S.of(context).date, formattedDate),
                  _buildInfoRow(S.of(context).heure, formattedTime),
                  _buildInfoRow(
                      S.of(context).duree, '${appointment.duration} minutes'),
                  _buildInfoRow(S.of(context).service, appointment.reason!),
                ],
              ),
            ),

            SizedBox(
              height: 10,
            ),
            ElevatedButton(
              onPressed: () {
                Get.offAll(() => NavigationMenu());
              },
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(100),
                ),
                backgroundColor: Colors.white,
              ),
              child: Container(
                width: RDeviceUtils.getScreenWidth(context) - 20,
                padding: EdgeInsets.all(1),
                child: Text(
                  'Go to Home',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFF0B9AD3),
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          children: [
            Text(
              label,
              style: TextStyle(
                color: Colors.black.withOpacity(0.5),
                fontSize: 14,
                fontFamily: 'Nunito',
                fontWeight: FontWeight.w600,
                letterSpacing: -0.27,
              ),
            ),
          ],
        ),
        // Espacement entre l'étiquette et la valeur

        Column(
          children: [
            Text(
              value,
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontFamily: 'Roboto',
                fontWeight: FontWeight.w500,
                letterSpacing: -0.16,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
