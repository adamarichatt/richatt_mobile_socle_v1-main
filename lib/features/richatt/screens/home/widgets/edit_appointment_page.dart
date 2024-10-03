import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:Remeet/features/richatt/models/Appointment.dart';
import 'package:Remeet/features/richatt/models/Schedule.dart';

import 'package:Remeet/features/richatt/screens/home/widgets/AppointmentsList.dart';
import 'package:Remeet/utils/constants/sizes.dart';
import 'package:Remeet/features/richatt/controllers/professionalController.dart';
import 'package:collection/collection.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:Remeet/utils/helpers/helper_functions.dart';

class EditAppointmentPage extends StatefulWidget {
  final Appointment appointment;
  final String email;
  final String phone;

  EditAppointmentPage({
    required this.appointment,
    required this.email,
    required this.phone,
  });

  @override
  _EditAppointmentPageState createState() => _EditAppointmentPageState();
}

class _EditAppointmentPageState extends State<EditAppointmentPage> {
  late DateTime initialDate;
  late TimeOfDay initialTime;
  late DateTime selectedDate;
  late TimeOfDay selectedTime;

  final ProfessionalController _controller = ProfessionalController();
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();

  Schedule? newSchedule;

  @override
  void initState() {
    super.initState();

    initialDate = DateTime.parse(widget.appointment.dateTime!.split('T').first +
        ' ' +
        widget.appointment.dateTime!.split('T').last.split('-').first);
    initialTime = TimeOfDay(
      hour: int.parse(
          widget.appointment.dateTime!.split('T').last.split(':').first),
      minute:
          int.parse(widget.appointment.dateTime!.split('T').last.split(':')[1]),
    );

    selectedDate = initialDate;
    selectedTime = initialTime;
  }

  Future<void> _updateAppointment() async {
    try {
      // Combine the selected date and time into a DateTime object
      DateTime newDateTime = DateTime(
        selectedDate.year,
        selectedDate.month,
        selectedDate.day,
        selectedTime.hour,
        selectedTime.minute,
      );

      widget.appointment.email = widget.email;
      widget.appointment.phone = widget.phone;
      widget.appointment.address = widget.appointment.address;
      widget.appointment.description = widget.appointment.description;

      List<Schedule> allSchedules = await _controller
          .fetchSchedules(widget.appointment.professional!.id!);

      Schedule? originalSchedule = allSchedules.firstWhereOrNull(
        (schedule) => DateTime.parse(schedule.dateTime.split('T').first +
                ' ' +
                schedule.dateTime.split('T').last.split('-').first)
            .isAtSameMomentAs(initialDate),
      );

      if (originalSchedule == null) {
        throw Exception('Original schedule not found');
      }

      if (newSchedule == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('No available slot at the chosen time')),
        );
      } else {
        widget.appointment.dateTime = newSchedule!.dateTime;
        await _controller.updateAppointment(
            widget.appointment.id!, widget.appointment);
        await _controller.enableSchedules([originalSchedule]);
        await _controller.deleteSchedules([newSchedule!!]);
        await _controller.addSchedules([newSchedule!!]);
        await _controller.reserveSchedules([newSchedule!!]);
        Navigator.of(context).pop();
      }
      // } else {
      //   RHelperFunctions.showLoader();
      //   await _controller.updateAppointment(
      //       widget.appointment.id!, widget.appointment);
      //   Navigator.of(context).pop();
      // }

      Get.to(() => AppointmentsList(email: widget.email, phone: widget.phone));
    } catch (error) {
      Future.delayed(Duration(milliseconds: 300), () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update appointment!: $error')),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Modifier RDV'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const SizedBox(height: RSizes.spaceBtwInputFields),
            ListTile(
              title: Text(
                  "Date: ${DateFormat('dd/MM/yyyy').format(selectedDate)}"),
              subtitle: Text(
                  "Heure: ${DateFormat('HH:mm').format(DateTime(0, 1, 1, selectedTime.hour, selectedTime.minute))}"),
              trailing: Icon(Icons.calendar_today),
            ),
            const SizedBox(height: RSizes.spaceBtwInputFields),
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
                  return isSameDay(selectedDate, day);
                },
                onDaySelected: (selectedDay, focusedDay) {
                  setState(() {
                    selectedDate = selectedDay;
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
            const SizedBox(height: RSizes.spaceBtwInputFields),
            FutureBuilder<List<Schedule>>(
              future: _controller.fetchDaySchedules(
                  selectedDate, widget.appointment.professional!.id!),
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

                  return _activeSchedulesForSelectedDay(schedules);
                }
              },
            ),
            const SizedBox(height: RSizes.spaceBtwInputFields),
            ElevatedButton(
              onPressed: _updateAppointment,
              child: Text(
                'Enregistrer',
                style: TextStyle(fontSize: 14),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding: EdgeInsets.symmetric(
                    horizontal: 16, vertical: 8), // Smaller padding
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _activeSchedulesForSelectedDay(List<Schedule> schedules) {
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
              setState(() {
                selectedDate = DateTime.parse(
                    schedule.dateTime.split('T').first +
                        ' ' +
                        schedule.dateTime.split('T').last.split('-').first);
                selectedTime = TimeOfDay(
                  hour: int.parse(
                      schedule.dateTime.split('T').last.split(':').first),
                  minute: int.parse(
                      schedule.dateTime.split('T').last.split(':')[1]),
                );
                newSchedule = schedule;
                // _showCalendar = false;
              });
            },
            child: Text(schedule.dateTime
                .substring(11, 16)), // Afficher seulement l'heure (HH:MM)
          );
        }).toList(),
      ),
    );
  }
}
