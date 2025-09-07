import 'package:fixbuddy_partner/app/modules/register/controllers/registration_controller.dart';
import 'package:fixbuddy_partner/app/utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddressDetailsScreen extends StatelessWidget {
  final RegistrationController controller = Get.put(RegistrationController());

  AddressDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: controller.addressFormKey,
            child: SingleChildScrollView(
              child: FocusScope(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Address Details',
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      controller: controller.addressController,
                      decoration: InputDecoration(labelText: 'Address'),
                      validator: (value) => value == null || value.isEmpty
                          ? 'Address is required'
                          : null,
                      textInputAction: TextInputAction.next,
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      controller: controller.stateController,
                      decoration: InputDecoration(labelText: 'State'),
                      validator: (value) => value == null || value.isEmpty
                          ? 'State is required'
                          : null,
                      textInputAction: TextInputAction.next,
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      controller: controller.cityController,
                      decoration: InputDecoration(labelText: 'City'),
                      validator: (value) => value == null || value.isEmpty
                          ? 'City is required'
                          : null,
                      textInputAction: TextInputAction.next,
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      controller: controller.pinCodeController,
                      decoration: InputDecoration(labelText: 'Pincode'),
                      keyboardType: TextInputType.number,
                      validator: (value) => value == null || value.isEmpty
                          ? 'Pincode is required'
                          : null,
                      textInputAction: TextInputAction.next,
                    ),
                    SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      value:
                          controller.documentTypes.contains(
                            controller.documentTypeController.text,
                          )
                          ? controller.documentTypeController.text
                          : null,
                      decoration: InputDecoration(
                        labelText: 'Address Document Type',
                      ),
                      items: controller.documentTypes
                          .map(
                            (type) => DropdownMenuItem(
                              value: type,
                              child: Text(type),
                            ),
                          )
                          .toList(),
                      onChanged: (value) {
                        if (value != null) {
                          controller.documentTypeController.text = value;
                        }
                      },
                      validator: (value) => value == null || value.isEmpty
                          ? 'Address Document Type is required'
                          : null,
                      isExpanded: true,
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      controller: controller.documentNumberController,
                      decoration: InputDecoration(
                        labelText: 'Address Document Number',
                      ),
                      validator: (value) => value == null || value.isEmpty
                          ? 'Address Document Number is required'
                          : null,
                      textInputAction: TextInputAction.done,
                    ),
                    SizedBox(height: 24),
                    Obx(
                      () => SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: controller.isLoading.value
                              ? null
                              : controller.submitAddressDetails,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                          child: controller.isLoading.value
                              ? const SizedBox(
                                  height: 24,
                                  width: 24,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                  ),
                                )
                              : const Text(
                                  'Next',
                                  style: TextStyle(fontSize: 16),
                                ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
