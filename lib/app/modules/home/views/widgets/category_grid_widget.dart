// import 'package:fixbuddy_partner/app/utils/theme.dart';
// import 'package:flutter/material.dart';

// class CategoryGridWidget extends StatelessWidget {
//   final Function(String) onCategoryTap;

//   const CategoryGridWidget({super.key, required this.onCategoryTap});

//   @override
//   Widget build(BuildContext context) {
   

//     return GridView.builder(
//       shrinkWrap: true,
//       physics: BouncingScrollPhysics(),
//       // physics: const NeverScrollableScrollPhysics(),
//       itemCount: categories.length,
//       gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//         crossAxisCount: 2,
//         childAspectRatio: 2.0,
//         crossAxisSpacing: 12,
//         mainAxisSpacing: 12,
//       ),
//       itemBuilder: (context, index) {
//         final category = categories[index];
//         return GestureDetector(
//           onTap: () {
//             onCategoryTap(category['title']!);
//           },
//           child: Container(
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(5),
//             ),
//             padding: const EdgeInsets.all(12),
//             child: Row(
//               children: [
//                 Expanded(
//                   child: Text(
//                     category['title']!,
//                     textAlign: TextAlign.center,
//                     style: const TextStyle(fontSize: 13),
//                   ),
//                 ),
//                 const SizedBox(width: 2),
//                 Image.asset(
//                   category['icon']!,
//                   height: 50,
//                   errorBuilder: (context, error, stackTrace) {
//                     return const Icon(
//                       Icons.error,
//                       size: 50,
//                       color: AppColors.secondaryColor,
//                     );
//                   },
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }
// }
