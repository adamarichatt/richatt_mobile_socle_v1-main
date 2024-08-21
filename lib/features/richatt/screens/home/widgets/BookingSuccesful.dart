import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:richatt_mobile_socle_v1/features/richatt/screens/home/widgets/AppointmentDetailsPage.dart';
import 'package:richatt_mobile_socle_v1/features/richatt/screens/home/widgets/home.dart';
import 'package:richatt_mobile_socle_v1/navigation_menu.dart';
import 'package:richatt_mobile_socle_v1/utils/constants/image_strings.dart';
import 'package:richatt_mobile_socle_v1/utils/device/device_utility.dart';
import 'package:richatt_mobile_socle_v1/features/richatt/models/Appointment.dart';
import 'package:richatt_mobile_socle_v1/features/richatt/models/professional.dart';

class BookingSuccessful extends StatelessWidget {
  final Appointment appointment;
  BookingSuccessful({required this.appointment});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false, // Prevent going back
      child: Scaffold(
        appBar: AppBar(
          title: Text('Confirmation'),
          automaticallyImplyLeading: false, // Remove back button
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 100),
              Image.asset(RImages.confrim),
              SizedBox(height: 30),
              Text(
                'Booking Successful',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text:
                            'You have successfully booked an appointment with\n\n',
                        style: TextStyle(
                          color: Colors.black.withOpacity(0.5),
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      TextSpan(
                        text:
                            ' Dr ${appointment.professional!.firstName} ${appointment.professional!.name}',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              Padding(
                padding: EdgeInsets.all(20.0),
                child: Row(
                  children: [
                    Icon(
                      Iconsax.user,
                      color: Color(0xFF0B9AD3),
                    ),
                    Text(
                      '${appointment.firstName} ${appointment.lastName}',
                      style: TextStyle(
                        color: Color(0xFF0B9AD3),
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(
                      width: 100,
                    ),
                    Icon(
                      Iconsax.location,
                      color: Color(0xFF0B9AD3),
                    ),
                    Text(
                      '${appointment.address}',
                      style: TextStyle(
                        color: Color(0xFF0B9AD3),
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.all(20.0),
                child: Row(
                  children: [
                    Icon(
                      Iconsax.calendar,
                      color: Color(0xFF0B9AD3),
                    ),
                    Text(
                      '${appointment.dateTime!.split('T').first}',
                      style: TextStyle(
                        color: Color(0xFF0B9AD3),
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(
                      width: 80,
                    ),
                    Icon(
                      Iconsax.clock,
                      color: Color(0xFF0B9AD3),
                    ),
                    Text(
                      '${appointment.dateTime!.split('T').last.split('-').first}',
                      style: TextStyle(
                        color: Color(0xFF0B9AD3),
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              ElevatedButton(
                onPressed: () {
                  Get.offAll(() => AppointmentDetailsPage(
                        appointment: appointment,
                      ));
                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(100),
                  ),
                  backgroundColor: Color(0xFF0B9AD3),
                ),
                child: Container(
                  width: RDeviceUtils.getScreenWidth(context) - 20,
                  padding: EdgeInsets.all(1),
                  child: Text(
                    'View Appointment',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              ElevatedButton(
                onPressed: () {
                  Get.offAll(() => NavigationMenu(), popGesture: false);
                },
                style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(100),
                    ),
                    backgroundColor: Colors.white),
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
              SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }
}
