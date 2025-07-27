import 'package:flutter/material.dart';
import 'package:fixbuddy_partner/app/constants/app_color.dart';

class CategoryGridWidget extends StatelessWidget {
  final Function(String) onCategoryTap;

  const CategoryGridWidget({super.key, required this.onCategoryTap});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> categories = [
      {'title': 'Women Salon & Spa', 'icon': 'assets/icons/women_salon.png'},
      {'title': 'Men Massage & Spa', 'icon': 'assets/icons/men_massage.png'},
      {'title': 'AC & Appliances', 'icon': 'assets/icons/ac.png'},
      {'title': 'Cleaning & Pest Control', 'icon': 'assets/icons/cleaning.png'},
      {'title': 'Electrician & Plumber', 'icon': 'assets/icons/plumber.png'},
      {'title': 'Healthcare', 'icon': 'assets/icons/healthcare.png'},
      {'title': 'Moving', 'icon': 'assets/icons/moving.png'},
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: BouncingScrollPhysics(),
      // physics: const NeverScrollableScrollPhysics(),
      itemCount: categories.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 2.0,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemBuilder: (context, index) {
        final category = categories[index];
        return GestureDetector(
          onTap: () {
            onCategoryTap(category['title']!);
          },
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(5),
            ),
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    category['title']!,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 13),
                  ),
                ),
                const SizedBox(width: 2),
                Image.asset(
                  category['icon']!,
                  height: 50,
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(
                      Icons.error,
                      size: 50,
                      color: AppColors.secondaryColor,
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
