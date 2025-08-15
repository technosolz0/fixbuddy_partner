import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:fixbuddy_partner/app/constants/app_color.dart';
import 'package:fixbuddy_partner/app/modules/account/controllers/account_controller.dart';
import 'package:fixbuddy_partner/app/widgets/customListTile.dart';
import 'package:fixbuddy_partner/app/widgets/custom_app_bar.dart';

class AccountView extends StatelessWidget {
  final AccountController controller = Get.put(AccountController());
  final TextEditingController amountController = TextEditingController();

  AccountView({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: const CustomAppBar(title: 'My Account', centerTitle: true),
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
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }
              return Padding(
                padding: EdgeInsets.fromLTRB(16.w, 24.h, 16.w, 16.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(20.w),
                      decoration: BoxDecoration(
                        color: AppColors.whiteColor,
                        borderRadius: BorderRadius.circular(5.r),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 6,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Available Balance',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 14.sp,
                            ),
                          ),
                          SizedBox(height: 8.h),
                          Text(
                            '₹${controller.balance.value.toStringAsFixed(2)}',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 28.sp,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          SizedBox(height: 12.h),
                          ElevatedButton(
                            onPressed: () {
                              Get.dialog(
                                AlertDialog(
                                  title: const Text('Withdraw Amount'),
                                  content: TextField(
                                    controller: amountController,
                                    keyboardType: TextInputType.number,
                                    decoration: const InputDecoration(
                                      hintText: 'Enter withdrawal amount',
                                    ),
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Get.back(),
                                      child: const Text('Cancel'),
                                    ),
                                    ElevatedButton(
                                      onPressed: () async {
                                        final amt = double.tryParse(
                                          amountController.text,
                                        );
                                        if (amt != null && amt > 0) {
                                          final status = await controller
                                              .withdraw(amt);
                                          Get.back();
                                          Get.snackbar(
                                            'Withdrawal Status',
                                            status ?? 'Error',
                                          );
                                          amountController.clear();
                                        } else {
                                          Get.snackbar(
                                            'Error',
                                            'Enter a valid amount',
                                          );
                                        }
                                      },
                                      child: const Text('Proceed'),
                                    ),
                                  ],
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primaryColor,
                              foregroundColor: Colors.white,
                            ),
                            child: Text(
                              'Withdraw',
                              style: TextStyle(fontSize: 16.sp),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 24.h),
                    Text(
                      'Recent Transactions',
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 16.h),
                    Expanded(
                      child: ListView.separated(
                        itemCount: controller.transactions.length,
                        separatorBuilder: (context, index) =>
                            SizedBox(height: 12.h),
                        itemBuilder: (context, index) {
                          final tx = controller.transactions[index];
                          final isCredit = tx['type'] == 'credit';
                          return CustomListTile(
                            title: Text(
                              tx['title'],
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            subtitle: Text(
                              tx['date'],
                              style: TextStyle(
                                color: Colors.black54,
                                fontSize: 14.sp,
                              ),
                            ),
                            trailing: Text(
                              tx['amount'],
                              style: TextStyle(
                                color: isCredit ? Colors.green : Colors.red,
                                fontWeight: FontWeight.w600,
                                fontSize: 15.sp,
                              ),
                            ),
                            onTap: () {
                              print('Transaction ${tx['title']} tapped');
                            },
                            backgroundColor: AppColors.whiteColor,
                            borderRadius: 12.r,
                          );
                        },
                      ),
                    ),
                  ],
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
