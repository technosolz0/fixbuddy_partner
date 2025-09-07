import 'package:fixbuddy_partner/app/modules/profile/controllers/work_details_controller.dart.dart';
import 'package:get/get.dart';

import '../controllers/profile_controller.dart';

class ProfileBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProfileController>(() => ProfileController());
    Get.lazyPut<WorkDetailsController>(() => WorkDetailsController());
  }
}
