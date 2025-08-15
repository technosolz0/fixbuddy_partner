import 'package:fixbuddy_partner/app/modules/account/bindings/account_binding.dart';
import 'package:fixbuddy_partner/app/modules/account/views/account_view.dart';
import 'package:fixbuddy_partner/app/modules/login/bindings/login_binding.dart';
import 'package:fixbuddy_partner/app/modules/login/views/login_view.dart';
import 'package:fixbuddy_partner/app/modules/register/bindings/registration_binding.dart';
import 'package:fixbuddy_partner/app/modules/register/views/registration_view.dart';
import 'package:fixbuddy_partner/app/modules/register/views/widgets/bank_details_screen.dart';
import 'package:fixbuddy_partner/app/modules/register/views/widgets/otp_verification_screen.dart';
import 'package:fixbuddy_partner/app/modules/register/views/widgets/address_details_screen.dart';
import 'package:fixbuddy_partner/app/modules/register/views/widgets/work_details_screen.dart';
import 'package:fixbuddy_partner/app/modules/splash/bindings/splash_binding.dart';
import 'package:fixbuddy_partner/app/modules/splash/views/splash_view.dart';
import 'package:get/get.dart';
import 'package:fixbuddy_partner/app/modules/Notification/bindings/notification_binding.dart';
import 'package:fixbuddy_partner/app/modules/Notification/views/notification_view.dart';
import 'package:fixbuddy_partner/app/modules/booking/bindings/booking_binding.dart'
    show BookingBinding;
import 'package:fixbuddy_partner/app/modules/profile/bindings/profile_binding.dart'
    show ProfileBinding;
import 'package:fixbuddy_partner/app/modules/settings/bindings/setting_binding.dart';
import 'package:fixbuddy_partner/app/modules/settings/views/setting_view.dart';
import 'package:fixbuddy_partner/app/routes/app_routes.dart';
import 'package:fixbuddy_partner/app/widgets/main_screen.dart';
import 'package:fixbuddy_partner/app/modules/home/views/home_view.dart';
import 'package:fixbuddy_partner/app/modules/home/bindings/home_binding.dart';

import 'package:fixbuddy_partner/app/modules/booking/views/booking_view.dart';

import 'package:fixbuddy_partner/app/modules/profile/views/profile_view.dart';

class AppPages {
  static const initial = Routes.splash;

  static final routes = [
    GetPage(
      name: Routes.splash,
      page: () => SplashView(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: Routes.mainScreen,
      page: () => MainScreen(),
      binding: HomeBinding(),
    ),
    GetPage(name: Routes.home, page: () => HomeView(), binding: HomeBinding()),
    GetPage(
      name: Routes.register,
      page: () => RegistrationView(),
      binding: RegistrationBinding(),
    ),
    GetPage(
      name: Routes.verifyOtp,
      page: () => OtpVerificationScreen(),
      binding: RegistrationBinding(),
    ),
    GetPage(
      name: Routes.addressDetails,
      page: () => AddressDetailsScreen(),
      binding: RegistrationBinding(),
    ),
    GetPage(
      name: Routes.bankDetails,
      page: () => BankDetailsScreen(),
      binding: RegistrationBinding(),
    ),
    GetPage(
      name: Routes.workDetails,
      page: () => WorkDetailsScreen(),
      binding: RegistrationBinding(),
    ),
    GetPage(
      name: Routes.login,
      page: () => const LoginView(),
      binding: LoginBinding(),
    ),

    GetPage(
      name: Routes.booking,
      page: () => const BookingView(),
      binding: BookingBinding(),
    ),
    GetPage(
      name: Routes.wallet,
      page: () => AccountView(),
      binding: AccountBinding(),
    ),
    GetPage(
      name: Routes.profile,
      page: () => const ProfileView(),
      binding: ProfileBinding(),
    ),
    GetPage(
      name: Routes.notification,
      page: () => const NotificationView(),
      binding: NotificationBinding(),
    ),
    GetPage(
      name: Routes.setting,
      page: () => SettingView(),
      binding: SettingBinding(),
    ),

    GetPage(
      name: Routes.editProfile,
      page: () => EditProfileView(),
      binding: EditProfileBinding(),
    ),
    GetPage(
      name: Routes.changePassword,
      page: () => ChangePasswordView(),
      binding: ChangePasswordBinding(),
    ),
    GetPage(
      name: Routes.helpCenter,
      page: () => HelpCenterView(),
      binding: HelpCenterBinding(),
    ),
    GetPage(
      name: Routes.aboutUs,
      page: () => AboutUsView(),
      binding: AboutUsBinding(),
    ),
    GetPage(
      name: Routes.termsAndConditions,
      page: () => TermsAndConditionsView(),
      binding: TermsAndConditionsBinding(),
    ),
    GetPage(
      name: Routes.privacyPolicy,
      page: () => PrivacyPolicyView(),
      binding: PrivacyPolicyBinding(),
    ),
    GetPage(
      name: Routes.contactUs,
      page: () => ContactUsView(),
      binding: ContactUsBinding(),
    ),
  ];
}
