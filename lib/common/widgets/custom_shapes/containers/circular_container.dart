import 'package:flutter/material.dart';
import 'package:richatt_mobile_rimeet/utils/constants/colors.dart';

class RCircularContainer extends StatelessWidget {
  const RCircularContainer({
    super.key,
    this.child,
    this.width = 400,
    this.height = 400,
    this.raduis = 400,
    this.padding = 0,
    this.backgroundColor = RColors.white,
  });

  final double? width;
  final double? height;
  final double raduis;
  final double padding;
  final Widget? child;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      padding: EdgeInsets.all(padding),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(raduis),
        color: backgroundColor,
      ),
      child: child,
    );
  }
}
