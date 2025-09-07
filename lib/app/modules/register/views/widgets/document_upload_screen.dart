import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:fixbuddy_partner/app/utils/theme.dart';
import 'package:fixbuddy_partner/app/modules/register/controllers/registration_controller.dart';

class DocumentUploadScreen extends StatelessWidget {
  const DocumentUploadScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<RegistrationController>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Upload Documents'),
        backgroundColor: AppColors.primaryColor,
        elevation: 0,
        centerTitle: true,
      ),
      body: Container(
        color: Colors.grey[100],
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: controller.documentFormKey,
          child: ListView(
            children: [
              const Text(
                'Please upload the required documents to complete your registration.',
                style: TextStyle(fontSize: 16, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),
              // Profile Picture
              _buildDocumentUploadCard(
                title: 'Profile Picture',
                icon: Icons.person,
                onPressed: () => _pickImage(controller.profilePicBytes),
                obxChild: Obx(
                  () => controller.profilePicBytes.value == null
                      ? const Text('Select your profile photo')
                      : const Text(
                          'Profile picture selected',
                          style: TextStyle(color: AppColors.primaryColor),
                        ),
                ),
              ),
              const SizedBox(height: 20),
              // Identity Document
              _buildDocumentUploadCard(
                title: 'Identity Document (e.g., Passport, ID Card)',
                icon: Icons.credit_card,
                onPressed: () => _pickImage(controller.identityDocBytes),
                obxChild: Obx(
                  () => controller.identityDocBytes.value == null
                      ? const Text('Select identity document')
                      : const Text(
                          'Identity document selected',
                          style: TextStyle(color: AppColors.primaryColor),
                        ),
                ),
              ),
              const SizedBox(height: 20),
              // Bank Document
              _buildDocumentUploadCard(
                title: 'Bank Document (e.g., Cheque, Bank Statement)',
                icon: Icons.account_balance,
                onPressed: () => _pickImage(controller.bankDocBytes),
                obxChild: Obx(
                  () => controller.bankDocBytes.value == null
                      ? const Text('Select bank document')
                      : const Text(
                          'Bank document selected',
                          style: TextStyle(color: AppColors.primaryColor),
                        ),
                ),
              ),
              const SizedBox(height: 20),
              // Address Document
              _buildDocumentUploadCard(
                title: 'Address Document (e.g., Utility Bill)',
                icon: Icons.home,
                onPressed: () => _pickImage(controller.addressDocBytes),
                obxChild: Obx(
                  () => controller.addressDocBytes.value == null
                      ? const Text('Select address document')
                      : const Text(
                          'Address document selected',
                          style: TextStyle(color: AppColors.primaryColor),
                        ),
                ),
              ),
              const SizedBox(height: 40),
              // Submit Button
              Obx(
                () => ElevatedButton(
                  onPressed: controller.isLoading.value
                      ? null
                      : controller.submitDocuments,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryColor,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: controller.isLoading.value
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          'Submit Documents',
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // A reusable widget for document upload sections
  Widget _buildDocumentUploadCard({
    required String title,
    required IconData icon,
    required VoidCallback onPressed,
    required Widget obxChild,
  }) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              // ignore: deprecated_member_use
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(icon, color: AppColors.primaryColor, size: 28),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  obxChild,
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 16),
          ],
        ),
      ),
    );
  }

  // Helper function to pick an image and update the observable
  Future<void> _pickImage(Rx<Uint8List?> obsBytes) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      obsBytes.value = await pickedFile.readAsBytes();
    }
  }
}
