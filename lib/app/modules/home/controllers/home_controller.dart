import 'package:dio/dio.dart';
import 'package:fixbuddy_partner/app/constants/app_color.dart';
import 'package:fixbuddy_partner/app/data/models/vendor_model.dart';
import 'package:fixbuddy_partner/app/modules/register/models/register_models.dart';
import 'package:fixbuddy_partner/app/modules/register/services/register_services.dart';
import 'package:fixbuddy_partner/app/utils/local_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  var username = ''.obs;
  var location = ''.obs;
  final RxInt selectedIndex = 0.obs;
  var workStatus = 'work_on'.obs;

  final isLoading = false.obs;

  final LocalStorage localStorage = LocalStorage();
  final AuthApiService _apiService = AuthApiService();

  @override
  void onInit() {
    super.onInit();
    _loadVendorDetails();
  }

  void changeTab(int index) {
    selectedIndex.value = index;
  }

  Future<void> _loadVendorDetails() async {
    final VendorModel? vendor = await localStorage.getVendorDetails();
    if (vendor != null) {
      // Full name fallback
      username.value = vendor.name.isNotEmpty == true ? vendor.name : 'Vendor';

      // Location from personalDetails map if city exists
      location.value =
          (vendor.address.isNotEmpty &&
              vendor.city.isNotEmpty &&
              vendor.state.isNotEmpty &&
              vendor.pincode.toString().isNotEmpty)
          ? '${vendor.address}, ${vendor.city}, ${vendor.state}, ${vendor.pincode}'
          : vendor.address.isNotEmpty
          ? vendor.address
          : vendor.state.isNotEmpty
          ? vendor.state
          : vendor.city.isNotEmpty
          ? vendor.city.toString()
          : 'Unknown Location';

      workStatus.value = vendor.workStatus.toString();
    }
  }

  Future<void> updateWorkStatus(String newWorkStatus) async {
    if (!['work_on', 'work_off'].contains(newWorkStatus)) {
      Get.snackbar(
        'Error',
        'Invalid work status',
        backgroundColor: AppColors.errorColor,
        colorText: Colors.white,
      );
      return;
    }

    isLoading.value = true;
    try {
      final VendorModel? vendor = await localStorage.getVendorDetails();
      if (vendor == null) {
        Get.snackbar(
          'Error',
          'Vendor details not found or invalid',
          backgroundColor: AppColors.errorColor,
          colorText: Colors.white,
        );
        return;
      }

      final response = await _apiService.updateWorkStatus(
        vendorId: vendor.id,
        workStatus: newWorkStatus,
      );

      if (response.statusCode == 200) {
        workStatus.value = newWorkStatus;

        Get.snackbar(
          'Success',
          'Work status updated to $newWorkStatus',
          backgroundColor: AppColors.successColor,
          colorText: Colors.white,
        );
      } else {
        Get.snackbar(
          'Error',
          response.data['detail']?.toString() ?? 'Failed to update work status',
          backgroundColor: AppColors.errorColor,
          colorText: Colors.white,
        );
      }
    } on DioException catch (e) {
      Get.snackbar(
        'Error',
        e.response?.data['detail']?.toString() ??
            'Failed to update work status',
        backgroundColor: AppColors.errorColor,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }
}
