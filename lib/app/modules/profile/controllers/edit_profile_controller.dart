import 'package:fixbuddy_partner/app/data/models/vendor_model.dart';
import 'package:fixbuddy_partner/app/modules/profile/services/VendorApiService.dart';
import 'package:fixbuddy_partner/app/utils/local_storage.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

class EditProfileController extends GetxController
    with GetSingleTickerProviderStateMixin {
  final LocalStorage _localStorage = LocalStorage();
  final VendorApiService _vendorApiService = VendorApiService();

  final Rx<VendorModel?> vendor = Rx<VendorModel?>(null);
  final RxBool isLoading = false.obs;
  late TabController tabController;

  @override
  void onInit() async {
    super.onInit();
    tabController = TabController(length: 4, vsync: this);
    await loadVendorData();
  }

  Future<void> loadVendorData() async {
    isLoading.value = true;
    try {
      // Try to load from local storage first
      final cachedVendor = await _localStorage.getVendorDetails();
      if (cachedVendor != null) {
        vendor.value = cachedVendor;
      }

      // Fetch updated data from API
      final vendorId = await _localStorage.getVendorID();
      final token = await _localStorage.getToken();
      if (vendorId != null && token != null) {
        vendor.value = await _vendorApiService.fetchVendorData(vendorId, token);
        await _localStorage.setVendorDetails(vendor.value!);
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to load vendor data: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateWorkStatus(String status) async {
    if (vendor.value == null) return;
    isLoading.value = true;
    try {
      final vendorId = await _localStorage.getVendorID();
      final token = await _localStorage.getToken();
      if (vendorId != null && token != null) {
        vendor.value = await _vendorApiService.updateVendorData(
          vendorId,
          vendor.value!.copyWith(workStatus: status),
          token,
        );
        await _localStorage.setVendorDetails(vendor.value!);
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to update work status: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    tabController.dispose();
    super.onClose();
  }
}

// Extension to create a copy of VendorModel with updated fields
extension VendorModelExtension on VendorModel {
  VendorModel copyWith({String? workStatus}) {
    return VendorModel(
      id: id,
      name: name,
      email: email,
      phone: phone,
      address: address,
      city: city,
      state: state,
      pincode: pincode,
      accountHolderName: accountHolderName,
      accountNumber: accountNumber,
      ifscCode: ifscCode,
      upiId: upiId,
      identityDocType: identityDocType,
      identityDocNumber: identityDocNumber,
      identityDocUrl: identityDocUrl,
      bankDocType: bankDocType,
      bankDocNumber: bankDocNumber,
      bankDocUrl: bankDocUrl,
      addressDocType: addressDocType,
      addressDocNumber: addressDocNumber,
      addressDocUrl: addressDocUrl,
      categoryId: categoryId,
      profilePic: profilePic,
      status: status,
      adminStatus: adminStatus,
      workStatus: workStatus ?? this.workStatus,
      subcategoryCharges: subcategoryCharges,
    );
  }
}
