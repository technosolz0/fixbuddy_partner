// ignore_for_file: avoid_print

import 'package:get/get.dart';
import 'package:fixbuddy_partner/app/modules/login/controllers/login_controller.dart';

class SettingController extends GetxController {
  final LoginController loginController = Get.put(LoginController());
  final RxString appVersion = '1.0.0'.obs;

  @override
  void onInit() {
    super.onInit();
    print('SettingController initialized');
  }

  @override
  void onReady() {
    super.onReady();
    print('SettingController view rendered');
  }

  @override
  void onClose() {
    print('SettingController closed');
    super.onClose();
  }

  void goToChangePass() {
    print('Navigate to Change Password');
    // Implement navigation to change password screen
  }

  void goToHelpCenter() {
    print('Navigate to Help Center');
    // Implement navigation to help center
  }

  void logOut() {
    loginController.logout();
    print('Logout executed');
    // Navigate to login screen or home after logout
  }
}
