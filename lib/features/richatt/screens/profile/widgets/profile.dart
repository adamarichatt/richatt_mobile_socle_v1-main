import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:richatt_mobile_socle_v1/app.dart';
import 'package:richatt_mobile_socle_v1/common/widgets/appbar/appbar.dart';
import 'package:richatt_mobile_socle_v1/features/authentication/controllers/login/login_controller.dart';
import 'package:richatt_mobile_socle_v1/features/richatt/screens/home/widgets/professionalDetails.dart';
import 'package:richatt_mobile_socle_v1/features/richatt/screens/profile/widgets/profile_update.dart';
import 'package:richatt_mobile_socle_v1/generated/l10n.dart';
import 'package:richatt_mobile_socle_v1/utils/constants/image_strings.dart';
import 'package:richatt_mobile_socle_v1/utils/device/device_utility.dart';
import '../controllers/profile_controller.dart';
import 'package:richatt_mobile_socle_v1/utils/constants/sizes.dart';
import 'package:richatt_mobile_socle_v1/utils/constants/text_strings.dart';
import 'package:richatt_mobile_socle_v1/utils/validators/validation.dart';
import 'package:iconsax/iconsax.dart';
import '../models/customer.dart';
// Make sure to import your LanguageController

class ProfilePage extends StatelessWidget {
  final String email;

  ProfilePage({required this.email});

  @override
  Widget build(BuildContext context) {
    final ProfileController controller = Get.put(ProfileController());
    final LoginController logincontroller = LoginController();
    final LanguageController languageController =
        Get.find<LanguageController>();
    final customer = ProfileController.instance;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.getCustomerByEmail(email);
    });

    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'.tr),
        centerTitle: true,
      ),
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
                                MaterialStateProperty.all<Color>(Colors.grey),
                          ),
                          child: Icon(
                            Iconsax.camera,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Obx(
                () => Text(
                  '${controller.firstName.value} ${controller.lastName.value}',
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
              child: Obx(
                () => Text(
                  '${controller.email.value} | ${controller.phone.value}',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontFamily: 'FONTSPRING DEMO - Proxima Nova',
                    fontWeight: FontWeight.w400,
                    height: 0,
                  ),
                ),
              ),
            ),
            SizedBox(height: 50.0),
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
                  title: S.of(context).editprofile,
                  icon: Iconsax.edit,
                  onPressed: () async {
                    print('tap');
                    Get.to(() => profile_update(controller: controller));
                  },
                ),
                CustomListTile(
                  title: S.of(context).notif,
                  icon: Iconsax.notification,
                  trailing: Text(
                    'ON'.tr,
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
                Obx(() => CustomListTile(
                      title: S.of(context).langue,
                      icon: Iconsax.global,
                      trailing: Text(
                        languageController.currentLanguage.value == 'en'
                            ? S.of(context).english
                            : languageController.currentLanguage.value == 'fr'
                                ? S.of(context).french
                                : S.of(context).arabic,
                        style: TextStyle(color: Colors.blue),
                      ),
                      onPressed: () {
                        Get.bottomSheet(
                          Container(
                            color: Colors.white,
                            child: Wrap(
                              children: [
                                ListTile(
                                  leading: Icon(Icons.language),
                                  title: Text(S.of(context).english),
                                  onTap: () {
                                    languageController.changeLanguage('en');
                                    Get.back();
                                  },
                                ),
                                ListTile(
                                  leading: Icon(Icons.language),
                                  title: Text(S.of(context).arabic),
                                  onTap: () {
                                    languageController.changeLanguage('ar');
                                    Get.back();
                                  },
                                ),
                                ListTile(
                                  leading: Icon(Icons.language),
                                  title: Text(S.of(context).french),
                                  onTap: () {
                                    languageController.changeLanguage('fr');
                                    Get.back();
                                  },
                                ),
                                SizedBox(
                                  height: 50,
                                )
                              ],
                            ),
                          ),
                        );
                      },
                    )),
              ]),
            ),
            SizedBox(height: 30.0),
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
                      title: S.of(context).Security,
                      icon: Iconsax.security_user),
                  CustomListTile(
                    title: S.of(context).Theme,
                    icon: Iconsax.moon,
                    trailing: Text(
                      'Light mode',
                      style: TextStyle(color: Colors.blue),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 30.0),
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
                    title: S.of(context).Help,
                    icon: Iconsax.message_question,
                  ),
                  CustomListTile(
                    title: S.of(context).contact,
                    icon: Iconsax.message,
                  ),
                  CustomListTile(
                    title: S.of(context).Privacy,
                    icon: Iconsax.security_safe4,
                  ),
                  CustomListTile(
                    title: S.of(context).Logout,
                    icon: Iconsax.logout,
                    onPressed: () {
                      Get.defaultDialog(
                        title: 'Are you sure you want to log out?'.tr,
                        titleStyle: TextStyle(
                            fontSize: 14.0, fontWeight: FontWeight.w300),
                        titlePadding: EdgeInsets.all(12.0),
                        content: Container(),
                        textConfirm: "YES".tr,
                        textCancel: "NO".tr,
                        cancelTextColor: Colors.black,
                        backgroundColor: Colors.white,
                        buttonColor: Colors.blueAccent,
                        onConfirm: () {
                          logincontroller.logout();
                        },
                        onCancel: () {},
                      );
                    },
                  ),
                ],
              ),
            ),
            SizedBox(height: 15.0),
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

  const CustomListTile({
    Key? key,
    required this.title,
    required this.icon,
    this.trailing,
    this.onPressed,
  }) : super(key: key);

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
