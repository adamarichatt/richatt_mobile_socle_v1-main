import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:Remeet/features/authentication/controllers/onboarding/onboarding_controller.dart';
import 'package:Remeet/utils/constants/colors.dart';
import 'package:Remeet/utils/constants/sizes.dart';
import 'package:Remeet/utils/device/device_utility.dart';
import 'package:Remeet/utils/helpers/helper_functions.dart';

class OnBoardingNextButton extends StatelessWidget {
  const OnBoardingNextButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final dark = RHelperFunctions.isDarkMode(context);
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: EdgeInsets.only(
            bottom: RDeviceUtils.getBottomNavigationBarHeight()),
        child: SizedBox(
          width: RDeviceUtils.getScreenWidth(context) *
              0.9, // Définissez la largeur souhaitée ici
          child: OutlinedButton(
            style: ButtonStyle(
              backgroundColor:
                  WidgetStateColor.resolveWith((states) => Colors.blue),
              shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                      24), // Définissez le rayon du bord ici
                ),
              ),
            ),
            onPressed: () => OnBoardingController.instance.nextPage(),
            child: const Text(
              'Next',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w700,
                height: 0,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
