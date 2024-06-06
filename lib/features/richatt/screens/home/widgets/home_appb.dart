import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import 'package:richatt_mobile_socle_v1/common/widgets/appbar/appbar.dart';

import 'package:richatt_mobile_socle_v1/utils/constants/colors.dart';
import 'package:richatt_mobile_socle_v1/utils/constants/image_strings.dart';
import 'package:richatt_mobile_socle_v1/utils/constants/text_strings.dart';

class RHomeAppBar extends StatelessWidget {
  const RHomeAppBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return RAppBar(
      title: Row(children: [
        Container(
          width: 52,
          height: 52,
          decoration: ShapeDecoration(
            image: DecorationImage(
              image: AssetImage(RImages.doctor1),
              fit: BoxFit.fill,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(500),
            ),
          ),
        ),
        const SizedBox(
          width: 20,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(RTexts.homeAppbarTitle + ' sarah 👋🏽',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.w500,
                )),
            Text(
              RTexts.homeAppbarSubTitle,
              style: TextStyle(
                color: Colors.black.withOpacity(0.5),
                fontSize: 14,
                fontFamily: 'Nunito',
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ]),
    );
  }
}
