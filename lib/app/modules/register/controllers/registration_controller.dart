// import 'dart:async';
// import 'dart:convert';
// import 'dart:typed_data';
// import 'package:dio/dio.dart';
// import 'package:fixbuddy_partner/app/data/models/vendor_model.dart';
// import 'package:fixbuddy_partner/app/modules/register/models/category.dart';
// import 'package:fixbuddy_partner/app/modules/register/models/sub_category.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';
// import 'package:get/get.dart';
// import 'package:fixbuddy_partner/app/constants/app_color.dart';
// import 'package:fixbuddy_partner/app/modules/register/models/register_models.dart';
// import 'package:fixbuddy_partner/app/modules/register/services/register_services.dart';
// import 'package:fixbuddy_partner/app/modules/register/views/widgets/address_details_screen.dart';
// import 'package:fixbuddy_partner/app/modules/register/views/widgets/bank_details_screen.dart';
// import 'package:fixbuddy_partner/app/modules/register/views/widgets/document_upload_screen.dart';
// import 'package:fixbuddy_partner/app/modules/register/views/widgets/otp_verification_screen.dart';
// import 'package:fixbuddy_partner/app/modules/register/views/widgets/work_details_screen.dart';
// import 'package:fixbuddy_partner/app/routes/app_routes.dart';
// import 'package:fixbuddy_partner/app/utils/local_storage.dart';
// import 'package:fixbuddy_partner/app/utils/servex_utils.dart';

// // This is a new class to hold the state for each subcategory item
// // It's a cleaner way to manage the checkbox and text field together
// class SubCategoryChargeState {
//   final int subcategoryId;
//   final RxBool isSelected = false.obs;
//   final TextEditingController textController = TextEditingController();

//   SubCategoryChargeState({required this.subcategoryId});
// }

// class RegistrationController extends GetxController {
//   final otpControllers = List.generate(6, (_) => TextEditingController());
//   final emailFormKey = GlobalKey<FormState>();
//   final addressFormKey = GlobalKey<FormState>();
//   final bankFormKey = GlobalKey<FormState>();
//   final workFormKey = GlobalKey<FormState>();
//   final documentFormKey = GlobalKey<FormState>();

//   final emailController = TextEditingController();
//   final fullNameController = TextEditingController();
//   final phoneController = TextEditingController();
//   final passwordController = TextEditingController();
//   final addressController = TextEditingController();
//   final stateController = TextEditingController();
//   final cityController = TextEditingController();
//   final pinCodeController = TextEditingController();
//   final accountHolderNameController = TextEditingController();
//   final accountNumberController = TextEditingController();
//   final ifscCodeController = TextEditingController();
//   final upiIdController = TextEditingController();
//   final documentTypeController = TextEditingController();
//   final documentNumberController = TextEditingController();
//   final bankDocTypeController = TextEditingController();
//   final bankDocNumberController = TextEditingController();

//   final categoryId = 0.obs;
//   // We'll manage subcategory charges using a map for better state control
//   final subcategoryChargesMap = <int, SubCategoryChargeState>{}.obs;

//   Rx<Uint8List?> profilePicBytes = Rx<Uint8List?>(null);
//   Rx<Uint8List?> identityDocBytes = Rx<Uint8List?>(null);
//   Rx<Uint8List?> bankDocBytes = Rx<Uint8List?>(null);
//   Rx<Uint8List?> addressDocBytes = Rx<Uint8List?>(null);
//   final fcmTokenController = TextEditingController();
//   final latitudeController = TextEditingController();
//   final longitudeController = TextEditingController();
//   final deviceNameController = TextEditingController();

//   final identityDocTypeController = TextEditingController();
//   final identityDocNumberController = TextEditingController();
//   final profilePicController = TextEditingController();

//   final termsAccepted = false.obs;
//   final isLoading = false.obs;
//   // A new loading state specifically for fetching subcategories
//   final isSubcategoriesLoading = false.obs;
//   final registrationModal = RegistrationModal().obs;
//   final categories = <CategoryModel>[].obs;
//   final subcategories = <SubcategoryModel>[].obs;
//   final authToken = ''.obs;

//   final AuthApiService _apiService = AuthApiService();
//   Timer? _notificationTimer;
//   final storage = const FlutterSecureStorage();
//   final localStorage = LocalStorage();

//   // Helper getter to convert the map back to the required list format
//   // List<SubCategoryCharge> get subcategoryCharges => subcategoryChargesMap.values
//   //     .where((state) => state.isSelected.value)
//   //     .map(
//   //       (state) => SubCategoryCharge(
//   //         subcategoryId: state.subcategoryId,
//   //         serviceCharge: double.tryParse(state.textController.text) ?? 0.0,
//   //       ),
//   //     )
//   //     .toList();

//   List<SubCategoryCharge> get subcategoryCharges => subcategoryChargesMap.values
//       .where((state) => state.isSelected.value)
//       .map(
//         (state) => SubCategoryCharge(
//           subcategoryId: state.subcategoryId,
//           serviceCharge: double.tryParse(state.textController.text) ?? 0.0,
//         ),
//       )
//       .toList();
//   String get otp => otpControllers.map((controller) => controller.text).join();
//   final List<String> documentTypes = [
//     'Passport',
//     'Driver\'s License',
//     'Aadhaar Card',
//     'Voter ID',
//     'PAN Card',
//   ];

//   @override
//   void onInit() {
//     super.onInit();
//     initializeRegistration();
//     setupNotificationReminder();
//     fetchCategories();
//   }

//   @override
//   void onClose() {
//     _notificationTimer?.cancel();
//     for (var controller in otpControllers) {
//       controller.dispose();
//     }
//     emailController.dispose();
//     fullNameController.dispose();
//     phoneController.dispose();
//     passwordController.dispose();
//     addressController.dispose();
//     stateController.dispose();
//     cityController.dispose();
//     pinCodeController.dispose();
//     accountHolderNameController.dispose();
//     accountNumberController.dispose();
//     ifscCodeController.dispose();
//     upiIdController.dispose();
//     documentTypeController.dispose();
//     documentNumberController.dispose();
//     bankDocTypeController.dispose();
//     bankDocNumberController.dispose();
//     fcmTokenController.dispose();
//     latitudeController.dispose();
//     longitudeController.dispose();
//     deviceNameController.dispose();
//     // Dispose all TextControllers in the map
//     for (var state in subcategoryChargesMap.values) {
//       state.textController.dispose();
//     }
//     super.onClose();
//   }

//   Future<void> initializeRegistration() async {
//     try {
//       final data = await storage.read(key: 'registrationModal');
//       if (data != null) {
//         final jsonData =
//             await compute(jsonDecode, data) as Map<String, dynamic>;
//         registrationModal.value = RegistrationModal.fromJson(jsonData);
//         fillControllers();
//         final storedStep = await localStorage.getRegistrationStep();
//         if (storedStep != registrationModal.value.registrationStep) {
//           registrationModal.value.registrationStep = storedStep;
//         }
//       } else {
//         registrationModal.value = RegistrationModal();
//         registrationModal.value.registrationStep = await localStorage
//             .getRegistrationStep();
//       }

//       fcmTokenController.text = await localStorage.getFirebaseToken() ?? '';
//       deviceNameController.text = await localStorage.getDeviceName() ?? '';
//       latitudeController.text = await localStorage.getDeviceLatitude() ?? '';
//       longitudeController.text = await localStorage.getDeviceLongitude() ?? '';

//       await Future.delayed(const Duration(milliseconds: 100));
//       navigateToCurrentStep();
//     } catch (e) {
//       ServexUtils.logPrint('Error initializing registration: $e');
//       Get.snackbar(
//         'Error',
//         'Failed to initialize registration data: $e',
//         backgroundColor: AppColors.errorColor,
//         colorText: Colors.white,
//       );
//       registrationModal.value = RegistrationModal();
//       registrationModal.value.registrationStep = await localStorage
//           .getRegistrationStep();
//       navigateToCurrentStep();
//     }
//   }

//   void fillControllers() {
//     final personalDetails = registrationModal.value.personalDetails;
//     final bankDetails = registrationModal.value.bankDetails;

//     addressController.text = personalDetails['address']?.toString() ?? '';
//     stateController.text = personalDetails['state']?.toString() ?? '';
//     cityController.text = personalDetails['city']?.toString() ?? '';
//     pinCodeController.text = personalDetails['pincode']?.toString() ?? '';
//     documentTypeController.text =
//         personalDetails['document_type']?.toString() ?? '';
//     documentNumberController.text =
//         personalDetails['document_number']?.toString() ?? '';
//     accountHolderNameController.text =
//         bankDetails['account_holder_name']?.toString() ?? '';
//     accountNumberController.text =
//         bankDetails['account_number']?.toString() ?? '';
//     ifscCodeController.text = bankDetails['ifsc_code']?.toString() ?? '';
//     upiIdController.text = bankDetails['upi_id']?.toString() ?? '';
//     bankDocTypeController.text = bankDetails['bank_doc_type']?.toString() ?? '';
//     bankDocNumberController.text =
//         bankDetails['bank_doc_number']?.toString() ?? '';
//     fcmTokenController.text = registrationModal.value.fcmToken ?? '';
//     latitudeController.text =
//         registrationModal.value.latitude?.toString() ?? '';
//     longitudeController.text =
//         registrationModal.value.longitude?.toString() ?? '';
//     deviceNameController.text = registrationModal.value.deviceName ?? '';
//     termsAccepted.value = registrationModal.value.termsAccepted;

//     // Restore subcategory charges and update the map
//     categoryId.value = registrationModal.value.workDetails['category_id'] ?? 0;
//     if (categoryId.value != 0) {
//       // Assuming subcategories for the category are fetched here or will be fetched later
//       for (var charge in registrationModal.value.subcategoryCharges) {
//         final state =
//             subcategoryChargesMap[charge.subcategoryId] ??
//             SubCategoryChargeState(subcategoryId: charge.subcategoryId);
//         state.isSelected.value = true;
//         state.textController.text = charge.serviceCharge.toString();
//         subcategoryChargesMap[charge.subcategoryId] = state;
//       }
//     }
//   }

//   Future<void> saveRegistrationProgress() async {
//     try {
//       // Update registrationModal with latest data from controllers and map
//       registrationModal.update((val) {
//         val?.personalDetails = {
//           'address': addressController.text.trim(),
//           'state': stateController.text.trim(),
//           'city': cityController.text.trim(),
//           'pincode': pinCodeController.text.trim(),
//           'document_type': documentTypeController.text.trim(),
//           'document_number': documentNumberController.text.trim(),
//         };
//         val?.bankDetails = {
//           'account_holder_name': accountHolderNameController.text.trim(),
//           'account_number': accountNumberController.text.trim(),
//           'ifsc_code': ifscCodeController.text.trim(),
//           'upi_id': upiIdController.text.trim(),
//           'bank_doc_type': bankDocTypeController.text.trim(),
//           'bank_doc_number': bankDocNumberController.text.trim(),
//         };
//         val?.workDetails = {'category_id': categoryId.value};
//         val?.subcategoryCharges = subcategoryCharges;
//       });

//       await storage.write(
//         key: 'registrationModal',
//         value: jsonEncode(registrationModal.value.toJson()),
//       );
//       await localStorage.setRegistrationStep(
//         registrationModal.value.registrationStep,
//       );
//     } catch (e) {
//       Get.snackbar(
//         'Error',
//         'Failed to save registration progress',
//         backgroundColor: AppColors.errorColor,
//         colorText: Colors.white,
//       );
//     }
//   }

//   void setupNotificationReminder() {
//     _notificationTimer = Timer.periodic(const Duration(minutes: 30), (
//       timer,
//     ) async {
//       if (registrationModal.value.registrationStep < 6 &&
//           !registrationModal.value.isVerified) {
//         await showNotification();
//       } else {
//         _notificationTimer?.cancel();
//       }
//     });
//   }

//   Future<void> showNotification() async {
//     final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
//     const AndroidNotificationDetails androidDetails =
//         AndroidNotificationDetails(
//           'registration_channel',
//           'Registration Reminders',
//           importance: Importance.high,
//           priority: Priority.high,
//         );
//     const NotificationDetails platformDetails = NotificationDetails(
//       android: androidDetails,
//     );

//     await flutterLocalNotificationsPlugin.show(
//       0,
//       'Complete Your Registration',
//       'Please complete your registration to access all features',
//       platformDetails,
//     );
//   }

//   bool isValidEmail(String email) {
//     final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
//     return emailRegex.hasMatch(email);
//   }

//   Future<void> fetchCategories() async {
//     try {
//       final fetchedCategories = await _apiService.fetchCategories();
//       categories.assignAll(fetchedCategories);
//     } catch (e) {
//       Get.snackbar(
//         'Error',
//         'Failed to fetch categories: $e',
//         backgroundColor: AppColors.errorColor,
//         colorText: Colors.white,
//       );
//     }
//   }

//   Future<void> fetchSubcategories(int? categoryId) async {
//     if (categoryId == null) return;
//     isSubcategoriesLoading.value = true;
//     try {
//       final fetchedSubcategories = await _apiService.fetchSubcategories(
//         categoryId,
//       );
//       subcategories.assignAll(fetchedSubcategories);

//       // Initialize the state map for each subcategory
//       subcategoryChargesMap.clear();
//       for (var subcategory in fetchedSubcategories) {
//         subcategoryChargesMap[subcategory.id] = SubCategoryChargeState(
//           subcategoryId: subcategory.id,
//         );
//       }
//     } catch (e) {
//       Get.snackbar(
//         'Error',
//         'Failed to fetch subcategories: $e',
//         backgroundColor: AppColors.errorColor,
//         colorText: Colors.white,
//       );
//       subcategories.clear();
//     } finally {
//       isSubcategoriesLoading.value = false;
//     }
//   }

//   // New method to handle checkbox clicks
//   void onSubcategorySelected(int subcategoryId, bool isSelected) {
//     final state = subcategoryChargesMap[subcategoryId];
//     if (state != null) {
//       state.isSelected.value = isSelected;
//       if (!isSelected) {
//         state.textController.clear();
//       }
//       ServexUtils.logPrint('Subcategory $subcategoryId selected: $isSelected');
//     }
//   }

//   void onChargeChanged(int subcategoryId, String value) {
//     final state = subcategoryChargesMap[subcategoryId];
//     if (state != null) {
//       final chargeValue = double.tryParse(value) ?? 0.0;
//       state.isSelected.value = chargeValue > 0;
//       ServexUtils.logPrint(
//         'Charge for subcategory $subcategoryId: $value, selected: ${state.isSelected.value}',
//       );
//     }
//   }

//   Future<void> login() async {
//     if (!emailFormKey.currentState!.validate()) return;

//     isLoading.value = true;
//     try {
//       final response = await _apiService.login(
//         email: emailController.text.trim(),
//         password: passwordController.text.trim(),
//       );
//       if (response.statusCode == 200) {
//         authToken.value = response.data['access_token'];
//         localStorage.setToken(authToken.value);
//         await localStorage.setVendorID(
//           registrationModal.value.vendorId?.toString() ?? '',
//         );
//         Get.offAllNamed(Routes.home);
//         Get.snackbar(
//           'Success',
//           'Login successful',
//           backgroundColor: AppColors.successColor,
//           colorText: Colors.white,
//         );
//       } else {
//         Get.snackbar(
//           'Error',
//           response.data['detail']?.toString() ?? 'Login failed',
//           backgroundColor: AppColors.errorColor,
//           colorText: Colors.white,
//         );
//       }
//     } on DioException catch (e) {
//       Get.snackbar(
//         'Error',
//         e.response?.data['detail']?.toString() ?? 'Login failed',
//         backgroundColor: AppColors.errorColor,
//         colorText: Colors.white,
//       );
//     } finally {
//       isLoading.value = false;
//     }
//   }

//   Future<void> sendRegistrationOtp() async {
//     if (!emailFormKey.currentState!.validate()) return;

//     final email = emailController.text.trim();
//     final fullName = fullNameController.text.trim();
//     final phone = phoneController.text.trim();
//     final password = passwordController.text.trim();
//     final identityDocType = identityDocTypeController.text.trim();
//     final identityDocNumber = identityDocNumberController.text.trim();
//     final profilePic = profilePicController.text.trim();

//     if (!isValidEmail(email)) {
//       Get.snackbar(
//         'Invalid Email',
//         'Enter a valid email address',
//         backgroundColor: AppColors.errorColor,
//         colorText: Colors.white,
//       );
//       return;
//     }

//     if (identityDocType.isEmpty || identityDocNumber.isEmpty) {
//       Get.snackbar(
//         'Error',
//         'Identity document type and number are required',
//         backgroundColor: AppColors.errorColor,
//         colorText: Colors.white,
//       );
//       return;
//     }

//     if (profilePic.isEmpty) {
//       Get.snackbar(
//         'Error',
//         'Profile picture URL is required',
//         backgroundColor: AppColors.errorColor,
//         colorText: Colors.white,
//       );
//       return;
//     }

//     if (!termsAccepted.value) {
//       Get.snackbar(
//         'Error',
//         'You must accept the terms and conditions',
//         backgroundColor: AppColors.errorColor,
//         colorText: Colors.white,
//       );
//       return;
//     }

//     isLoading.value = true;
//     try {
//       final response = await _apiService.sendRegistrationOtp(
//         name: fullName,
//         email: email,
//         phone: phone,
//         password: password,
//         termsAccepted: termsAccepted.value,
//         identityDocType: identityDocType,
//         identityDocNumber: identityDocNumber,
//         fcmToken: fcmTokenController.text.isNotEmpty
//             ? fcmTokenController.text
//             : null,
//         latitude: latitudeController.text.isNotEmpty
//             ? double.tryParse(latitudeController.text)
//             : null,
//         longitude: longitudeController.text.isNotEmpty
//             ? double.tryParse(longitudeController.text)
//             : null,
//         deviceName: deviceNameController.text.isNotEmpty
//             ? deviceNameController.text
//             : null,
//         profilePic: profilePic,
//       );

//       if (response.statusCode == 200) {
//         registrationModal.update((val) {
//           val?.email = email;
//           val?.fullName = fullName;
//           val?.phone = phone;
//           val?.password = password;
//           val?.termsAccepted = termsAccepted.value;
//           val?.identityDocType = identityDocType;
//           val?.identityDocNumber = identityDocNumber;
//           val?.fcmToken = fcmTokenController.text.isNotEmpty
//               ? fcmTokenController.text
//               : null;
//           val?.latitude = latitudeController.text.isNotEmpty
//               ? double.tryParse(latitudeController.text)
//               : null;
//           val?.longitude = longitudeController.text.isNotEmpty
//               ? double.tryParse(longitudeController.text)
//               : null;
//           val?.deviceName = deviceNameController.text.isNotEmpty
//               ? deviceNameController.text
//               : null;
//           val?.profilePic = profilePic;
//           val?.vendorId = response.data['vendor_id'];
//         });
//         await saveRegistrationProgress();
//         Get.to(() => OtpVerificationScreen());
//         Get.snackbar(
//           'Success',
//           'OTP sent to your email',
//           backgroundColor: AppColors.successColor,
//           colorText: Colors.white,
//         );
//       } else {
//         Get.snackbar(
//           'Error',
//           response.data['detail']?.toString() ?? 'Failed to send OTP',
//           backgroundColor: AppColors.errorColor,
//           colorText: Colors.white,
//         );
//       }
//     } on DioException catch (e) {
//       Get.snackbar(
//         'Error',
//         e.response?.data['detail']?.toString() ?? 'Something went wrong',
//         backgroundColor: AppColors.errorColor,
//         colorText: Colors.white,
//       );
//     } finally {
//       isLoading.value = false;
//     }
//   }

//   Future<void> resendRegistrationOtp() async {
//     if (registrationModal.value.email == null) {
//       Get.snackbar(
//         'Error',
//         'No email found for resending OTP',
//         backgroundColor: AppColors.errorColor,
//         colorText: Colors.white,
//       );
//       return;
//     }

//     isLoading.value = true;
//     try {
//       final response = await _apiService.resendRegistrationOtp(
//         registrationModal.value.email!,
//       );
//       if (response.statusCode == 200) {
//         Get.snackbar(
//           'Success',
//           'OTP resent to your email',
//           backgroundColor: AppColors.successColor,
//           colorText: Colors.white,
//         );
//       } else {
//         Get.snackbar(
//           'Error',
//           response.data['detail']?.toString() ?? 'Failed to resend OTP',
//           backgroundColor: AppColors.errorColor,
//           colorText: Colors.white,
//         );
//       }
//     } on DioException catch (e) {
//       Get.snackbar(
//         'Error',
//         e.response?.data['detail']?.toString() ?? 'Something went wrong',
//         backgroundColor: AppColors.errorColor,
//         colorText: Colors.white,
//       );
//     } finally {
//       isLoading.value = false;
//     }
//   }

//   Future<void> verifyOtp() async {
//     isLoading.value = true;
//     try {
//       final response = await _apiService.verifyRegistrationOtp(
//         email: registrationModal.value.email!,
//         otp: otp,
//       );

//       if (response.statusCode == 200) {
//         registrationModal.update((val) {
//           val?.isVerified = true;
//           val?.otp = null;
//           val?.vendorId = response.data['vendor_id'];
//           // Updated to match navigation
//         });
//         authToken.value = response.data['access_token'];
//         await localStorage.setToken(authToken.value);
//         await localStorage.setVendorID(
//           registrationModal.value.vendorId!.toString(),
//         );
//         Get.off(() => AddressDetailsScreen());
//         Get.snackbar(
//           'Success',
//           'OTP verified successfully',
//           backgroundColor: AppColors.successColor,
//           colorText: Colors.white,
//         );
//       } else {
//         Get.snackbar(
//           'Error',
//           response.data['detail']?.toString() ?? 'Invalid OTP',
//           backgroundColor: AppColors.errorColor,
//           colorText: Colors.white,
//         );
//       }
//     } on DioException catch (e) {
//       Get.snackbar(
//         'Error',
//         e.response?.data['detail']?.toString() ?? 'Invalid OTP',
//         backgroundColor: AppColors.errorColor,
//         colorText: Colors.white,
//       );
//     } finally {
//       isLoading.value = false;
//     }
//   }

//   Future<void> submitAddressDetails() async {
//     if (!addressFormKey.currentState!.validate()) return;

//     // Validate address_doc_type against documentTypes
//     final docType = documentTypeController.text.trim();
//     if (!documentTypes.contains(docType)) {
//       Get.snackbar(
//         'Error',
//         'Please select a valid document type: ${documentTypes.join(', ')}',
//         backgroundColor: AppColors.errorColor,
//         colorText: Colors.white,
//       );
//       return;
//     }

//     isLoading.value = true;
//     try {
//       final userIdStr = await localStorage.getVendorID();
//       final userId = userIdStr != null ? int.tryParse(userIdStr) : null;
//       if (userId == null) {
//         Get.snackbar(
//           'Error',
//           'User ID not found or invalid',
//           backgroundColor: AppColors.errorColor,
//           colorText: Colors.white,
//         );
//         isLoading.value = false;
//         return;
//       }

//       print('vendorId: $userId');
//       print('address: "${addressController.text.trim()}"');
//       print('state: "${stateController.text.trim()}"');
//       print('city: "${cityController.text.trim()}"');
//       print('pincode: "${pinCodeController.text.trim()}"');
//       print('documentType: "${documentTypeController.text.trim()}"');
//       print('documentNumber: "${documentNumberController.text.trim()}"');

//       final response = await _apiService.updateVendorAddress(
//         vendorId: userId,
//         address: addressController.text.trim(),
//         state: stateController.text.trim(),
//         city: cityController.text.trim(),
//         pincode: pinCodeController.text.trim(),
//         documentType: documentTypeController.text.trim(),
//         documentNumber: documentNumberController.text.trim(),
//       );

//       if (response.statusCode == 200) {
//         registrationModal.update((val) {
//           val?.personalDetails = {
//             'address': addressController.text.trim(),
//             'state': stateController.text.trim(),
//             'city': cityController.text.trim(),
//             'pincode': pinCodeController.text.trim(),
//             'document_type': documentTypeController.text.trim(),
//             'document_number': documentNumberController.text.trim(),
//           };
//           val?.registrationStep = 1; // Updated to match next step
//         });
//         await saveRegistrationProgress();
//         Get.off(() => BankDetailsScreen());
//         Get.snackbar(
//           'Success',
//           'Address details saved',
//           backgroundColor: AppColors.successColor,
//           colorText: Colors.white,
//         );
//       } else {
//         // Handle 422 or other error responses
//         String errorMessage = 'Failed to save address details';
//         if (response.data['detail'] is List) {
//           final errors = response.data['detail'] as List;
//           errorMessage = errors.map((e) => e['msg']).join(', ');
//         } else if (response.data['detail'] is String) {
//           errorMessage = response.data['detail'];
//         }
//         Get.snackbar(
//           'Error',
//           errorMessage,
//           backgroundColor: AppColors.errorColor,
//           colorText: Colors.white,
//         );
//       }
//     } on DioException catch (e) {
//       String errorMessage = 'Failed to save address details';
//       if (e.response?.data['detail'] is List) {
//         final errors = e.response!.data['detail'] as List;
//         errorMessage = errors.map((e) => e['msg']).join(', ');
//       } else if (e.response?.data['detail'] is String) {
//         errorMessage = e.response!.data['detail'];
//       }
//       Get.snackbar(
//         'Error',
//         errorMessage,
//         backgroundColor: AppColors.errorColor,
//         colorText: Colors.white,
//       );
//     } finally {
//       isLoading.value = false;
//     }
//   }

//   Future<void> submitBankDetails() async {
//     if (!bankFormKey.currentState!.validate()) return;

//     isLoading.value = true;
//     try {
//       final userIdStr = await localStorage.getVendorID();
//       final userId = userIdStr != null ? int.tryParse(userIdStr) : null;
//       if (userId == null) {
//         Get.snackbar(
//           'Error',
//           'User ID not found or invalid',
//           backgroundColor: AppColors.errorColor,
//           colorText: Colors.white,
//         );
//         isLoading.value = false;
//         return;
//       }

//       final response = await _apiService.updateVendorBank(
//         vendorId: userId,
//         accountHolderName: accountHolderNameController.text.trim(),
//         accountNumber: accountNumberController.text.trim(),
//         ifscCode: ifscCodeController.text.trim(),
//         upiId: upiIdController.text.trim(),
//         bankDocType: bankDocTypeController.text.trim(),
//         bankDocNumber: bankDocNumberController.text.trim(),
//       );

//       if (response.statusCode == 200) {
//         registrationModal.update((val) {
//           val?.bankDetails = {
//             'account_holder_name': accountHolderNameController.text.trim(),
//             'account_number': accountNumberController.text.trim(),
//             'ifsc_code': ifscCodeController.text.trim(),
//             'upi_id': upiIdController.text.trim(),
//             'bank_doc_type': bankDocTypeController.text.trim(),
//             'bank_doc_number': bankDocNumberController.text.trim(),
//           };
//           val?.registrationStep = 2;
//         });
//         await saveRegistrationProgress();
//         Get.off(() => WorkDetailsScreen());
//         Get.snackbar(
//           'Success',
//           'Bank details saved',
//           backgroundColor: AppColors.successColor,
//           colorText: Colors.white,
//         );
//       } else {
//         Get.snackbar(
//           'Error',
//           response.data['detail']?.toString() ?? 'Failed to save bank details',
//           backgroundColor: AppColors.errorColor,
//           colorText: Colors.white,
//         );
//       }
//     } on DioException catch (e) {
//       Get.snackbar(
//         'Error',
//         e.response?.data['detail']?.toString() ?? 'Failed to save bank details',
//         backgroundColor: AppColors.errorColor,
//         colorText: Colors.white,
//       );
//     } finally {
//       isLoading.value = false;
//     }
//   }

//   Future<void> submitWorkDetails() async {
//     if (!workFormKey.currentState!.validate()) {
//       ServexUtils.logPrint('Work form validation failed');
//       return;
//     }

//     if (subcategoryCharges.isEmpty) {
//       Get.snackbar(
//         'Error',
//         'Please select at least one subcategory with a valid charge',
//         backgroundColor: AppColors.errorColor,
//         colorText: Colors.white,
//       );
//       return;
//     }

//     isLoading.value = true;
//     try {
//       final userIdStr = await localStorage.getVendorID();
//       final userId = userIdStr != null ? int.tryParse(userIdStr) : null;
//       if (userId == null) {
//         Get.snackbar(
//           'Error',
//           'User ID not found or invalid',
//           backgroundColor: AppColors.errorColor,
//           colorText: Colors.white,
//         );
//         isLoading.value = false;
//         return;
//       }

//       // Prepare subcategory charges in the expected format
//       final charges = subcategoryCharges
//           .map(
//             (e) => {
//               'subcategory_id': e.subcategoryId,
//               'service_charge': e.serviceCharge ?? 0.0,
//             },
//           )
//           .toList();

//       ServexUtils.logPrint(
//         'Submitting work details: vendor_id=$userId, category_id=${categoryId.value}, charges=$charges',
//       );

//       // Log the auth token for debugging
//       final token = await localStorage.getToken();
//       ServexUtils.logPrint('Authorization token: $token');

//       final response = await _apiService.updateVendorWork(
//         vendorId: userId,
//         categoryId: categoryId.value,
//         subcategoryCharges: charges,
//       );

//       if (response.statusCode == 200) {
//         registrationModal.update((val) {
//           val?.workDetails = {'category_id': categoryId.value};
//           val?.subcategoryCharges = subcategoryCharges.toList();
//           val?.registrationStep = 3;
//         });
//         await saveRegistrationProgress();
//         Get.off(() => DocumentUploadScreen());
//         Get.snackbar(
//           'Success',
//           'Work details saved successfully',
//           backgroundColor: AppColors.successColor,
//           colorText: Colors.white,
//         );
//       } else {
//         final errorMessage =
//             response.data['detail']?.toString() ??
//             'Failed to save work details';
//         ServexUtils.logPrint('Work details submission failed: $errorMessage');
//         Get.snackbar(
//           'Error',
//           errorMessage,
//           backgroundColor: AppColors.errorColor,
//           colorText: Colors.white,
//         );
//       }
//     } on DioException catch (e) {
//       String errorMessage = 'Failed to save work details';
//       if (e.response?.data['detail'] is List) {
//         final errors = e.response!.data['detail'] as List;
//         errorMessage = errors.map((e) => e['msg']).join(', ');
//       } else if (e.response?.data['detail'] is String) {
//         errorMessage = e.response!.data['detail'];
//       } else {
//         errorMessage = e.message ?? 'Unknown error';
//       }
//       ServexUtils.logPrint(
//         'DioException in submitWorkDetails: $errorMessage, response: ${e.response?.data}',
//       );
//       Get.snackbar(
//         'Error',
//         errorMessage,
//         backgroundColor: AppColors.errorColor,
//         colorText: Colors.white,
//       );
//     } catch (e) {
//       ServexUtils.logPrint('Unexpected error in submitWorkDetails: $e');
//       Get.snackbar(
//         'Error',
//         'Unexpected error occurred: $e',
//         backgroundColor: AppColors.errorColor,
//         colorText: Colors.white,
//       );
//     } finally {
//       isLoading.value = false;
//     }
//   }

//   Future<void> submitDocuments() async {
//     if (!documentFormKey.currentState!.validate()) {
//       ServexUtils.logPrint('Document form validation failed');
//       return;
//     }

//     if (identityDocBytes.value == null ||
//         bankDocBytes.value == null ||
//         addressDocBytes.value == null) {
//       Get.snackbar(
//         'Error',
//         'Please upload all required documents (identity, bank, address)',
//         backgroundColor: AppColors.errorColor,
//         colorText: Colors.white,
//       );
//       return;
//     }

//     isLoading.value = true;
//     try {
//       final userIdStr = await localStorage.getVendorID();
//       final userId = userIdStr != null ? int.tryParse(userIdStr) : null;
//       if (userId == null) {
//         Get.snackbar(
//           'Error',
//           'User ID not found or invalid',
//           backgroundColor: AppColors.errorColor,
//           colorText: Colors.white,
//         );
//         isLoading.value = false;
//         return;
//       }

//       ServexUtils.logPrint('Submitting documents for vendor_id=$userId');

//       final response = await _apiService.uploadVendorDocuments(
//         vendorId: userId,
//         profilePicBytes: profilePicBytes.value ?? Uint8List(0),
//         identityDocBytes: identityDocBytes.value!,
//         bankDocBytes: bankDocBytes.value!,
//         addressDocBytes: addressDocBytes.value!,
//       );

//       if (response.statusCode == 200) {
//         registrationModal.update((val) {
//           val?.registrationStep = 4;
//         });
//         await storage.delete(key: 'registrationModal');
//         await localStorage.setRegistrationStep(0);
//         await localStorage.setVendorDetails(VendorModel registrationModal.value);
//         Get.offAllNamed(Routes.home);
//         Get.snackbar(
//           'Success',
//           'Documents uploaded successfully. Registration completed.',
//           backgroundColor: AppColors.successColor,
//           colorText: Colors.white,
//         );
//       } else {
//         final errorMessage =
//             response.data['detail']?.toString() ?? 'Failed to upload documents';
//         ServexUtils.logPrint('Document upload failed: $errorMessage');
//         Get.snackbar(
//           'Error',
//           errorMessage,
//           backgroundColor: AppColors.errorColor,
//           colorText: Colors.white,
//         );
//       }
//     } on DioException catch (e) {
//       final errorMessage =
//           e.response?.data['detail']?.toString() ??
//           'Failed to upload documents';
//       ServexUtils.logPrint('DioException in submitDocuments: $errorMessage');
//       Get.snackbar(
//         'Error',
//         errorMessage,
//         backgroundColor: AppColors.errorColor,
//         colorText: Colors.white,
//       );
//     } catch (e) {
//       ServexUtils.logPrint('Unexpected error in submitDocuments: $e');
//       Get.snackbar(
//         'Error',
//         'Unexpected error occurred',
//         backgroundColor: AppColors.errorColor,
//         colorText: Colors.white,
//       );
//     } finally {
//       isLoading.value = false;
//     }
//   }

//   Future<void> updateAdminStatus(String adminStatus) async {
//     if (!['active', 'inactive'].contains(adminStatus)) {
//       Get.snackbar(
//         'Error',
//         'Invalid admin status',
//         backgroundColor: AppColors.errorColor,
//         colorText: Colors.white,
//       );
//       return;
//     }

//     isLoading.value = true;
//     try {
//       final userIdStr = await localStorage.getVendorID();
//       final userId = userIdStr != null ? int.tryParse(userIdStr) : null;
//       if (userId == null) {
//         Get.snackbar(
//           'Error',
//           'User ID not found or invalid',
//           backgroundColor: AppColors.errorColor,
//           colorText: Colors.white,
//         );
//         isLoading.value = false;
//         return;
//       }

//       final response = await _apiService.updateAdminStatus(
//         vendorId: userId,
//         adminStatus: adminStatus,
//       );

//       if (response.statusCode == 200) {
//         Get.snackbar(
//           'Success',
//           'Admin status updated',
//           backgroundColor: AppColors.successColor,
//           colorText: Colors.white,
//         );
//       } else {
//         Get.snackbar(
//           'Error',
//           response.data['detail']?.toString() ??
//               'Failed to update admin status',
//           backgroundColor: AppColors.errorColor,
//           colorText: Colors.white,
//         );
//       }
//     } on DioException catch (e) {
//       Get.snackbar(
//         'Error',
//         e.response?.data['detail']?.toString() ??
//             'Failed to update admin status',
//         backgroundColor: AppColors.errorColor,
//         colorText: Colors.white,
//       );
//     } finally {
//       isLoading.value = false;
//     }
//   }

//   Future<void> submitDeviceDetails() async {
//     isLoading.value = true;
//     try {
//       final userIdStr = await localStorage.getVendorID();
//       final userId = userIdStr != null ? int.tryParse(userIdStr) : null;
//       if (userId == null) {
//         Get.snackbar(
//           'Error',
//           'User ID not found or invalid',
//           backgroundColor: AppColors.errorColor,
//           colorText: Colors.white,
//         );
//         isLoading.value = false;
//         return;
//       }

//       final response = await _apiService.updateDeviceDetails(
//         vendorId: userId,
//         data: {
//           'fcm_token': fcmTokenController.text.isNotEmpty
//               ? fcmTokenController.text
//               : null,
//           'latitude': latitudeController.text.isNotEmpty
//               ? double.tryParse(latitudeController.text)
//               : null,
//           'longitude': longitudeController.text.isNotEmpty
//               ? double.tryParse(longitudeController.text)
//               : null,
//           'device_name': deviceNameController.text.isNotEmpty
//               ? deviceNameController.text
//               : null,
//         },
//       );

//       if (response.statusCode == 200) {
//         Get.snackbar(
//           'Success',
//           'Device details updated',
//           backgroundColor: AppColors.successColor,
//           colorText: Colors.white,
//         );
//       } else {
//         Get.snackbar(
//           'Error',
//           response.data['detail']?.toString() ??
//               'Failed to update device details',
//           backgroundColor: AppColors.errorColor,
//           colorText: Colors.white,
//         );
//       }
//     } on DioException catch (e) {
//       Get.snackbar(
//         'Error',
//         e.response?.data['detail']?.toString() ??
//             'Failed to update device details',
//         backgroundColor: AppColors.errorColor,
//         colorText: Colors.white,
//       );
//     } finally {
//       isLoading.value = false;
//     }
//   }

//   void addSubCategoryCharge(int subcategoryId, double serviceCharge) {
//     subcategoryCharges.removeWhere(
//       (charge) => charge.subcategoryId == subcategoryId,
//     );
//     subcategoryCharges.add(
//       SubCategoryCharge(
//         subcategoryId: subcategoryId,
//         serviceCharge: serviceCharge,
//       ),
//     );
//   }

//   void removeSubCategoryCharge(int subcategoryId) {
//     subcategoryCharges.removeWhere(
//       (charge) => charge.subcategoryId == subcategoryId,
//     );
//   }

//   void navigateToCurrentStep() {
//     String? currentRoute = Get.currentRoute;
//     switch (registrationModal.value.registrationStep) {
//       case 0:
//         if (currentRoute != Routes.register) Get.offAllNamed(Routes.register);
//         break;
//       case 1:
//         if (currentRoute != Routes.addressDetails) {
//           Get.offAllNamed(Routes.addressDetails);
//         }
//         break;
//       case 2:
//         if (currentRoute != Routes.bankDetails) {
//           Get.offAllNamed(Routes.bankDetails);
//         }
//         break;
//       case 3:
//         if (currentRoute != Routes.workDetails) {
//           Get.offAllNamed(Routes.workDetails);
//         }
//         break;
//       case 4:
//         if (currentRoute != '/documentUpload') {
//           Get.offAllNamed('/documentUpload');
//         }
//         break;
//       case 6:
//         if (currentRoute != Routes.home) Get.offAllNamed(Routes.home);
//         break;
//       default:
//         Get.offAllNamed(Routes.register);
//         break;
//     }
//   }
// }

import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:fixbuddy_partner/app/data/models/vendor_model.dart';
import 'package:fixbuddy_partner/app/modules/register/models/category.dart';
import 'package:fixbuddy_partner/app/modules/register/models/sub_category.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:fixbuddy_partner/app/constants/app_color.dart';
import 'package:fixbuddy_partner/app/modules/register/models/register_models.dart';
import 'package:fixbuddy_partner/app/modules/register/services/register_services.dart';
import 'package:fixbuddy_partner/app/modules/register/views/widgets/address_details_screen.dart';
import 'package:fixbuddy_partner/app/modules/register/views/widgets/bank_details_screen.dart';
import 'package:fixbuddy_partner/app/modules/register/views/widgets/document_upload_screen.dart';
import 'package:fixbuddy_partner/app/modules/register/views/widgets/otp_verification_screen.dart';
import 'package:fixbuddy_partner/app/modules/register/views/widgets/work_details_screen.dart';
import 'package:fixbuddy_partner/app/routes/app_routes.dart';
import 'package:fixbuddy_partner/app/utils/local_storage.dart';
import 'package:fixbuddy_partner/app/utils/servex_utils.dart';

// This is a new class to hold the state for each subcategory item
// It's a cleaner way to manage the checkbox and text field together
class SubCategoryChargeState {
  final int subcategoryId;
  final RxBool isSelected = false.obs;
  final TextEditingController textController = TextEditingController();

  SubCategoryChargeState({required this.subcategoryId});
}

class RegistrationController extends GetxController {
  final otpControllers = List.generate(6, (_) => TextEditingController());
  final emailFormKey = GlobalKey<FormState>();
  final addressFormKey = GlobalKey<FormState>();
  final bankFormKey = GlobalKey<FormState>();
  final workFormKey = GlobalKey<FormState>();
  final documentFormKey = GlobalKey<FormState>();

  final emailController = TextEditingController();
  final fullNameController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  final addressController = TextEditingController();
  final stateController = TextEditingController();
  final cityController = TextEditingController();
  final pinCodeController = TextEditingController();
  final accountHolderNameController = TextEditingController();
  final accountNumberController = TextEditingController();
  final ifscCodeController = TextEditingController();
  final upiIdController = TextEditingController();
  final documentTypeController = TextEditingController();
  final documentNumberController = TextEditingController();
  final bankDocTypeController = TextEditingController();
  final bankDocNumberController = TextEditingController();

  final categoryId = 0.obs;
  // We'll manage subcategory charges using a map for better state control
  final subcategoryChargesMap = <int, SubCategoryChargeState>{}.obs;

  Rx<Uint8List?> profilePicBytes = Rx<Uint8List?>(null);
  Rx<Uint8List?> identityDocBytes = Rx<Uint8List?>(null);
  Rx<Uint8List?> bankDocBytes = Rx<Uint8List?>(null);
  Rx<Uint8List?> addressDocBytes = Rx<Uint8List?>(null);
  final fcmTokenController = TextEditingController();
  final latitudeController = TextEditingController();
  final longitudeController = TextEditingController();
  final deviceNameController = TextEditingController();

  final identityDocTypeController = TextEditingController();
  final identityDocNumberController = TextEditingController();
  final profilePicController = TextEditingController();

  final termsAccepted = false.obs;
  final isLoading = false.obs;
  // A new loading state specifically for fetching subcategories
  final isSubcategoriesLoading = false.obs;
  final registrationModal = RegistrationModal().obs;
  final categories = <CategoryModel>[].obs;
  final subcategories = <SubcategoryModel>[].obs;
  final authToken = ''.obs;

  final AuthApiService _apiService = AuthApiService();
  Timer? _notificationTimer;
  final storage = const FlutterSecureStorage();
  final localStorage = LocalStorage();

  // Helper getter to convert the map back to the required list format
  // List<SubCategoryCharge> get subcategoryCharges => subcategoryChargesMap.values
  //     .where((state) => state.isSelected.value)
  //     .map(
  //       (state) => SubCategoryCharge(
  //         subcategoryId: state.subcategoryId,
  //         serviceCharge: double.tryParse(state.textController.text) ?? 0.0,
  //       ),
  //     )
  //     .toList();

  List<SubCategoryCharge> get subcategoryCharges => subcategoryChargesMap.values
      .where((state) => state.isSelected.value)
      .map(
        (state) => SubCategoryCharge(
          subcategoryId: state.subcategoryId,
          serviceCharge: double.tryParse(state.textController.text) ?? 0.0,
        ),
      )
      .toList();
  String get otp => otpControllers.map((controller) => controller.text).join();
  final List<String> documentTypes = [
    'Passport',
    'Driver\'s License',
    'Aadhaar Card',
    'Voter ID',
    'PAN Card',
  ];

  @override
  void onInit() {
    super.onInit();
    initializeRegistration();
    setupNotificationReminder();
    fetchCategories();
  }

  @override
  void onClose() {
    _notificationTimer?.cancel();
    for (var controller in otpControllers) {
      controller.dispose();
    }
    emailController.dispose();
    fullNameController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    addressController.dispose();
    stateController.dispose();
    cityController.dispose();
    pinCodeController.dispose();
    accountHolderNameController.dispose();
    accountNumberController.dispose();
    ifscCodeController.dispose();
    upiIdController.dispose();
    documentTypeController.dispose();
    documentNumberController.dispose();
    bankDocTypeController.dispose();
    bankDocNumberController.dispose();
    fcmTokenController.dispose();
    latitudeController.dispose();
    longitudeController.dispose();
    deviceNameController.dispose();
    // Dispose all TextControllers in the map
    for (var state in subcategoryChargesMap.values) {
      state.textController.dispose();
    }
    super.onClose();
  }

  Future<void> initializeRegistration() async {
    try {
      final data = await storage.read(key: 'registrationModal');
      if (data != null) {
        final jsonData =
            await compute(jsonDecode, data) as Map<String, dynamic>;
        registrationModal.value = RegistrationModal.fromJson(jsonData);
        fillControllers();
        final storedStep = await localStorage.getRegistrationStep();
        if (storedStep != registrationModal.value.registrationStep) {
          registrationModal.value.registrationStep = storedStep;
        }
      } else {
        registrationModal.value = RegistrationModal();
        registrationModal.value.registrationStep = await localStorage
            .getRegistrationStep();
      }

      fcmTokenController.text = await localStorage.getFirebaseToken() ?? '';
      deviceNameController.text = await localStorage.getDeviceName() ?? '';
      latitudeController.text = await localStorage.getDeviceLatitude() ?? '';
      longitudeController.text = await localStorage.getDeviceLongitude() ?? '';

      await Future.delayed(const Duration(milliseconds: 100));
      navigateToCurrentStep();
    } catch (e) {
      ServexUtils.logPrint('Error initializing registration: $e');
      Get.snackbar(
        'Error',
        'Failed to initialize registration data: $e',
        backgroundColor: AppColors.errorColor,
        colorText: Colors.white,
      );
      registrationModal.value = RegistrationModal();
      registrationModal.value.registrationStep = await localStorage
          .getRegistrationStep();
      navigateToCurrentStep();
    }
  }

  void fillControllers() {
    final personalDetails = registrationModal.value.personalDetails;
    final bankDetails = registrationModal.value.bankDetails;

    addressController.text = personalDetails['address']?.toString() ?? '';
    stateController.text = personalDetails['state']?.toString() ?? '';
    cityController.text = personalDetails['city']?.toString() ?? '';
    pinCodeController.text = personalDetails['pincode']?.toString() ?? '';
    documentTypeController.text =
        personalDetails['document_type']?.toString() ?? '';
    documentNumberController.text =
        personalDetails['document_number']?.toString() ?? '';
    accountHolderNameController.text =
        bankDetails['account_holder_name']?.toString() ?? '';
    accountNumberController.text =
        bankDetails['account_number']?.toString() ?? '';
    ifscCodeController.text = bankDetails['ifsc_code']?.toString() ?? '';
    upiIdController.text = bankDetails['upi_id']?.toString() ?? '';
    bankDocTypeController.text = bankDetails['bank_doc_type']?.toString() ?? '';
    bankDocNumberController.text =
        bankDetails['bank_doc_number']?.toString() ?? '';
    fcmTokenController.text = registrationModal.value.fcmToken ?? '';
    latitudeController.text =
        registrationModal.value.latitude?.toString() ?? '';
    longitudeController.text =
        registrationModal.value.longitude?.toString() ?? '';
    deviceNameController.text = registrationModal.value.deviceName ?? '';
    termsAccepted.value = registrationModal.value.termsAccepted;

    // Restore subcategory charges and update the map
    categoryId.value = registrationModal.value.workDetails['category_id'] ?? 0;
    if (categoryId.value != 0) {
      // Assuming subcategories for the category are fetched here or will be fetched later
      for (var charge in registrationModal.value.subcategoryCharges) {
        final state =
            subcategoryChargesMap[charge.subcategoryId] ??
            SubCategoryChargeState(subcategoryId: charge.subcategoryId);
        state.isSelected.value = true;
        state.textController.text = charge.serviceCharge.toString();
        subcategoryChargesMap[charge.subcategoryId] = state;
      }
    }
  }

  Future<void> saveRegistrationProgress() async {
    try {
      // Update registrationModal with latest data from controllers and map
      registrationModal.update((val) {
        val?.personalDetails = {
          'address': addressController.text.trim(),
          'state': stateController.text.trim(),
          'city': cityController.text.trim(),
          'pincode': pinCodeController.text.trim(),
          'document_type': documentTypeController.text.trim(),
          'document_number': documentNumberController.text.trim(),
        };
        val?.bankDetails = {
          'account_holder_name': accountHolderNameController.text.trim(),
          'account_number': accountNumberController.text.trim(),
          'ifsc_code': ifscCodeController.text.trim(),
          'upi_id': upiIdController.text.trim(),
          'bank_doc_type': bankDocTypeController.text.trim(),
          'bank_doc_number': bankDocNumberController.text.trim(),
        };
        val?.workDetails = {'category_id': categoryId.value};
        val?.subcategoryCharges = subcategoryCharges;
      });

      await storage.write(
        key: 'registrationModal',
        value: jsonEncode(registrationModal.value.toJson()),
      );
      await localStorage.setRegistrationStep(
        registrationModal.value.registrationStep,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to save registration progress',
        backgroundColor: AppColors.errorColor,
        colorText: Colors.white,
      );
    }
  }

  void setupNotificationReminder() {
    _notificationTimer = Timer.periodic(const Duration(minutes: 30), (
      timer,
    ) async {
      if (registrationModal.value.registrationStep < 6 &&
          !registrationModal.value.isVerified) {
        await showNotification();
      } else {
        _notificationTimer?.cancel();
      }
    });
  }

  Future<void> showNotification() async {
    final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
          'registration_channel',
          'Registration Reminders',
          importance: Importance.high,
          priority: Priority.high,
        );
    const NotificationDetails platformDetails = NotificationDetails(
      android: androidDetails,
    );

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

  Future<void> fetchCategories() async {
    try {
      final fetchedCategories = await _apiService.fetchCategories();
      categories.assignAll(fetchedCategories);
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to fetch categories: $e',
        backgroundColor: AppColors.errorColor,
        colorText: Colors.white,
      );
    }
  }

  Future<void> fetchSubcategories(int? categoryId) async {
    if (categoryId == null) return;
    isSubcategoriesLoading.value = true;
    try {
      final fetchedSubcategories = await _apiService.fetchSubcategories(
        categoryId,
      );
      subcategories.assignAll(fetchedSubcategories);

      // Initialize the state map for each subcategory
      subcategoryChargesMap.clear();
      for (var subcategory in fetchedSubcategories) {
        subcategoryChargesMap[subcategory.id] = SubCategoryChargeState(
          subcategoryId: subcategory.id,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to fetch subcategories: $e',
        backgroundColor: AppColors.errorColor,
        colorText: Colors.white,
      );
      subcategories.clear();
    } finally {
      isSubcategoriesLoading.value = false;
    }
  }

  // New method to handle checkbox clicks
  void onSubcategorySelected(int subcategoryId, bool isSelected) {
    final state = subcategoryChargesMap[subcategoryId];
    if (state != null) {
      state.isSelected.value = isSelected;
      if (!isSelected) {
        state.textController.clear();
      }
      ServexUtils.logPrint('Subcategory $subcategoryId selected: $isSelected');
    }
  }

  void onChargeChanged(int subcategoryId, String value) {
    final state = subcategoryChargesMap[subcategoryId];
    if (state != null) {
      final chargeValue = double.tryParse(value) ?? 0.0;
      state.isSelected.value = chargeValue > 0;
      ServexUtils.logPrint(
        'Charge for subcategory $subcategoryId: $value, selected: ${state.isSelected.value}',
      );
    }
  }

  Future<void> login() async {
    if (!emailFormKey.currentState!.validate()) return;

    isLoading.value = true;
    try {
      final response = await _apiService.login(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
      if (response.statusCode == 200) {
        authToken.value = response.data['access_token'];
        localStorage.setToken(authToken.value);
        await localStorage.setVendorID(
          registrationModal.value.vendorId?.toString() ?? '',
        );
        Get.offAllNamed(Routes.home);
        Get.snackbar(
          'Success',
          'Login successful',
          backgroundColor: AppColors.successColor,
          colorText: Colors.white,
        );
      } else {
        Get.snackbar(
          'Error',
          response.data['detail']?.toString() ?? 'Login failed',
          backgroundColor: AppColors.errorColor,
          colorText: Colors.white,
        );
      }
    } on DioException catch (e) {
      Get.snackbar(
        'Error',
        e.response?.data['detail']?.toString() ?? 'Login failed',
        backgroundColor: AppColors.errorColor,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> sendRegistrationOtp() async {
    if (!emailFormKey.currentState!.validate()) return;

    final email = emailController.text.trim();
    final fullName = fullNameController.text.trim();
    final phone = phoneController.text.trim();
    final password = passwordController.text.trim();
    final identityDocType = identityDocTypeController.text.trim();
    final identityDocNumber = identityDocNumberController.text.trim();
    final profilePic = profilePicController.text.trim();

    if (!isValidEmail(email)) {
      Get.snackbar(
        'Invalid Email',
        'Enter a valid email address',
        backgroundColor: AppColors.errorColor,
        colorText: Colors.white,
      );
      return;
    }

    if (identityDocType.isEmpty || identityDocNumber.isEmpty) {
      Get.snackbar(
        'Error',
        'Identity document type and number are required',
        backgroundColor: AppColors.errorColor,
        colorText: Colors.white,
      );
      return;
    }

    if (profilePic.isEmpty) {
      Get.snackbar(
        'Error',
        'Profile picture URL is required',
        backgroundColor: AppColors.errorColor,
        colorText: Colors.white,
      );
      return;
    }

    if (!termsAccepted.value) {
      Get.snackbar(
        'Error',
        'You must accept the terms and conditions',
        backgroundColor: AppColors.errorColor,
        colorText: Colors.white,
      );
      return;
    }

    isLoading.value = true;
    try {
      final response = await _apiService.sendRegistrationOtp(
        name: fullName,
        email: email,
        phone: phone,
        password: password,
        termsAccepted: termsAccepted.value,
        identityDocType: identityDocType,
        identityDocNumber: identityDocNumber,
        fcmToken: fcmTokenController.text.isNotEmpty
            ? fcmTokenController.text
            : null,
        latitude: latitudeController.text.isNotEmpty
            ? double.tryParse(latitudeController.text)
            : null,
        longitude: longitudeController.text.isNotEmpty
            ? double.tryParse(longitudeController.text)
            : null,
        deviceName: deviceNameController.text.isNotEmpty
            ? deviceNameController.text
            : null,
        profilePic: profilePic,
      );

      if (response.statusCode == 200) {
        registrationModal.update((val) {
          val?.email = email;
          val?.fullName = fullName;
          val?.phone = phone;
          val?.password = password;
          val?.termsAccepted = termsAccepted.value;
          val?.identityDocType = identityDocType;
          val?.identityDocNumber = identityDocNumber;
          val?.fcmToken = fcmTokenController.text.isNotEmpty
              ? fcmTokenController.text
              : null;
          val?.latitude = latitudeController.text.isNotEmpty
              ? double.tryParse(latitudeController.text)
              : null;
          val?.longitude = longitudeController.text.isNotEmpty
              ? double.tryParse(longitudeController.text)
              : null;
          val?.deviceName = deviceNameController.text.isNotEmpty
              ? deviceNameController.text
              : null;
          val?.profilePic = profilePic;
          val?.vendorId = response.data['vendor_id'];
        });
        await saveRegistrationProgress();
        Get.to(() => OtpVerificationScreen());
        Get.snackbar(
          'Success',
          'OTP sent to your email',
          backgroundColor: AppColors.successColor,
          colorText: Colors.white,
        );
      } else {
        Get.snackbar(
          'Error',
          response.data['detail']?.toString() ?? 'Failed to send OTP',
          backgroundColor: AppColors.errorColor,
          colorText: Colors.white,
        );
      }
    } on DioException catch (e) {
      Get.snackbar(
        'Error',
        e.response?.data['detail']?.toString() ?? 'Something went wrong',
        backgroundColor: AppColors.errorColor,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> resendRegistrationOtp() async {
    if (registrationModal.value.email == null) {
      Get.snackbar(
        'Error',
        'No email found for resending OTP',
        backgroundColor: AppColors.errorColor,
        colorText: Colors.white,
      );
      return;
    }

    isLoading.value = true;
    try {
      final response = await _apiService.resendRegistrationOtp(
        registrationModal.value.email!,
      );
      if (response.statusCode == 200) {
        Get.snackbar(
          'Success',
          'OTP resent to your email',
          backgroundColor: AppColors.successColor,
          colorText: Colors.white,
        );
      } else {
        Get.snackbar(
          'Error',
          response.data['detail']?.toString() ?? 'Failed to resend OTP',
          backgroundColor: AppColors.errorColor,
          colorText: Colors.white,
        );
      }
    } on DioException catch (e) {
      Get.snackbar(
        'Error',
        e.response?.data['detail']?.toString() ?? 'Something went wrong',
        backgroundColor: AppColors.errorColor,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> verifyOtp() async {
    isLoading.value = true;
    try {
      final response = await _apiService.verifyRegistrationOtp(
        email: registrationModal.value.email!,
        otp: otp,
      );

      if (response.statusCode == 200) {
        registrationModal.update((val) {
          val?.isVerified = true;
          val?.otp = null;
          val?.vendorId = response.data['vendor_id'];
          // Updated to match navigation
        });
        authToken.value = response.data['access_token'];
        await localStorage.setToken(authToken.value);
        await localStorage.setVendorID(
          registrationModal.value.vendorId!.toString(),
        );
        // Fetch and store full vendor data
        final vendorResponse = await _apiService.getCurrentVendor(
          authToken.value,
        );
        if (vendorResponse.statusCode == 200) {
          final vendor = VendorModel.fromJson(vendorResponse.data);
          await localStorage.setVendorDetails(vendor);
        }
        Get.off(() => AddressDetailsScreen());
        Get.snackbar(
          'Success',
          'OTP verified successfully',
          backgroundColor: AppColors.successColor,
          colorText: Colors.white,
        );
      } else {
        Get.snackbar(
          'Error',
          response.data['detail']?.toString() ?? 'Invalid OTP',
          backgroundColor: AppColors.errorColor,
          colorText: Colors.white,
        );
      }
    } on DioException catch (e) {
      Get.snackbar(
        'Error',
        e.response?.data['detail']?.toString() ?? 'Invalid OTP',
        backgroundColor: AppColors.errorColor,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> submitAddressDetails() async {
    if (!addressFormKey.currentState!.validate()) return;

    // Validate address_doc_type against documentTypes
    final docType = documentTypeController.text.trim();
    if (!documentTypes.contains(docType)) {
      Get.snackbar(
        'Error',
        'Please select a valid document type: ${documentTypes.join(', ')}',
        backgroundColor: AppColors.errorColor,
        colorText: Colors.white,
      );
      return;
    }

    isLoading.value = true;
    try {
      final userIdStr = await localStorage.getVendorID();
      final userId = userIdStr != null ? int.tryParse(userIdStr) : null;
      if (userId == null) {
        Get.snackbar(
          'Error',
          'User ID not found or invalid',
          backgroundColor: AppColors.errorColor,
          colorText: Colors.white,
        );
        isLoading.value = false;
        return;
      }

      print('vendorId: $userId');
      print('address: "${addressController.text.trim()}"');
      print('state: "${stateController.text.trim()}"');
      print('city: "${cityController.text.trim()}"');
      print('pincode: "${pinCodeController.text.trim()}"');
      print('documentType: "${documentTypeController.text.trim()}"');
      print('documentNumber: "${documentNumberController.text.trim()}"');

      final response = await _apiService.updateVendorAddress(
        vendorId: userId,
        address: addressController.text.trim(),
        state: stateController.text.trim(),
        city: cityController.text.trim(),
        pincode: pinCodeController.text.trim(),
        documentType: documentTypeController.text.trim(),
        documentNumber: documentNumberController.text.trim(),
      );

      if (response.statusCode == 200) {
        registrationModal.update((val) {
          val?.personalDetails = {
            'address': addressController.text.trim(),
            'state': stateController.text.trim(),
            'city': cityController.text.trim(),
            'pincode': pinCodeController.text.trim(),
            'document_type': documentTypeController.text.trim(),
            'document_number': documentNumberController.text.trim(),
          };
          val?.registrationStep = 1; // Updated to match next step
        });
        // Store updated vendor data from response
        final vendor = VendorModel.fromJson(response.data);
        await localStorage.setVendorDetails(vendor);
        await saveRegistrationProgress();
        Get.off(() => BankDetailsScreen());
        Get.snackbar(
          'Success',
          'Address details saved',
          backgroundColor: AppColors.successColor,
          colorText: Colors.white,
        );
      } else {
        // Handle 422 or other error responses
        String errorMessage = 'Failed to save address details';
        if (response.data['detail'] is List) {
          final errors = response.data['detail'] as List;
          errorMessage = errors.map((e) => e['msg']).join(', ');
        } else if (response.data['detail'] is String) {
          errorMessage = response.data['detail'];
        }
        Get.snackbar(
          'Error',
          errorMessage,
          backgroundColor: AppColors.errorColor,
          colorText: Colors.white,
        );
      }
    } on DioException catch (e) {
      String errorMessage = 'Failed to save address details';
      if (e.response?.data['detail'] is List) {
        final errors = e.response!.data['detail'] as List;
        errorMessage = errors.map((e) => e['msg']).join(', ');
      } else if (e.response?.data['detail'] is String) {
        errorMessage = e.response!.data['detail'];
      }
      Get.snackbar(
        'Error',
        errorMessage,
        backgroundColor: AppColors.errorColor,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> submitBankDetails() async {
    if (!bankFormKey.currentState!.validate()) return;

    isLoading.value = true;
    try {
      final userIdStr = await localStorage.getVendorID();
      final userId = userIdStr != null ? int.tryParse(userIdStr) : null;
      if (userId == null) {
        Get.snackbar(
          'Error',
          'User ID not found or invalid',
          backgroundColor: AppColors.errorColor,
          colorText: Colors.white,
        );
        isLoading.value = false;
        return;
      }

      final response = await _apiService.updateVendorBank(
        vendorId: userId,
        accountHolderName: accountHolderNameController.text.trim(),
        accountNumber: accountNumberController.text.trim(),
        ifscCode: ifscCodeController.text.trim(),
        upiId: upiIdController.text.trim(),
        bankDocType: bankDocTypeController.text.trim(),
        bankDocNumber: bankDocNumberController.text.trim(),
      );

      if (response.statusCode == 200) {
        registrationModal.update((val) {
          val?.bankDetails = {
            'account_holder_name': accountHolderNameController.text.trim(),
            'account_number': accountNumberController.text.trim(),
            'ifsc_code': ifscCodeController.text.trim(),
            'upi_id': upiIdController.text.trim(),
            'bank_doc_type': bankDocTypeController.text.trim(),
            'bank_doc_number': bankDocNumberController.text.trim(),
          };
          val?.registrationStep = 2;
        });
        // Store updated vendor data from response
        final vendor = VendorModel.fromJson(response.data);
        await localStorage.setVendorDetails(vendor);
        await saveRegistrationProgress();
        Get.off(() => WorkDetailsScreen());
        Get.snackbar(
          'Success',
          'Bank details saved',
          backgroundColor: AppColors.successColor,
          colorText: Colors.white,
        );
      } else {
        Get.snackbar(
          'Error',
          response.data['detail']?.toString() ?? 'Failed to save bank details',
          backgroundColor: AppColors.errorColor,
          colorText: Colors.white,
        );
      }
    } on DioException catch (e) {
      Get.snackbar(
        'Error',
        e.response?.data['detail']?.toString() ?? 'Failed to save bank details',
        backgroundColor: AppColors.errorColor,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> submitWorkDetails() async {
    if (!workFormKey.currentState!.validate()) {
      ServexUtils.logPrint('Work form validation failed');
      return;
    }

    if (subcategoryCharges.isEmpty) {
      Get.snackbar(
        'Error',
        'Please select at least one subcategory with a valid charge',
        backgroundColor: AppColors.errorColor,
        colorText: Colors.white,
      );
      return;
    }

    isLoading.value = true;
    try {
      final userIdStr = await localStorage.getVendorID();
      final userId = userIdStr != null ? int.tryParse(userIdStr) : null;
      if (userId == null) {
        Get.snackbar(
          'Error',
          'User ID not found or invalid',
          backgroundColor: AppColors.errorColor,
          colorText: Colors.white,
        );
        isLoading.value = false;
        return;
      }

      // Prepare subcategory charges in the expected format
      final charges = subcategoryCharges
          .map(
            (e) => {
              'subcategory_id': e.subcategoryId,
              'service_charge': e.serviceCharge ?? 0.0,
            },
          )
          .toList();

      ServexUtils.logPrint(
        'Submitting work details: vendor_id=$userId, category_id=${categoryId.value}, charges=$charges',
      );

      // Log the auth token for debugging
      final token = await localStorage.getToken();
      ServexUtils.logPrint('Authorization token: $token');

      final response = await _apiService.updateVendorWork(
        vendorId: userId,
        categoryId: categoryId.value,
        subcategoryCharges: charges,
      );

      if (response.statusCode == 200) {
        registrationModal.update((val) {
          val?.workDetails = {'category_id': categoryId.value};
          val?.subcategoryCharges = subcategoryCharges.toList();
          val?.registrationStep = 3;
        });
        // Store updated vendor data from response
        final vendor = VendorModel.fromJson(response.data);
        await localStorage.setVendorDetails(vendor);
        await saveRegistrationProgress();
        Get.off(() => DocumentUploadScreen());
        Get.snackbar(
          'Success',
          'Work details saved successfully',
          backgroundColor: AppColors.successColor,
          colorText: Colors.white,
        );
      } else {
        final errorMessage =
            response.data['detail']?.toString() ??
            'Failed to save work details';
        ServexUtils.logPrint('Work details submission failed: $errorMessage');
        Get.snackbar(
          'Error',
          errorMessage,
          backgroundColor: AppColors.errorColor,
          colorText: Colors.white,
        );
      }
    } on DioException catch (e) {
      String errorMessage = 'Failed to save work details';
      if (e.response?.data['detail'] is List) {
        final errors = e.response!.data['detail'] as List;
        errorMessage = errors.map((e) => e['msg']).join(', ');
      } else if (e.response?.data['detail'] is String) {
        errorMessage = e.response!.data['detail'];
      } else {
        errorMessage = e.message ?? 'Unknown error';
      }
      ServexUtils.logPrint(
        'DioException in submitWorkDetails: $errorMessage, response: ${e.response?.data}',
      );
      Get.snackbar(
        'Error',
        errorMessage,
        backgroundColor: AppColors.errorColor,
        colorText: Colors.white,
      );
    } catch (e) {
      ServexUtils.logPrint('Unexpected error in submitWorkDetails: $e');
      Get.snackbar(
        'Error',
        'Unexpected error occurred: $e',
        backgroundColor: AppColors.errorColor,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> submitDocuments() async {
    if (!documentFormKey.currentState!.validate()) {
      ServexUtils.logPrint('Document form validation failed');
      return;
    }

    if (identityDocBytes.value == null ||
        bankDocBytes.value == null ||
        addressDocBytes.value == null) {
      Get.snackbar(
        'Error',
        'Please upload all required documents (identity, bank, address)',
        backgroundColor: AppColors.errorColor,
        colorText: Colors.white,
      );
      return;
    }

    isLoading.value = true;
    try {
      final userIdStr = await localStorage.getVendorID();
      final userId = userIdStr != null ? int.tryParse(userIdStr) : null;
      if (userId == null) {
        Get.snackbar(
          'Error',
          'User ID not found or invalid',
          backgroundColor: AppColors.errorColor,
          colorText: Colors.white,
        );
        isLoading.value = false;
        return;
      }

      ServexUtils.logPrint('Submitting documents for vendor_id=$userId');

      final response = await _apiService.uploadVendorDocuments(
        vendorId: userId,
        profilePicBytes: profilePicBytes.value ?? Uint8List(0),
        identityDocBytes: identityDocBytes.value!,
        bankDocBytes: bankDocBytes.value!,
        addressDocBytes: addressDocBytes.value!,
      );

      if (response.statusCode == 200) {
        registrationModal.update((val) {
          val?.registrationStep = 4;
        });
        // Store updated vendor data from response
        final vendor = VendorModel.fromJson(response.data);
        await localStorage.setVendorDetails(vendor);
        await storage.delete(key: 'registrationModal');
        await localStorage.setRegistrationStep(0);
        Get.offAllNamed(Routes.home);
        Get.snackbar(
          'Success',
          'Documents uploaded successfully. Registration completed.',
          backgroundColor: AppColors.successColor,
          colorText: Colors.white,
        );
      } else {
        final errorMessage =
            response.data['detail']?.toString() ?? 'Failed to upload documents';
        ServexUtils.logPrint('Document upload failed: $errorMessage');
        Get.snackbar(
          'Error',
          errorMessage,
          backgroundColor: AppColors.errorColor,
          colorText: Colors.white,
        );
      }
    } on DioException catch (e) {
      final errorMessage =
          e.response?.data['detail']?.toString() ??
          'Failed to upload documents';
      ServexUtils.logPrint('DioException in submitDocuments: $errorMessage');
      Get.snackbar(
        'Error',
        errorMessage,
        backgroundColor: AppColors.errorColor,
        colorText: Colors.white,
      );
    } catch (e) {
      ServexUtils.logPrint('Unexpected error in submitDocuments: $e');
      Get.snackbar(
        'Error',
        'Unexpected error occurred',
        backgroundColor: AppColors.errorColor,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateAdminStatus(String adminStatus) async {
    if (!['active', 'inactive'].contains(adminStatus)) {
      Get.snackbar(
        'Error',
        'Invalid admin status',
        backgroundColor: AppColors.errorColor,
        colorText: Colors.white,
      );
      return;
    }

    isLoading.value = true;
    try {
      final userIdStr = await localStorage.getVendorID();
      final userId = userIdStr != null ? int.tryParse(userIdStr) : null;
      if (userId == null) {
        Get.snackbar(
          'Error',
          'User ID not found or invalid',
          backgroundColor: AppColors.errorColor,
          colorText: Colors.white,
        );
        isLoading.value = false;
        return;
      }

      final response = await _apiService.updateAdminStatus(
        vendorId: userId,
        adminStatus: adminStatus,
      );

      if (response.statusCode == 200) {
        Get.snackbar(
          'Success',
          'Admin status updated',
          backgroundColor: AppColors.successColor,
          colorText: Colors.white,
        );
      } else {
        Get.snackbar(
          'Error',
          response.data['detail']?.toString() ??
              'Failed to update admin status',
          backgroundColor: AppColors.errorColor,
          colorText: Colors.white,
        );
      }
    } on DioException catch (e) {
      Get.snackbar(
        'Error',
        e.response?.data['detail']?.toString() ??
            'Failed to update admin status',
        backgroundColor: AppColors.errorColor,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> submitDeviceDetails() async {
    isLoading.value = true;
    try {
      final userIdStr = await localStorage.getVendorID();
      final userId = userIdStr != null ? int.tryParse(userIdStr) : null;
      if (userId == null) {
        Get.snackbar(
          'Error',
          'User ID not found or invalid',
          backgroundColor: AppColors.errorColor,
          colorText: Colors.white,
        );
        isLoading.value = false;
        return;
      }

      final response = await _apiService.updateDeviceDetails(
        vendorId: userId,
        data: {
          'fcm_token': fcmTokenController.text.isNotEmpty
              ? fcmTokenController.text
              : null,
          'latitude': latitudeController.text.isNotEmpty
              ? double.tryParse(latitudeController.text)
              : null,
          'longitude': longitudeController.text.isNotEmpty
              ? double.tryParse(longitudeController.text)
              : null,
          'device_name': deviceNameController.text.isNotEmpty
              ? deviceNameController.text
              : null,
        },
      );

      if (response.statusCode == 200) {
        Get.snackbar(
          'Success',
          'Device details updated',
          backgroundColor: AppColors.successColor,
          colorText: Colors.white,
        );
      } else {
        Get.snackbar(
          'Error',
          response.data['detail']?.toString() ??
              'Failed to update device details',
          backgroundColor: AppColors.errorColor,
          colorText: Colors.white,
        );
      }
    } on DioException catch (e) {
      Get.snackbar(
        'Error',
        e.response?.data['detail']?.toString() ??
            'Failed to update device details',
        backgroundColor: AppColors.errorColor,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void addSubCategoryCharge(int subcategoryId, double serviceCharge) {
    subcategoryCharges.removeWhere(
      (charge) => charge.subcategoryId == subcategoryId,
    );
    subcategoryCharges.add(
      SubCategoryCharge(
        subcategoryId: subcategoryId,
        serviceCharge: serviceCharge,
      ),
    );
  }

  void removeSubCategoryCharge(int subcategoryId) {
    subcategoryCharges.removeWhere(
      (charge) => charge.subcategoryId == subcategoryId,
    );
  }

  void navigateToCurrentStep() {
    String? currentRoute = Get.currentRoute;
    switch (registrationModal.value.registrationStep) {
      case 0:
        if (currentRoute != Routes.register) Get.offAllNamed(Routes.register);
        break;
      case 1:
        if (currentRoute != Routes.addressDetails) {
          Get.offAllNamed(Routes.addressDetails);
        }
        break;
      case 2:
        if (currentRoute != Routes.bankDetails) {
          Get.offAllNamed(Routes.bankDetails);
        }
        break;
      case 3:
        if (currentRoute != Routes.workDetails) {
          Get.offAllNamed(Routes.workDetails);
        }
        break;
      case 4:
        if (currentRoute != '/documentUpload') {
          Get.offAllNamed('/documentUpload');
        }
        break;
      case 6:
        if (currentRoute != Routes.home) Get.offAllNamed(Routes.home);
        break;
      default:
        Get.offAllNamed(Routes.register);
        break;
    }
  }
}
