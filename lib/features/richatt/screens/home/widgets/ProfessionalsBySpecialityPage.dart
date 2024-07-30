import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:richatt_mobile_socle_v1/features/richatt/controllers/professionalController.dart';
import 'package:richatt_mobile_socle_v1/features/richatt/models/professional.dart';
import 'package:richatt_mobile_socle_v1/common/widgets/doctor/RProfileCard.dart';
import 'package:richatt_mobile_socle_v1/features/richatt/screens/home/widgets/professionalDetails.dart';

class ProfessionalsBySpecialityPage extends StatefulWidget {
  final String speciality;
  final String emailCustomer;
  final List<Professional> professionals;

  ProfessionalsBySpecialityPage({required this.speciality, required this.emailCustomer, required this.professionals});

  @override
  _ProfessionalsBySpecialityPageState createState() => _ProfessionalsBySpecialityPageState();
}

class _ProfessionalsBySpecialityPageState extends State<ProfessionalsBySpecialityPage> {
  final controller = Get.find<ProfessionalController>();

  // Variables de pagination
  int currentPage = 0;
  final int itemsPerPage = 5;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Professionals by ${widget.speciality}'),
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
                      hintText: 'Filter by city',
                      border: OutlineInputBorder(),
                    ),
                    items: controller.getCitiesForSpeciality(widget.speciality).map((city) {
                      return DropdownMenuItem<String>(
                        value: city,
                        child: Text(city.isEmpty ? 'No filter' : city),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        currentPage = 0; // Reset to first page
                        controller.filterProfessionalsBySpecialityAndCity(widget.speciality, value ?? '');
                      });
                    },
                  ),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      hintText: 'Filter by entity',
                      border: OutlineInputBorder(),
                    ),
                    items: controller.getEntitiesForSpeciality(widget.speciality).map((entity) {
                      return DropdownMenuItem<String>(
                        value: entity,
                        child: Text(entity.isEmpty ? 'No filter' : entity),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        currentPage = 0; // Reset to first page
                        controller.filterProfessionalsBySpecialityAndEntity(widget.speciality, value ?? '');
                      });
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
              List<Professional> professionalsToDisplay = controller.filteredProfessionals
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
                              :null,
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
