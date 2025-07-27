import 'package:fixbuddy_partner/app/constants/app_color.dart';
import 'package:fixbuddy_partner/app/modules/VendorRegister/controllers/provider_register_controller.dart';
import 'package:fixbuddy_partner/app/modules/VendorRegister/models/service_location_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ServiceLocationView extends StatelessWidget {
  final controller = Get.find<ProviderRegisterController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Service Locations & Charges'),
        backgroundColor: AppColors.primaryColor,
        foregroundColor: AppColors.blackColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Category Dropdown
              Obx(
                () => DropdownButtonFormField<String>(
                  value: controller.selectedCategory.value.isNotEmpty
                      ? controller.selectedCategory.value
                      : null,
                  items: controller.categories
                      .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                      .toList(),
                  onChanged: (value) {
                    controller.selectedCategory.value = value!;
                    controller.selectedSubCategory.value = '';
                  },
                  decoration: InputDecoration(
                    labelText: 'Category',
                    filled: true,
                    fillColor: AppColors.lightgrayColor,
                    border: const OutlineInputBorder(),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // SubCategory Dropdown
              Obx(
                () => DropdownButtonFormField<String>(
                  value: controller.selectedSubCategory.value.isNotEmpty
                      ? controller.selectedSubCategory.value
                      : null,
                  items:
                      (controller.subCategories[controller
                                  .selectedCategory
                                  .value] ??
                              [])
                          .map(
                            (sc) =>
                                DropdownMenuItem(value: sc, child: Text(sc)),
                          )
                          .toList(),
                  onChanged: (value) =>
                      controller.selectedSubCategory.value = value ?? '',
                  decoration: InputDecoration(
                    labelText: 'Sub Category',
                    filled: true,
                    fillColor: AppColors.lightgrayColor,
                    border: const OutlineInputBorder(),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // State Dropdown
              Obx(
                () => DropdownButtonFormField<String>(
                  value: controller.selectedState.value.isNotEmpty
                      ? controller.selectedState.value
                      : null,
                  items: controller.states
                      .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                      .toList(),
                  onChanged: (value) {
                    controller.selectedState.value = value!;
                    controller.selectedCity.value = '';
                  },
                  decoration: InputDecoration(
                    labelText: 'State',
                    filled: true,
                    fillColor: AppColors.lightgrayColor,
                    border: const OutlineInputBorder(),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // City Dropdown
              Obx(() {
                final cityList = controller.selectedState.value.isNotEmpty
                    ? controller.cities[controller.selectedState.value]!
                    : [];
                return DropdownButtonFormField<String>(
                  value: controller.selectedCity.value.isNotEmpty
                      ? controller.selectedCity.value
                      : null,
                  items: cityList
                      .map(
                        (c) =>
                            DropdownMenuItem<String>(value: c, child: Text(c)),
                      )
                      .toList(),
                  onChanged: (value) => controller.selectedCity.value = value!,
                  decoration: InputDecoration(
                    labelText: 'City',
                    filled: true,
                    fillColor: AppColors.lightgrayColor,
                    border: const OutlineInputBorder(),
                  ),
                );
              }),
              const SizedBox(height: 16),

              // Experience
              TextFormField(
                controller: controller.experienceController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Experience (in years)',
                  filled: true,
                  fillColor: AppColors.lightgrayColor,
                  border: const OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),

              // Charge
              TextFormField(
                controller: controller.priceController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Charge (₹)',
                  filled: true,
                  fillColor: AppColors.lightgrayColor,
                  border: const OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 24),

              // Add Service Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (controller.selectedCategory.value.isEmpty ||
                        controller.selectedSubCategory.value.isEmpty ||
                        controller.selectedState.value.isEmpty ||
                        controller.selectedCity.value.isEmpty ||
                        controller.priceController.text.isEmpty ||
                        controller.experienceController.text.isEmpty) {
                      Get.snackbar('Error', 'Please fill all fields.');
                      return;
                    }

                    final newLocation = ServiceLocationModel(
                      category: controller.selectedCategory.value,
                      subCategory: controller.selectedSubCategory.value,
                      state: controller.selectedState.value,
                      city: controller.selectedCity.value,
                      charge: controller.priceController.text,
                      experience: controller.experienceController.text,
                    );

                    controller.serviceLocations.add(newLocation);
                    Get.snackbar('Success', 'Service location added.');

                    // Clear inputs
                    controller.selectedCategory.value = '';
                    controller.selectedSubCategory.value = '';
                    controller.selectedState.value = '';
                    controller.selectedCity.value = '';
                    controller.priceController.clear();
                    controller.experienceController.clear();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryColor,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: const Text(
                    'Add Service',
                    style: TextStyle(
                      color: AppColors.blackColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // List of added service locations
              Obx(
                () => ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: controller.serviceLocations.length,
                  itemBuilder: (context, index) {
                    final e = controller.serviceLocations[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 6),
                      child: ListTile(
                        title: Text(
                          '${e.category} > ${e.subCategory} (${e.state}, ${e.city})',
                        ),
                        subtitle: Text(
                          '₹${e.charge} | ${e.experience} yrs experience',
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            controller.serviceLocations.removeAt(index);
                          },
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
