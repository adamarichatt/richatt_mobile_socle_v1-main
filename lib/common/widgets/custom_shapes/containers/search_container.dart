import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:Remeet/features/richatt/screens/home/widgets/RSearchPage.dart';
import 'package:Remeet/utils/constants/colors.dart';
import 'package:Remeet/utils/constants/sizes.dart';
import 'package:Remeet/utils/device/device_utility.dart';
import 'package:Remeet/utils/helpers/helper_functions.dart';

class RSearchContainer extends StatelessWidget {
  const RSearchContainer({
    super.key,
    required this.text,
    required this.emailCustomer,
    this.icon = Iconsax.search_normal,
    this.showBackground = true,
    this.showBorder = true,
  });

  final String text;
  final String emailCustomer;
  final IconData? icon;
  final bool showBackground, showBorder;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.to(() => RSearchPage(emailCustomer: emailCustomer));
      },
      child: Container(
        width: RDeviceUtils.getScreenWidth(context) - 30,
        height: 56,
        padding: const EdgeInsets.all(RSizes.md),
        decoration: BoxDecoration(
          color: showBackground
              ? RHelperFunctions.isDarkMode(context)
                  ? RColors.dark
                  : RColors.light
              : Colors.transparent,
          borderRadius: BorderRadius.circular(28),
          border: showBorder ? Border.all(color: RColors.grey) : null,
        ),
        child: Row(
          children: [
            Icon(icon, color: RColors.grey),
            const SizedBox(width: 4),
            Expanded(
              child: Text(
                text,
                style: Theme.of(context)
                    .textTheme
                    .bodySmall
                    ?.copyWith(color: RColors.grey),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
