import 'package:fixbuddy_partner/app/constants/app_color.dart';
import 'package:fixbuddy_partner/app/modules/VendorRegister/controllers/provider_register_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddressDetailsSection extends StatelessWidget {
  final ProviderRegisterController controller;

  const AddressDetailsSection({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Address Details',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: AppColors.blackColor,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller.addressController,
          decoration: InputDecoration(
            labelText: 'Room/Flat No, Building',
            filled: true,
            fillColor: AppColors.lightgrayColor,
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 10),
        TextFormField(
          controller: controller.roadController,
          decoration: InputDecoration(
            labelText: 'Road / Area',
            filled: true,
            fillColor: AppColors.lightgrayColor,
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 10),
        TextFormField(
          controller: controller.landmarkController,
          decoration: InputDecoration(
            labelText: 'Landmark (optional)',
            filled: true,
            fillColor: AppColors.lightgrayColor,
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 10),
        TextFormField(
          controller: controller.landmarkController,
          decoration: InputDecoration(
            labelText: 'City',
            filled: true,
            fillColor: AppColors.lightgrayColor,
            border: OutlineInputBorder(),
          ),
        ),

        const SizedBox(height: 10),
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
        const SizedBox(height: 10),

        TextFormField(
          controller: controller.pinCodeController,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            labelText: 'Pin Code',
            filled: true,
            fillColor: AppColors.lightgrayColor,
            border: OutlineInputBorder(),
          ),
        ),
      ],
    );
  }
}
