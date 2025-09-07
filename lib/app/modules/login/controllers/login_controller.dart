import 'package:dio/dio.dart';
import 'package:fixbuddy_partner/app/utils/theme.dart';
import 'package:fixbuddy_partner/app/data/models/vendor_model.dart';
import 'package:fixbuddy_partner/app/modules/register/services/register_services.dart';
import 'package:fixbuddy_partner/app/routes/app_routes.dart';
import 'package:fixbuddy_partner/app/utils/local_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final LocalStorage _localStorage = LocalStorage();
  final AuthApiService _apiService = AuthApiService();

  final isLoading = false.obs;
  final loginFormKey = GlobalKey<FormState>();

  var isPasswordHidden = true.obs;

  void togglePasswordVisibility() {
    isPasswordHidden.value = !isPasswordHidden.value;
  }

  // Email validation regex
  bool isValidEmail(String email) {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(email);
  }

  // Optional: validate email and password before sending OTP or login
  bool validateEmailAndPassword() {
    final email = emailController.text.trim();
    final password = passwordController.text;

    if (email.isEmpty || !isValidEmail(email)) {
      Get.closeAllSnackbars();
      Get.snackbar(
        'Invalid Input',
        email.isEmpty
            ? 'Please enter your email'
            : 'Enter a valid email address',
        backgroundColor: AppColors.errorColor,
        colorText: Colors.white,
      );
      return false;
    }

    if (password.isEmpty) {
      Get.closeAllSnackbars();
      Get.snackbar(
        'Invalid Input',
        'Please enter your password',
        backgroundColor: AppColors.errorColor,
        colorText: Colors.white,
      );
      return false;
    }

    return true;
  }

  Future<void> login() async {
    if (!loginFormKey.currentState!.validate()) return;

    isLoading.value = true;
    try {
      final email = emailController.text.trim();
      final password = passwordController.text.trim();

      final response = await _apiService.login(
        email: email,
        password: password,
      );

      if (response.statusCode == 200) {
        final data = response.data;
        final token = data['access_token'] as String?;
        final vendorMap = data['vendor'] as Map<String, dynamic>?;

        if (token == null || vendorMap == null) {
          throw Exception('Invalid login response');
        }

        // Save token securely
        await _localStorage.setToken(token);

        // Save user ID if available
        if (vendorMap['id'] != null) {
          await _localStorage.setVendorID(vendorMap['id'].toString());
          await _localStorage.setVendorName(  vendorMap['name'] ?? '');
        }

        // Save user details model (assuming you have VendorModel.fromJson)
        final vendorDetails = VendorModel.fromJson(vendorMap);
        await _localStorage.setVendorDetails(vendorDetails);

        // Save last login date
        await _localStorage.setLastLoginDate(DateTime.now());

        // Optionally set onboarded to true (if relevant)
        await _localStorage.setIsOnboarded(true);

        Get.snackbar('Success', 'Logged in successfully');

        // Navigate to your home/dashboard screen
        Get.offNamed(Routes.home); // replace with your route
      } else {
        Get.snackbar(
          'Login Failed',
          response.data['message'] ?? 'Unable to login, please try again.',
          backgroundColor: AppColors.errorColor,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        e is DioException
            ? e.response?.data['detail'] ?? e.message
            : e.toString(),
        backgroundColor: AppColors.errorColor,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }

  // Logout user and clear local storage
  Future<void> logout() async {
    await _localStorage.clearLocalStorage();

    Get.offAllNamed(Routes.login);
    Get.snackbar(
      'Logged out',
      'You have been logged out successfully.',
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}
