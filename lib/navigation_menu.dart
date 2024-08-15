import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:richatt_mobile_socle_v1/features/richatt/screens/camera/camera.dart';
import 'package:richatt_mobile_socle_v1/features/richatt/screens/profile/widgets/profile.dart';
import 'package:richatt_mobile_socle_v1/features/richatt/screens/home/widgets/home.dart';
import 'package:richatt_mobile_socle_v1/features/richatt/screens/home/widgets/AppointmentsList.dart';
import 'package:richatt_mobile_socle_v1/generated/l10n.dart';
import 'package:richatt_mobile_socle_v1/utils/constants/colors.dart';
import 'package:richatt_mobile_socle_v1/utils/helpers/helper_functions.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NavigationMenu extends StatelessWidget {
  const NavigationMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(NavigationController());
    final darkMode = RHelperFunctions.isDarkMode(context);
    return Scaffold(
      bottomNavigationBar: Obx(
        () => NavigationBar(
          height: 80,
          elevation: 0,
          selectedIndex: controller.selectIndex.value,
          onDestinationSelected: (index) =>
              controller.selectIndex.value = index,
          backgroundColor: darkMode ? RColors.black : Colors.white,
          indicatorColor: darkMode
              ? RColors.white.withOpacity(0.1)
              : Colors.black.withOpacity(0.1),
          destinations: [
            NavigationDestination(
                icon: Icon(Iconsax.home), label: S.of(context).Home),
            NavigationDestination(
                icon: Icon(Iconsax.calendar), label: S.of(context).rdvs),
            NavigationDestination(
                icon: Icon(Iconsax.user), label: S.of(context).Profile),
          ],
        ),
      ),
      body: Obx(() => controller.isLoading.value
          ? Center(child: CircularProgressIndicator())
          : controller.screens[controller.selectIndex.value]),
    );
  }
}

class NavigationController extends GetxController {
  final Rx<int> selectIndex = 0.obs;
  final RxBool isLoading = true.obs; // Variable d'état de chargement

  final screens = <Widget>[
    Center(child: CircularProgressIndicator()), // Écran de chargement initial
    Center(child: CircularProgressIndicator()),
    Center(child: CircularProgressIndicator()),
  ];

  @override
  void onInit() {
    super.onInit();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? email = prefs.getString('email');
    String? phone = prefs.getString('phone');

    if (email != null && phone != null) {
      screens[0] = HomeScreen(email: email);
      screens[1] = AppointmentsList(email: email, phone: phone);
      screens[2] = ProfilePage(email: email);
      debugPrint('User data loaded: email=$email, phone=$phone');
    } else {
      screens[0] = Container(child: Center(child: Text('User not found')));
      screens[1] = Container(child: Center(child: Text('User info not found')));
      screens[2] =
          Container(child: Center(child: Text('User email not found')));
    }
    isLoading.value = false; // Les données sont chargées, mise à jour de l'état
  }
}
