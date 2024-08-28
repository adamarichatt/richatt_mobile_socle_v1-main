import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:richatt_mobile_socle_v1/features/richatt/controllers/professionalController.dart';
import 'package:richatt_mobile_socle_v1/features/richatt/models/professional.dart';
import 'package:richatt_mobile_socle_v1/common/widgets/doctor/RProfileCard.dart';
import 'package:richatt_mobile_socle_v1/features/richatt/screens/home/widgets/professionalDetails.dart';

class ProfessionalsByEntityPage extends StatefulWidget {
  final String entityName;
  final String emailCustomer;
  final List<Professional> professionals;

  ProfessionalsByEntityPage(
      {required this.entityName,
      required this.emailCustomer,
      required this.professionals});

  @override
  _ProfessionalsByEntityPageState createState() =>
      _ProfessionalsByEntityPageState();
}

class _ProfessionalsByEntityPageState extends State<ProfessionalsByEntityPage> {
  final controller = Get.find<ProfessionalController>();

  // Variables de pagination
  int currentPage = 0;
  final int itemsPerPage = 5;
  final GlobalKey<FormFieldState> _availabilityFilterKey = GlobalKey<FormFieldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Professionals by ${widget.entityName}'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      hintText: null,
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(
                          vertical: 15.0, horizontal: 10.0),
                    ),
                    hint: Align(
                      alignment: Alignment.center,
                      child: Text(
                        'By city',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                    items: controller
                        .getCitiesForEntity(widget.entityName)
                        .map((city) {
                      return DropdownMenuItem<String>(
                        value: city,
                        child: Text(city.isEmpty ? 'By city' : city),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        currentPage = 0; // Reset to first page
                        controller.filterProfessionalsByEntityAndCity(
                            widget.entityName, value ?? '');
                          // Reset availability filter to 'No filter'
                        controller.selectedAvailability.value =
                            ''; // Set controller's selectedAvailability to empty string
                        controller.filterProfessionalsByAvailability('');
                      });
                    },
                  ),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      hintText: null,
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(
                          vertical: 15.0, horizontal: 10.0),
                    ),
                    hint: Align(
                      alignment: Alignment.center,
                      child: Text(
                        'By speciality',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                    items: controller
                        .getSpecialitiesForEntity(widget.entityName)
                        .map((speciality) {
                      return DropdownMenuItem<String>(
                        value: speciality,
                        child:
                            Text(speciality.isEmpty ? 'By speciality' : speciality),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        currentPage = 0; // Reset to first page
                        controller.filterProfessionalsByEntityAndSpeciality(
                            widget.entityName, value ?? '');
                          // Reset availability filter to 'No filter'
                        controller.selectedAvailability.value =
                            ''; // Set controller's selectedAvailability to empty string
                        controller.filterProfessionalsByAvailability('');
                      });
                    },
                  ),
                ),
                SizedBox(width: 6),
                // Add this inside the Row widget that contains the other filters
                Expanded(
                  child: DropdownButtonFormField<String>(
                    key: _availabilityFilterKey,
                    decoration: InputDecoration(
                      hintText: null,
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(
                          vertical: 15.0, horizontal: 10.0),
                    ),
                    hint: Align(
                      alignment: Alignment.center,
                      child: Text(
                        'By availability',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                    value: controller.selectedAvailability.value.isEmpty
                        ? ''
                        : controller.selectedAvailability.value,
                    items: [
                      DropdownMenuItem(value: '', child: Text('By availability')),
                      DropdownMenuItem(
                          value: 'Aujourd\'hui', child: Text('Aujourd\'hui')),
                      DropdownMenuItem(
                          value: 'Dans 3 jours', child: Text('Dans 3 jours')),
                      DropdownMenuItem(
                          value: 'Dans une semaine',
                          child: Text('Dans une semaine')),
                    ],
                    onChanged: (value) async {
                      setState(() {
                        currentPage = 0; // Reset to first page
                      });
                      controller.filterProfessionalsByAvailability(value ?? '');
                      setState(
                          () {}); // Trigger a rebuild after the async operation
                    },
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Obx(() {
              if (controller.filteredProfessionals.isEmpty) {
                return Center(child: Text("No results found"));
              }

              // Pagination logic
              int totalItems = controller.filteredProfessionals.length;
              int totalPages = (totalItems / itemsPerPage).ceil();
              List<Professional> professionalsToDisplay = controller
                  .filteredProfessionals
                  .skip(currentPage * itemsPerPage)
                  .take(itemsPerPage)
                  .toList();

              return Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: professionalsToDisplay.length,
                      itemBuilder: (context, index) {
                        final professional = professionalsToDisplay[index];
                        return InkWell(
                          onTap: () {
                            Get.to(() => ProfessionalDetailsPage(
                                  professionalId: professional.id!,
                                  professional: professional,
                                  emailCustomer: widget.emailCustomer,
                                ));
                          },
                          child: ProfileCard(
                            professional: professional,
                            emailCustomer: widget.emailCustomer,
                          ),
                        );
                      },
                    ),
                  ),
                  // Pagination controls
                  if (totalPages > 1)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          icon: Icon(Icons.arrow_back),
                          onPressed: currentPage > 0
                              ? () {
                                  setState(() {
                                    currentPage--;
                                  });
                                }
                              : null,
                        ),
                        Text('Page ${currentPage + 1} of $totalPages'),
                        IconButton(
                          icon: Icon(Icons.arrow_forward),
                          onPressed: currentPage < totalPages - 1
                              ? () {
                                  setState(() {
                                    currentPage++;
                                  });
                                }
                              : null,
                        ),
                      ],
                    ),
                ],
              );
            }),
          ),
        ],
      ),
    );
  }
}
