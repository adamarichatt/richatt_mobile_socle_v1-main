import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:Remeet/features/richatt/screens/home/widgets/HomeGeust.dart';
import 'package:Remeet/features/richatt/screens/profile/widgets/profile.dart';
import 'package:Remeet/features/richatt/screens/home/widgets/home.dart';
import 'package:Remeet/features/richatt/screens/home/widgets/AppointmentsList.dart';
import 'package:Remeet/generated/l10n.dart';

import 'package:Remeet/utils/constants/colors.dart';
import 'package:Remeet/utils/helpers/helper_functions.dart';
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
    debugPrint('User data loaded1: email=$email, phone=$phone');

    if (email != null && phone != null) {
      debugPrint('User data loaded2: email=$email, phone=$phone');
      screens[0] = HomeScreen(email: email, phone: phone);
      screens[1] = AppointmentsList(email: email, phone: phone);
      screens[2] = ProfilePage(
        email: email,
        isGuest: false,
      );
    } else {
      screens[0] = HomeGeustScreen();
      screens[1] = Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: Text(
                    'vous devez vous connecter ou cree un compte ticket loading.....'),
              ),
            ],
          ),
        ),
      );
      screens[2] = ProfilePage(
        email: '',
        isGuest: true,
      );
    }
    isLoading.value = false; // Les données sont chargées, mise à jour de l'état
  }
}
