import 'package:flutter/material.dart';
import 'package:richatt_mobile_socle_v1/utils/constants/colors.dart';
import 'package:richatt_mobile_socle_v1/utils/constants/sizes.dart';

class RRoundedImage extends StatelessWidget {
  const RRoundedImage({
    super.key,
    this.width,
    this.height,
    this.borderRadius = RSizes.md,
    required this.imageUrl,
    this.border,
    this.fit = BoxFit.contain,
    this.applyImageRadius = true,
    this.isNetworkImage = false,
    this.backgroundColor = RColors.light,
    this.padding,
    this.onPressed,
  });

  final double? width;
  final double? height;
  final double borderRadius;
  final String imageUrl;
  final BoxBorder? border;
  final BoxFit? fit;
  final bool applyImageRadius;
  final bool isNetworkImage;

  final Color backgroundColor;
  final EdgeInsetsGeometry? padding;
  final VoidCallback? onPressed;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: width,
        height: height,
        padding: padding,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(borderRadius),
          border: border,
        ),
        child: ClipRRect(
          borderRadius: applyImageRadius
              ? BorderRadius.circular(borderRadius)
              : BorderRadius.zero,
          child: Image(
            fit: fit,
            image: isNetworkImage
                ? NetworkImage(imageUrl)
                : AssetImage(imageUrl) as ImageProvider,
          ),
        ),
      ),
    );
  }
}
