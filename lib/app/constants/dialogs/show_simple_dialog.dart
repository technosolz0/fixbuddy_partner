import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fixbuddy_partner/app/utils/extensions.dart';
import 'package:fixbuddy_partner/app/utils/theme.dart';
import 'package:fixbuddy_partner/app/widgets/custom_button.dart';

showSimpleDialog(
  BuildContext context,
  String title,
  String btnText,
  VoidCallback onTapOK, {
  bool canPop = true,
  TextStyle? style,
  String? desc,
}) {
  return showDialog(
    context: context,
    barrierDismissible: canPop,
    builder: (context) {
      return PopScope(
        canPop: canPop,
        child: Dialog(
          backgroundColor: context.isLightTheme
              ? AppColors.cardLightColor
              : AppColors.cardColor,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style:
                      style ??
                      GothamRounded.bold(
                        fontSize: 20.sp,
                        color: AppColors.darkModeTextColor,
                      ),
                ),
                if (desc != null)
                  Column(
                    children: [
                      SizedBox(height: 20.h),
                      Text(
                        desc,
                        style: GothamRounded.medium(
                          fontSize: 14.sp,
                          color: AppColors.darkModeTextColor,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                SizedBox(height: 50.h),
                CustomButton(onPressed: onTapOK, text: btnText),
              ],
            ),
          ),
        ),
      );
    },
  );
}
