import 'package:json_annotation/json_annotation.dart';

class Professional {
  final String? id;
  final String firstName;
  final String? lastName;
  final String? email;
  final String? phone;

  final String name;
  final String? lange;
  final String? presentation;
  final String? imageUrl;

  Professional({
    this.id,
    required this.firstName,
    this.lastName,
    this.email,
    this.phone,
    required this.name,
    this.lange,
    this.presentation,
    this.imageUrl,
  });

  factory Professional.fromJson(Map<String, dynamic> json) =>
      _$ProfessionalFromJson(json);

  Map<String, dynamic> toJson() => _$ProfessionalToJson(this);
}

Professional _$ProfessionalFromJson(Map<String, dynamic> json) {
  return Professional(
    id: json['id'],
    firstName: json['firstName'],
    lastName: json['lastName'],
    email: json['email'],
    phone: json['phone'],
    name: json['name'],
    lange: json['lange'],
    presentation: json['presentation'],
    imageUrl: json['imageUrl'],
  );
}

Map<String, dynamic> _$ProfessionalToJson(Professional instance) =>
    <String, dynamic>{
      'id': instance.id,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'email': instance.email,
      'phone': instance.phone,
      'name': instance.name,
      'lange': instance.lange,
      'presentation': instance.presentation,
      'imageUrl': instance.imageUrl,
    };
