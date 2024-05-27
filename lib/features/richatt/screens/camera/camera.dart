import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:richatt_mobile_socle_v1/features/richatt/controllers/cameraController.dart';

class CameraScreen extends StatelessWidget {
  final CameraController controller = Get.put(CameraController());

  File? selectedImage;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Camera Page'),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Obx(() => controller.selectedImagePath.value == ''
                  ? Text(
                      'Select image from gamera/gallery',
                      style: TextStyle(fontSize: 20),
                    )
                  : Image.file(File(controller.selectedImagePath.value))),
              ElevatedButton(
                onPressed: () {
                  // Naviguer vers la page de récupération de photo
                  controller.getImage(ImageSource.camera);
                },
                child: Text('Prendre une photo'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // Naviguer vers la page de récupération de photo
                  controller.getImage(ImageSource.gallery);
                },
                child: Text('Récupérer une photo'),
              ),
              const SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
