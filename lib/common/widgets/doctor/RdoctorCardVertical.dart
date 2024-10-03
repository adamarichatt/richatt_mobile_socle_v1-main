import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:Remeet/common/styles/shadows.dart';
import 'package:Remeet/common/widgets/custom_shapes/containers/rounded_container.dart';
import 'package:Remeet/features/richatt/controllers/professionalController.dart';
import 'package:Remeet/features/richatt/models/professional.dart';
import 'package:Remeet/utils/constants/colors.dart';
import 'package:Remeet/utils/constants/sizes.dart';
import 'package:Remeet/utils/helpers/helper_functions.dart';
import 'package:Remeet/features/richatt/screens/home/widgets/professionalDetails.dart';
import 'package:get/get.dart';

class RDoctorCardVertical extends StatelessWidget {
  const RDoctorCardVertical({
    super.key,
    required this.professional,
    required this.emailCustomer,
  });

  final Professional professional;
  final String emailCustomer;
  @override
  Widget build(BuildContext context) {
    final controller = ProfessionalController.instance;
    final dark = RHelperFunctions.isDarkMode(context);
    return GestureDetector(
      onTap: () async {
        await controller.getProfessionalById(professional.id!);
        Get.to(() => ProfessionalDetailsPage(
              professionalId: professional.id!,
              professional: professional,
              emailCustomer: emailCustomer,
            ));
      },
      child: Container(
        width: 180,
        padding: const EdgeInsets.all(1),
        decoration: BoxDecoration(
          boxShadow: [RShadowStyle.vertcalCardShadow],
          borderRadius: BorderRadius.circular(RSizes.doctorImageRadius),
          color: dark ? RColors.darkerGrey : RColors.white,
        ),
        child: Column(
          children: [
            RRoundedContainer(
              height: 180,
              padding: const EdgeInsets.all(RSizes.sm),
              backgroundColor: dark ? RColors.dark : RColors.light,
              child: Stack(
                children: [
                  Positioned(
                    top: 0,
                    right: 0,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        color: dark
                            ? RColors.black.withOpacity(0.9)
                            : RColors.white.withOpacity(0.9),
                      ),
                      child: IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            Iconsax.heart5,
                            color: Colors.red,
                          )),
                    ),
                  )
                ],
              ),
            ),
            ////detail
            const SizedBox(
              height: RSizes.spaceBtwItems / 2,
            ),

            Padding(
              padding: const EdgeInsets.only(left: RSizes.sm),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //rafractor le text plus tard
                  Text(
                    professional.firstName + ' ' + professional.name,
                    style: Theme.of(context).textTheme.labelSmall,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                    textAlign: TextAlign.left,
                  ),
                  const SizedBox(
                    height: RSizes.spaceBtwItems / 2,
                  ),
                  Row(
                    children: [
                      Text(
                        professional.businessSector!,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: Theme.of(context).textTheme.labelMedium,
                      ),
                      const SizedBox(
                        width: RSizes.xs,
                      ),
                    ],
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Reserver ',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                      Container(
                        decoration: const BoxDecoration(
                          color: RColors.dark,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(RSizes.cardRadiusMd),
                            bottomRight:
                                Radius.circular(RSizes.doctorImageRadius),
                          ),
                        ),
                        child: const SizedBox(
                          width: RSizes.iconLg * 1.2,
                          height: RSizes.iconLg * 1.2,
                          child: Center(
                            child: Icon(Iconsax.calendar_add,
                                color: RColors.white),
                          ),
                        ),
                      )
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
