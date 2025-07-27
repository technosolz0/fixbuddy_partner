import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  var username = 'aamir'.obs;
  var location = 'Jivdani road Virar East-Virar-Maharashtra'.obs;
  final RxInt selectedIndex = 0.obs;

  @override
  void onInit() {
    super.onInit();
  }

  void changeTab(int index) {
    selectedIndex.value = index;
  }

  // Map of sub-categories by main category title
  final Map<String, List<Map<String, String>>> subCategories = {
    'Cleaning & Pest Control': [
      {'title': 'Bathroom Cleaning', 'icon': 'assets/icons/bathroom.png'},
      {'title': 'Kitchen Cleaning', 'icon': 'assets/icons/kitchen.png'},
      {'title': 'Full Home Cleaning', 'icon': 'assets/icons/home.png'},
      {'title': 'Sofa & Carpet Cleaning', 'icon': 'assets/icons/sofa.png'},
      {'title': 'Cockroach Control', 'icon': 'assets/icons/pest1.png'},
      {'title': 'Termite Control', 'icon': 'assets/icons/pest2.png'},
      {'title': 'Bed Bug Control', 'icon': 'assets/icons/pest3.png'},
    ],
  };

  // Function to open sub-category bottom sheet
  void openSubCategories(String categoryTitle) {
    final selectedSubCategories = subCategories[categoryTitle];

    if (selectedSubCategories == null) {
      Get.snackbar(
        'Coming Soon',
        'Sub categories for $categoryTitle not added yet.',
      );
      return;
    }

    Get.bottomSheet(
      Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    categoryTitle,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () => Get.back(),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
            const SizedBox(height: 16),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: selectedSubCategories.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 2.0,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemBuilder: (context, index) {
                final sub = selectedSubCategories[index];
                return Container(
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 238, 238, 238),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Column(
                    children: [
                      Image.asset(
                        sub['icon']!,
                        height: 36,
                        errorBuilder: (context, error, stackTrace) =>
                            const Icon(
                              Icons.error,
                              color: Colors.red,
                              size: 50,
                            ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        sub['title']!,
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 11),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
      isScrollControlled: true,
    );
  }
}
