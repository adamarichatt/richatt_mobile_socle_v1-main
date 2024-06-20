import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:richatt_mobile_socle_v1/features/richatt/controllers/professionalController.dart';
import 'package:richatt_mobile_socle_v1/features/richatt/models/Appointment.dart';
import 'package:richatt_mobile_socle_v1/features/richatt/models/Schedule.dart';
import 'package:richatt_mobile_socle_v1/features/richatt/screens/home/widgets/edit_appointment_page.dart';
import 'package:richatt_mobile_socle_v1/utils/constants/api_constants.dart';
import 'package:richatt_mobile_socle_v1/utils/constants/sizes.dart';

class AppointmentsList extends StatefulWidget {
  final String email;
  final String phone;

  const AppointmentsList({required this.email, required this.phone});

  @override
  _AppointmentsListState createState() => _AppointmentsListState();
}

class _AppointmentsListState extends State<AppointmentsList>
    with SingleTickerProviderStateMixin {
  late Future<List<Appointment>> futureAppointments;
  late TabController _tabController;
  late ProfessionalController _controller = new ProfessionalController();

  @override
  void initState() {
    super.initState();
    futureAppointments = _controller.fetchAppointmentsByEmail(widget.email);
    _tabController = TabController(length: 2, vsync: this);
  }

  void _showCancelDialog(Appointment appointment) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirmation'),
          content: Text('Voulez-vous annuler ce RDV?'),
          actions: [
            TextButton(
              child: Text('Non'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Oui'),
              onPressed: () async {
                Navigator.of(context).pop();
                try {
                  List<Schedule> schedules = await _controller
                      .fetchSchedules(appointment.professional!.id!);
                  Schedule? correspondingSchedule = schedules.firstWhere(
                    (schedule) =>
                        schedule.dateTime == appointment.dateTime &&
                        schedule.status == "Reserved",
                  );

                  if (correspondingSchedule != null) {
                    await _controller.enableSchedules([correspondingSchedule]);
                    await _controller.deleteAppointment(appointment.id!);
                    setState(() {
                      futureAppointments =
                          _controller.fetchAppointmentsByEmail(widget.email);
                    });
                  } else {
                    throw Exception('No matching schedule found');
                  }
                } catch (error) {
                  Future.delayed(Duration(milliseconds: 300), () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content:
                              Text('Failed to cancel appointment!: $error')),
                    );
                  });
                }
              },
            ),
          ],
        );
      },
    );
  }

  List<Appointment> filterAppointments(
      List<Appointment> appointments, bool upcoming) {
    DateTime now = DateTime.now();
    return appointments.where((appointment) {
      DateTime appointmentDate = DateTime.parse(
          appointment.dateTime!.split('T').first +
              ' ' +
              appointment.dateTime!.split('T').last.split('-').first);
      return upcoming
          ? appointmentDate.isAfter(now)
          : appointmentDate.isBefore(now);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Appointments List'),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: 'Upcoming'),
            Tab(text: 'Completed'),
          ],
        ),
      ),
      body: FutureBuilder<List<Appointment>>(
        future: futureAppointments,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("${snapshot.error}"));
          } else if (snapshot.hasData) {
            List<Appointment> upcomingAppointments =
                filterAppointments(snapshot.data!, true);
            List<Appointment> completedAppointments =
                filterAppointments(snapshot.data!, false);

            return TabBarView(
              controller: _tabController,
              children: [
                AppointmentsTab(
                  appointments: upcomingAppointments,
                  showButtons: true,
                  onCancel: _showCancelDialog,
                  onEdit: (appointment) {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => EditAppointmentPage(
                        appointment: appointment,
                        email: widget.email,
                        phone: widget.phone,
                      ),
                    ));
                  },
                ),
                AppointmentsTab(
                  appointments: completedAppointments,
                  showButtons: false,
                  onCancel: _showCancelDialog,
                  onEdit: (appointment) {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => EditAppointmentPage(
                        appointment: appointment,
                        email: widget.email,
                        phone: widget.phone,
                      ),
                    ));
                  },
                ),
              ],
            );
          } else {
            return Center(child: Text('No appointments found'));
          }
        },
      ),
    );
  }
}

class AppointmentsTab extends StatelessWidget {
  final List<Appointment> appointments;
  final bool showButtons;
  final Function(Appointment) onCancel;
  final Function(Appointment) onEdit;

  const AppointmentsTab({
    required this.appointments,
    required this.showButtons,
    required this.onCancel,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: appointments.length,
      itemBuilder: (context, index) {
        final appointment = appointments[index];
        List<String> dateTimeParts = appointment.dateTime!.split('T');
        String datePart = dateTimeParts.first;
        String timePart = dateTimeParts.last.split('-').first;
        String combinedDateTime = '$datePart $timePart';

        DateTime dateTime = DateTime.parse(combinedDateTime);
        final formattedDate = DateFormat('dd/MM/yyyy').format(dateTime);
        final formattedTime = DateFormat('HH:mm').format(dateTime);

        return Card(
          margin: EdgeInsets.all(8.0),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('$formattedDate - $formattedTime',
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                SizedBox(height: 8),
                Text(
                    'Patient: ${appointment.firstName!} ${appointment.lastName!}',
                    style: TextStyle(fontSize: 16)),
                SizedBox(height: 8),
                Text(
                    'Dr: ${appointment.professional!.firstName} ${appointment.professional!.name}',
                    style: TextStyle(fontSize: 16)),
                SizedBox(height: 4),
                Text('Addresse: ${appointment.address!}',
                    style: TextStyle(fontSize: 14)),
                SizedBox(height: 8),
                Text('Service: ${appointment.reason!}',
                    style: TextStyle(fontSize: 14)),
                SizedBox(height: 16),
                if (showButtons)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          onEdit(appointment);
                        },
                        child: Text('Edit'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          onCancel(appointment);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                        ),
                        child: Text('Cancel'),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
