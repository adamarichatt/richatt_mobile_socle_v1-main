class Professional {
  final String? id;
  final String firstName;
  final String? lastName;
  final String? email;
  final String? phone;
  final String? businessSector;
  final String? address;
  final String name;
  final String? lange;
  final String? presentation;
  final String? imageUrl;
  final String? statut;
  final String? speciality;
  final String? entityName;
  final String? city;

  Professional(
      {this.id,
      required this.firstName,
      this.lastName,
      this.email,
      this.phone,
      this.businessSector,
      this.address,
      required this.name,
      this.lange,
      this.presentation,
      this.imageUrl,
      this.entityName,
      this.speciality,
      this.statut,
      this.city});

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
    businessSector: json['businessSector'],
    address: json['address'],
    name: json['name'],
    lange: json['lange'],
    presentation: json['presentation'],
    imageUrl: json['imageUrl'],
    statut: json['statut'],
    speciality: json['speciality'],
    entityName: json['entityName'],
    city: json['city'],
  );
}

Map<String, dynamic> _$ProfessionalToJson(Professional instance) =>
    <String, dynamic>{
      'id': instance.id,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'email': instance.email,
      'phone': instance.phone,
      'businessSector': instance.businessSector,
      'address': instance.address,
      'name': instance.name,
      'lange': instance.lange,
      'presentation': instance.presentation,
      'imageUrl': instance.imageUrl,
      'statut': instance.statut,
      'speciality': instance.speciality,
      'entityName': instance.entityName,
      'city': instance.city,
    };
