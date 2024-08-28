import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:richatt_mobile_socle_v1/features/richatt/controllers/professionalController.dart';
import 'package:richatt_mobile_socle_v1/features/richatt/models/professional.dart';
import 'package:richatt_mobile_socle_v1/common/widgets/doctor/RProfileCard.dart';
import 'package:richatt_mobile_socle_v1/features/richatt/screens/home/widgets/professionalDetails.dart';
import 'package:richatt_mobile_socle_v1/utils/constants/sizes.dart';
import 'package:richatt_mobile_socle_v1/utils/device/device_utility.dart';

class ProfessionalsBySpecialityPage extends StatefulWidget {
  final String speciality;
  final String emailCustomer;
  final List<Professional> professionals;

  ProfessionalsBySpecialityPage(
      {required this.speciality,
      required this.emailCustomer,
      required this.professionals});

  @override
  _ProfessionalsBySpecialityPageState createState() =>
      _ProfessionalsBySpecialityPageState();
}

class _ProfessionalsBySpecialityPageState
    extends State<ProfessionalsBySpecialityPage> {
  final ProfessionalController controller = Get.find<ProfessionalController>();

  int currentPage = 0;
  final int itemsPerPage = 5;
  final GlobalKey<FormFieldState> _availabilityFilterKey =
      GlobalKey<FormFieldState>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.filterProfessionalsBySpeciality(widget.speciality);
    });
  }

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
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: IntrinsicHeight(
                child: Row(
                  children: [
                    _buildDropdown(
                        'By city',
                        controller.getCitiesForSpeciality(widget.speciality),
                        (value) =>
                            controller.filterProfessionalsBySpecialityAndCity(
                                widget.speciality, value ?? '')),
                    SizedBox(width: 6),
                    _buildDropdown(
                        'By entity',
                        controller.getEntitiesForSpeciality(widget.speciality),
                        (value) =>
                            controller.filterProfessionalsBySpecialityAndEntity(
                                widget.speciality, value ?? '')),
                    SizedBox(width: 6),
                    _buildAvailabilityDropdown(),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return Center(child: CircularProgressIndicator());
              }
              if (controller.filteredProfessionals.isEmpty) {
                return Center(child: Text("No results found"));
              }

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
                                  professionalId: professional.id ?? '',
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
                  if (totalPages > 1) _buildPagination(totalPages),
                ],
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdown(
      String hint, List<String> items, Function(String?) onChanged) {
    return SizedBox(
      width: 120,
      child: DropdownButtonFormField<String>(
        isExpanded: true,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          border: OutlineInputBorder(),
        ),
        hint: Text(hint, style: TextStyle(fontSize: 13)),
        items: items
            .map((item) => DropdownMenuItem<String>(
                  value: item,
                  child: Text(item.isEmpty ? hint : item,
                      style: TextStyle(fontSize: 13)),
                ))
            .toList(),
        onChanged: (value) {
          setState(() {
            currentPage = 0;
            onChanged(value);
            controller.selectedAvailability.value = '';
            controller.filterProfessionalsByAvailability('');
          });
        },
      ),
    );
  }

  Widget _buildAvailabilityDropdown() {
    return SizedBox(
      width: RDeviceUtils.getScreenWidth(context) / 3 + 15,
      child: DropdownButtonFormField<String>(
        key: _availabilityFilterKey,
        isExpanded: true,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          border: OutlineInputBorder(),
        ),
        hint: Text('By availability', style: TextStyle(fontSize: 13)),
        value: controller.selectedAvailability.value.isEmpty
            ? null
            : controller.selectedAvailability.value,
        items: [
          DropdownMenuItem(
              value: '',
              child: Text('By availability', style: TextStyle(fontSize: 13))),
          DropdownMenuItem(
              value: 'Aujourd\'hui',
              child: Text('Aujourd\'hui', style: TextStyle(fontSize: 13))),
          DropdownMenuItem(
              value: 'Dans 3 jours',
              child: Text('Dans 3 jours', style: TextStyle(fontSize: 13))),
          DropdownMenuItem(
              value: 'Dans une semaine',
              child: Text('Dans une semaine', style: TextStyle(fontSize: 13))),
        ],
        onChanged: (value) {
          setState(() {
            currentPage = 0;
            controller.filterProfessionalsByAvailability(value ?? '');
          });
        },
      ),
    );
  }

  Widget _buildPagination(int totalPages) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed:
              currentPage > 0 ? () => setState(() => currentPage--) : null,
        ),
        Text('Page ${currentPage + 1} of $totalPages'),
        IconButton(
          icon: Icon(Icons.arrow_forward),
          onPressed: currentPage < totalPages - 1
              ? () => setState(() => currentPage++)
              : null,
        ),
      ],
    );
  }
}
