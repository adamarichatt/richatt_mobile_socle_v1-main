import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'package:richatt_mobile_socle_v1/features/richatt/models/professional.dart';
import 'package:richatt_mobile_socle_v1/features/richatt/models/service.dart';
import 'package:richatt_mobile_socle_v1/features/richatt/models/Schedule.dart';
import 'package:richatt_mobile_socle_v1/features/richatt/models/Appointment.dart';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:richatt_mobile_socle_v1/features/richatt/screens/profile/controllers/profile_controller.dart';
import 'package:richatt_mobile_socle_v1/features/richatt/screens/profile/models/customer.dart';
import 'package:richatt_mobile_socle_v1/utils/constants/api_constants.dart';

class ProfessionalController extends GetxController {
  static ProfessionalController get instance => Get.find();
  final isLoading = false.obs;
  RxList<Professional> featuredProf = <Professional>[].obs;
  final selectedSchedules = <Schedule>[].obs;
  RxList<Professional> filteredProfessionals = <Professional>[].obs;
  RxList<String> filteredCities = <String>[].obs;
  RxList<String> filteredSpecialities = <String>[].obs;
  RxList<String> filteredEntities = <String>[].obs;
  Rx<Appointment?> nextAppointment = Rx<Appointment?>(null);
  // Favorite Professionals
  var favoriteProfessionals = <Professional>{}.obs;
  Rx<Professional?> selectedProfessional = Rx<Professional?>(null);

  var selectedCity = ''.obs;
  var selectedEntity = ''.obs;
  var selectedSpeciality = ''.obs;
  var selectedAvailability= ''.obs;
  var searchText = ''.obs;
  
  @override
  void onInit() {
    getProf();
    super.onInit();
  }

  Future<void> getProf() async {
    print('test');
    var headers = {
      'Content-Type': 'application/json',
      'Access-Control-Allow-Origin': 'http://195.35.25.110:8733',
      'Authorization':
          'Bearer eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiJtZWRtYWhtb3VkZGplYmJhQGdtYWlsLmNvbSIsImlhdCI6MTcxNjg5ODI0MywiZXhwIjoxNzE2ODk4MzQzfQ.Jqp0yPyEcaf27htJF1kOaeXJPd3tB3HK5Jui8X9VeflGru1S6X2ScpqFV6lYQeqoAgU0Jq3QCDfrPo4lUF_pmw'
    };

    var url =
        Uri.parse(APIConstants.apiBackend + 'professional/getALLProfessional');

    try {
      http.Response response = await http.get(url, headers: headers);

      debugPrint('response:' + response.body);
      if (response.statusCode == 200) {
        final List<dynamic> responseData =
            json.decode(utf8.decode(response.bodyBytes));
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

  void filterProfessionalsBySpeciality(String speciality) {
    selectedSpeciality.value = speciality;

    final specialityLower = speciality.toLowerCase();
    filteredProfessionals.value = featuredProf.where((professional) {
      return professional.businessSector != null &&
          professional.businessSector!.toLowerCase() == specialityLower;
    }).toList();
  }

  void filterProfessionalsByEntityName(String entityName) {
    selectedEntity.value = entityName;

    final entityNameLower = entityName.toLowerCase();
    filteredProfessionals.value = featuredProf.where((professional) {
      return professional.entityName != null &&
          professional.entityName!.toLowerCase() == entityNameLower;
    }).toList();
  }

  void filterProfessionalsByCity(String city) {
    selectedCity.value = city;

    final cityLower = city.toLowerCase();
    filteredProfessionals.value = featuredProf.where((professional) {
      return professional.city != null &&
          professional.city!.toLowerCase().contains(cityLower);
    }).toList();
  }

  void searchProfessionals(String query) {
    searchText.value = query;
    filterProfessionals();
  }

  // Combined filters
  void filterProfessionalsBySpecialityAndCity(String speciality, String city) {
    selectedSpeciality.value = speciality;
    selectedCity.value = city;
    filterProfessionals();
  }

  void filterProfessionalsByEntityAndCity(String entityName, String city) {
    selectedEntity.value = entityName;
    selectedCity.value = city;
    filterProfessionals();
  }

  void filterProfessionalsBySpecialityAndEntity(
      String speciality, String entityName) {
    selectedSpeciality.value = speciality;
    selectedEntity.value = entityName;
    filterProfessionals();
  }

  void filterProfessionalsByEntityAndSpeciality(
      String entityName, String speciality) {
    filterProfessionalsBySpecialityAndEntity(speciality, entityName);
  }

  void filterProfessionals() {
    String query = searchText.value.toLowerCase();

    // Filter specialties and entities
    filteredSpecialities.value = featuredProf
        .where((professional) =>
            professional.businessSector != null &&
            professional.businessSector!.toLowerCase().contains(query))
        .map((professional) => professional.businessSector!)
        .toSet()
        .toList();

    filteredEntities.value = featuredProf
        .where((professional) =>
            professional.entityName != null &&
            professional.entityName!.toLowerCase().contains(query))
        .map((professional) => professional.entityName!)
        .toSet()
        .toList();

    // Filter professionals
    filteredProfessionals.value = featuredProf.where((professional) {
      bool matchesQuery =
          professional.firstName.toLowerCase().contains(query) ||
              professional.name.toLowerCase().contains(query) ||
              (professional.businessSector != null &&
                  professional.businessSector!.toLowerCase().contains(query)) ||
              (professional.entityName != null &&
                  professional.entityName!.toLowerCase().contains(query));

      bool matchesSpeciality = selectedSpeciality.value.isEmpty ||
          (professional.businessSector != null &&
              professional.businessSector!
                  .toLowerCase()
                  .contains(selectedSpeciality.value.toLowerCase()));
      bool matchesCity = selectedCity.value.isEmpty ||
          (professional.city != null &&
              professional.city!
                  .toLowerCase()
                  .contains(selectedCity.value.toLowerCase()));
      bool matchesEntity = selectedEntity.value.isEmpty ||
          (professional.entityName != null &&
              professional.entityName!
                  .toLowerCase()
                  .contains(selectedEntity.value.toLowerCase()));

      return matchesQuery && matchesSpeciality && matchesCity && matchesEntity;
    }).toList();
  }

  void resetFilters() {
    searchText.value = '';
    selectedCity.value = '';
    selectedEntity.value = '';
    selectedSpeciality.value = '';
    filteredProfessionals.value = featuredProf; // Reset to all professionals
  }

  Future<Schedule?> getNextAvailability(String professionalCode) async {
  final url = APIConstants.apiBackend +
      'schedules/nextAvailabilityByProfessionalCode/$professionalCode';
  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    if (response.body.isNotEmpty) {
      print('Availibility: ${response.body}');
      
      try {
        final jsonResponse = json.decode(response.body);
        if (jsonResponse is Map<String, dynamic>) {
          return Schedule.fromJson(jsonResponse);
        } else {
          print('Unexpected response format for professional $professionalCode');
          return null;
        }
      } catch (e) {
        print('Error parsing JSON for professional $professionalCode: $e');
        return null;
      }
    } else {
      print('Empty response for professional $professionalCode');
      return null;
    }
  } else {
    print('Failed to load next availability for professional $professionalCode');
    return null;
  }
}



 Future<void> applyAvailabilityFilter(String availability) async {
  if (availability.isEmpty) {
    return; // Aucun filtre à appliquer
  }

  DateTime filterDate;
  switch (availability) {
    case 'Aujourd\'hui':
      filterDate = DateTime.now();
      break;
    case 'Dans 3 jours':
      filterDate = DateTime.now().add(Duration(days: 3));
      break;
    case 'Dans une semaine':
      filterDate = DateTime.now().add(Duration(days: 7));
      break;
    default:
      return; // Filtre non valide
  }

  List<Professional> availableProfessionals = [];

  for (var professional in filteredProfessionals) {
    if (professional.id != null) {
      try {
        Schedule? nextAvailability = await getNextAvailability(professional.id!);
        if (nextAvailability != null && nextAvailability.dateTime != null) {
          DateTime nextAvailabilityDate = DateTime.parse(nextAvailability.dateTime.split('T').first);
          if (nextAvailabilityDate.isBefore(filterDate) || nextAvailabilityDate.isAtSameMomentAs(filterDate)) {
            availableProfessionals.add(professional);
          }
        }
      } catch (e) {
        print('Error fetching availability for ${professional.name}: $e');
      }
    }
  }

  filteredProfessionals.value = availableProfessionals;

}
void filterProfessionalsByAvailability(String availability) async {
  selectedAvailability.value = availability;
  filterProfessionals(); // Appliquez d'abord les autres filtres
  await applyAvailabilityFilter(availability); // Ensuite, appliquez le filtre de disponibilité
}

  List<String> getUniqueCities() {
    final cities = <String>{};
    for (var professional in featuredProf) {
      if (professional.city != null && professional.city!.isNotEmpty) {
        cities.add(professional.city!);
      }
    }
    return ['']
        .followedBy(cities)
        .toList(); // Add empty string for no filter option
  }

  List<String> getCitiesForSpeciality(String speciality) {
    final cities = <String>{};
    for (var professional in featuredProf) {
      if (professional.city != null &&
          professional.city!.isNotEmpty &&
          professional.businessSector == speciality) {
        cities.add(professional.city!);
      }
    }
    return ['']
        .followedBy(cities)
        .toList(); // Add empty string for no filter option
  }

  List<String> getCitiesForEntity(String entity) {
    final cities = <String>{};
    for (var professional in featuredProf) {
      if (professional.city != null &&
          professional.city!.isNotEmpty &&
          professional.entityName == entity) {
        cities.add(professional.city!);
      }
    }
    return ['']
        .followedBy(cities)
        .toList(); // Add empty string for no filter option
  }

  List<String> getUniqueSpecialities() {
    final specialities = <String>{};
    for (var professional in featuredProf) {
      if (professional.businessSector != null &&
          professional.businessSector!.isNotEmpty) {
        specialities.add(professional.businessSector!);
      }
    }
    return ['']
        .followedBy(specialities)
        .toList(); // Add empty string for no filter option
  }

  List<String> getSpecialitiesForEntity(String entity) {
    final specialities = <String>{};
    for (var professional in featuredProf) {
      if (professional.businessSector != null &&
          professional.businessSector!.isNotEmpty &&
          professional.entityName == entity) {
        specialities.add(professional.businessSector!);
      }
    }
    return ['']
        .followedBy(specialities)
        .toList(); // Add empty string for no filter option
  }

  List<String> getUniqueEntities() {
    final entities = <String>{};
    for (var professional in featuredProf) {
      if (professional.entityName != null &&
          professional.entityName!.isNotEmpty) {
        entities.add(professional.entityName!);
      }
    }
    return ['']
        .followedBy(entities)
        .toList(); // Add empty string for no filter option
  }

  List<String> getEntitiesForSpeciality(String speciality) {
    final entities = <String>{};
    for (var professional in featuredProf) {
      if (professional.entityName != null &&
          professional.entityName!.isNotEmpty &&
          professional.businessSector == speciality) {
        entities.add(professional.entityName!);
      }
    }
    return ['']
        .followedBy(entities)
        .toList(); // Add empty string for no filter option
  }

  Future<void> getProfessionalById(String id) async {
    var headers = {
      'Content-Type': 'application/json',
      'Access-Control-Allow-Origin': 'http://195.35.25.110:8733',
      'Authorization':
          'Bearer eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiJtZWRtYWhtb3VkZGplYmJhQGdtYWlsLmNvbSIsImlhdCI6MTcxNjg5ODI0MywiZXhwIjoxNzE2ODk4MzQzfQ.Jqp0yPyEcaf27htJF1kOaeXJPd3tB3HK5Jui8X9VeflGru1S6X2ScpqFV6lYQeqoAgU0Jq3QCDfrPo4lUF_pmw'
    };

    var url = Uri.parse(
        APIConstants.apiBackend + 'professional/getProfessionalById/$id');

    try {
      http.Response response = await http.get(url, headers: headers);

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData =
            json.decode(utf8.decode(response.bodyBytes));
        print('response  ${responseData}');

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

    var url = Uri.parse(APIConstants.apiBackend +
        'service/getServicesByProfessional/$professionalId');

    try {
      http.Response response = await http.get(url);

      if (response.statusCode == 200) {
        if (response.body.isEmpty) {
          return [];
        }
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

    final response = await http.get(Uri.parse(APIConstants.apiBackend +
        'schedules/getWeekSchedules?start=$formattedStart&end=$formattedEnd&code=$code'));

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
      List<Schedule> schedules =
          await fetchWeekSchedules(start, end, professionalId);
      return schedules.where((schedule) {
        List<String> dateTimeParts = schedule.dateTime.split('T');
        String datePart = dateTimeParts.first;
        String timePart = dateTimeParts.last.split('-').first;
        String combinedDateTime = '$datePart $timePart';

        DateTime scheduleDateTime = DateTime.parse(combinedDateTime);
        print('scheduleDateTime');
        print(DateFormat('yyyy-MM-dd HH:mm:ss').format(scheduleDateTime));

        return schedule.status == 'Active' && scheduleDateTime.isAfter(now);
      }).toList();
    } catch (error) {
      Get.snackbar('Error', error.toString());
      return [];
    }
  }

  Future<void> deleteSchedules(List<Schedule> schedules) async {
    final url =
        Uri.parse(APIConstants.apiBackend + 'schedules/deleteSchedules');
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
    final url = Uri.parse(APIConstants.apiBackend + 'schedules/addSchedules');
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

  Future<List<Schedule>> fetchSchedules(String professionalId) async {
    final response = await http.get(
      Uri.parse(APIConstants.apiBackend +
          'schedules/getAllSchedules?code=$professionalId'),
    );

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse
          .map<Schedule>((schedule) => Schedule.fromJson(schedule))
          .toList();
    } else {
      throw Exception('Failed to load schedules');
    }
  }

  Future<void> enableSchedules(List<Schedule> schedules) async {
    final url =
        Uri.parse(APIConstants.apiBackend + 'schedules/enableSchedules');
    final headers = {
      'Content-Type': 'application/json',
      'Access-Control-Allow-Origin': 'http://195.35.25.110:8733',
      'Authorization':
          'Bearer eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiJtZWRtYWhtb3VkZGplYmJhQGdtYWlsLmNvbSIsImlhdCI6MTcxNjg5ODI0MywiZXhwIjoxNzE2ODk4MzQzfQ.Jqp0yPyEcaf27htJF1kOaeXJPd3tB3HK5Jui8X9VeflGru1S6X2ScpqFV6lYQeqoAgU0Jq3QCDfrPo4lUF_pmw'
    };
    final body = jsonEncode(schedules.map((s) => s.toJson()).toList());

    final response = await http.post(url, headers: headers, body: body);

    if (response.statusCode != 200) {
      throw Exception('Failed to enable schedules');
    }
  }

  Future<void> reserveSchedules(List<Schedule> schedules) async {
    final url =
        Uri.parse(APIConstants.apiBackend + 'schedules/reservedSchedules');
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
        Uri.parse(APIConstants.apiBackend + 'appointment/addAppointment');
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

  Future<void> deleteAppointment(String appointmentId) async {
    final response = await http.delete(
      Uri.parse(APIConstants.apiBackend +
          'appointment/deleteAppointment/$appointmentId'),
    );

    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception('Failed to delete appointment');
    }
  }

  Future<void> updateAppointment(
      String appointmentId, Appointment appointment) async {
    final url = Uri.parse(APIConstants.apiBackend +
        'appointment/updateAppointment/$appointmentId');
    final headers = {
      'Content-Type': 'application/json',
      'Access-Control-Allow-Origin': 'http://195.35.25.110:8733',
      'Authorization':
          'Bearer eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiJtZWRtYWhtb3VkZGplYmJhQGdtYWlsLmNvbSIsImlhdCI6MTcxNjg5ODI0MywiZXhwIjoxNzE2ODk4MzQzfQ.Jqp0yPyEcaf27htJF1kOaeXJPd3tB3HK5Jui8X9VeflGru1S6X2ScpqFV6lYQeqoAgU0Jq3QCDfrPo4lUF_pmw'
    };
    final body = jsonEncode(appointment.toJson());
    debugPrint('appointUpdate:' + body);
    final response = await http.put(url, headers: headers, body: body);

    if (response.statusCode != 200) {
      throw Exception('Failed to update appointment');
    }
  }

  Future<List<Appointment>> fetchAppointmentsByEmail(String email) async {
    final response = await http.get(
      Uri.parse(APIConstants.apiBackend +
          'appointment/getAppointmentsByEmail?email=$email'),
    );

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse
          .map<Appointment>((appointment) => Appointment.fromJson(appointment))
          .toList();
    } else {
      throw Exception('Failed to load appointments');
    }
  }

  Future<void> getNextAppointmentByEmail(String email) async {
    final headers = {
      'Content-Type': 'application/json',
      'Access-Control-Allow-Origin': 'http://195.35.25.110:8733',
      'Authorization':
          'Bearer eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiJtZWRtYWhtb3VkZGplYmJhQGdtYWlsLmNvbSIsImlhdCI6MTcxNjg5ODI0MywiZXhwIjoxNzE2ODk4MzQzfQ.Jqp0yPyEcaf27htJF1kOaeXJPd3tB3HK5Jui8X9VeflGru1S6X2ScpqFV6lYQeqoAgU0Jq3QCDfrPo4lUF_pmw'
    };

    var url = Uri.parse(
        APIConstants.apiBackend + 'appointment/nextAppointmentByEmail/$email');

    try {
      http.Response response = await http.get(url, headers: headers);
      debugPrint('Next Appointment Response: ${response.body}');
      if (response.statusCode == 200) {
        if (response.body != 'null') {
          final json = jsonDecode(response.body);
          debugPrint('Decoded JSON: $json');
          final appointment =
              Appointment.fromJson(json as Map<String, dynamic>);
          nextAppointment.value = appointment;
        } else {
          nextAppointment.value = null; // No upcoming appointments
        }
      } else if (response.statusCode == 204) {
        nextAppointment.value = null; // No upcoming appointments
      } else {
        throw Exception('Failed to load next appointment');
      }
    } catch (error) {
      debugPrint('Error: $error');
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

  // Add a favorite professional
  Future<void> addFavoriteProfessional(
      String customerId, Professional professional) async {
    var headers = {
      'Content-Type': 'application/json',
      'Access-Control-Allow-Origin': 'http://195.35.25.110:8733',
      'Authorization':
          'Bearer eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiJtZWRtYWhtb3VkZGplYmJhQGdtYWlsLmNvbSIsImlhdCI6MTcxNjg5ODI0MywiZXhwIjoxNzE2ODk4MzQzfQ.Jqp0yPyEcaf27htb3tB3HK5Jui8X9VeflGru1S6X2ScpqFV6lYQeqoAgU0Jq3QCDfrPo4lUF_pmw'
    };

    var url =
        Uri.parse(APIConstants.apiBackend + 'customer/$customerId/favorites');

    var body = json.encode(professional.toJson());

    try {
      final response = await http.post(
        url,
        headers: headers,
        body: body,
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        Professional addedProfessional = Professional.fromJson(responseData);
        favoriteProfessionals.add(addedProfessional);
        print('favorites');
        print(addedProfessional);
      } else {
        throw Exception('Failed to add favorite');
      }
    } catch (error) {
      Get.snackbar('Error', error.toString());
    }
  }

  Future<void> removeFavoriteProfessional(
      String customerId, Professional professional) async {
    var headers = {
      'Content-Type': 'application/json',
      'Access-Control-Allow-Origin': 'http://195.35.25.110:8733',
      'Authorization':
          'Bearer eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiJtZWRtYWhtb3VkZGplYmJhQGdtYWlsLmNvbSIsImlhdCI6MTcxNjg5ODI0MywiZXhwIjoxNzE2ODk4MzQzfQ.Jqp0yPyEcaf27htb3tB3HK5Jui8X9VeflGru1S6X2ScpqFV6lYQeqoAgU0Jq3QCDfrPo4lUF_pmw'
    };

    var url = Uri.parse(APIConstants.apiBackend +
        'customer/$customerId/favorites/${professional.id}');

    try {
      final response = await http.delete(
        url,
        headers: headers,
      );

      if (response.statusCode == 200) {
        favoriteProfessionals.removeWhere((prof) => prof.id == professional.id);
      } else {
        throw Exception('Failed to remove favorite');
      }
    } catch (error) {
      Get.snackbar('Error', error.toString());
    }
  }

  // Future<Schedule?> getNextAvailability(String professionalCode) async {
  //   final url = APIConstants.apiBackend +
  //       'schedules/nextAvailabilityByProfessionalCode/$professionalCode';
  //   final response = await http.get(Uri.parse(url));

  //   if (response.statusCode == 200) {
  //     if (response.body.isNotEmpty) {
  //       print('Availibility: ${response.body}');

  //       return Schedule.fromJson(json.decode(response.body));
  //     } else {
  //       return null;
  //     }
  //   } else {
  //     throw Exception('Failed to load next availability');
  //   }
  // }

//  void filterProfessionalsByAvailability(String availability) async {
//   DateTime filterDate;

//   // Déterminer la date de filtre en fonction de la sélection de disponibilité
//   if (availability == 'Aujourd\'hui') {
//     filterDate = DateTime.now();
//   } else if (availability == 'Dans 3 jours') {
//     filterDate = DateTime.now().add(Duration(days: 3));
//   } else if (availability == 'Dans une semaine') {
//     filterDate = DateTime.now().add(Duration(days: 7));
//   } else {
//     return; // Aucun filtre appliqué
//   }

//   List<Professional> tempProfessionals = [];

//   // Filtrer les professionnels en fonction de la prochaine disponibilité
//   for (var professional in filteredProfessionals) {
//     // try {
//       if (professional.id != null) {
//         print('Fetching availability for professional ID: ${professional.id}');
//         Schedule? nextAvailability = await getNextAvailability(professional.id!);

//         if (nextAvailability != null) {
//           // Vérification pour s'assurer que 'nextAvailability.dateTime' n'est pas nul
//           DateTime nextAvailabilityDate = DateTime.parse(nextAvailability.dateTime.split('T').first);

//           // Ajouter le professionnel à la liste s'il a une disponibilité avant ou à la date de filtre
//           if (nextAvailabilityDate.isBefore(filterDate) || nextAvailabilityDate.isAtSameMomentAs(filterDate)) {
//             tempProfessionals.add(professional);
//           }
//                 } else {
//           print('No availability found for ${professional.name}. Excluding from results.');
//         }
//       } else {
//         print('Professional ID is null for ${professional.name}. Excluding from results.');
//       }
//     }
//     // catch (e) {
//     //   print('Error fetching availability for ${professional.name}: $e');
//     // }
//  // }

//   // Mettre à jour la liste des professionnels filtrés
//   filteredProfessionals.value = tempProfessionals;

//   // Afficher les professionnels filtrés
//   print('Filtered Professionals: $tempProfessionals');
// }

  

}
