import 'package:flutter/material.dart';
import 'package:richatt_mobile_rimeet/features/authentication/controllers/onboarding/onboarding_controller.dart';
import 'package:richatt_mobile_rimeet/utils/constants/sizes.dart';
import 'package:richatt_mobile_rimeet/utils/device/device_utility.dart';

class OnBoardingSkip extends StatelessWidget {
  const OnBoardingSkip({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: RDeviceUtils.getAppBarHeight(),
      right: RSizes.defaultSpace,
      child: TextButton(
        onPressed: () => OnBoardingController.instance.skipPage(),
        child: const Text('Skip'),
      ),
    );
  }
}
