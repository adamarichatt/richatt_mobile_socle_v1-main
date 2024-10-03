import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:Remeet/features/richatt/controllers/FavoriteController.dart';
import 'package:Remeet/features/richatt/controllers/professionalController.dart';
import 'package:Remeet/features/richatt/models/professional.dart';
import 'package:Remeet/common/widgets/doctor/RProfileCard.dart';

class FavoriteProfessionalsPage extends StatelessWidget {
  final String emailCustomer;
  const FavoriteProfessionalsPage({required this.emailCustomer});

  @override
  Widget build(BuildContext context) {
    final favoriteController = Get.put(FavoriteController());

    return Scaffold(
      appBar: AppBar(
        title: Text('Favorite Professionals'),
      ),
      body: Obx(() {
        Set<Professional> favoriteProfessionals =
            favoriteController.favoriteProfessionals;

        if (favoriteProfessionals.isEmpty) {
          return Center(
            child: Text('No favorite professionals yet.'),
          );
        }

        return ListView.builder(
          itemCount: favoriteProfessionals.length,
          itemBuilder: (context, index) {
            Professional professional =
                favoriteProfessionals.elementAt(index); // Utilisation de Set
            return ProfileCard(
                professional: professional, emailCustomer: emailCustomer);
          },
        );
      }),
    );
  }
}
