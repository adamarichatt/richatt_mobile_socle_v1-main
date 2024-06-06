import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get.dart';
import 'package:richatt_mobile_socle_v1/features/richatt/models/professional.dart';
import 'package:richatt_mobile_socle_v1/features/richatt/models/service.dart';
import 'package:richatt_mobile_socle_v1/features/richatt/models/schedule.dart';
import 'package:richatt_mobile_socle_v1/features/richatt/models/Appointment.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ProfessionalController extends GetxController {
  static ProfessionalController get instance => Get.find();
  final isLoading = false.obs;
  RxList<Professional> featuredProf = <Professional>[].obs;
  final selectedSchedules = <Schedule>[].obs;

  Rx<Professional?> selectedProfessional = Rx<Professional?>(null);

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

  Future<void> getProfessionalById(String id) async {
    var headers = {
      'Content-Type': 'application/json',
      'Access-Control-Allow-Origin': 'http://195.35.25.110:8733',
      'Authorization':
          'Bearer eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiJtZWRtYWhtb3VkZGplYmJhQGdtYWlsLmNvbSIsImlhdCI6MTcxNjg5ODI0MywiZXhwIjoxNzE2ODk4MzQzfQ.Jqp0yPyEcaf27htJF1kOaeXJPd3tB3HK5Jui8X9VeflGru1S6X2ScpqFV6lYQeqoAgU0Jq3QCDfrPo4lUF_pmw'
    };

    var url = Uri.parse(
        'http://195.35.25.110:8733/api/professional/getProfessionalById/$id');

    try {
      http.Response response = await http.get(url, headers: headers);

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        selectedProfessional.value = Professional.fromJson(responseData);
      } else {
        throw Exception('Failed to load professional');
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

  Future<List<Service>> getServicesByProfessional(String professionalId) async {
    var headers = {
      'Content-Type': 'application/json',
      'Access-Control-Allow-Origin': 'http://195.35.25.110:8733',
      'Authorization':
          'Bearer eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiJtZWRtYWhtb3VkZGplYmJhQGdtYWlsLmNvbSIsImlhdCI6MTcxNjg5ODI0MywiZXhwIjoxNzE2ODk4MzQzfQ.Jqp0yPyEcaf27htJF1kOaeXJPd3tB3HK5Jui8X9VeflGru1S6X2ScpqFV6lYQeqoAgU0Jq3QCDfrPo4lUF_pmw'
    };

    var url = Uri.parse(
        'http://195.35.25.110:8733/api/service/getServicesByProfessional/$professionalId');

    try {
      http.Response response = await http.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> responseData = json.decode(response.body);
        List<Service> services =
            responseData.map((data) => Service.fromJson(data)).toList();
        return services;
      } else {
        throw Exception('Failed to load services');
      }
    } catch (error) {
      throw error;
    }
  }

  Future<List<Schedule>> fetchWeekSchedules(
      DateTime start, DateTime end, String code) async {
    final String formattedStart = start.toIso8601String();
    final String formattedEnd = end.toIso8601String();

    final response = await http.get(Uri.parse(
        'http://195.35.25.110:8733/api/schedules/getWeekSchedules?start=$formattedStart&end=$formattedEnd&code=$code'));

    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);

      // Print the response to debug
      print('API Response: ${response.body}');

      return body.map((dynamic item) => Schedule.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load schedules');
    }
  }

  Future<List<Schedule>> fetchDaySchedules(
    DateTime date, String professionalId) async {
  final DateTime start = DateTime(date.year, date.month, date.day, 0, 0, 0);
  final DateTime end = DateTime(date.year, date.month, date.day, 23, 59, 59);
  final DateTime now = DateTime.now();
  print(now);

  try {
    List<Schedule> schedules = await fetchWeekSchedules(start, end, professionalId);
    return schedules.where((schedule) {
     
      List<String> dateTimeParts = schedule.dateTime.split('T');
      String datePart = dateTimeParts.first;
      String timePart = dateTimeParts.last.split('-').first; 
      String combinedDateTime = '$datePart $timePart';
      
      DateTime scheduleDateTime = DateTime.parse(combinedDateTime); 
      print(scheduleDateTime);
      return schedule.status == 'Active' && scheduleDateTime.isAfter(now);
    }).toList();
  } catch (error) {
    Get.snackbar('Error', error.toString());
    return [];
  }
}


  Future<void> deleteSchedules(List<Schedule> schedules) async {
    final url =
        Uri.parse('http://195.35.25.110:8733/api/schedules/deleteSchedules');
    final headers = {
      'Content-Type': 'application/json',
      'Access-Control-Allow-Origin': 'http://195.35.25.110:8733',
      'Authorization':
          'Bearer eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiJtZWRtYWhtb3VkZGplYmJhQGdtYWlsLmNvbSIsImlhdCI6MTcxNjg5ODI0MywiZXhwIjoxNzE2ODk4MzQzfQ.Jqp0yPyEcaf27htJF1kOaeXJPd3tB3HK5Jui8X9VeflGru1S6X2ScpqFV6lYQeqoAgU0Jq3QCDfrPo4lUF_pmw'
    };
    final body = jsonEncode(schedules.map((s) => s.toJson()).toList());

    final response = await http.delete(url, headers: headers, body: body);

    if (response.statusCode != 200) {
      throw Exception('Failed to delete schedules');
    }
  }

  Future<void> addSchedules(List<Schedule> schedules) async {
    final url =
        Uri.parse('http://195.35.25.110:8733/api/schedules/addSchedules');
    final headers = {
      'Content-Type': 'application/json',
      'Access-Control-Allow-Origin': 'http://195.35.25.110:8733',
      'Authorization':
          'Bearer eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiJtZWRtYWhtb3VkZGplYmJhQGdtYWlsLmNvbSIsImlhdCI6MTcxNjg5ODI0MywiZXhwIjoxNzE2ODk4MzQzfQ.Jqp0yPyEcaf27htJF1kOaeXJPd3tB3HK5Jui8X9VeflGru1S6X2ScpqFV6lYQeqoAgU0Jq3QCDfrPo4lUF_pmw'
    };
    final body = jsonEncode(schedules.map((s) => s.toJson()).toList());

    final response = await http.post(url, headers: headers, body: body);

    if (response.statusCode != 200) {
      throw Exception('Failed to add schedules');
    }
  }

  Future<void> reserveSchedules(List<Schedule> schedules) async {
    final url =
        Uri.parse('http://195.35.25.110:8733/api/schedules/reservedSchedules');
    final headers = {
      'Content-Type': 'application/json',
      'Access-Control-Allow-Origin': 'http://195.35.25.110:8733',
      'Authorization':
          'Bearer eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiJtZWRtYWhtb3VkZGplYmJhQGdtYWlsLmNvbSIsImlhdCI6MTcxNjg5ODI0MywiZXhwIjoxNzE2ODk4MzQzfQ.Jqp0yPyEcaf27htJF1kOaeXJPd3tB3HK5Jui8X9VeflGru1S6X2ScpqFV6lYQeqoAgU0Jq3QCDfrPo4lUF_pmw'
    };
    final body = jsonEncode(schedules.map((s) => s.toJson()).toList());

    final response = await http.post(url, headers: headers, body: body);

    if (response.statusCode != 200) {
      throw Exception('Failed to reserve schedules');
    }
  }

  Future<void> addAppointment(Appointment appointment) async {
    final url =
        Uri.parse('http://195.35.25.110:8733/api/appointment/addAppointment');
    final headers = {
      'Content-Type': 'application/json',
      'Access-Control-Allow-Origin': 'http://195.35.25.110:8733',
      'Authorization':
          'Bearer eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiJtZWRtYWhtb3VkZGplYmJhQGdtYWlsLmNvbSIsImlhdCI6MTcxNjg5ODI0MywiZXhwIjoxNzE2ODk4MzQzfQ.Jqp0yPyEcaf27htJF1kOaeXJPd3tB3HK5Jui8X9VeflGru1S6X2ScpqFV6lYQeqoAgU0Jq3QCDfrPo4lUF_pmw'
    };
    final body = jsonEncode(appointment.toJson());

    final response = await http.post(url, headers: headers, body: body);

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Failed to add appointment');
    }
  }
}
