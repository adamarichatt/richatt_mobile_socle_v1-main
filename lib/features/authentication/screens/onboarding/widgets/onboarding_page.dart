import 'package:flutter/material.dart';
import 'package:richatt_mobile_socle_v1/utils/constants/sizes.dart';

import 'package:richatt_mobile_socle_v1/utils/helpers/helper_functions.dart';

class OnBoardingPage extends StatelessWidget {
  const OnBoardingPage({
    super.key,
    required this.image,
    required this.title,
    required this.subTitle,
  });

  final String image, title, subTitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Image(
            width: RHelperFunctions.screenWidth(),
            height: RHelperFunctions.screenHeight() * 0.6,
            // ignore: prefer_const_constructors
            image: AssetImage(
              image,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(RSizes.defaultSpace),
            child: Text.rich(
              TextSpan(
                text: title,
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 32,
                    fontFamily: 'Roboto',
                    height: 0,
                    fontWeight: FontWeight.w500),
                children: [
                  TextSpan(
                    text: subTitle,
                    style: TextStyle(fontWeight: FontWeight.w300),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(
            height: RSizes.spaceBtwItems,
          ),
        ],
      ),
    );
  }
}
