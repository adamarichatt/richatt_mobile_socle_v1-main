import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import 'package:richatt_mobile_socle_v1/common/widgets/appbar/appbar.dart';

import 'package:richatt_mobile_socle_v1/utils/constants/colors.dart';
import 'package:richatt_mobile_socle_v1/utils/constants/text_strings.dart';

class RHomeAppBar extends StatelessWidget {
  const RHomeAppBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return RAppBar(
      title: Row(children: [
        const Icon(Iconsax.user),
        const SizedBox(
          width: 20,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              RTexts.homeAppbarTitle,
              style: Theme.of(context)
                  .textTheme
                  .labelMedium!
                  .apply(color: RColors.grey),
            ),
            Text(
              RTexts.homeAppbarSubTitle,
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall!
                  .apply(color: RColors.grey),
            ),
          ],
        ),
      ]),
    );
  }
}
