import 'package:flutter/material.dart';
import 'package:richatt_mobile_socle_v1/utils/constants/colors.dart';

class RShadowStyle {
  static final vertcalCardShadow = BoxShadow(
    color: RColors.darkGrey.withOpacity(0.1),
    blurRadius: 50,
    spreadRadius: 7,
    offset: const Offset(0, 2),
  );
}
