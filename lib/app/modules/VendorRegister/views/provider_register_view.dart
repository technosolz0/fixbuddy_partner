import 'package:fixbuddy_partner/app/constants/app_color.dart';
import 'package:fixbuddy_partner/app/modules/VendorRegister/controllers/provider_register_controller.dart';
import 'package:fixbuddy_partner/app/modules/VendorRegister/views/widgets/address_details_section.dart';
import 'package:fixbuddy_partner/app/modules/VendorRegister/views/widgets/bank_details_widget.dart';
import 'package:fixbuddy_partner/app/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProviderRegisterView extends StatelessWidget {
  final controller = Get.put(ProviderRegisterController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Service Provider Registration'),
        backgroundColor: AppColors.primaryColor,
        foregroundColor: AppColors.blackColor,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Address Section
              AddressDetailsSection(controller: controller),
              const SizedBox(height: 16),

              // About
              TextFormField(
                controller: controller.aboutController,
                decoration: InputDecoration(
                  labelText: 'About',
                  filled: true,
                  fillColor: AppColors.lightgrayColor,
                  border: const OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 16),

              // Bank Details Section
              BankDetailsSection(controller: controller),
              const SizedBox(height: 24),

              // Documents Uploads
              Text(
                'Upload Documents',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: AppColors.blackColor,
                ),
              ),
              const SizedBox(height: 10),

              ElevatedButton(
                onPressed: controller.pickProfilePic,
                child: const Text('Capture Profile Photo'),
              ),
              if (controller.profilePic.value != null)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Image.file(controller.profilePic.value!, height: 100),
                ),
              const SizedBox(height: 16),

              ElevatedButton(
                onPressed: controller.pickAddressProof,
                child: const Text('Upload Address Proof'),
              ),
              if (controller.addressProof.value != null)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    controller.addressProof.value!.path.split('/').last,
                  ),
                ),
              const SizedBox(height: 16),

              ElevatedButton(
                onPressed: controller.pickBankStatement,
                child: const Text('Upload Bank Statement'),
              ),
              if (controller.bankStatement.value != null)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    controller.bankStatement.value!.path.split('/').last,
                  ),
                ),
              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Get.toNamed(Routes.serviceLocationScreen);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryColor,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: const Text(
                    'Next',
                    style: TextStyle(
                      color: AppColors.blackColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
