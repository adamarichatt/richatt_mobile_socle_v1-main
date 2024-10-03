import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:Remeet/common/widgets/doctor/RProfileCard.dart';
import 'package:Remeet/features/richatt/controllers/professionalController.dart';

class SearchResultsView extends StatelessWidget {
  final String emailCustomer;
  const SearchResultsView({required this.emailCustomer});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ProfessionalController>();

    return Scaffold(
      appBar: AppBar(
        title: Text('Search Results'),
      ),
      body: Obx(() {
        if (controller.filteredProfessionals.isEmpty) {
          return Center(child: Text('No results found.'));
        }
        return ListView.builder(
          itemCount: controller.filteredProfessionals.length,
          itemBuilder: (context, index) {
            var professional = controller.filteredProfessionals[index];
            return ProfileCard(
              professional: professional,
              emailCustomer: emailCustomer,
            );
          },
        );
      }),
    );
  }
}
