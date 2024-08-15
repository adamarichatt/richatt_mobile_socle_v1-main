import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:richatt_mobile_socle_v1/features/richatt/controllers/professionalController.dart';
import 'package:richatt_mobile_socle_v1/features/richatt/models/professional.dart';
import 'package:richatt_mobile_socle_v1/features/richatt/screens/home/widgets/AppointmentPage.dart';
import 'package:richatt_mobile_socle_v1/features/richatt/models/service.dart';
import 'package:richatt_mobile_socle_v1/features/richatt/models/Schedule.dart';
import 'package:richatt_mobile_socle_v1/common/widgets/custom_shapes/containers/rounded_image.dart';
import 'package:richatt_mobile_socle_v1/utils/constants/image_strings.dart';
import 'package:richatt_mobile_socle_v1/utils/constants/sizes.dart';

class ProfessionalDetailsPage extends StatelessWidget {
  final String professionalId;
  final Professional professional;

  ProfessionalDetailsPage(
      {required this.professionalId, required this.professional});

  @override
  Widget build(BuildContext context) {
    final controller = ProfessionalController.instance;

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
                    image: AssetImage(RImages.doctor1),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              // Add some space to ensure the button does not overlap the second container
              Container(
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
                            '${professional.firstName} ${professional.name}',
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 24,
                              fontFamily: 'Roboto',
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            professional.businessSector ?? 'N/A',
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
                          width: 30,
                        ),
                        Icon(Iconsax.share),
                        SizedBox(
                          width: 30,
                        ),
                        Icon(Iconsax.heart),
                        SizedBox(
                          width: 15,
                        ),
                      ],
                    ),
                  ],
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
                                professional.address ?? 'N/A',
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
                        professional.presentation ?? 'N/A',
                        textAlign: TextAlign.justify,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                          fontFamily: 'Roboto',
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
            RRoundedImage(
              imageUrl: RImages.doctor1,
              applyImageRadius: true,
            ),
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
