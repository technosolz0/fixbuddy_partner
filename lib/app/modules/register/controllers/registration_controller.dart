import 'package:dio/dio.dart';
import 'package:fixbuddy_partner/app/constants/app_color.dart';
import 'package:fixbuddy_partner/app/modules/register/models/register_models.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:async';
import 'dart:convert';

// Assuming these are defined in your project
import 'package:fixbuddy_partner/app/constants/api_constants.dart';
import 'package:fixbuddy_partner/app/services/auth_api_service.dart';

// Models
// Controller
class RegistrationController extends GetxController {
  final emailFormKey = GlobalKey<FormState>();
  final otpFormKey = GlobalKey<FormState>();
  final personalFormKey = GlobalKey<FormState>();
  final bankFormKey = GlobalKey<FormState>();
  final workFormKey = GlobalKey<FormState>();

  final emailController = TextEditingController();
  final otpController = TextEditingController();
  final fullNameController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  final addressController = TextEditingController();
  final roadController = TextEditingController();
  final landmarkController = TextEditingController();
  final pinCodeController = TextEditingController();
  final bankNameController = TextEditingController();
  final accountNameController = TextEditingController();
  final accountNumberController = TextEditingController();
  final ifscCodeController = TextEditingController();
  final experienceYearsController = TextEditingController();
  final aboutController = TextEditingController();
  final categoryId = 0.obs;
  final subCategoryId = 0.obs;
  final serviceIds = <int>[].obs;

  final isLoading = false.obs;
  final registrationData = RegistrationData().obs;
  final AuthApiService _apiService = AuthApiService();
  Timer? _notificationTimer;

  @override
  void onInit() {
    super.onInit();
    initializeRegistration();
    setupNotificationReminder();
  }

  @override
  void onClose() {
    emailController.dispose();
    otpController.dispose();
    fullNameController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    addressController.dispose();
    roadController.dispose();
    landmarkController.dispose();
    pinCodeController.dispose();
    bankNameController.dispose();
    accountNameController.dispose();
    accountNumberController.dispose();
    ifscCodeController.dispose();
    experienceYearsController.dispose();
    aboutController.dispose();
    _notificationTimer?.cancel();
    super.onClose();
  }

  Future<void> initializeRegistration() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString('registrationData');
    if (data != null) {
      registrationData.value = RegistrationData.fromJson(jsonDecode(data));
      fillControllers();
    }
    navigateToCurrentStep();
  }

  void fillControllers() {
    emailController.text = registrationData.value.email ?? '';
    fullNameController.text = registrationData.value.fullName ?? '';
    phoneController.text = registrationData.value.phone ?? '';
    passwordController.text = registrationData.value.password ?? '';
    addressController.text = registrationData.value.personalDetails['address'] ?? '';
    roadController.text = registrationData.value.personalDetails['road'] ?? '';
    landmarkController.text = registrationData.value.personalDetails['landmark'] ?? '';
    pinCodeController.text = registrationData.value.personalDetails['pin_code'] ?? '';
    bankNameController.text = registrationData.value.bankDetails['bank_name'] ?? '';
    accountNameController.text = registrationData.value.bankDetails['account_name'] ?? '';
    accountNumberController.text = registrationData.value.bankDetails['account_number'] ?? '';
    ifscCodeController.text = registrationData.value.bankDetails['ifsc_code'] ?? '';
    experienceYearsController.text = registrationData.value.workDetails['experience_years']?.toString() ?? '';
    aboutController.text = registrationData.value.workDetails['about'] ?? '';
  }

  Future<void> saveRegistrationProgress() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('registrationData', jsonEncode(registrationData.value.toJson()));
  }

  void setupNotificationReminder() {
    _notificationTimer = Timer.periodic(Duration(minutes: 30), (timer) async {
      if (registrationData.value.registrationStep < 5 && !registrationData.value.isVerified) {
        await showNotification();
      } else {
        _notificationTimer?.cancel();
      }
    });
  }

  Future<void> showNotification() async {
    final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'registration_channel',
      'Registration Reminders',
      importance: Importance.high,
      priority: Priority.high,
    );
    const NotificationDetails platformDetails = NotificationDetails(android: androidDetails);
    
    await flutterLocalNotificationsPlugin.show(
      0,
      'Complete Your Registration',
      'Please complete your registration to access all features',
      platformDetails,
    );
  }

  bool isValidEmail(String email) {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(email);
  }

  Future<void> sendRegistrationOtp() async {
    if (!emailFormKey.currentState!.validate()) return;
    
    final email = emailController.text.trim();
    final fullName = fullNameController.text.trim();
    final phone = phoneController.text.trim();
    final password = passwordController.text.trim();

    if (!isValidEmail(email)) {
      Get.snackbar('Invalid Email', 'Enter a valid email address',
          backgroundColor: AppColors.errorColor, colorText: Colors.white);
      return;
    }

    isLoading.value = true;
    try {
      final response = await _apiService.sendRegistrationOtp(
        name: fullName,
        email: email,
        mobile: phone,
        password: password,
      );

      if (response.statusCode == 200) {
        registrationData.update((val) {
          val?.email = email;
          val?.fullName = fullName;
          val?.phone = phone;
          val?.password = password;
          val?.registrationStep = 1;
        });
        await saveRegistrationProgress();
        Get.to(() => OtpVerificationScreen());
        Get.snackbar('Success', 'OTP sent to your email',
            backgroundColor: AppColors.successColor, colorText: Colors.white);
      } else {
        Get.snackbar('Error', response.data['detail'] ?? 'Failed to send OTP',
            backgroundColor: AppColors.errorColor, colorText: Colors.white);
      }
    } on DioError catch (e) {
      Get.snackbar('Error', e.response?.data['detail'] ?? 'Something went wrong',
          backgroundColor: AppColors.errorColor, colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> verifyOtp() async {
    if (!otpFormKey.currentState!.validate()) return;

    isLoading.value = true;
    try {
      final response = await _apiService.verifyRegistrationOtp(
        email: registrationData.value.email!,
        otp: otpController.text.trim(),
      );

      if (response.statusCode == 200) {
        registrationData.update((val) {
          val?.isVerified = true;
          val?.otp = null;
          val?.vendorId = response.data['vendor']['id'];
          val?.registrationStep = 2;
        });
        await saveRegistrationProgress();
        Get.to(() => PersonalDetailsScreen());
        Get.snackbar('Success', 'OTP verified successfully',
            backgroundColor: AppColors.successColor, colorText: Colors.white);
      } else {
        Get.snackbar('Error', response.data['detail'] ?? 'Invalid OTP',
            backgroundColor: AppColors.errorColor, colorText: Colors.white);
      }
    } on DioError catch (e) {
      Get.snackbar('Error', e.response?.data['detail'] ?? 'Invalid OTP',
          backgroundColor: AppColors.errorColor, colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> submitPersonalDetails() async {
    if (!personalFormKey.currentState!.validate()) return;

    isLoading.value = true;
    try {
      registrationData.update((val) {
        val?.personalDetails = {
          'address': addressController.text.trim(),
          'road': roadController.text.trim(),
          'landmark': landmarkController.text.trim(),
          'pin_code': pinCodeController.text.trim(),
        };
        val?.registrationStep = 3;
      });
      await saveRegistrationProgress();
      final response = await _apiService.updateVendor(
        vendorId: registrationData.value.vendorId!,
        data: registrationData.value.toJson(),
      );
      if (response.statusCode == 200) {
        Get.to(() => BankDetailsScreen());
        Get.snackbar('Success', 'Personal details saved',
            backgroundColor: AppColors.successColor, colorText: Colors.white);
      } else {
        Get.snackbar('Error', response.data['detail'] ?? 'Failed to save details',
            backgroundColor: AppColors.errorColor, colorText: Colors.white);
      }
    } on DioError catch (e) {
      Get.snackbar('Error', e.response?.data['detail'] ?? 'Failed to save details',
          backgroundColor: AppColors.errorColor, colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> submitBankDetails() async {
    if (!bankFormKey.currentState!.validate()) return;

    isLoading.value = true;
    try {
      registrationData.update((val) {
        val?.bankDetails = {
          'bank_name': bankNameController.text.trim(),
          'account_name': accountNameController.text.trim(),
          'account_number': accountNumberController.text.trim(),
          'ifsc_code': ifscCodeController.text.trim(),
        };
        val?.registrationStep = 4;
      });
      await saveRegistrationProgress();
      final response = await _apiService.updateVendor(
        vendorId: registrationData.value.vendorId!,
        data: registrationData.value.toJson(),
      );
      if (response.statusCode == 200) {
        Get.to(() => WorkDetailsScreen());
        Get.snackbar('Success', 'Bank details saved',
            backgroundColor: AppColors.successColor, colorText: Colors.white);
      } else {
        Get.snackbar('Error', response.data['detail'] ?? 'Failed to save details',
            backgroundColor: AppColors.errorColor, colorText: Colors.white);
      }
    } on DioError catch (e) {
      Get.snackbar('Error', e.response?.data['detail'] ?? 'Failed to save details',
          backgroundColor: AppColors.errorColor, colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> submitWorkDetails() async {
    if (!workFormKey.currentState!.validate()) return;

    isLoading.value = true;
    try {
      registrationData.update((val) {
        val?.workDetails = {
          'experience_years': int.tryParse(experienceYearsController.text.trim()) ?? 0,
          'about': aboutController.text.trim(),
          'category_id': categoryId.value,
          'sub_category_id': subCategoryId.value,
          'service_ids': serviceIds.toList(),
          'service_locations': {}, // Add appropriate service locations data
        };
        val?.registrationStep = 5;
      });
      await saveRegistrationProgress();
      final response = await _apiService.updateVendor(
        vendorId: registrationData.value.vendorId!,
        data: registrationData.value.toJson(),
      );
      if (response.statusCode == 200) {
        _notificationTimer?.cancel();
        await SharedPreferences.getInstance().then((prefs) => prefs.remove('registrationData'));
        Get.offAllNamed('/home');
        Get.snackbar('Success', 'Registration completed',
            backgroundColor: AppColors.successColor, colorText: Colors.white);
      } else {
        Get.snackbar('Error', response.data['detail'] ?? 'Failed to save details',
            backgroundColor: AppColors.errorColor, colorText: Colors.white);
      }
    } on DioError catch (e) {
      Get.snackbar('Error', e.response?.data['detail'] ?? 'Failed to save details',
          backgroundColor: AppColors.errorColor, colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }

  void navigateToCurrentStep() {
    switch (registrationData.value.registrationStep) {
      case 0:
        Get.to(() => EmailScreen());
        break;
      case 1:
        Get.to(() => OtpVerificationScreen());
        break;
      case 2:
        Get.to(() => PersonalDetailsScreen());
        break;
      case 3:
        Get.to(() => BankDetailsScreen());
        break;
      case 4:
        Get.to(() => WorkDetailsScreen());
        break;
      case 5:
        Get.offAllNamed('/home');
        break;
    }
  }
}

// Updated AuthApiService
// Screens
class EmailScreen extends StatelessWidget {
  final RegistrationController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Form(
            key: controller.emailFormKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Register', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                SizedBox(height: 16),
                TextFormField(
                  controller: controller.fullNameController,
                  decoration: InputDecoration(labelText: 'Full Name'),
                  validator: (value) => value!.isEmpty ? 'Name is required' : null,
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: controller.emailController,
                  decoration: InputDecoration(labelText: 'Email'),
                  validator: (value) => value!.isEmpty ? 'Email is required' : null,
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: controller.phoneController,
                  decoration: InputDecoration(labelText: 'Phone'),
                  validator: (value) => value!.isEmpty ? 'Phone is required' : null,
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: controller.passwordController,
                  decoration: InputDecoration(labelText: 'Password'),
                  obscureText: true,
                  validator: (value) => value!.isEmpty ? 'Password is required' : null,
                ),
                SizedBox(height: 24),
                Obx(() => ElevatedButton(
                      onPressed: controller.isLoading.value ? null : controller.sendRegistrationOtp,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryColor,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      ),
                      child: controller.isLoading.value
                          ? CircularProgressIndicator(color: Colors.white)
                          : Text('Send OTP', style: TextStyle(fontSize: 16)),
                    )),
                SizedBox(height: 16),
                Center(
                  child: TextButton(
                    onPressed: () => Get.back(),
                    child: Text('Back to Login', style: TextStyle(color: AppColors.secondaryColor)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class OtpVerificationScreen extends StatelessWidget {
  final RegistrationController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Form(
            key: controller.otpFormKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Verify OTP', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                SizedBox(height: 16),
                TextFormField(
                  controller: controller.otpController,
                  decoration: InputDecoration(labelText: 'Enter OTP'),
                  validator: (value) => value!.isEmpty ? 'OTP is required' : null,
                ),
                SizedBox(height: 24),
                Obx(() => ElevatedButton(
                      onPressed: controller.isLoading.value ? null : controller.verifyOtp,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryColor,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      ),
                      child: controller.isLoading.value
                          ? CircularProgressIndicator(color: Colors.white)
                          : Text('Verify OTP', style: TextStyle(fontSize: 16)),
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class PersonalDetailsScreen extends StatelessWidget {
  final RegistrationController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Form(
            key: controller.personalFormKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Personal Details', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                SizedBox(height: 16),
                TextFormField(
                  controller: controller.addressController,
                  decoration: InputDecoration(labelText: 'Address'),
                  validator: (value) => value!.isEmpty ? 'Address is required' : null,
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: controller.roadController,
                  decoration: InputDecoration(labelText: 'Road'),
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: controller.landmarkController,
                  decoration: InputDecoration(labelText: 'Landmark'),
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: controller.pinCodeController,
                  decoration: InputDecoration(labelText: 'Pin Code'),
                  validator: (value) => value!.isEmpty ? 'Pin Code is required' : null,
                ),
                SizedBox(height: 24),
                Obx(() => ElevatedButton(
                      onPressed: controller.isLoading.value ? null : controller.submitPersonalDetails,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryColor,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      ),
                      child: controller.isLoading.value
                          ? CircularProgressIndicator(color: Colors.white)
                          : Text('Next', style: TextStyle(fontSize: 16)),
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class BankDetailsScreen extends StatelessWidget {
  final RegistrationController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Form(
            key: controller.bankFormKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Bank Details', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                SizedBox(height: 16),
                TextFormField(
                  controller: controller.bankNameController,
                  decoration: InputDecoration(labelText: 'Bank Name'),
                  validator: (value) => value!.isEmpty ? 'Bank Name is required' : null,
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: controller.accountNameController,
                  decoration: InputDecoration(labelText: 'Account Name'),
                  validator: (value) => value!.isEmpty ? 'Account Name is required' : null,
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: controller.accountNumberController,
                  decoration: InputDecoration(labelText: 'Account Number'),
                  validator: (value) => value!.isEmpty ? 'Account Number is required' : null,
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: controller.ifscCodeController,
                  decoration: InputDecoration(labelText: 'IFSC Code'),
                  validator: (value) => value!.isEmpty ? 'IFSC Code is required' : null,
                ),
                SizedBox(height: 24),
                Obx(() => ElevatedButton(
                      onPressed: controller.isLoading.value ? null : controller.submitBankDetails,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryColor,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      ),
                      child: controller.isLoading.value
                          ? CircularProgressIndicator(color: Colors.white)
                          : Text('Next', style: TextStyle(fontSize: 16)),
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class WorkDetailsScreen extends StatelessWidget {
  final RegistrationController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Form(
            key: controller.workFormKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Work Details', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                SizedBox(height: 16),
                TextFormField(
                  controller: controller.experienceYearsController,
                  decoration: InputDecoration(labelText: 'Years of Experience'),
                  keyboardType: TextInputType.number,
                  validator: (value) => value!.isEmpty ? 'Experience is required' : null,
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: controller.aboutController,
                  decoration: InputDecoration(labelText: 'About'),
                  maxLines: 3,
                ),
                // Add dropdowns for category_id, sub_category_id, and service_ids
                SizedBox(height: 24),
                Obx(() => ElevatedButton(
                      onPressed: controller.isLoading.value ? null : controller.submitWorkDetails,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryColor,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      ),
                      child: controller.isLoading.value
                          ? CircularProgressIndicator(color: Colors.white)
                          : Text('Complete Registration', style: TextStyle(fontSize: 16)),
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Main initialization for notifications
void initializeNotifications() async {
  final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');
  final InitializationSettings initializationSettings =
      InitializationSettings(android: initializationSettingsAndroid);
  await flutterLocalNotificationsPlugin.initialize(initializationSettings);
}