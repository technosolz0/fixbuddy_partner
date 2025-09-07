import 'package:fixbuddy_partner/app/modules/profile/services/work_details_services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fixbuddy_partner/app/modules/register/models/category.dart';
import 'package:fixbuddy_partner/app/modules/register/models/sub_category.dart';
import 'package:fixbuddy_partner/app/utils/theme.dart';
import 'package:fixbuddy_partner/app/utils/local_storage.dart';
import 'package:dio/dio.dart';

class SubCategoryChargeState {
  final int subcategoryId;
  final RxBool isSelected = false.obs;
  final TextEditingController textController = TextEditingController();

  SubCategoryChargeState({required this.subcategoryId});
}

class WorkDetailsController extends GetxController {
  final WorkDetailsServices _apiService = WorkDetailsServices();
  final LocalStorage _localStorage = LocalStorage();

  final RxInt categoryId = 0.obs;
  final RxList<CategoryModel> categories = <CategoryModel>[].obs;
  final RxList<SubcategoryModel> subcategories = <SubcategoryModel>[].obs;
  final RxMap<int, SubCategoryChargeState> subcategoryChargesMap =
      <int, SubCategoryChargeState>{}.obs;
  final RxBool isLoading = false.obs;
  final RxBool isSubcategoriesLoading = false.obs;
  final GlobalKey<FormState> workFormKey = GlobalKey<FormState>();

  @override
  void onInit() async {
    super.onInit();
    await fetchCategories();
    await initializeWorkDetails();
  }

  @override
  void onClose() {
    for (var state in subcategoryChargesMap.values) {
      state.textController.dispose();
    }
    super.onClose();
  }

  // Convert subcategory charges map to list for API submission
  List<Map<String, dynamic>> get subcategoryCharges => subcategoryChargesMap
      .values
      .where((state) => state.isSelected.value)
      .map(
        (state) => {
          'subcategory_id': state.subcategoryId,
          'service_charge': double.tryParse(state.textController.text) ?? 0.0,
        },
      )
      .toList();

  Future<void> initializeWorkDetails() async {
    isLoading.value = true;
    try {
      final vendor = await _localStorage.getVendorDetails();
      if (vendor != null) {
        categoryId.value = vendor.categoryId ?? 0;
        if (categoryId.value != 0) {
          await fetchSubcategories(categoryId.value);
          if (vendor.subcategoryCharges != null) {
            for (var charge in vendor.subcategoryCharges!) {
              final state =
                  subcategoryChargesMap[int.parse(
                    charge['subcategory_id'].toString(),
                  )] ??
                  SubCategoryChargeState(
                    subcategoryId: int.parse(
                      charge['subcategory_id'].toString(),
                    ),
                  );
              state.isSelected.value = true;
              state.textController.text = charge['charge'].toString();
              subcategoryChargesMap[int.parse(
                    charge['subcategory_id'].toString(),
                  )] =
                  state;
            }
          }
        }
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to load work details: $e',
        backgroundColor: AppColors.errorColor,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
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

  void onSubcategorySelected(int subcategoryId, bool isSelected) {
    final state = subcategoryChargesMap[subcategoryId];
    if (state != null) {
      state.isSelected.value = isSelected;
      if (!isSelected) {
        state.textController.clear();
      }
    }
  }

  void onChargeChanged(int subcategoryId, String value) {
    final state = subcategoryChargesMap[subcategoryId];
    if (state != null) {
      final chargeValue = double.tryParse(value) ?? 0.0;
      state.isSelected.value = chargeValue > 0;
    }
  }

  Future<void> updateWorkDetails() async {
    if (!workFormKey.currentState!.validate()) {
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
      final vendorId = await _localStorage.getVendorID();
      if (vendorId == null) {
        Get.snackbar(
          'Error',
          'Vendor ID not found',
          backgroundColor: AppColors.errorColor,
          colorText: Colors.white,
        );
        return;
      }

      final vendor = await _apiService.updateVendorWork(
        vendorId: int.parse(vendorId),
        categoryId: categoryId.value,
        subcategoryCharges: subcategoryCharges,
      );

      await _localStorage.setVendorDetails(vendor);
      Get.back();
      Get.snackbar(
        'Success',
        'Work details updated successfully',
        backgroundColor: AppColors.successColor,
        colorText: Colors.white,
      );
    } on DioException catch (e) {
      String errorMessage = 'Failed to update work details';
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
    } catch (e) {
      Get.snackbar(
        'Error',
        'Unexpected error: $e',
        backgroundColor: AppColors.errorColor,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }
}
