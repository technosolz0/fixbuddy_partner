import 'dart:io';
import 'package:fixbuddy_partner/app/utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../controllers/registration_controller.dart';

class RegistrationView extends StatelessWidget {
  final RegistrationController controller = Get.put(RegistrationController());

  RegistrationView({super.key});

  Future<void> pickProfileImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 600,
      maxHeight: 600,
      imageQuality: 80,
    );

    if (pickedFile != null) {
      final file = File(pickedFile.path);
      // Update controller profilePicBytes and profilePicController text with file path or base64 as needed
      controller.profilePicBytes.value = await file.readAsBytes();
      controller.profilePicController.text = file.path;
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: Stack(
        children: [
          // Top gradient
          Container(
            height: size.height * 0.35,
            decoration: BoxDecoration(gradient: AppColors.primaryGradient),
          ),

          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 30),
                  const SizedBox(height: 24),
                  const Text(
                    'Create Account',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Register to book and manage your services easily.',
                    style: TextStyle(color: Colors.black54, fontSize: 14),
                  ),
                  const SizedBox(height: 30),

                  Form(
                    key: controller.emailFormKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextFormField(
                          controller: controller.fullNameController,
                          decoration: const InputDecoration(
                            labelText: 'Full Name',
                          ),
                          validator: (value) =>
                              value!.isEmpty ? 'Name is required' : null,
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: controller.emailController,
                          decoration: const InputDecoration(labelText: 'Email'),
                          validator: (value) =>
                              value!.isEmpty ? 'Email is required' : null,
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.next,
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: controller.phoneController,
                          decoration: const InputDecoration(labelText: 'Phone'),
                          validator: (value) =>
                              value!.isEmpty ? 'Phone is required' : null,
                          keyboardType: TextInputType.phone,
                          textInputAction: TextInputAction.next,
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          keyboardType: TextInputType.text,
                          controller: controller.passwordController,
                          decoration: const InputDecoration(
                            labelText: 'Password',
                          ),
                          obscureText: true,
                          validator: (value) =>
                              value!.isEmpty ? 'Password is required' : null,
                          textInputAction: TextInputAction.next,
                        ),
                        const SizedBox(height: 16),

                        // Dropdown for Identity Document Type
                        DropdownButtonFormField<String>(
                          value:
                              controller
                                  .identityDocTypeController
                                  .text
                                  .isNotEmpty
                              ? controller.identityDocTypeController.text
                              : null,
                          decoration: const InputDecoration(
                            labelText: 'Identity Document Type',
                          ),
                          items: controller.documentTypes
                              .map(
                                (docType) => DropdownMenuItem(
                                  value: docType,
                                  child: Text(docType),
                                ),
                              )
                              .toList(),
                          onChanged: (value) {
                            if (value != null) {
                              controller.identityDocTypeController.text = value;
                            }
                          },
                          validator: (value) => (value == null || value.isEmpty)
                              ? 'Required'
                              : null,
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          keyboardType: TextInputType.number,
                          controller: controller.identityDocNumberController,
                          decoration: const InputDecoration(
                            labelText: 'Identity Document Number',
                          ),
                          validator: (value) =>
                              value!.isEmpty ? 'Required' : null,
                          textInputAction: TextInputAction.next,
                        ),
                        const SizedBox(height: 16),

                        // Profile Picture Picker
                        Text(
                          'Profile Picture',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey.shade700,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 8),

                        Obx(() {
                          final profilePicBytes =
                              controller.profilePicBytes.value;
                          return Row(
                            children: [
                              GestureDetector(
                                onTap: pickProfileImage,
                                child: Container(
                                  width: 90,
                                  height: 90,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: Colors.grey.shade400,
                                      width: 1,
                                    ),
                                    color: Colors.grey.shade200,
                                  ),
                                  child: profilePicBytes != null
                                      ? ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                          child: Image.memory(
                                            profilePicBytes,
                                            fit: BoxFit.cover,
                                          ),
                                        )
                                      : Icon(
                                          Icons.add_a_photo_outlined,
                                          size: 40,
                                          color: Colors.grey.shade600,
                                        ),
                                ),
                              ),
                            ],
                          );
                        }),
                        const SizedBox(height: 16),

                        Obx(
                          () => CheckboxListTile(
                            title: const Text('Accept Terms and Conditions'),
                            value: controller.termsAccepted.value,
                            onChanged: (value) =>
                                controller.termsAccepted.value = value ?? false,
                          ),
                        ),
                        const SizedBox(height: 24),

                        Obx(
                          () => SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: controller.isLoading.value
                                  ? null
                                  : controller.sendRegistrationOtp,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primaryColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                ),
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
                                      'Send OTP',
                                      style: TextStyle(fontSize: 16),
                                    ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 16),

                        Center(
                          child: TextButton(
                            onPressed: () => Get.back(),
                            child: Text(
                              'Back to Login',
                              style: TextStyle(color: AppColors.secondaryColor),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
