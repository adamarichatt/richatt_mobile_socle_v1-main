import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:richatt_mobile_socle_v1/features/richatt/models/Appointment.dart';
import 'package:richatt_mobile_socle_v1/features/richatt/models/Schedule.dart';
import 'package:richatt_mobile_socle_v1/features/richatt/models/service.dart';
import 'package:richatt_mobile_socle_v1/features/richatt/screens/home/widgets/AppointmentsList.dart';
import 'package:richatt_mobile_socle_v1/utils/constants/sizes.dart';
import 'package:richatt_mobile_socle_v1/features/richatt/controllers/professionalController.dart';
import 'package:collection/collection.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:richatt_mobile_socle_v1/utils/helpers/helper_functions.dart';
import 'package:table_calendar/table_calendar.dart';

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
  late TextEditingController firstNameController;
  late TextEditingController lastNameController;
  List<Service> services = [];
  String? selectedReason;
  final ProfessionalController _controller = ProfessionalController();
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  bool _showCalendar = false;
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

    firstNameController =
        TextEditingController(text: widget.appointment.firstName);
    lastNameController =
        TextEditingController(text: widget.appointment.lastName);

    _fetchServices();
  }

  Future<void> _fetchServices() async {
    try {
      List<Service> fetchedServices = await _controller
          .getServicesByProfessional(widget.appointment.professional!.id!);
      setState(() {
        services = fetchedServices;
        selectedReason = services
            .firstWhere((service) => service.name == widget.appointment.reason)
            .id;
      });
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to fetch services: $error')),
      );
    }
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

      final service =
          services.firstWhere((service) => service.id == selectedReason);

      // Check if the date and time have changed
      bool dateTimeChanged = newDateTime != initialDate;
      // Formatter la date selon le format souhaité sans millisecondes
//       String formattedDateTime =
//           DateFormat("yyyy-MM-ddTHH:mm:ss").format(newDateTime);

// // Affecter la date formatée à widget.appointment.dateTime
//       widget.appointment.dateTime = formattedDateTime;

      widget.appointment.firstName = firstNameController.value.text;
      widget.appointment.lastName = lastNameController.value.text;
      widget.appointment.reason = service.name;
      widget.appointment.price = service.price;
      widget.appointment.duration = service.duration;
      widget.appointment.email = widget.email;
      widget.appointment.phone = widget.phone;
      widget.appointment.address = widget.appointment.address;
      widget.appointment.description = widget.appointment.description;

      if (dateTimeChanged) {
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
      } else {
        RHelperFunctions.showLoader();
        await _controller.updateAppointment(
            widget.appointment.id!, widget.appointment);
        Navigator.of(context).pop();
      }

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
              //       final formattedDate = DateFormat('dd/MM/yyyy').format(dateTime);
              // final formattedTime = DateFormat('HH:mm').format(dateTime);
              title: Text(
                  "Date: ${DateFormat('dd/MM/yyyy').format(selectedDate)}"),
              subtitle: Text(
                  "Heure: ${DateFormat('HH:mm').format(DateTime(0, 1, 1, selectedTime.hour, selectedTime.minute))}"),

              trailing: Icon(Icons.calendar_today),
              onTap: () {
                setState(() {
                  _showCalendar = !_showCalendar;
                });
              },
            ),
            if (_showCalendar) ...[
              const SizedBox(height: RSizes.spaceBtwInputFields),
              TableCalendar(
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
            ],
            const SizedBox(height: RSizes.spaceBtwInputFields),
            TextField(
              controller: firstNameController,
              decoration: InputDecoration(labelText: 'First Name'),
            ),
            const SizedBox(height: RSizes.spaceBtwInputFields),
            TextField(
              controller: lastNameController,
              decoration: InputDecoration(labelText: 'Last Name'),
            ),
            const SizedBox(height: RSizes.spaceBtwInputFields),
            DropdownButtonFormField<String>(
              value: selectedReason,
              onChanged: (value) {
                setState(() {
                  selectedReason = value;
                });
              },
              items: services.map((Service service) {
                return DropdownMenuItem<String>(
                  value: service.id,
                  child: Text(service.name),
                );
              }).toList(),
              decoration: InputDecoration(
                labelText: 'Service',
              ),
            ),
            const SizedBox(height: RSizes.spaceBtwInputFields),
            ElevatedButton(
              onPressed: _updateAppointment,
              child: Text('Enregistrer'),
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
                _showCalendar = false;
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
