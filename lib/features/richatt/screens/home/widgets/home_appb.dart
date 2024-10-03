import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import 'package:Remeet/common/widgets/appbar/appbar.dart';
import 'package:Remeet/features/richatt/screens/profile/controllers/profile_controller.dart';
import 'package:Remeet/generated/l10n.dart';

import 'package:Remeet/utils/constants/colors.dart';
import 'package:Remeet/utils/constants/image_strings.dart';
import 'package:Remeet/utils/constants/text_strings.dart';

class RHomeAppBar extends StatelessWidget {
  const RHomeAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    final ProfileController controller = Get.put(ProfileController());

    return RAppBar(
      title: Row(children: [
        Obx(() {
          Uint8List? image64;
          try {
            if (controller.image.value.isNotEmpty) {
              image64 = base64Decode(controller.image.value.split(',').last);
            }
          } catch (e) {
            print('Erreur lors de la conversion de l\'image: $e');
          }

          return Container(
            width: 52,
            height: 52,
            decoration: ShapeDecoration(
              image: DecorationImage(
                image: image64 != null
                    ? MemoryImage(image64)
                    : AssetImage(RImages.doctor1) as ImageProvider,
                fit: BoxFit.fill,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(500),
              ),
            ),
          );
        }),
        const SizedBox(width: 20),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Obx(() => Text(
                '${S.of(context).gretting} ${controller.firstName.value} 👋🏽',
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.w500,
                ))),
            Text(
              S.of(context).gretting2,
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
