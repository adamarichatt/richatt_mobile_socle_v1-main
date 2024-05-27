import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:richatt_mobile_socle_v1/features/richatt/screens/camera/camera.dart';
import 'package:richatt_mobile_socle_v1/features/richatt/screens/profile/widgets/profile.dart';
import 'package:richatt_mobile_socle_v1/features/richatt/screens/home/widgets/home.dart';
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
          destinations: const [
            NavigationDestination(icon: Icon(Iconsax.home), label: 'Home'),
            NavigationDestination(icon: Icon(Iconsax.calendar), label: 'RV'),
            NavigationDestination(
                icon: Icon(Iconsax.favorite_chart1), label: 'favorite'),
            NavigationDestination(icon: Icon(Iconsax.user), label: 'Profile'),
          ],
        ),
      ),
      body: Obx(() => controller.screens[controller.selectIndex.value]),
    );
  }
}

class NavigationController extends GetxController {
  final Rx<int> selectIndex = 0.obs;

  final screens = [
    const HomeScreen(),
    Container(color: Colors.purple),
    CameraScreen(),
  ];

  @override
  void onInit() {
    super.onInit();
    _loadUserEmail();
  }

  Future<void> _loadUserEmail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? email = prefs.getString('email');
    //debugPrint('email1' + email!);
    if (email != null) {
      screens.add(ProfilePage(email: email));
      debugPrint('email2' + email!);
    } else {
      // Handle the case where the email is not available
      screens
          .add(Container(child: Center(child: Text('User email not found'))));
    }
  }
}
