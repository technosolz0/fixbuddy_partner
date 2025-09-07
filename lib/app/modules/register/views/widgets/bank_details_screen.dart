
import 'package:fixbuddy_partner/app/modules/register/controllers/registration_controller.dart';
import 'package:fixbuddy_partner/app/utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BankDetailsScreen extends StatelessWidget {
  final RegistrationController controller = Get.find();

  BankDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('Bank Details'),
        backgroundColor: AppColors.primaryColor,
        elevation: 0,
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Form(
            key: controller.bankFormKey,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  const Text(
                    'Enter your bank information securely',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 30),

                  // Account Holder Name Field
                  _buildTextField(
                    controller: controller.accountHolderNameController,
                    labelText: 'Account Holder Name',
                    validator: (value) => value == null || value.isEmpty
                        ? 'Account Holder Name is required'
                        : null,
                    icon: Icons.person,
                  ),
                  const SizedBox(height: 20),

                  // Account Number Field
                  _buildTextField(
                    controller: controller.accountNumberController,
                    labelText: 'Account Number',
                    validator: (value) => value == null || value.isEmpty
                        ? 'Account Number is required'
                        : null,
                    icon: Icons.account_balance_wallet,
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 20),

                  // IFSC Code Field
                  _buildTextField(
                    controller: controller.ifscCodeController,
                    labelText: 'IFSC Code',
                    validator: (value) => value == null || value.isEmpty
                        ? 'IFSC Code is required'
                        : null,
                    icon: Icons.qr_code,
                  ),
                  const SizedBox(height: 20),

                  // UPI ID Field
                  _buildTextField(
                    controller: controller.upiIdController,
                    labelText: 'UPI ID (Optional)',
                    icon: Icons.payment,
                    validator: (value) => null,
                  ),
                  const SizedBox(height: 20),

                  // Bank Document Type Field
                  _buildTextField(
                    controller: controller.bankDocTypeController,
                    labelText: 'Bank Document Type',
                    validator: (value) => value == null || value.isEmpty
                        ? 'Bank Document Type is required'
                        : null,
                    icon: Icons.description,
                  ),
                  const SizedBox(height: 20),

                  // Bank Document Number Field
                  _buildTextField(
                    controller: controller.bankDocNumberController,
                    labelText: 'Bank Document Number',
                    validator: (value) => value == null || value.isEmpty
                        ? 'Bank Document Number is required'
                        : null,
                    icon: Icons.numbers,
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 40),

                  // Next Button
                  Obx(
                    () => SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: controller.isLoading.value
                            ? null
                            : controller.submitBankDetails,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryColor,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: controller.isLoading.value
                            ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                            : const Text(
                                'Next',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // A reusable widget for a styled TextFormField
  Widget _buildTextField({
    required TextEditingController controller,
    required String labelText,
    required String? Function(String?) validator,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: labelText,
        prefixIcon: Icon(icon, color: AppColors.primaryColor),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primaryColor, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red, width: 2),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
      validator: validator,
    );
  }
}
