import 'package:get/get.dart';
import 'package:richatt_mobile_socle_v1/features/richatt/models/professional.dart';
import 'package:richatt_mobile_socle_v1/features/richatt/controllers/professionalController.dart';
import 'package:richatt_mobile_socle_v1/features/richatt/screens/profile/controllers/profile_controller.dart';

class FavoriteController extends GetxController {
  static FavoriteController get instance => Get.find();
  var favoriteProfessionals = <Professional>[].obs;
  final ProfileController profileController = Get.find();
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
}
