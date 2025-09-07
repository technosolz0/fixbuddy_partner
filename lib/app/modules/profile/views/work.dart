import 'package:fixbuddy_partner/app/modules/profile/controllers/work_details_controller.dart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:fixbuddy_partner/app/utils/theme.dart';

class WorkDetailsScreen extends StatelessWidget {
  final WorkDetailsController controller = Get.put(WorkDetailsController());

  WorkDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Work Details'),
        centerTitle: true,
        backgroundColor: AppColors.primaryColor,
        foregroundColor: AppColors.whiteColor,
      ),
      body: Obx(() {
        if (controller.isLoading.value ||
            controller.isSubcategoriesLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return SingleChildScrollView(
          padding: EdgeInsets.all(16.w),
          child: Form(
            key: controller.workFormKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Select Category',
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textColor,
                  ),
                ),
                SizedBox(height: 12.h),
                DropdownButtonFormField<int>(
                  value: controller.categoryId.value == 0
                      ? null
                      : controller.categoryId.value,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    filled: true,
                    fillColor: AppColors.lightGrayColor,
                  ),
                  hint: const Text('Select a category'),
                  items: controller.categories.map((category) {
                    return DropdownMenuItem<int>(
                      value: category.id,
                      child: Text(category.name),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      controller.categoryId.value = value;
                      controller.fetchSubcategories(value);
                    }
                  },
                  validator: (value) => value == null || value == 0
                      ? 'Please select a category'
                      : null,
                ),
                SizedBox(height: 20.h),
                Text(
                  'Select Subcategories and Charges',
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textColor,
                  ),
                ),
                SizedBox(height: 12.h),
                if (controller.subcategories.isNotEmpty)
                  ...controller.subcategories.map((subcategory) {
                    final state =
                        controller.subcategoryChargesMap[subcategory.id];
                    return Obx(
                      () => Card(
                        elevation: 2,
                        margin: EdgeInsets.symmetric(vertical: 8.h),
                        child: Padding(
                          padding: EdgeInsets.all(12.w),
                          child: Column(
                            children: [
                              CheckboxListTile(
                                title: Text(
                                  subcategory.name,
                                  style: TextStyle(fontSize: 16.sp),
                                ),
                                value: state?.isSelected.value ?? false,
                                onChanged: (value) {
                                  if (value != null) {
                                    controller.onSubcategorySelected(
                                      subcategory.id,
                                      value,
                                    );
                                  }
                                },
                                activeColor: AppColors.primaryColor,
                              ),
                              if (state != null && state.isSelected.value)
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 16.w,
                                    vertical: 8.h,
                                  ),
                                  child: TextFormField(
                                    controller: state.textController,
                                    decoration: InputDecoration(
                                      labelText: 'Service Charge (₹)',
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(
                                          12.r,
                                        ),
                                      ),
                                      prefixIcon: const Icon(
                                        Icons.currency_rupee,
                                      ),
                                    ),
                                    keyboardType: TextInputType.number,
                                    onChanged: (value) => controller
                                        .onChargeChanged(subcategory.id, value),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter a service charge';
                                      }
                                      final charge = double.tryParse(value);
                                      if (charge == null || charge <= 0) {
                                        return 'Please enter a valid charge';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }).toList()
                else
                  const Text('No subcategories available'),
                SizedBox(height: 20.h),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      controller.updateWorkDetails();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryColor,
                      padding: EdgeInsets.symmetric(
                        horizontal: 24.w,
                        vertical: 12.h,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                    ),
                    child: Text(
                      'Save Work Details',
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: AppColors.whiteColor,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
