import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:fixbuddy_partner/app/utils/extensions.dart';
import 'package:fixbuddy_partner/app/utils/theme.dart';

Future showLogoutConfirmationDialog({required VoidCallback onTapYes}) async {
  await showDialog(
    context: Get.context!,
    builder: (context) {
      return Dialog(
        insetPadding: EdgeInsets.symmetric(horizontal: 20.w),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 22.h),
          decoration: BoxDecoration(
            color: context.isLightTheme
                ? AppColors.cardLightColor
                : AppColors.cardColor,
            borderRadius: BorderRadius.circular(16.r),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                context.l10n.logout_confirmation,
                style: GothamRounded.semiBold(
                  fontSize: 24.sp,
                  color: AppColors.darkModeTextColor,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 56.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // SizedBox(
                  //   width: 140.h,
                  //   child: CustomFilledButton(
                  //     onPressed: () {
                  //       Get.back();
                  //     },
                  //     text: context.l10n.cancel,
                  //     isOutlined: true,
                  //     borderColor: Colors.white,
                  //   ),
                  // ),
                  // SizedBox(
                  //   width: 140.h,
                  //   child: CustomFilledButton(
                  //     onPressed: () {
                  //       Get.back();
                  //       onTapYes();
                  //     },
                  //     text: context.l10n.yes,
                  //   ),
                  // ),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
}
