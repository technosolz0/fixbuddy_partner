import 'package:fixbuddy_partner/app/modules/VendorRegister/controllers/provider_register_controller.dart';
import 'package:get/get.dart';

class ProviderRegisterBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProviderRegisterController>(() => ProviderRegisterController());
  }
}
