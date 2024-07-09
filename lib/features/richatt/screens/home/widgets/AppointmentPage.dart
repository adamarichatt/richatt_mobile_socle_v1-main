import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:get/get.dart';
import 'package:richatt_mobile_socle_v1/features/richatt/controllers/professionalController.dart';
import 'package:richatt_mobile_socle_v1/features/richatt/models/Schedule.dart';
import 'package:richatt_mobile_socle_v1/features/richatt/screens/home/widgets/BookingFormPage.dart';
import 'package:richatt_mobile_socle_v1/features/richatt/models/professional.dart';

class AppointmentPage extends StatefulWidget {
  final String professionalId;
  final Professional professional;

  AppointmentPage({required this.professionalId, required this.professional});

  @override
  _AppointmentPageState createState() => _AppointmentPageState();
}

class _AppointmentPageState extends State<AppointmentPage> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();
  late ProfessionalController _controller;

  @override
  void initState() {
    super.initState();
    _controller = ProfessionalController.instance;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Prendre un rendez-vous'),
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: ShapeDecoration(
              color: Color(0x3312AFF0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(28),
              ),
            ),
            child: TableCalendar(
              calendarStyle: CalendarStyle(
                rangeHighlightColor: Colors.blue,
                markerDecoration: BoxDecoration(
                    color: Color.fromARGB(255, 43, 141, 191),
                    shape: BoxShape.circle),
              ),
              firstDay: DateTime(2020, 1, 1),
              lastDay: DateTime(2030, 12, 31),
              focusedDay: _focusedDay,
              calendarFormat: _calendarFormat,
              selectedDayPredicate: (day) {
                return isSameDay(_selectedDay, day);
              },
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  _selectedDay = selectedDay;
                  _focusedDay = focusedDay;
                });
              },
              onFormatChanged: (format) {
                if (_calendarFormat != format) {
                  setState(() {
                    _calendarFormat = format;
                  });
                }
              },
            ),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Text(
                'Available Time',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Schedule>>(
              future: _controller.fetchDaySchedules(
                  _selectedDay, widget.professionalId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(
                      child: Text('No active schedules for selected day'));
                } else {
                  List<Schedule> schedules = snapshot.data!;
                  schedules.sort((a, b) => a.dateTime.compareTo(b.dateTime));

                  return _buildActiveSchedulesForSelectedDay(schedules);
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActiveSchedulesForSelectedDay(List<Schedule> schedules) {
    if (schedules.isEmpty) {
      return Center(child: Text('No active schedules for the selected day'));
    }

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Wrap(
        spacing: 8.0, // Espace horizontal entre les boutons
        runSpacing: 8.0, // Espace vertical entre les lignes de boutons
        children: schedules.map((schedule) {
          return ElevatedButton(
            onPressed: () {
              Get.to(() => BookingFormPage(
                  professionalId: widget.professionalId,
                  schedule: schedule,
                  professional: widget.professional));
            },
            child: Text(schedule.dateTime
                .substring(11, 16)), // Afficher seulement l'heure (HH:MM)
          );
        }).toList(),
      ),
    );
  }
}
