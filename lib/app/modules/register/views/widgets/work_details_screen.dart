// // lib/app/views/screens/register/work_details_screen.dart
// import 'package:fixbuddy_partner/app/constants/app_color.dart';
// import 'package:fixbuddy_partner/app/modules/register/controllers/registration_controller.dart';
// import 'package:fixbuddy_partner/app/modules/register/models/sub_category.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// class WorkDetailsScreen extends StatelessWidget {
//   final RegistrationController controller = Get.find();

//   WorkDetailsScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColors.whiteColor,
//       appBar: AppBar(
//         title: const Text(
//           'Work Details',
//           style: TextStyle(
//             color: AppColors.primaryColor,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         centerTitle: true,
//         backgroundColor: Colors.white,
//         elevation: 0,
//       ),
//       body: SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 24.0),
//           child: Form(
//             key: controller.workFormKey,
//             child: SingleChildScrollView(
//               physics: const BouncingScrollPhysics(),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   const SizedBox(height: 16),
//                   Text(
//                     'Choose Your Expertise',
//                     style: Theme.of(context).textTheme.titleLarge?.copyWith(
//                       fontWeight: FontWeight.bold,
//                       color: AppColors.blackColor,
//                     ),
//                   ),
//                   const SizedBox(height: 8),
//                   const Text(
//                     'Select a category and specify the services you offer with their charges.',
//                     style: TextStyle(color: AppColors.grayColor),
//                   ),
//                   const SizedBox(height: 24),
//                   _buildCategorySelector(),
//                   const SizedBox(height: 32),
//                   _buildSubcategorySection(),
//                   const SizedBox(height: 40),
//                   _buildSubmitButton(),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildCategorySelector() {
//     return Obx(() {
//       if (controller.categories.isEmpty) {
//         // If categories are loading, show a circular progress indicator.
//         // Once loaded, this section will rebuild.
//         return const Center(child: CircularProgressIndicator());
//       }
//       return DropdownButtonFormField<int>(
//         decoration: InputDecoration(
//           labelText: 'Select Main Category',
//           labelStyle: const TextStyle(color: AppColors.primaryColor),
//           border: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(12),
//             borderSide: const BorderSide(color: AppColors.primaryColor),
//           ),
//           focusedBorder: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(12),
//             borderSide: const BorderSide(
//               color: AppColors.primaryColor,
//               width: 2,
//             ),
//           ),
//         ),
//         value: controller.categoryId.value == 0
//             ? null
//             : controller.categoryId.value,
//         items: controller.categories.map((category) {
//           return DropdownMenuItem<int>(
//             value: category.id,
//             child: Row(
//               children: [
//                 if (category.image != null)
//                   Padding(
//                     padding: const EdgeInsets.only(right: 8.0),
//                     child: ClipRRect(
//                       borderRadius: BorderRadius.circular(8),
//                       child: Image.network(
//                         category.image!,
//                         width: 32,
//                         height: 32,
//                         fit: BoxFit.cover,
//                         errorBuilder: (context, error, stackTrace) =>
//                             const Icon(
//                               Icons.category,
//                               color: AppColors.primaryColor,
//                               size: 32,
//                             ),
//                       ),
//                     ),
//                   ),
//                 Text(
//                   category.name,
//                   style: const TextStyle(
//                     fontSize: 16,
//                     fontWeight: FontWeight.w500,
//                   ),
//                 ),
//               ],
//             ),
//           );
//         }).toList(),
//         onChanged: (value) {
//           controller.categoryId.value = value ?? 0;
//           if (value != null) {
//             controller.fetchSubcategories(value);
//           } else {
//             // Clear subcategories if no category is selected
//             controller.subcategories.clear();
//           }
//         },
//         validator: (value) => value == null ? 'Category is required' : null,
//       );
//     });
//   }

//   Widget _buildSubcategorySection() {
//     return Obx(() {
//       if (controller.categoryId.value == 0) {
//         return const Center(
//           child: Text(
//             'Select a category to see available services.',
//             style: TextStyle(
//               color: AppColors.grayColor,
//               fontStyle: FontStyle.italic,
//             ),
//           ),
//         );
//       }
//       if (controller.isSubcategoriesLoading.value) {
//         // Show a dedicated loader for subcategories
//         return const Center(child: CircularProgressIndicator());
//       }
//       if (controller.subcategories.isEmpty) {
//         // Show a message if no subcategories are found
//         return const Center(
//           child: Text(
//             'No subcategories found for this category.',
//             style: TextStyle(
//               color: AppColors.grayColor,
//               fontStyle: FontStyle.italic,
//             ),
//           ),
//         );
//       }
//       return Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           const Text(
//             'Set Your Charges',
//             style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//           ),
//           const SizedBox(height: 16),
//           // Use the subcategory list to build the UI
//           ...controller.subcategories.map((subcategory) {
//             return _buildSubcategoryChargeItem(subcategory);
//           }).toList(),
//         ],
//       );
//     });
//   }

//   Widget _buildSubcategoryChargeItem(SubcategoryModel subcategory) {
//     // We now retrieve the state from the map using the subcategory ID
//     final chargeState = controller.subcategoryChargesMap[subcategory.id];

//     // If the state for this subcategory isn't in the map, something is wrong.
//     // It shouldn't happen with the new controller logic, but we handle it gracefully.
//     if (chargeState == null) {
//       return const SizedBox.shrink();
//     }

//     return Padding(
//       padding: const EdgeInsets.only(bottom: 16.0),
//       child: Obx(
//         () => Container(
//           decoration: BoxDecoration(
//             color: AppColors.lightgrayColor,
//             borderRadius: BorderRadius.circular(12),
//             border: Border.all(
//               color: chargeState.isSelected.value
//                   ? AppColors.primaryColor
//                   : AppColors.grayColor.withOpacity(0.3),
//               width: 1.5,
//             ),
//           ),
//           child: Row(
//             children: [
//               Expanded(
//                 child: CheckboxListTile(
//                   contentPadding: const EdgeInsets.symmetric(horizontal: 8),
//                   dense: true,
//                   title: Row(
//                     children: [
//                       if (subcategory.image != null)
//                         ClipRRect(
//                           borderRadius: BorderRadius.circular(8),
//                           child: Image.network(
//                             subcategory.image!,
//                             width: 28,
//                             height: 28,
//                             fit: BoxFit.cover,
//                             errorBuilder: (context, error, stackTrace) =>
//                                 const Icon(
//                                   Icons.miscellaneous_services,
//                                   color: AppColors.primaryColor,
//                                 ),
//                           ),
//                         ),
//                       const SizedBox(width: 12),
//                       Expanded(
//                         child: Text(
//                           subcategory.name,
//                           style: const TextStyle(
//                             fontSize: 15,
//                             fontWeight: FontWeight.w500,
//                           ),
//                           overflow: TextOverflow.ellipsis,
//                         ),
//                       ),
//                     ],
//                   ),
//                   value: chargeState.isSelected.value,
//                   onChanged: (value) {
//                     controller.onSubcategorySelected(
//                       subcategory.id,
//                       value ?? false,
//                     );
//                   },
//                 ),
//               ),
//               SizedBox(
//                 width: 100,
//                 child: Padding(
//                   padding: const EdgeInsets.only(right: 16.0),
//                   child: TextFormField(
//                     controller: chargeState.textController,
//                     enabled: chargeState.isSelected.value,
//                     decoration: InputDecoration(
//                       labelText: 'Charge',
//                       prefixText: '\$',
//                       border: InputBorder.none,
//                       filled: false,
//                       isDense: true,
//                       contentPadding: const EdgeInsets.only(
//                         top: 10,
//                         bottom: 10,
//                       ),
//                       // Change the label color based on whether it's enabled
//                       labelStyle: TextStyle(
//                         color: chargeState.isSelected.value
//                             ? AppColors.primaryColor
//                             : AppColors.grayColor,
//                       ),
//                     ),
//                     keyboardType: TextInputType.number,
//                     onChanged: (value) {
//                       controller.onChargeChanged(subcategory.id, value);
//                     },
//                     validator: (value) {
//                       if (chargeState.isSelected.value &&
//                           (value == null ||
//                               value.isEmpty ||
//                               double.tryParse(value) == null ||
//                               double.parse(value) <= 0)) {
//                         return 'Required';
//                       }
//                       return null;
//                     },
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildSubmitButton() {
//     return Obx(
//       () => SizedBox(
//         width: double.infinity,
//         child: ElevatedButton(
//           onPressed: controller.isLoading.value
//               ? null
//               : controller.submitWorkDetails,
//           style: ElevatedButton.styleFrom(
//             backgroundColor: AppColors.primaryColor,
//             foregroundColor: AppColors.whiteColor,
//             padding: const EdgeInsets.symmetric(vertical: 16),
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(14),
//             ),
//             elevation: 4,
//           ),
//           child: controller.isLoading.value
//               ? const CircularProgressIndicator(color: Colors.white)
//               : const Text(
//                   'Save & Continue',
//                   style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                 ),
//         ),
//       ),
//     );
//   }
// }

// lib/app/views/screens/register/work_details_screen.dart

import 'package:fixbuddy_partner/app/constants/app_color.dart';
import 'package:fixbuddy_partner/app/modules/register/controllers/registration_controller.dart';
import 'package:fixbuddy_partner/app/modules/register/models/sub_category.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WorkDetailsScreen extends StatelessWidget {
  final RegistrationController controller = Get.find();

  WorkDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: AppBar(
        title: const Text(
          'Work Details',
          style: TextStyle(
            color: AppColors.primaryColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Form(
            key: controller.workFormKey,
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  Text(
                    'Choose Your Expertise',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.blackColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Select a category and specify the services you offer with their charges.',
                    style: TextStyle(color: AppColors.grayColor),
                  ),
                  const SizedBox(height: 24),
                  _buildCategorySelector(),
                  const SizedBox(height: 32),
                  _buildSubcategorySection(),
                  const SizedBox(height: 40),
                  _buildSubmitButton(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCategorySelector() {
    return Obx(() {
      if (controller.categories.isEmpty) {
        // If categories are loading, show a circular progress indicator.
        // Once loaded, this section will rebuild.
        return const Center(child: CircularProgressIndicator());
      }
      return DropdownButtonFormField<int>(
        decoration: InputDecoration(
          labelText: 'Select Main Category',
          labelStyle: const TextStyle(color: AppColors.primaryColor),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.primaryColor),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(
              color: AppColors.primaryColor,
              width: 2,
            ),
          ),
        ),
        value: controller.categoryId.value == 0
            ? null
            : controller.categoryId.value,
        items: controller.categories.map((category) {
          return DropdownMenuItem<int>(
            value: category.id,
            child: Row(
              children: [
                if (category.image != null)
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        category.image!,
                        width: 32,
                        height: 32,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            const Icon(
                              Icons.category,
                              color: AppColors.primaryColor,
                              size: 32,
                            ),
                      ),
                    ),
                  ),
                Text(
                  category.name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
        onChanged: (value) {
          controller.categoryId.value = value ?? 0;
          if (value != null) {
            controller.fetchSubcategories(value);
          } else {
            // Clear subcategories if no category is selected
            controller.subcategories.clear();
          }
        },
        validator: (value) => value == null ? 'Category is required' : null,
      );
    });
  }

  Widget _buildSubcategorySection() {
    return Obx(() {
      if (controller.categoryId.value == 0) {
        return const Center(
          child: Text(
            'Select a category to see available services.',
            style: TextStyle(
              color: AppColors.grayColor,
              fontStyle: FontStyle.italic,
            ),
          ),
        );
      }
      if (controller.isSubcategoriesLoading.value) {
        // Show a dedicated loader for subcategories
        return const Center(child: CircularProgressIndicator());
      }
      if (controller.subcategories.isEmpty) {
        // Show a message if no subcategories are found
        return const Center(
          child: Text(
            'No subcategories found for this category.',
            style: TextStyle(
              color: AppColors.grayColor,
              fontStyle: FontStyle.italic,
            ),
          ),
        );
      }
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Set Your Charges',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          // Use the subcategory list to build the UI
          ...controller.subcategories.map((subcategory) {
            return _buildSubcategoryChargeItem(subcategory);
          }).toList(),
        ],
      );
    });
  }

  Widget _buildSubcategoryChargeItem(SubcategoryModel subcategory) {
    // We now retrieve the state from the map using the subcategory ID
    final chargeState = controller.subcategoryChargesMap[subcategory.id];

    // If the state for this subcategory isn't in the map, something is wrong.
    // It shouldn't happen with the new controller logic, but we handle it gracefully.
    if (chargeState == null) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Obx(
        () => Container(
          decoration: BoxDecoration(
            color: AppColors.lightgrayColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: chargeState.isSelected.value
                  ? AppColors.primaryColor
                  : AppColors.grayColor.withOpacity(0.3),
              width: 1.5,
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: CheckboxListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                  dense: true,
                  title: Row(
                    children: [
                      if (subcategory.image != null)
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            subcategory.image!,
                            width: 28,
                            height: 28,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                const Icon(
                                  Icons.miscellaneous_services,
                                  color: AppColors.primaryColor,
                                ),
                          ),
                        ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          subcategory.name,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  value: chargeState.isSelected.value,
                  onChanged: (value) {
                    controller.onSubcategorySelected(
                      subcategory.id,
                      value ?? false,
                    );
                  },
                ),
              ),
              SizedBox(
                width: 100,
                child: Padding(
                  padding: const EdgeInsets.only(right: 16.0),
                  child: TextFormField(
                    controller: chargeState.textController,
                    enabled: chargeState.isSelected.value,
                    decoration: InputDecoration(
                      labelText: 'Charge',
                      prefixText: '\$',
                      border: InputBorder.none,
                      filled: false,
                      isDense: true,
                      contentPadding: const EdgeInsets.only(
                        top: 10,
                        bottom: 10,
                      ),
                      // Change the label color based on whether it's enabled
                      labelStyle: TextStyle(
                        color: chargeState.isSelected.value
                            ? AppColors.primaryColor
                            : AppColors.grayColor,
                      ),
                    ),
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      controller.onChargeChanged(subcategory.id, value);
                    },
                    validator: (value) {
                      if (chargeState.isSelected.value &&
                          (value == null ||
                              value.isEmpty ||
                              double.tryParse(value) == null ||
                              double.parse(value) <= 0)) {
                        return 'Required';
                      }
                      return null;
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSubmitButton() {
    return Obx(
      () => SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: controller.isLoading.value
              ? null
              : controller.submitWorkDetails,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryColor,
            foregroundColor: AppColors.whiteColor,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
            elevation: 4,
          ),
          child: controller.isLoading.value
              ? const CircularProgressIndicator(color: Colors.white)
              : const Text(
                  'Save & Continue',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
        ),
      ),
    );
  }
}
