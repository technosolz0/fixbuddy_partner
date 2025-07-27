import 'package:fixbuddy_partner/app/constants/app_color.dart';
import 'package:fixbuddy_partner/app/modules/VendorRegister/controllers/provider_register_controller.dart';
import 'package:flutter/material.dart';

class BankDetailsSection extends StatelessWidget {
  final ProviderRegisterController controller;

  const BankDetailsSection({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Bank Details',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: AppColors.blackColor,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller.bankNameController,
          decoration: InputDecoration(
            labelText: 'Bank Name',
            filled: true,
            fillColor: AppColors.lightgrayColor,
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 10),
        TextFormField(
          controller: controller.accountNameController,
          decoration: InputDecoration(
            labelText: 'Name as per Bank Account',
            filled: true,
            fillColor: AppColors.lightgrayColor,
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 10),
        TextFormField(
          controller: controller.accountNumberController,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            labelText: 'Account Number',
            filled: true,
            fillColor: AppColors.lightgrayColor,
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 10),
        TextFormField(
          controller: controller.confirmAccountNumberController,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            labelText: 'Confirm Account Number',
            filled: true,
            fillColor: AppColors.lightgrayColor,
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 10),
        TextFormField(
          controller: controller.ifscController,
          decoration: InputDecoration(
            labelText: 'IFSC Code',
            filled: true,
            fillColor: AppColors.lightgrayColor,
            border: OutlineInputBorder(),
          ),
        ),
      ],
    );
  }
}
