import 'package:richatt_mobile_socle_v1/features/richatt/models/professional.dart';

class Schedule {
  final String id;
  final String status;
  final String dateTime; 
  final double duration;
  final String code;
  // final Professional professional;
  
  Schedule({
    required this.id,
    required this.status,
    required this.dateTime,
    required this.duration,
    required this.code,
    // required this.professional,
  });

  factory Schedule.fromJson(Map<String, dynamic> json) {
    return Schedule(
      id: json['id'] ?? '',
      status: json['status'] ?? '',
      dateTime: json['date_time'] ?? '', 
      duration: json['duration'] ?? 0,
      code: json['code'] ?? '',
      //  professional: Professional.fromJson(json['professional']),
    );
  }

}
