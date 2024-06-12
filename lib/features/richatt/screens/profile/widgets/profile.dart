import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:richatt_mobile_socle_v1/common/widgets/appbar/appbar.dart';
import 'package:richatt_mobile_socle_v1/features/authentication/controllers/login/login_controller.dart';
import 'package:richatt_mobile_socle_v1/features/richatt/screens/home/widgets/professionalDetails.dart';
import 'package:richatt_mobile_socle_v1/features/richatt/screens/profile/widgets/profile_update.dart';
import 'package:richatt_mobile_socle_v1/utils/constants/image_strings.dart';
import 'package:richatt_mobile_socle_v1/utils/device/device_utility.dart';
import '../controllers/profile_controller.dart';
import 'package:richatt_mobile_socle_v1/utils/constants/sizes.dart';
import 'package:richatt_mobile_socle_v1/utils/constants/text_strings.dart';
import 'package:richatt_mobile_socle_v1/utils/validators/validation.dart';
import 'package:iconsax/iconsax.dart';
import '../models/customer.dart';


class ProfilePage extends StatelessWidget {
  final String email;

  ProfilePage({required this.email});

  @override
  Widget build(BuildContext context) {
    final ProfileController controller = Get.put(ProfileController());
    final LoginController logincontroller = new LoginController();
    final customer = ProfileController.instance;
    // Appeler getCustomerByEmail lors de l'initialisation de la page
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.getCustomerByEmail(email);
    });
  
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        centerTitle: true,
      ),

      //body: profile_update(controller: controller),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Center(
              child: SizedBox(
                height: 115,
                width: 115,
                child: Stack(
                  fit: StackFit.expand,
                  clipBehavior: Clip.none,
                  children: [
                    CircleAvatar(
                      backgroundImage: AssetImage(RImages.doctor1),
                    ),
                    Positioned(
                      right: -12,
                      bottom: 0,
                      child: SizedBox(
                          height: 46,
                          width: 46,
                          child: TextButton(
                            onPressed: () {},
                            style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.grey)),
                            child: Icon(
                              Iconsax.camera,
                              color: Colors.white,
                            ),
                          )),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                child: Text(
                  '${customer.firstName.value.text} ${customer.lastName.value.text}',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 24,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(1.0),
              child: SizedBox(
                  child: Text(
              '${customer.email.value.text} | ${customer.phone.value.text}',
                // 'youremail@domain.com | 37822516',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontFamily: 'FONTSPRING DEMO - Proxima Nova',
                  fontWeight: FontWeight.w400,
                  height: 0,
                ),
              )),
            ),
            SizedBox(
              height: 50.0,
            ),
            Container(
              width: RDeviceUtils.getScreenWidth(context) - 20,
              height: 170,
              decoration: ShapeDecoration(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
                shadows: [
                  BoxShadow(
                    color: Color(0x3F000000),
                    blurRadius: 4,
                    offset: Offset(0, 1),
                    spreadRadius: 0,
                  )
                ],
              ),
              child: Column(children: [
                CustomListTile(
                  title: "Edit profile information",
                  icon: Iconsax.edit,
                  onPressed: () async {
                    print('tap');
                    Get.to(() => profile_update(controller: controller));
                  },
                ),
                CustomListTile(
                  title: "Notifications",
                  icon: Iconsax.notification,
                  trailing: Text(
                    'ON',
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
                CustomListTile(
                  title: "Language",
                  icon: Iconsax.global,
                  trailing: Text(
                    'Arabic',
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
              ]),
            ),
            SizedBox(
              height: 30.0,
            ),
            Container(
              width: RDeviceUtils.getScreenWidth(context) - 20,
              height: 115,
              decoration: ShapeDecoration(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
                shadows: [
                  BoxShadow(
                    color: Color(0x3F000000),
                    blurRadius: 4,
                    offset: Offset(0, 1),
                    spreadRadius: 0,
                  )
                ],
              ),
              child: Column(
                children: [
                  CustomListTile(
                      title: "Security", icon: Iconsax.security_user),
                  CustomListTile(
                    title: "Theme",
                    icon: Iconsax.moon,
                    trailing: Text(
                      'Light mode',
                      style: TextStyle(color: Colors.blue),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 30.0,
            ),
            Container(
              width: RDeviceUtils.getScreenWidth(context) - 20,
              height: 240,
              decoration: ShapeDecoration(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
                shadows: [
                  BoxShadow(
                    color: Color(0x3F000000),
                    blurRadius: 4,
                    offset: Offset(0, 1),
                    spreadRadius: 0,
                  )
                ],
              ),
              child: Column(
                children: [
                  CustomListTile(
                    title: "Help & Support",
                    icon: Iconsax.message_question,
                  ),
                  CustomListTile(
                    title: "Contact us",
                    icon: Iconsax.message,
                  ),
                  CustomListTile(
                    title: "Privacy policy",
                    icon: Iconsax.security_safe4,
                  ),
                    CustomListTile(
                  title: "Logout",
                  icon: Iconsax.logout,
                  onPressed:(){logincontroller.logout();} 
                ),
                ],
              ),
            ),
             SizedBox(
              height: 15.0,
            ),
          ],
        ),
      ),
    );
  }
}

class CustomListTile extends StatelessWidget {
  final String title;
  final IconData icon;
  final Widget? trailing;
  final VoidCallback? onPressed;
  const CustomListTile(
      {super.key,
      required this.title,
      required this.icon,
      this.trailing,
      this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      leading: Icon(icon),
      trailing: trailing,
      onTap: onPressed,
    );
  }
}
