import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:Remeet/features/richatt/screens/profile/controllers/profile_controller.dart';
import 'package:Remeet/features/richatt/screens/profile/widgets/profile.dart';
import 'package:Remeet/utils/constants/sizes.dart';
import 'package:Remeet/utils/constants/text_strings.dart';

class profile_security extends StatelessWidget {
  const profile_security({
    super.key,
    required this.controller,
  });

  final ProfileController controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile security'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [Text('page face id ')],
        ),
      ),
    );
  }
}
