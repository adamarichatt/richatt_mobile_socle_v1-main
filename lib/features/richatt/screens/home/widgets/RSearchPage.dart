import 'dart:async';

import 'package:Remeet/common/widgets/doctor/RProfileCard.dart';
import 'package:Remeet/features/richatt/controllers/professionalController.dart';
import 'package:Remeet/features/richatt/models/professional.dart';
import 'package:Remeet/features/richatt/screens/home/widgets/ProfessionalsByEntityPage.dart';
import 'package:Remeet/features/richatt/screens/home/widgets/ProfessionalsBySpecialityPage.dart';
import 'package:Remeet/features/richatt/screens/home/widgets/professionalDetails.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RSearchPage extends StatefulWidget {
  const RSearchPage({super.key, required this.emailCustomer});
  final String emailCustomer;

  @override
  _RSearchPageState createState() => _RSearchPageState();
}

class _RSearchPageState extends State<RSearchPage> {
  final controller = Get.find<ProfessionalController>();
  final TextEditingController _searchController = TextEditingController();
  final _debouncer = Debouncer(milliseconds: 500);
  final RxBool _isLoading = false.obs;

  // Pagination variables
  static const int itemsPerPage = 4;
  int currentPage = 0;

  @override
  void initState() {
    super.initState();
    controller.resetFilters();
    _setupSearchListener();
  }

  void _setupSearchListener() {
    _searchController.addListener(() {
      _debouncer.run(() async {
        final query = _searchController.text;
        if (query.isEmpty) {
          controller.resetFilters();
        } else {
          _isLoading.value = true;
          try {
            await controller.searchProfessionals(query);
          } finally {
            _isLoading.value = false;
          }
        }
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _debouncer.dispose();
    super.dispose();
  }

  Widget _buildSearchField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: 'Search doctor by name, specialty, or facility',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          prefixIcon: const Icon(Icons.search),
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                    controller.resetFilters();
                  },
                )
              : null,
        ),
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(),
          const SizedBox(height: 16),
          Text(
            'Searching...',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInitialContent() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search,
            size: 64,
            color: Colors.grey,
          ),
          SizedBox(height: 16),
          Text(
            'Start typing to search for professionals',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildSpecialtiesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (controller.filteredSpecialities.isNotEmpty) ...[
          _buildSectionHeader('Specialties'),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: controller.filteredSpecialities.length,
            itemBuilder: (context, index) {
              final specialty = controller.filteredSpecialities[index];
              return Card(
                child: ListTile(
                  title: Text(specialty),
                  onTap: () {
                    controller.filterProfessionalsBySpeciality(specialty);
                    Get.to(() => ProfessionalsBySpecialityPage(
                          speciality: specialty,
                          emailCustomer: widget.emailCustomer,
                          professionals: controller.filteredProfessionals,
                        ));
                  },
                ),
              );
            },
          ),
        ],
      ],
    );
  }

  Widget _buildEntitiesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (controller.filteredEntities.isNotEmpty) ...[
          _buildSectionHeader('Facilities'),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: controller.filteredEntities.length,
            itemBuilder: (context, index) {
              final entity = controller.filteredEntities[index];
              return Card(
                child: ListTile(
                  title: Text(entity),
                  onTap: () {
                    controller.filterProfessionalsByEntityName(entity);
                    Get.to(() => ProfessionalsByEntityPage(
                          entityName: entity,
                          emailCustomer: widget.emailCustomer,
                          professionals: controller.filteredProfessionals,
                        ));
                  },
                ),
              );
            },
          ),
        ],
      ],
    );
  }

  Widget _buildProfessionalsSection(
      List<Professional> professionals, int totalPages) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('Professionals'),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: professionals.length,
          itemBuilder: (context, index) {
            final professional = professionals[index];
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
        if (totalPages > 1)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: currentPage > 0
                    ? () => setState(() => currentPage--)
                    : null,
              ),
              Text('Page ${currentPage + 1} of $totalPages'),
              IconButton(
                icon: const Icon(Icons.arrow_forward),
                onPressed: currentPage < totalPages - 1
                    ? () => setState(() => currentPage++)
                    : null,
              ),
            ],
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search'),
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Column(
          children: [
            _buildSearchField(),
            Expanded(
              child: Obx(() {
                // Show loading indicator while searching
                if (_isLoading.value) {
                  return _buildLoadingIndicator();
                }

                // Show initial content if search is empty
                if (_searchController.text.isEmpty) {
                  return _buildInitialContent();
                }

                // Show no results message if search has no results
                if (controller.filteredProfessionals.isEmpty &&
                    controller.filteredSpecialities.isEmpty &&
                    controller.filteredEntities.isEmpty) {
                  return const Center(child: Text("No results found"));
                }

                // Pagination calculations
                final totalItems = controller.filteredProfessionals.length;
                final totalPages = (totalItems / itemsPerPage).ceil();
                final professionalsToDisplay = controller.filteredProfessionals
                    .skip(currentPage * itemsPerPage)
                    .take(itemsPerPage)
                    .toList();

                return SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSpecialtiesSection(),
                      _buildEntitiesSection(),
                      if (professionalsToDisplay.isNotEmpty)
                        _buildProfessionalsSection(
                            professionalsToDisplay, totalPages),
                    ],
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}

class Debouncer {
  final int milliseconds;
  Timer? _timer;

  Debouncer({required this.milliseconds});

  void run(VoidCallback action) {
    _timer?.cancel();
    _timer = Timer(Duration(milliseconds: milliseconds), action);
  }

  void dispose() {
    _timer?.cancel();
  }
}
