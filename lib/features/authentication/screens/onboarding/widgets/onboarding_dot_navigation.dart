import 'package:flutter/material.dart';
import 'package:richatt_mobile_socle_v1/features/authentication/controllers/onboarding/onboarding_controller.dart';
import 'package:richatt_mobile_socle_v1/utils/constants/colors.dart';
import 'package:richatt_mobile_socle_v1/utils/constants/sizes.dart';
import 'package:richatt_mobile_socle_v1/utils/device/device_utility.dart';
import 'package:richatt_mobile_socle_v1/utils/helpers/helper_functions.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnBoardingDotNavigation extends StatelessWidget {
  const OnBoardingDotNavigation({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final controller = OnBoardingController.instance;
    final dark = RHelperFunctions.isDarkMode(context);

    return Positioned(
      bottom: RDeviceUtils.getBottomNavigationBarHeight() + 25,
      left: RSizes.defaultSpace,
      child: SmoothPageIndicator(
        controller: controller.pageController,
        onDotClicked: controller.dotNavigationClick,
        count: 3,
        effect: ExpandingDotsEffect(
          activeDotColor: dark ? RColors.light : RColors.dark,
          dotHeight: 6,
        ),
      ),
    );
  }
}
