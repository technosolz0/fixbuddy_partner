import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:fixbuddy_partner/app/modules/VendorRegister/models/service_provider_register_model.dart';
import 'package:fixbuddy_partner/app/modules/VendorRegister/models/service_location_model.dart';
import 'package:fixbuddy_partner/app/modules/VendorRegister/services/provider_api_service.dart';
import 'package:fixbuddy_partner/app/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class ProviderRegisterController extends GetxController {
  // Category for registration
  final category = ''.obs;
  final states = ['Maharashtra', 'Delhi', 'Karnataka'];
  final cities = {
    'Maharashtra': ['Mumbai', 'Pune'],
    'Delhi': ['Central Delhi', 'South Delhi'],
    'Karnataka': ['Bengaluru', 'Mysuru'],
  };

  final categories = ['Electrician', 'Plumber', 'Carpenter'];
  // Subcategories mapping
  final subCategories = {
    'Electrician': ['Wiring', 'Switch Repair', 'AC Installation'],
    'Plumber': ['Leak Repair', 'Fitting', 'Water Tank Cleaning'],
    'Carpenter': ['Furniture Making', 'Door Fitting', 'Repair Work'],
  };

  // Address
  final addressController = TextEditingController();
  final roadController = TextEditingController();
  final landmarkController = TextEditingController();
  final pinCodeController = TextEditingController();

  // About & Bank
  final aboutController = TextEditingController();
  final bankNameController = TextEditingController();
  final accountNameController = TextEditingController();
  final accountNumberController = TextEditingController();
  final confirmAccountNumberController = TextEditingController();
  final ifscController = TextEditingController();

  // Document Uploads
  final Rxn<File> profilePic = Rxn<File>();
  final Rxn<File> addressProof = Rxn<File>();
  final Rxn<File> bankStatement = Rxn<File>();

  final isLoading = false.obs;

  final ProviderApiService _apiService = ProviderApiService();

  /// Service Location Form Fields
  final selectedCategory = ''.obs;
  final selectedSubCategory = ''.obs;
  final selectedState = ''.obs;
  final selectedCity = ''.obs;
  final experienceController = TextEditingController();
  final priceController = TextEditingController();

  // List of Service Locations
  final serviceLocations = <ServiceLocationModel>[].obs;

  /// Available subcategories for selected category
  List<String> get availableSubCategories =>
      subCategories[selectedCategory.value] ?? [];

  /// Pick Profile Image
  Future<void> pickProfilePic() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.camera);
    if (picked != null) profilePic.value = File(picked.path);
  }

  /// Pick Address Proof
  Future<void> pickAddressProof() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.any);
    if (result != null) addressProof.value = File(result.files.single.path!);
  }

  /// Pick Bank Statement
  Future<void> pickBankStatement() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.any);
    if (result != null) bankStatement.value = File(result.files.single.path!);
  }

  /// Add Service Location Entry
  void addServiceLocation() {
    if (selectedCategory.value.isEmpty ||
        selectedSubCategory.value.isEmpty ||
        selectedState.value.isEmpty ||
        selectedCity.value.isEmpty ||
        priceController.text.isEmpty ||
        experienceController.text.isEmpty) {
      Get.snackbar('Error', 'Please fill all service location fields.');
      return;
    }
    serviceLocations.add(
      ServiceLocationModel(
        category: selectedCategory.value,
        subCategory: selectedSubCategory.value,
        state: selectedState.value,
        city: selectedCity.value,
        charge: priceController.text,
        experience: experienceController.text,
      ),
    );

    clearServiceLocationForm();
    Get.snackbar('Success', 'Service location added!');
  }

  /// Clear Service Location Form
  void clearServiceLocationForm() {
    selectedCategory.value = '';
    selectedSubCategory.value = '';
    selectedState.value = '';
    selectedCity.value = '';
    priceController.clear();
    experienceController.clear();
  }

  /// Final Provider Registration
  Future<void> registerProvider() async {
    if (category.value.isEmpty ||
        serviceLocations.isEmpty ||
        addressController.text.isEmpty ||
        bankNameController.text.isEmpty ||
        accountNumberController.text.isEmpty ||
        confirmAccountNumberController.text.isEmpty ||
        ifscController.text.isEmpty ||
        profilePic.value == null ||
        addressProof.value == null ||
        bankStatement.value == null) {
      Get.snackbar('Error', 'Please fill all required fields.');
      return;
    }

    if (accountNumberController.text != confirmAccountNumberController.text) {
      Get.snackbar('Error', 'Account numbers do not match.');
      return;
    }

    isLoading.value = true;

    try {
      final model = ServiceProviderRegisterModel(
        category: category.value,
        serviceLocations: serviceLocations
            .map((e) => jsonEncode(e.toJson()))
            .toList(),
        address: addressController.text,
        road: roadController.text,
        landmark: landmarkController.text,
        pinCode: pinCodeController.text,
        about: aboutController.text,
        bankName: bankNameController.text,
        accountName: accountNameController.text,
        accountNumber: accountNumberController.text,
        ifscCode: ifscController.text,
        profilePic: profilePic.value!,
        addressProof: addressProof.value!,
        bankStatement: bankStatement.value!,
      );

      await _apiService.registerServiceProvider(model);

      Get.snackbar('Success', 'Registered successfully!');
      Get.offAllNamed(Routes.mainScreen);
    } catch (e) {
      Get.snackbar('Error', 'Failed to register provider.');
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    addressController.dispose();
    roadController.dispose();
    landmarkController.dispose();
    pinCodeController.dispose();
    aboutController.dispose();
    bankNameController.dispose();
    accountNameController.dispose();
    accountNumberController.dispose();
    confirmAccountNumberController.dispose();
    ifscController.dispose();
    experienceController.dispose();
    priceController.dispose();
    super.onClose();
  }
}
