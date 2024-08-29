import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:richatt_mobile_rimeet/features/authentication/controllers/onboarding/onboarding_controller.dart';

import 'package:richatt_mobile_rimeet/features/authentication/screens/onboarding/widgets/onboarding_dot_navigation.dart';
import 'package:richatt_mobile_rimeet/features/authentication/screens/onboarding/widgets/onboarding_next_button.dart';
import 'package:richatt_mobile_rimeet/features/authentication/screens/onboarding/widgets/onboarding_page.dart';
import 'package:richatt_mobile_rimeet/features/authentication/screens/onboarding/widgets/onboarding_skip.dart';
import 'package:richatt_mobile_rimeet/generated/l10n.dart';

import 'package:richatt_mobile_rimeet/utils/constants/image_strings.dart';

import 'package:richatt_mobile_rimeet/utils/constants/text_strings.dart';

class OnBoardingScreen extends StatelessWidget {
  const OnBoardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(OnBoardingController());

    return Scaffold(
      body: Stack(
        children: [
          PageView(
            controller: controller.pageController,
            onPageChanged: controller.updatePageIndicator,
            children: [
              OnBoardingPage(
                image: RImages.onBoardingImage1,
                title: S.of(context).onBoardingTitle1,
                subTitle: S.of(context).onBoardingSubTitle1,
              ),
              OnBoardingPage(
                image: RImages.onBoardingImage2,
                title: S.of(context).onBoardingTitle2,
                subTitle: S.of(context).onBoardingSubTitle2,
              ),
              OnBoardingPage(
                image: RImages.onBoardingImage3,
                title: S.of(context).onBoardingTitle3,
                subTitle: S.of(context).onBoardingSubTitle3,
              ),
            ],
          ),

          //Skip Button
          const OnBoardingSkip(),

          //dot Navigation SmoothPageIndicator
          const OnBoardingDotNavigation(),

          //Circular Button
          const OnBoardingNextButton(),
        ],
      ),
    );
  }
}
