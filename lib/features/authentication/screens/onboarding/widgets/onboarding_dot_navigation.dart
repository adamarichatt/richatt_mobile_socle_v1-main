import 'package:flutter/material.dart';
import 'package:Remeet/features/authentication/controllers/onboarding/onboarding_controller.dart';
import 'package:Remeet/utils/constants/colors.dart';
import 'package:Remeet/utils/device/device_utility.dart';
import 'package:Remeet/utils/helpers/helper_functions.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnBoardingDotNavigation extends StatelessWidget {
  const OnBoardingDotNavigation({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final controller = OnBoardingController.instance;
    final dark = RHelperFunctions.isDarkMode(context);

    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: EdgeInsets.only(
            bottom: RDeviceUtils.getBottomNavigationBarHeight() + 100),
        child: SmoothPageIndicator(
          controller: controller.pageController,
          onDotClicked: controller.dotNavigationClick,
          count: 3,
          effect: ExpandingDotsEffect(
            activeDotColor: dark ? RColors.light : Colors.blue,
            dotHeight: 6,
          ),
        ),
      ),
    );
  }
}
