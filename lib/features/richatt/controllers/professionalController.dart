import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get.dart';
import 'package:richatt_mobile_socle_v1/features/richatt/models/professional.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ProfessionalController extends GetxController {
  static ProfessionalController get instance => Get.find();
  final isLoading = false.obs;
  RxList<Professional> featuredProf = <Professional>[].obs;

  @override
  void onInit() {
    getProf();
    super.onInit();
  }

  Future<void> getProf() async {
    var headers = {
      'Content-Type': 'application/json',
      'Access-Control-Allow-Origin': 'http://195.35.25.110:8733',
      'Authorization':
          'Bearer eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiJtZWRtYWhtb3VkZGplYmJhQGdtYWlsLmNvbSIsImlhdCI6MTcxNjg5ODI0MywiZXhwIjoxNzE2ODk4MzQzfQ.Jqp0yPyEcaf27htJF1kOaeXJPd3tB3HK5Jui8X9VeflGru1S6X2ScpqFV6lYQeqoAgU0Jq3QCDfrPo4lUF_pmw'
    };

    var url = Uri.parse(
        'http://195.35.25.110:8733/api/professional/getALLProfessional');

    try {
      http.Response response = await http.get(url, headers: headers);

      debugPrint('response:' + response.body);
      if (response.statusCode == 200) {
        final List<dynamic> responseData = json.decode(response.body);
        featuredProf
            .assignAll(responseData.map((data) => Professional.fromJson(data)));
      } else {
        throw Exception('Failed to load list');
      }
    } catch (error) {
      showDialog(
        context: Get.context!,
        builder: (context) {
          return SimpleDialog(
            title: const Text('Error'),
            contentPadding: const EdgeInsets.all(20),
            children: [Text(error.toString())],
          );
        },
      );
    }
  }
}
