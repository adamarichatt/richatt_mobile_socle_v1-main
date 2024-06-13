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

class EditAppointmentPage extends StatefulWidget {
  final Appointment appointment;
  final String email;
  final String phone;
  EditAppointmentPage({required this.appointment, required this.email, required this.phone});

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

      widget.appointment.dateTime = newDateTime.toIso8601String();
      widget.appointment.firstName = firstNameController.text;
      widget.appointment.lastName = lastNameController.text;
      widget.appointment.reason = service.name;
      widget.appointment.price = service.price;
      widget.appointment.duration = service.duration;

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

        Schedule? newSchedule = allSchedules.firstWhereOrNull(
          (schedule) =>
              DateTime.parse(schedule.dateTime.split('T').first +
                      ' ' +
                      schedule.dateTime.split('T').last.split('-').first)
                  .isAtSameMomentAs(newDateTime) &&
              schedule.status == 'Active',
        );

        if (newSchedule == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('No available slot at the chosen time')),
          );
        } else {
          await _controller.updateAppointment(
              widget.appointment.id!, widget.appointment);
          await _controller.enableSchedules([originalSchedule]);
          await _controller.deleteSchedules([newSchedule]);
          await _controller.addSchedules([newSchedule]);
          await _controller.reserveSchedules([newSchedule]);
        }
      } else {
        await _controller.updateAppointment(
            widget.appointment.id!, widget.appointment);
      }

      Get.to(() => AppointmentsList(email:widget.email, phone:widget.phone));
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
                  "Date: ${DateFormat('yyyy-MM-dd').format(selectedDate)}"),
              trailing: Icon(Icons.calendar_today),
              onTap: () async {
                DateTime? picked = await showDatePicker(
                  context: context,
                  initialDate: selectedDate,
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2101),
                );
                if (picked != null && picked != selectedDate) {
                  setState(() {
                    selectedDate = picked;
                  });
                }
              },
            ),
            const SizedBox(height: RSizes.spaceBtwInputFields),
            ListTile(
              title: Text("Heure: ${selectedTime.format(context)}"),
              trailing: Icon(Icons.access_time),
              onTap: () async {
                TimeOfDay? picked = await showTimePicker(
                  context: context,
                  initialTime: selectedTime,
                );
                if (picked != null && picked != selectedTime) {
                  setState(() {
                    selectedTime = picked;
                  });
                }
              },
            ),
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
}
