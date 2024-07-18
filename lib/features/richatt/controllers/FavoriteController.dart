import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:richatt_mobile_socle_v1/features/richatt/models/professional.dart';
import 'package:richatt_mobile_socle_v1/features/richatt/controllers/professionalController.dart';
import 'package:richatt_mobile_socle_v1/utils/constants/api_constants.dart';

class FavoriteController extends GetxController {
  static FavoriteController get instance => Get.find();
  var favoriteProfessionals = <Professional>{}.obs;  // Using a list instead of a set

  final ProfessionalController professionalController = Get.find();

  bool isFavorite(Professional professional) {
    return favoriteProfessionals.any((fav) => fav.id == professional.id);
  }

  Future<void> toggleFavorite(Professional professional, String idCustomer) async {
    if (isFavorite(professional)) {
      await professionalController.removeFavoriteProfessional(idCustomer, professional);
      favoriteProfessionals.removeWhere((fav) => fav.id == professional.id);
    } else {
      await professionalController.addFavoriteProfessional(idCustomer, professional);
      favoriteProfessionals.add(professional);
    }
  }

   Future<void> getFavoriteProfessionals(String email) async {
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiJtZWRtYWhtb3VkZGplYmJhQGdtYWlsLmNvbSIsImlhdCI6MTcxNjg5ODI0MywiZXhwIjoxNzE2ODk4MzQzfQ.Jqp0yPyEcaf27htb3tB3HK5Jui8X9VeflGru1S6X2ScpqFV6lYQeqoAgU0Jq3QCDfrPo4lUF_pmw'
    };

    var url = Uri.parse(APIConstants.apiBackend + 'customer/$email/favorites');

    try {
      http.Response response = await http.get(url, headers: headers);

      if (response.statusCode == 200) {
        final List<dynamic> responseData = json.decode(response.body);
        favoriteProfessionals.assignAll(
          responseData.map((data) => Professional.fromJson(data)).toSet()
        );
      } else {
        throw Exception('Failed to load favorite professionals');
      }
    } catch (error) {
      showDialog(
        context: Get.context!,
        builder: (context) {
          return SimpleDialog(
            title: const Text('Error'),
            contentPadding: const EdgeInsets.all(20),
            children: [Text(error.toString())],
          );
        },
      );
    }
  }
}
