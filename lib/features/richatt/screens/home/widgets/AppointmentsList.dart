import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:richatt_mobile_socle_v1/features/richatt/controllers/professionalController.dart';
import 'package:richatt_mobile_socle_v1/features/richatt/models/Appointment.dart';
import 'package:richatt_mobile_socle_v1/features/richatt/models/Schedule.dart';
import 'package:richatt_mobile_socle_v1/features/richatt/screens/home/widgets/edit_appointment_page.dart';
import 'package:richatt_mobile_socle_v1/features/richatt/screens/home/widgets/AppointmentDetailsPage.dart';
import 'package:richatt_mobile_socle_v1/utils/constants/api_constants.dart';
import 'package:richatt_mobile_socle_v1/utils/constants/image_strings.dart';
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

        return InkWell(
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => AppointmentDetailsPage(
                appointment: appointment,
              ),
            ));
          },
          child: Container(
            width: 396,
            height: 256,
            margin: EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(28),
              boxShadow: [
                BoxShadow(
                  color: Color(0x19000000),
                  blurRadius: 4,
                  offset: Offset(0, 0),
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Stack(
              children: [
                Positioned(
                  left: 335,
                  top: -77,
                  child: Container(
                    width: 8,
                    height: 8,
                    color: Color(0xFFD9D9D9),
                  ),
                ),
                Positioned(
                  left: 9,
                  top: 16,
                  child: Text(
                    '$formattedDate - $formattedTime',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      letterSpacing: -0.38,
                    ),
                  ),
                ),
                Positioned(
                  left: 9,
                  top: 56,
                  right: 9,
                  child: Divider(color: Colors.black),
                ),
                Positioned(
                  left: 9,
                  top: 78,
                  child: Container(
                    width: 80,
                    height: 90,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(RImages
                            .doctor1), // Utilisation de l'URL de l'image du projet
                        fit: BoxFit.fill,
                      ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
                Positioned(
                  left: 100,
                  top: 81,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Dr. ${appointment.professional!.firstName} ${appointment.professional!.name}',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          letterSpacing: -0.16,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        '${appointment.professional!.businessSector}',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 12,
                          letterSpacing: -0.23,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Available at ${appointment.professional!.entityName}-${appointment.address}',
                        style: TextStyle(
                          color: Colors.black.withOpacity(0.5),
                          fontSize: 12,
                          letterSpacing: -0.23,
                        ),
                      ),
                      SizedBox(height: 16),
                      Row(
                        children: [
                          Text(
                            appointment.address!,
                            style: TextStyle(
                              color: Color(0xFF0B9AD3),
                              fontSize: 12,
                              letterSpacing: -0.23,
                            ),
                          ),
                          SizedBox(width: 16),
                          Text(
                            '+20 Years of Experience',
                            style: TextStyle(
                              color: Color(0xFFC2A404),
                              fontSize: 12,
                              letterSpacing: -0.23,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                if (showButtons)
                  Positioned(
                    left: 9,
                    top: 182,
                    right: 9,
                    child: Divider(color: Colors.black),
                  ),
                if (showButtons)
                  Positioned(
                    left: 9,
                    top: 200,
                    child: Row(
                      children: [
                        InkWell(
                          onTap: () => onCancel(appointment),
                          child: Container(
                            width: 181,
                            height: 40,
                            decoration: BoxDecoration(
                              border: Border.all(color: Color(0xFF0B9AD3)),
                              borderRadius: BorderRadius.circular(100),
                            ),
                            child: Center(
                              child: Text(
                                'Cancel',
                                style: TextStyle(
                                  color: Color(0xFF0B9AD3),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 16),
                        InkWell(
                          onTap: () => onEdit(appointment),
                          child: Container(
                            width: 181,
                            height: 40,
                            decoration: BoxDecoration(
                              color: Color(0xFF0B9AD3),
                              borderRadius: BorderRadius.circular(100),
                            ),
                            child: Center(
                              child: Text(
                                'Reschedule',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
