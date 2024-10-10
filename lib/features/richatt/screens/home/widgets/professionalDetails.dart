import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:Remeet/features/richatt/controllers/FavoriteController.dart';
import 'package:Remeet/features/richatt/controllers/professionalController.dart';
import 'package:Remeet/features/richatt/models/professional.dart';
import 'package:Remeet/features/richatt/screens/home/widgets/AppointmentPage.dart';
import 'package:Remeet/features/richatt/models/service.dart';
import 'package:Remeet/features/richatt/screens/profile/controllers/profile_controller.dart';
import 'package:Remeet/utils/constants/image_strings.dart';
import 'package:Remeet/utils/constants/sizes.dart';

class ProfessionalDetailsPage extends StatelessWidget {
  final String professionalId;
  final Professional professional;
  final String emailCustomer;
  var image64;
  ProfessionalDetailsPage({
    required this.professionalId,
    required this.professional,
    required this.emailCustomer,
  });

  @override
  Widget build(BuildContext context) {
    final controller = ProfessionalController.instance;
    try {
      if (professional.imageUrl != null) {
        image64 =
            base64Decode(professional.imageUrl?.split(',').last as String);
      }
    } catch (e) {
      print('Erreur lors de la conversion de l\'image: $e');
      image64 = '';
    }
    //image64 = base64Decode(professional.imageUrl?.split(',').last as String);
    final favoriteController = Get.put(FavoriteController());
    final ProfileController customer = Get.put(ProfileController());
    // Appeler getCustomerByEmail lors de l'initialisation de la page
    WidgetsBinding.instance.addPostFrameCallback((_) {
      customer.getCustomerByEmail(emailCustomer);
    });

    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
          child: Stack(
        clipBehavior: Clip.none, // To allow overflow of Positioned widget
        children: [
          Column(
            children: [
              Container(
                width: double.infinity,
                height: 250,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: image64 != null
                        ? MemoryImage(image64)
                        : AssetImage(RImages.doctor1) as ImageProvider,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              // Add some space to ensure the button does not overlap the second container
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  padding: EdgeInsets.fromLTRB(0, 30, 0, 0),
                  width: double.infinity,
                  height: 100.0,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.elliptical(20, 10),
                      bottomRight: Radius.elliptical(10, 20),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Dr. ${professional.firstName} ${professional.name}',
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 24,
                                fontFamily: 'Roboto',
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              '${professional.businessSector}',
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                                fontFamily: 'Nunito',
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(
                            width: 15,
                          ),
                          IconButton(
                            icon: Icon(
                              Iconsax.share,
                              size: 28,
                            ),
                            onPressed: () {},
                          ),
                          SizedBox(
                            width: 1,
                          ),
                          Obx(() {
                            bool isFavorite =
                                favoriteController.isFavorite(professional);
                            return IconButton(
                              icon: Icon(
                                isFavorite ? Iconsax.heart5 : Iconsax.heart,
                                color: isFavorite ? Colors.blue : Colors.grey,
                                size: 28,
                              ),
                              onPressed: () async {
                                await favoriteController.toggleFavorite(
                                    professional, customer.customerId.value);
                              },
                            );
                          }),
                          SizedBox(
                            width: 1,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Divider(
                        indent: 10,
                        endIndent: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Row(
                            children: [
                              Icon(Iconsax.location),
                              Text(
                                '${professional.entityName} - ${professional.address}',
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 14,
                                  fontFamily: 'Nunito',
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Icon(Icons.badge),
                              Text(
                                'Since 1998',
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 14,
                                  fontFamily: 'Nunito',
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Divider(
                        indent: 10,
                        endIndent: 10,
                      ),
                      Text(
                        'Biography',
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 24,
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        '${professional.presentation}',
                        textAlign: TextAlign.justify,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                          fontFamily: 'Nunito',
                          fontWeight: FontWeight.w400,
                          letterSpacing: -0.27,
                        ),
                      ),
                      Text(
                        'Language Spoken',
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 24,
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(
                        height: RSizes.spaceBtwItems,
                      ),
                      Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 10),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Color(0xFF0B9AD3),
                                    width: 1,
                                  ),
                                  borderRadius: BorderRadius.circular(28),
                                ),
                                child: Text(
                                  'French',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Color(0xFF0B9AD3),
                                    fontSize: 16,
                                    fontFamily:
                                        'FONTSPRING DEMO - Proxima Nova',
                                    fontWeight: FontWeight.w700,
                                    height: 0,
                                  ),
                                )),
                            SizedBox(
                              width: 15.0,
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 10),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Color(0xFF0B9AD3),
                                  width: 1,
                                ),
                                borderRadius: BorderRadius.circular(28),
                              ),
                              child: Text(
                                'French',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Color(0xFF0B9AD3),
                                  fontSize: 16,
                                  fontFamily: 'FONTSPRING DEMO - Proxima Nova',
                                  fontWeight: FontWeight.w700,
                                  height: 0,
                                ),
                              ),
                            ),
                          ]),
                      SizedBox(
                        height: 15,
                      ),
                      Text(
                        'Services',
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 24,
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(
                        height: RSizes.spaceBtwItems,
                      ),
                      _buildServicesList(context, controller, professional.id!),
                    ],
                  ),
                ),
              ),

              // Placeholder for more content if needed
              // Adjust as needed for space below the second container
            ],
          ),
          Positioned(
            top:
                230, // Adjust this value to control the exact overlap on the first container
            left: 46, // Adjust as per your requirement
            right: 46, // Adjust as per your requirement
            child: SizedBox(
              // Set a specific width for the button
              child: ElevatedButton(
                onPressed: () {
                  Get.to(() => AppointmentPage(
                      professionalId: professionalId,
                      professional: professional));
                },
                child: Text(
                  'Prendre un rendez-vous',
                  style: TextStyle(fontSize: 16), // Smaller font size
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10), // Smaller padding
                ),
              ),
            ),
          ),
        ],
      )),
    );
  }

  Widget _buildTopSection(
      BuildContext context, ProfessionalController controller) {
    return Obx(() {
      final professional = controller.selectedProfessional.value;
      if (professional == null) {
        return Center(child: CircularProgressIndicator());
      }

      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            SizedBox(height: 12),
            Text(
              '${professional.firstName} ${professional.name}',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            SizedBox(height: 8),
            Text(professional.businessSector ?? 'N/A',
                style: TextStyle(fontSize: 16)),
          ],
        ),
      );
    });
  }

  Widget _buildBottomSection(
      BuildContext context, ProfessionalController controller) {
    return DefaultTabController(
      length: 2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TabBar(
            tabs: [
              Tab(text: 'About'),
              Tab(text: 'Availability'),
            ],
          ),
          Container(
            height: MediaQuery.of(context).size.height * 0.7,
            child: TabBarView(
              children: [
                _buildAboutTab(context, controller),
                _buildAvailabilityTab(context, controller, professionalId),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAboutTab(
      BuildContext context, ProfessionalController controller) {
    return Obx(() {
      final professional = controller.selectedProfessional.value;
      if (professional == null) {
        return Center(child: CircularProgressIndicator());
      }

      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Email: ${professional.email ?? 'N/A'}',
                style: TextStyle(fontSize: 16)),
            SizedBox(height: 8),
            Text('Phone: ${professional.phone ?? 'N/A'}',
                style: TextStyle(fontSize: 16)),
            SizedBox(height: 8),
            Text('Address: ${professional.address ?? 'N/A'}',
                style: TextStyle(fontSize: 16)),
            SizedBox(height: 8),
            Text('Presentation: ${professional.presentation ?? 'N/A'}',
                style: TextStyle(fontSize: 16)),
            SizedBox(height: 16),
            Text('Services',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            _buildServicesList(context, controller, professional.id!),
          ],
        ),
      );
    });
  }

  Widget _buildAvailabilityTab(BuildContext context,
      ProfessionalController controller, String professionalId) {
    return Center(
      child: ElevatedButton(
        onPressed: () {
          Get.to(() => AppointmentPage(
              professionalId: professionalId, professional: professional));
        },
        child: Text('Prendre un rendez-vous'),
      ),
    );
  }
}

Widget _buildServicesList(BuildContext context,
    ProfessionalController controller, String professionalId) {
  return FutureBuilder(
    future: controller.getServicesByProfessional(professionalId),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return Center(child: CircularProgressIndicator());
      } else if (snapshot.hasError) {
        return Center(child: Text('Error: ${snapshot.error}'));
      } else if (!snapshot.hasData ||
          (snapshot.data as List<Service>).isEmpty) {
        return Center(child: Text('No services available'));
      } else {
        List<Service> services = snapshot.data as List<Service>;
        return Wrap(
          spacing: 8.0, // Espace horizontal entre les boutons
          runSpacing: 8.0, // Espace vertical entre les lignes de boutons
          children: services.map((service) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Color(0xFF0B9AD3),
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(28),
              ),
              child: Text(
                service.name,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xFF0B9AD3),
                  fontSize: 16,
                  fontFamily: 'FONTSPRING DEMO - Proxima Nova',
                  fontWeight: FontWeight.w700,
                  height: 0,
                ),
              ),
            );
          }).toList(),
        );
      }
    },
  );
}
