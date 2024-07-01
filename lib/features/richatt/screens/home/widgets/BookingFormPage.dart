import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'package:richatt_mobile_socle_v1/features/richatt/controllers/professionalController.dart';
import 'package:richatt_mobile_socle_v1/features/richatt/models/Schedule.dart';
import 'package:richatt_mobile_socle_v1/features/richatt/models/service.dart';
import 'package:richatt_mobile_socle_v1/features/richatt/models/Appointment.dart';
import 'package:richatt_mobile_socle_v1/features/richatt/models/professional.dart';
import 'package:richatt_mobile_socle_v1/utils/constants/sizes.dart';
import 'package:richatt_mobile_socle_v1/utils/constants/text_strings.dart';
import 'package:richatt_mobile_socle_v1/features/richatt/screens/home/widgets/BookingSuccesful.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BookingFormPage extends StatefulWidget {
  final String professionalId;
  final Schedule schedule;
  final Professional professional;

  BookingFormPage(
      {required this.professionalId,
      required this.schedule,
      required this.professional});

  @override
  _BookingFormPageState createState() => _BookingFormPageState();
}

class _BookingFormPageState extends State<BookingFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameKey = GlobalKey<FormFieldState>();
  final _lastNameKey = GlobalKey<FormFieldState>();
  final _birthdateKey = GlobalKey<FormFieldState>();
  final _serviceKey = GlobalKey<FormFieldState>();
  final _descriptionKey = GlobalKey<FormFieldState>();

  String _bookingFor = 'My self';
  String _firstName = '';
  String _lastName = '';
  String _email = '';
  String _phoneNumber = '';

  String _gender = 'Male';

  String _description = '';
  String? _selectedService;
  String? _birthdate;
  Professional? _professional;
  final TextEditingController _birthdateController = TextEditingController();

  late ProfessionalController _controller;
  late List<Service> _services = [];

  @override
  void initState() {
    super.initState();
    _controller = ProfessionalController.instance;
    _professional = widget.professional;
    _fetchServices();
    _populateUserDetails();
  }

  void _fetchServices() async {
    try {
      List<Service> services =
          await _controller.getServicesByProfessional(widget.professionalId);
      setState(() {
        _services = services;
      });
    } catch (error) {
      Get.snackbar('Error', error.toString());
    }
  }

  void _populateUserDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? email = prefs.getString('email');
    String? phone = prefs.getString('phone');
    print('email: $email');
    print('phone: $phone');
    setState(() {
      if (email != null) _email = email;
      if (phone != null) _phoneNumber = phone;
    });
  }

  void _bookSchedule() async {
    if (!_formKey.currentState!.validate()) {
      _validateAllFields();
      return;
    }

    _formKey.currentState!.save();

    final service =
        _services.firstWhere((service) => service.id == _selectedService);
    final appointment = Appointment(
      id: Appointment.generateId(),
      reason: service.name,
      price: service.price,
      duration: service.duration,
      description: _description,
      firstName: _firstName,
      lastName: _lastName,
      email: _email,
      phone: _phoneNumber,
      address: _professional!.address,
      dateTime: widget.schedule.dateTime,
      birthdate: _birthdate,
      professional: _professional,
    );

    try {
      await _controller.deleteSchedules([widget.schedule]);
      await _controller.addSchedules([widget.schedule]);
      await _controller.reserveSchedules([widget.schedule]);
      await _controller.addAppointment(appointment);

      Get.snackbar('Success', 'Appointment booked successfully!');
    } catch (error) {
      Get.snackbar('Error', error.toString());
    }
    Get.to(() => BookingSuccessful(
          appointment: appointment,
        ));
  }

  void _validateAllFields() {
    _firstNameKey.currentState?.validate();
    _lastNameKey.currentState?.validate();
    _birthdateKey.currentState?.validate();
    _serviceKey.currentState?.validate();
    _descriptionKey.currentState?.validate();
  }

  @override
  void dispose() {
    _birthdateController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate:
          _birthdate == null ? DateTime.now() : DateTime.parse(_birthdate!),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        _birthdate = DateFormat('yyyy-MM-ddTHH:mm:ss.SSS').format(picked);
        _birthdateController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Patient Details'),
      ),
      body: _services == null
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: ListView(
                  children: [
                    const SizedBox(
                      height: RSizes.spaceBtwItems,
                    ),
                    DropdownButtonFormField<String>(
                      value: _bookingFor,
                      onChanged: (value) {
                        setState(() {
                          _bookingFor = value!;
                        });
                      },
                      items: ['My self', 'Family relative', 'Friend']
                          .map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      decoration: InputDecoration(
                        labelText: 'Booking for',
                      ),
                    ),
                    const SizedBox(
                      height: RSizes.spaceBtwItems,
                    ),
                    DropdownButtonFormField<String>(
                      key: _serviceKey,
                      value: _selectedService,
                      onChanged: (value) {
                        setState(() {
                          _selectedService = value;
                        });
                      },
                      items: _services.map((Service service) {
                        return DropdownMenuItem<String>(
                          value: service.id,
                          child: Text(service.name),
                        );
                      }).toList(),
                      decoration: InputDecoration(
                        labelText: 'Service',
                        errorStyle: TextStyle(color: Colors.red),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.red),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please select a service';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: RSizes.spaceBtwItems,
                    ),
                    TextFormField(
                      key: _firstNameKey,
                      decoration: InputDecoration(
                        labelText: 'First Name',
                        errorStyle: TextStyle(color: Colors.red),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.red),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter first name';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _firstName = value!;
                      },
                    ),
                    const SizedBox(
                      height: RSizes.spaceBtwItems,
                    ),
                    TextFormField(
                      key: _lastNameKey,
                      decoration: InputDecoration(
                        labelText: 'Last Name',
                        errorStyle: TextStyle(color: Colors.red),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.red),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter last name';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _lastName = value!;
                      },
                    ),
                  
                    const SizedBox(
                      height: RSizes.spaceBtwItems,
                    ),

                    DropdownButtonFormField<String>(
                      value: _gender,
                      onChanged: (value) {
                        setState(() {
                          _gender = value!;
                        });
                      },
                      items: ['Male', 'Female'].map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      decoration: InputDecoration(
                        labelText: 'Gender',
                      ),
                    ),
                    const SizedBox(
                      height: RSizes.spaceBtwItems,
                    ),
                    TextFormField(
                      key: _birthdateKey,
                      controller: _birthdateController,
                      readOnly: true,
                      decoration: InputDecoration(
                        labelText: 'Birthdate',
                        hintText: 'Select birthdate',
                        errorStyle: TextStyle(color: Colors.red),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.red),
                        ),
                      ),
                      onTap: () {
                        _selectDate(context);
                      },
                      validator: (value) {
                        if (_birthdate == null) {
                          return 'Please select birthdate';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: RSizes.spaceBtwItems,
                    ),
                    TextFormField(
                      key: _descriptionKey,
                      decoration: InputDecoration(
                        labelText: 'Description',
                        errorStyle: TextStyle(color: Colors.red),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.red),
                        ),
                      ),
                      onSaved: (value) {
                        _description = value!;
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter description';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: RSizes.spaceBtwItems,
                    ),

                    ElevatedButton(
                      onPressed: _bookSchedule,
                      child: Text('Prendre un rendez-vous'),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
