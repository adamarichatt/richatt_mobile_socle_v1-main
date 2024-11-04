import 'package:Remeet/features/richatt/screens/home/widgets/HomeGeust.dart';
import 'package:Remeet/navigation_menu.dart';
import 'package:flutter/material.dart';
import 'package:Remeet/utils/constants/image_strings.dart';
import 'package:Remeet/utils/constants/sizes.dart';
import 'package:Remeet/utils/constants/text_strings.dart';
import 'package:Remeet/utils/helpers/helper_functions.dart';
import 'package:get/get.dart';

class RLoginHeader extends StatelessWidget {
  const RLoginHeader({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final dark = RHelperFunctions.isDarkMode(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Image(
              height: 150,
              image:
                  AssetImage(dark ? RImages.lightAppLogo : RImages.darkAppLogo),
            ),
            TextButton(
              onPressed: () {
                Get.to(() => NavigationMenu());
              },
              child: const Text(
                'continuer sans login',
                style: TextStyle(color: Colors.black),
              ),
            ),
          ],
        ),
        Text(
          RTexts.loginTitle,
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        const SizedBox(
          height: RSizes.sm,
        ),
        Text(
          RTexts.loginSubTitle,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ],
    );
  }
}
