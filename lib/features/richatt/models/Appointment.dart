import 'package:richatt_mobile_socle_v1/features/richatt/models/professional.dart';
import 'dart:math';


class Appointment {
  String? id;
  String? address;
  String? reason;
  dynamic price;
  dynamic duration;
  String? description;
  String? firstName;
  String? lastName;
  String? phone;
  String? dateTime;
  String? email;
  String? birthdate; 
  Professional? professional;

  Appointment({
    this.id,
    this.address,
    this.reason,
    this.price,
    this.duration,
    this.description,
    this.firstName,
    this.lastName,
    this.phone,
    this.dateTime,
    this.email,
    this.birthdate,
    this.professional,
  });

  // // Méthode pour générer un ID unique pour l'appointment
  // static String generateId() {
  //   final now = DateTime.now();
  //   final randomDigits = now.microsecondsSinceEpoch.toString().substring(9); // Générer des chiffres aléatoires basés sur le temps actuel
  //   return 'Appointment$randomDigits';
  // }
  static String generateId() {
    final random = Random();
    final randomDigits = List.generate(5, (_) => random.nextInt(10)).join();
    return 'Appointment$randomDigits';
  }

  factory Appointment.fromJson(Map<String, dynamic> json) {
    return Appointment(
      id: json['id'],
      address: json['address'],
      reason: json['reason'],
      price: json['price'],
      duration: json['duration'],
      description: json['description'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      phone: json['phone'],
      dateTime: json['dateTime'],
      email: json['email'],
      birthdate: json['birthdate'],
      professional: json['professional'] != null ? Professional.fromJson(json['professional']) : null,
      
    );
  }


  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'address': address,
      'reason': reason,
      'price': price,
      'duration': duration,
      'description': description,
      'firstName': firstName,
      'lastName': lastName,
      'phone': phone,
      'dateTime': dateTime,
      'email': email,
      'birthdate': birthdate, 
      'professional': professional?.toJson(),
    };
  }
}
