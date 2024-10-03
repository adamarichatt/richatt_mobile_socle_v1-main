import 'package:flutter/material.dart';
import 'package:Remeet/features/authentication/controllers/onboarding/onboarding_controller.dart';
import 'package:Remeet/utils/constants/sizes.dart';
import 'package:Remeet/utils/device/device_utility.dart';

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
