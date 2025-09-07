// ignore_for_file: avoid_print

import 'package:fixbuddy_partner/app/utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:fixbuddy_partner/app/widgets/customListTile.dart';
import 'package:fixbuddy_partner/app/widgets/custom_app_bar.dart';
import 'package:fixbuddy_partner/app/modules/settings/controllers/setting_controller.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingView extends StatefulWidget {
  const SettingView({super.key});

  @override
  State<SettingView> createState() => _SettingViewState();
}

class _SettingViewState extends State<SettingView> {
  late final SettingController controller;

  @override
  void initState() {
    super.initState();
    // Use Get.find if SettingController is already instantiated, otherwise use Get.put
    controller = Get.isRegistered<SettingController>()
        ? Get.find<SettingController>()
        : Get.put(SettingController());
  }

  @override
  void dispose() {
    // Only delete if we created the instance
    if (!Get.isRegistered<SettingController>()) {
      Get.delete<SettingController>();
    }
    super.dispose();
  }

  void _showLogoutConfirmationDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to log out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              controller.logOut();
              Navigator.pop(context);
            },
            child: const Text('Yes'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = TextStyle(
      color: Colors.black,
      fontSize: 16.sp,
      fontWeight: FontWeight.w500,
    );

    return Scaffold(
      appBar: CustomAppBar(title: 'Settings'),
      body: ListView(
        children: [
          SettingCard(
            title: 'Account',
            children: [
              CustomListTile(
                leading: Icons.lock_outline,
                title: Text('Change Password', style: textStyle),
                trailing: const Icon(Icons.arrow_forward_ios, size: 15),
                onTap: () => controller.goToChangePass(),
              ),
              // CustomListTile(
              //   leading: Icons.person,
              //   title: Text('Become a Vendor', style: textStyle),
              //   trailing: const Icon(Icons.arrow_forward_ios, size: 15),
              //   onTap: () {
              //     Get.toNamed(Routes.providerRegister);
              //     print('Become a Vendor tapped');
              //   },
              // ),
            ],
          ),
          SettingCard(
            title: 'Support',
            children: [
              CustomListTile(
                leading: Icons.help_outline,
                title: Text('Help Center', style: textStyle),
                trailing: const Icon(Icons.arrow_forward_ios, size: 15),
                onTap: () => controller.goToHelpCenter(),
              ),
              CustomListTile(
                leading: Icons.email_outlined,
                title: Text('Contact Us', style: textStyle),
                trailing: Text(
                  'support@fixbuddy.com',
                  style: TextStyle(fontSize: 14.sp, color: Colors.grey),
                ),
                onTap: () => launchUrl(
                  Uri.parse('mailto:support@fixbuddy.com'),
                  mode: LaunchMode.externalApplication,
                ),
              ),
              CustomListTile(
                leading: Icons.feedback_outlined,
                title: Text('Feedback', style: textStyle),
                trailing: const Icon(Icons.arrow_forward_ios, size: 15),
                onTap: () {
                  print('Feedback tapped');
                  // Implement feedback bottom sheet
                },
              ),
              CustomListTile(
                leading: Icons.star_outline,
                title: Text('Rate Us', style: textStyle),
                trailing: const Icon(Icons.arrow_forward_ios, size: 15),
                onTap: () {
                  print('Rate Us tapped');
                  // Implement rate us dialog
                },
              ),
            ],
          ),
          SettingCard(
            title: 'About',
            children: [
              CustomListTile(
                leading: Icons.group_outlined,
                title: Text('Community Guidelines', style: textStyle),
                trailing: const Icon(Icons.arrow_forward_ios, size: 15),
                onTap: () {
                  print('Community Guidelines tapped');
                  // Navigate to community guidelines screen
                },
              ),
              CustomListTile(
                leading: Icons.description_outlined,
                title: Text('Terms & Conditions', style: textStyle),
                trailing: const Icon(Icons.arrow_forward_ios, size: 15),
                onTap: () => launchUrl(
                  Uri.parse('https://fixbuddy.com/terms'),
                  mode: LaunchMode.externalApplication,
                ),
              ),
              CustomListTile(
                leading: Icons.privacy_tip_outlined,
                title: Text('Privacy Policy', style: textStyle),
                trailing: const Icon(Icons.arrow_forward_ios, size: 15),
                onTap: () => launchUrl(
                  Uri.parse('https://fixbuddy.com/privacy'),
                  mode: LaunchMode.externalApplication,
                ),
              ),
              CustomListTile(
                leading: Icons.delete_outline,
                title: Text('Request Account Deletion', style: textStyle),
                trailing: const Icon(Icons.arrow_forward_ios, size: 15),
                onTap: () {
                  print('Request Account Deletion tapped');
                  // Implement account deletion dialog
                },
              ),
              Obx(
                () => CustomListTile(
                  leading: Icons.info_outline,
                  title: Text('Version', style: textStyle),
                  trailing: Text(
                    'v${controller.appVersion.value}',
                    style: TextStyle(fontSize: 14.sp, color: Colors.grey),
                  ),
                  onTap: () {},
                ),
              ),
            ],
          ),
          Container(
            margin: EdgeInsets.only(top: 50.h),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.shade200,
                  blurRadius: 6.r,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
            child: CustomListTile(
              leading: Icons.logout,
              title: Text(
                'Logout',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              trailing: const Icon(Icons.arrow_forward, color: Colors.black),
              onTap: _showLogoutConfirmationDialog,
            ),
          ),
        ],
      ),
    );
  }
}

class SettingCard extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const SettingCard({super.key, required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(bottom: 14.h, top: 22.h, left: 20.w),
          child: Text(
            title,
            style: TextStyle(
              color: AppColors.primaryColor,
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        ...List.generate(
          children.length,
          (index) => Container(
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.shade200,
                  blurRadius: 6.r,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
            child: children[index],
          ),
        ),
      ],
    );
  }
}
