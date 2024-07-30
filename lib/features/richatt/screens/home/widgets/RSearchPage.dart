import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:richatt_mobile_socle_v1/features/richatt/controllers/professionalController.dart';
import 'package:richatt_mobile_socle_v1/features/richatt/models/professional.dart';
import 'package:richatt_mobile_socle_v1/features/richatt/screens/home/widgets/ProfessionalsByEntityPage.dart';
import 'package:richatt_mobile_socle_v1/features/richatt/screens/home/widgets/ProfessionalsBySpecialityPage.dart';
import 'package:richatt_mobile_socle_v1/features/richatt/screens/home/widgets/professionalDetails.dart';
import 'package:richatt_mobile_socle_v1/common/widgets/doctor/RProfileCard.dart'; 

class RSearchPage extends StatefulWidget {
  const RSearchPage({super.key, required this.emailCustomer});
  final String emailCustomer;

  @override
  _RSearchPageState createState() => _RSearchPageState();
}

class _RSearchPageState extends State<RSearchPage> {
  final controller = Get.find<ProfessionalController>();
  final TextEditingController _searchController = TextEditingController();

  // Variables de pagination
  int currentPage = 0;
  final int itemsPerPage = 4;

  @override
  void initState() {
    super.initState();
    controller.resetFilters(); // Réinitialiser les filtres au démarrage
    _searchController.addListener(() {
      final query = _searchController.text;
      if (query.isEmpty) {
        controller.resetFilters();
      } else {
        controller.searchProfessionals(query);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Rechercher'),
        actions: [
          IconButton(
            icon: Icon(Icons.clear),
            onPressed: () {
              setState(() {
                _searchController.clear(); // Effacer le texte
                controller.resetFilters(); // Réinitialiser les filtres
                currentPage = 0; // Réinitialiser la page actuelle
              });
            },
          )
        ],
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Rechercher un docteur par nom, spécialité et établissement',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            Expanded(
              child: Obx(() {
                if (controller.filteredProfessionals.isEmpty && _searchController.text.isNotEmpty) {
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
                      child: ListView(
                        children: [
                          // Specialties
                          if (controller.filteredSpecialities.isNotEmpty)
                            ListTile(
                              title: Text('Specialties', style: TextStyle(fontWeight: FontWeight.bold)),
                            ),
                          ...controller.filteredSpecialities.map((speciality) {
                            return ListTile(
                              title: Text(speciality),
                              onTap: () {
                                controller.filterProfessionalsBySpeciality(speciality);
                                Get.to(() => ProfessionalsBySpecialityPage(
                                  speciality: speciality,
                                  emailCustomer: widget.emailCustomer,
                                  professionals: controller.filteredProfessionals,
                                ));
                              },
                            );
                          }).toList(),

                          // Entities
                          if (controller.filteredEntities.isNotEmpty)
                            ListTile(
                              title: Text('Entities', style: TextStyle(fontWeight: FontWeight.bold)),
                            ),
                          ...controller.filteredEntities.map((entity) {
                            return ListTile(
                              title: Text(entity),
                              onTap: () {
                                controller.filterProfessionalsByEntityName(entity);
                                Get.to(() => ProfessionalsByEntityPage(
                                  entityName: entity,
                                  emailCustomer: widget.emailCustomer,
                                  professionals: controller.filteredProfessionals,
                                ));
                              },
                            );
                          }).toList(),

                          // Professionals
                          if (professionalsToDisplay.isNotEmpty)
                            ListTile(
                              title: Text('Professionals', style: TextStyle(fontWeight: FontWeight.bold)),
                            ),
                          ...professionalsToDisplay.map((professional) {
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
                          }).toList(),
                        ],
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
      ),
    );
  }
}
