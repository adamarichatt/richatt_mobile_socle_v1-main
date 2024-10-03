import 'package:Remeet/features/richatt/models/professional.dart';
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
  String? reservationFor;
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
    this.reservationFor,
    this.professional,
  });

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
      reservationFor: json['reservationFor'],
      professional: json['professional'] != null
          ? Professional.fromJson(json['professional'])
          : null,
    );
  }
//  print('hello');

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
      'reservationFor': reservationFor,
      'professional': professional?.toJson(),
    };
  }
}
