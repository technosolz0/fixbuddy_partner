import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:fixbuddy_partner/app/utils/extensions.dart';

/// ==============================
/// 🎨 App Colors & Gradients
/// ==============================
class AppColors {
  AppColors._(); // Prevent instantiation

  static const Color primaryColor = Color.fromARGB(255, 250, 201, 78);
  static const Color secondaryColor = Color.fromARGB(255, 250, 204, 89);
  static const Color tritoryColor = Color(0xFFFFD97C);
  static const Color whiteColor = Color(0xFFFFFFFF);
  static const Color grayColor = Color(0xFFD9D9D9);
  static const Color lightgrayColor = Color.fromARGB(255, 234, 234, 234);
  static const Color textColor = Color(0xFF333333);
  static const Color blackColor = Color(0xFF030303);
  static const Color successColor = Color(0xFF4CAF50);
  static const Color errorColor = Color(0xFFF44336);

  // Primary Colors
  static const Color primaryColorLight = Color(0xff3553B4);

  // Secondary Colors
  static const Color secondaryLightColor = Color(0xffB5C1C6);

  // Card Colors
  static const Color cardColor = Color(0xff3B525A);
  static const Color cardLightColor = Color(0xff455895);

  // Status Colors\
  static const Color dimErrorRed = Color.fromARGB(255, 16, 5, 5);
  static const Color successGreen = Color(0xff80B650);
  static const Color infoYellow = Color(0xffF7A12F);
  static const Color likeColor = Color(0xffEF3A43);

  static const Color lightGrayColor = Color(0xFFEAEAEA);

  // Background
  static const Color backgroundDark = Color(0xff060809);
  static const Color backgroundLight = Color(0xffFBFBFF);

  // Text
  static const Color lightModeTextColor = Color(0xff29393F);
  static const Color darkModeTextColor = Colors.white;

  // ==============================
  // 🌈 Gradients
  // ==============================
  static LinearGradient primaryGradient = LinearGradient(
    colors: [primaryColor, secondaryColor, tritoryColor],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static LinearGradient warmGradient = const LinearGradient(
    colors: [
      Color.fromARGB(255, 250, 201, 78),
      Color.fromARGB(255, 250, 204, 89),
      Color(0xFFFFD97C),
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  static LinearGradient successGradient = LinearGradient(
    colors: [
      successGreen.withValues(alpha: 0.9),
      successGreen.withValues(alpha: 0.6),
    ],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static LinearGradient errorGradient = LinearGradient(
    colors: [
      errorColor.withValues(alpha: 0.9),
      dimErrorRed.withValues(alpha: 0.8),
    ],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
}

/// ==============================
/// 🎨 Theme Setup
/// ==============================
class AppTheme {
  static BoxShadow lightBoxShadow = BoxShadow(
    offset: const Offset(0, 0),
    blurRadius: 16,
    color: AppColors.primaryColorLight.withValues(alpha: 0.1),
  );

  static const String gothamRounded = 'Gotham';

  /// Dark Theme
  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    fontFamily: gothamRounded,
    iconTheme: const IconThemeData(color: AppColors.primaryColor),
    scaffoldBackgroundColor: AppColors.backgroundDark,
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.backgroundDark,
      surfaceTintColor: AppColors.backgroundDark,
      elevation: 0,
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(elevation: 0),
    colorScheme: const ColorScheme.dark(
      primary: AppColors.primaryColor,
      secondary: AppColors.secondaryColor,
      onSurface: AppColors.secondaryLightColor,
      onPrimary: AppColors.backgroundDark,
    ),
    inputDecorationTheme: InputDecorationTheme(
      labelStyle: const TextStyle(color: AppColors.secondaryLightColor),
      iconColor: AppColors.secondaryLightColor,
      suffixIconColor: AppColors.secondaryLightColor,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.r),
        borderSide: const BorderSide(
          color: AppColors.secondaryLightColor,
          width: 1,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.r),
        borderSide: const BorderSide(
          color: AppColors.secondaryLightColor,
          width: 1,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.r),
        borderSide: const BorderSide(
          color: AppColors.secondaryLightColor,
          width: 1,
        ),
      ),
    ),
  );

  /// Light Theme
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    fontFamily: gothamRounded,
    iconTheme: const IconThemeData(color: AppColors.primaryColorLight),
    scaffoldBackgroundColor: AppColors.backgroundLight,
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.backgroundLight,
      surfaceTintColor: AppColors.backgroundLight,
      elevation: 0,
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(elevation: 0),
    colorScheme: const ColorScheme.light(
      primary: AppColors.primaryColorLight,
      secondary: AppColors.secondaryColor,
      onSurface: AppColors.secondaryLightColor,
      onPrimary: AppColors.backgroundLight,
    ),
    inputDecorationTheme: InputDecorationTheme(
      labelStyle: const TextStyle(color: AppColors.secondaryLightColor),
      iconColor: AppColors.secondaryLightColor,
      suffixIconColor: AppColors.secondaryLightColor,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.r),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.r),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.r),
        borderSide: BorderSide.none,
      ),
    ),
  );
}

/// ==============================
/// 🅰 Gotham Rounded Text Styles
/// ==============================
class GothamRounded {
  static BuildContext context = Get.context!;

  static TextStyle _base({
    required FontWeight weight,
    double? fontSize,
    Color? color,
    TextDecoration? decoration,
  }) {
    return TextStyle(
      fontFamily: AppTheme.gothamRounded,
      fontWeight: weight,
      color:
          color ??
          (context.isLightTheme
              ? AppColors.lightModeTextColor
              : AppColors.darkModeTextColor),
      fontSize: fontSize,
      decoration: decoration,
      letterSpacing: 0.6,
    );
  }

  static TextStyle thin({
    double? fontSize,
    Color? color,
    TextDecoration? decoration,
  }) => _base(
    weight: FontWeight.w100,
    fontSize: fontSize,
    color: color,
    decoration: decoration,
  );

  static TextStyle extraLight({
    double? fontSize,
    Color? color,
    TextDecoration? decoration,
  }) => _base(
    weight: FontWeight.w200,
    fontSize: fontSize,
    color: color,
    decoration: decoration,
  );

  static TextStyle book({
    double? fontSize,
    Color? color,
    TextDecoration? decoration,
  }) => _base(
    weight: FontWeight.w300,
    fontSize: fontSize,
    color: color,
    decoration: decoration,
  );

  static TextStyle regular({
    double? fontSize,
    Color? color,
    TextDecoration? decoration,
  }) => _base(
    weight: FontWeight.w400,
    fontSize: fontSize,
    color: color,
    decoration: decoration,
  );

  static TextStyle medium({
    double? fontSize,
    Color? color,
    TextDecoration? decoration,
  }) => _base(
    weight: FontWeight.w500,
    fontSize: fontSize,
    color: color,
    decoration: decoration,
  );

  static TextStyle semiBold({
    double? fontSize,
    Color? color,
    TextDecoration? decoration,
  }) => _base(
    weight: FontWeight.w600,
    fontSize: fontSize,
    color: color,
    decoration: decoration,
  );

  static TextStyle bold({
    double? fontSize,
    Color? color,
    TextDecoration? decoration,
  }) => _base(
    weight: FontWeight.w700,
    fontSize: fontSize,
    color: color,
    decoration: decoration,
  );

  static TextStyle extraBold({
    double? fontSize,
    Color? color,
    TextDecoration? decoration,
  }) => _base(
    weight: FontWeight.w800,
    fontSize: fontSize,
    color: color,
    decoration: decoration,
  );

  static TextStyle blackThick({
    double? fontSize,
    Color? color,
    TextDecoration? decoration,
  }) => _base(
    weight: FontWeight.w900,
    fontSize: fontSize,
    color: color,
    decoration: decoration,
  );
}
