import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:richatt_mobile_socle_v1/features/richatt/controllers/professionalController.dart';
import 'package:richatt_mobile_socle_v1/features/richatt/models/professional.dart';
import 'package:richatt_mobile_socle_v1/features/richatt/screens/home/widgets/AppointmentPage.dart';
import 'package:richatt_mobile_socle_v1/features/richatt/models/service.dart';
import 'package:richatt_mobile_socle_v1/features/richatt/models/schedule.dart';
import 'package:richatt_mobile_socle_v1/common/widgets/custom_shapes/containers/rounded_image.dart';
import 'package:richatt_mobile_socle_v1/utils/constants/image_strings.dart';

class ProfessionalDetailsPage extends StatelessWidget {
  final String professionalId;
  final Professional professional;

  ProfessionalDetailsPage({required this.professionalId, required this.professional });

  @override
  Widget build(BuildContext context) {
    final controller = ProfessionalController.instance;

    return Scaffold(
      appBar: AppBar(
        title: Text('Professional Details'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildTopSection(context, controller),
            _buildBottomSection(context, controller),
          ],
        ),
      ),
    );
  }

  Widget _buildTopSection(BuildContext context, ProfessionalController controller) {
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
            Text(professional.businessSector ?? 'N/A', style: TextStyle(fontSize: 16)),
          ],
        ),
      );
    });
  }

  Widget _buildBottomSection(BuildContext context, ProfessionalController controller) {
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

  Widget _buildAboutTab(BuildContext context, ProfessionalController controller) {
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
            Text('Email: ${professional.email ?? 'N/A'}', style: TextStyle(fontSize: 16)),
            SizedBox(height: 8),
            Text('Phone: ${professional.phone ?? 'N/A'}', style: TextStyle(fontSize: 16)),
            SizedBox(height: 8),
            Text('Address: ${professional.address ?? 'N/A'}', style: TextStyle(fontSize: 16)),
            SizedBox(height: 8),
            Text('Presentation: ${professional.presentation ?? 'N/A'}', style: TextStyle(fontSize: 16)),
            SizedBox(height: 16),
            Text('Services', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            _buildServicesList(context, controller, professional.id!),
          ],
        ),
      );
    });
  }

 Widget _buildAvailabilityTab(BuildContext context, ProfessionalController controller, String professionalId) {
  return Center(
      child:  ElevatedButton(
        onPressed: () {
          Get.to(() => AppointmentPage( professionalId: professionalId, professional: professional));
        },
        child: Text('Prendre un rendez-vous'),
      ),
    );
}

}

Widget _buildServicesList(BuildContext context, ProfessionalController controller, String professionalId) {
  return FutureBuilder(
    future: controller.getServicesByProfessional(professionalId),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return Center(child: CircularProgressIndicator());
      } else if (snapshot.hasError) {
        return Center(child: Text('Error: ${snapshot.error}'));
      } else if (!snapshot.hasData || (snapshot.data as List<Service>).isEmpty) {
        return Center(child: Text('No services available'));
      } else {
        List<Service> services = snapshot.data as List<Service>;
        return Wrap(
          spacing: 8.0, // Espace horizontal entre les boutons
          runSpacing: 8.0, // Espace vertical entre les lignes de boutons
          children: services.map((service) {
            return ElevatedButton(
              onPressed: () {},
              child: Text(service.name),
            );
          }).toList(),
        );
      }
    },
  );
}
