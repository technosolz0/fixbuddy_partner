// ignore_for_file: avoid_print

import 'package:fixbuddy_partner/app/modules/login/controllers/login_controller.dart';
import 'package:fixbuddy_partner/app/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:fixbuddy_partner/app/constants/app_color.dart';
import 'package:fixbuddy_partner/app/widgets/customListTile.dart';
import 'package:fixbuddy_partner/app/widgets/custom_app_bar.dart';
import 'package:get/get.dart';

class SettingView extends StatelessWidget {
  SettingView({super.key});
  final LoginController loginController = LoginController();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: CustomAppBar(title: 'Setting'),
      body: Stack(
        children: [
          Container(
            height: size.height * 0.25,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.secondaryColor,
                  AppColors.tritoryColor,
                  AppColors.whiteColor,
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                children: [
                  // Custom List Tiles
                  CustomListTile(
                    leading: Icons.language,
                    title: Text('Languages'),
                    onTap: () {
                      print('Languages tapped');
                    },
                  ),

                  CustomListTile(
                    leading: Icons.location_on_outlined,
                    title: Text('Location'),
                    onTap: () {
                      // open location screen
                      print('Location tapped');
                    },
                  ),
                  CustomListTile(
                    leading: Icons.person,
                    title: Text("Become a Vendor"),
                    onTap: () {
                      Get.toNamed(Routes.providerRegister);
                      // Optionally, navigate to the login screen or show a confirmation dialog
                      print('vendor tapped');
                    },
                  ),
                  CustomListTile(
                    leading: Icons.logout,
                    title: Text("Logout"),
                    onTap: () {
                      loginController.logout();
                      // Optionally, navigate to the login screen or show a confirmation dialog
                      print('Logout tapped');
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
