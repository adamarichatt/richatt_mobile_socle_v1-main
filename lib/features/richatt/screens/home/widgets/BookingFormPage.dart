import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'package:richatt_mobile_rimeet/features/richatt/controllers/professionalController.dart';
import 'package:richatt_mobile_rimeet/features/richatt/models/Schedule.dart';
import 'package:richatt_mobile_rimeet/features/richatt/models/service.dart';
import 'package:richatt_mobile_rimeet/features/richatt/models/Appointment.dart';
import 'package:richatt_mobile_rimeet/features/richatt/models/professional.dart';
import 'package:richatt_mobile_rimeet/features/richatt/screens/profile/controllers/profile_controller.dart';
import 'package:richatt_mobile_rimeet/notification/notification.dart';
import 'package:richatt_mobile_rimeet/utils/constants/sizes.dart';
import 'package:richatt_mobile_rimeet/utils/constants/text_strings.dart';
import 'package:richatt_mobile_rimeet/features/richatt/screens/home/widgets/BookingSuccesful.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:richatt_mobile_rimeet/utils/helpers/helper_functions.dart';

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
  final _descriptionController = TextEditingController();
  late ProfessionalController _controller;
  late List<Service> _services = [];
  final ProfileController profileController = Get.put(ProfileController());

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

      // Filtrer les services dont la durée est inférieure ou égale à la durée du schedule
      services = services
          .where((service) => service.duration! <= widget.schedule.duration)
          .toList();

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

    if (email != null) {
      _email = email;
    }
    if (phone != null) {
      _phoneNumber = phone;
    }

    if (_bookingFor == 'My self') {
      profileController
          .getCustomerByEmail(_email); // Assuming this fetches user details
      await Future.delayed(
          Duration(milliseconds: 500)); // Delay for the profile data to load

      setState(() {
        _firstName = profileController.firstName.value;
        _lastName = profileController.lastName.value;

        // Set initial values for first name and last name fields
        _firstNameKey.currentState?.didChange(_firstName);
        _lastNameKey.currentState?.didChange(_lastName);
      });
    }
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
      reservationFor: _bookingFor,
      professional: _professional,
    );
    //print('hello');
    try {
      RHelperFunctions.showLoader();
      await _controller.deleteSchedules([widget.schedule]);
      await _controller.addSchedules([widget.schedule]);
      await _controller.reserveSchedules([widget.schedule]);
      await _controller.addAppointment(appointment);

      Get.snackbar('Success', 'Appointment booked successfully!');
    } catch (error) {
      Get.snackbar('Error', error.toString());
    }
    List<String> dateTimeParts = appointment.dateTime!.split('T');
    String datePart = dateTimeParts.first;
    String timePart = dateTimeParts.last.split('-').first;
    DateTime parsedDate = DateTime.parse(datePart);
    String formattedDate = DateFormat('dd/MM/yyyy').format(parsedDate);
    NotificationService.showInstantNotification('RICHATT RDV ',
        'Prise de rendez vous confirmer Le $formattedDate à $timePart ');
    Get.to(() => BookingSuccessful(
          appointment: appointment,
        ));
  }

  void _validateAllFields() {
    _firstNameKey.currentState?.validate();
    _lastNameKey.currentState?.validate();
    _birthdateKey.currentState?.validate();
    _serviceKey.currentState?.validate();
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
      body: _services.isEmpty
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
                    SizedBox(
                      width: 396,
                      height: 21,
                      child: Text(
                        'Booking For',
                        style: TextStyle(
                          color: Color(0xFF17181A),
                          fontSize: 16,
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.w600,
                          height: 0,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: RSizes.spaceBtwItems,
                    ),
                    DropdownButtonFormField<String>(
                      value: _bookingFor,
                      onChanged: (value) {
                        setState(() {
                          _bookingFor = value!;
                          if (_bookingFor == 'My self') {
                            _firstName = profileController.firstName.value;
                            _lastName = profileController.lastName.value;
                            _firstNameKey.currentState?.didChange(_firstName);
                            _lastNameKey.currentState?.didChange(_lastName);
                          } else {
                            _firstName = '';
                            _lastName = '';
                            _firstNameKey.currentState?.didChange(_firstName);
                            _lastNameKey.currentState?.didChange(_lastName);
                          }
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
                        hintText: 'Booking for',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(28),
                          borderSide: BorderSide(color: Color(0xFFD9E1E7)),
                        ),
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                    ),
                    const SizedBox(
                      height: RSizes.spaceBtwItems,
                    ),
                    SizedBox(
                      width: 396,
                      height: 21,
                      child: Text(
                        'Service',
                        style: TextStyle(
                          color: Color(0xFF17181A),
                          fontSize: 16,
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.w600,
                          height: 0,
                        ),
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
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(28),
                          borderSide: BorderSide(color: Color(0xFFD9E1E7)),
                        ),
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                      hint: Align(
                        alignment: Alignment.center,
                        child: Text(
                          'Service',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontFamily: 'Nunito',
                            fontWeight: FontWeight.w400,
                          ),
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
                    SizedBox(
                      width: 396,
                      height: 21,
                      child: Text(
                        'First Name',
                        style: TextStyle(
                          color: Color(0xFF17181A),
                          fontSize: 16,
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.w600,
                          height: 0,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: RSizes.spaceBtwItems,
                    ),
                    TextFormField(
                      key: _firstNameKey,
                      decoration: InputDecoration(
                        hintText: 'First Name',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(28),
                          borderSide: BorderSide(color: Color(0xFFD9E1E7)),
                        ),
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                      initialValue: _firstName,
                      enabled: _bookingFor != 'My self',
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
                    SizedBox(
                      width: 396,
                      height: 21,
                      child: Text(
                        'Last Name',
                        style: TextStyle(
                          color: Color(0xFF17181A),
                          fontSize: 16,
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.w600,
                          height: 0,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: RSizes.spaceBtwItems,
                    ),
                    TextFormField(
                      key: _lastNameKey,
                      decoration: InputDecoration(
                        hintText: 'Last Name',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(28),
                          borderSide: BorderSide(color: Color(0xFFD9E1E7)),
                        ),
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                      initialValue: _lastName,
                      enabled: _bookingFor != 'My self',
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
                    SizedBox(
                      width: 396,
                      height: 21,
                      child: Text(
                        'Gender',
                        style: TextStyle(
                          color: Color(0xFF17181A),
                          fontSize: 16,
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.w600,
                          height: 0,
                        ),
                      ),
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
                        hintText: 'Gender',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(28),
                          borderSide: BorderSide(color: Color(0xFFD9E1E7)),
                        ),
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                    ),
                    const SizedBox(
                      height: RSizes.spaceBtwItems,
                    ),
                    SizedBox(
                      width: 396,
                      height: 21,
                      child: Text(
                        'Birthdate',
                        style: TextStyle(
                          color: Color(0xFF17181A),
                          fontSize: 16,
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.w600,
                          height: 0,
                        ),
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
                        hintText: 'Select birthdate',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(28),
                          borderSide: BorderSide(color: Color(0xFFD9E1E7)),
                        ),
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                        filled: true,
                        fillColor: Colors.white,
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
                    SizedBox(
                      width: 396,
                      height: 21,
                      child: Text(
                        'Description',
                        style: TextStyle(
                          color: Color(0xFF17181A),
                          fontSize: 16,
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.w600,
                          height: 0,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: RSizes.spaceBtwItems,
                    ),
                    TextField(
                      controller: _descriptionController,
                      maxLines: 5,
                      decoration: InputDecoration(
                        hintText: 'Description',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(28),
                          borderSide: BorderSide(color: Color(0xFFD9E1E7)),
                        ),
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                      onChanged: (value) {
                        _description = value;
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
