import 'package:cached_network_image/cached_network_image.dart';
import 'package:fixbuddy_partner/app/constants/app_color.dart';
import 'package:fixbuddy_partner/app/modules/profile/controllers/profile_controller.dart';
import 'package:fixbuddy_partner/app/routes/app_routes.dart';
import 'package:fixbuddy_partner/app/widgets/customListTile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  final ProfileController controller = Get.put(ProfileController());

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        floatingActionButton: AnimatedScale(
          scale: 1.0,
          duration: const Duration(milliseconds: 300),
          child: FloatingActionButton(
            onPressed: () {
              Get.toNamed(Routes.editProfile);
            },
            backgroundColor: Colors.transparent,
            elevation: 0,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColors.primaryColor, AppColors.secondaryColor],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 10.r,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: const Icon(Icons.edit, color: Colors.white, size: 28),
            ),
          ),
        ),
        body: Obx(() {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }
          final vendor = controller.vendor.value;
          if (vendor == null) {
            return const Center(child: Text('No vendor data available'));
          }
          return Column(
            children: [
              SizedBox(
                height: size.height * 0.35,
                child: Stack(
                  children: [
                    ClipPath(
                      clipper: WaveClipper(),
                      child: Container(
                        height: size.height * 0.3,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              AppColors.primaryColor.withOpacity(0.9),
                              AppColors.secondaryColor.withOpacity(0.85),
                              AppColors.whiteColor.withOpacity(0.3),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 50.h,
                      left: 0,
                      right: 0,
                      child: Column(
                        children: [
                          Stack(
                            alignment: Alignment.bottomRight,
                            children: [
                              AnimatedContainer(
                                duration: const Duration(milliseconds: 500),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: AppColors.whiteColor,
                                    width: 4.w,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.3),
                                      blurRadius: 12.r,
                                      offset: const Offset(0, 6),
                                    ),
                                  ],
                                ),
                                child: vendor.profilePic == null
                                    ? Container(
                                        decoration: BoxDecoration(
                                          color: Colors.grey[200],
                                          shape: BoxShape.circle,
                                        ),
                                        height: 110.h,
                                        width: 110.w,
                                        alignment: Alignment.center,
                                        child: Text(
                                          vendor.name.isNotEmpty
                                              ? vendor.name[0].toUpperCase()
                                              : 'U',
                                          style: TextStyle(
                                            color: AppColors.primaryColor,
                                            fontSize: 48.sp,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      )
                                    : CachedNetworkImage(
                                        imageUrl: vendor.profilePic!,
                                        imageBuilder:
                                            (context, imageProvider) =>
                                                CircleAvatar(
                                                  backgroundColor: Colors.grey,
                                                  backgroundImage:
                                                      imageProvider,
                                                  radius: 55.r,
                                                ),
                                        placeholder: (context, url) => Container(
                                          height: 110.h,
                                          width: 110.w,
                                          decoration: BoxDecoration(
                                            color: Colors.grey[200],
                                            shape: BoxShape.circle,
                                          ),
                                          child:
                                              const CircularProgressIndicator(),
                                        ),
                                        errorWidget: (context, url, error) =>
                                            Container(
                                              height: 110.h,
                                              width: 110.w,
                                              decoration: BoxDecoration(
                                                color: Colors.grey[200],
                                                shape: BoxShape.circle,
                                              ),
                                              child: Icon(
                                                Icons.error,
                                                color: AppColors.primaryColor,
                                                size: 48.sp,
                                              ),
                                            ),
                                      ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  controller.updateWorkStatus(
                                    vendor.workStatus == 'work_on'
                                        ? 'work_off'
                                        : 'work_on',
                                  );
                                },
                                child: Container(
                                  padding: EdgeInsets.all(6.w),
                                  decoration: BoxDecoration(
                                    color: vendor.workStatus == 'work_on'
                                        ? Colors.green
                                        : Colors.red,
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: AppColors.whiteColor,
                                      width: 2.w,
                                    ),
                                  ),
                                  child: Icon(
                                    vendor.workStatus == 'work_on'
                                        ? Icons.check
                                        : Icons.close,
                                    color: Colors.white,
                                    size: 16.sp,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 8.h),
                          Text(
                            vendor.name,
                            style: TextStyle(
                              fontSize: 24.sp,
                              fontWeight: FontWeight.bold,
                              color: AppColors.blackColor,
                              shadows: [
                                Shadow(
                                  color: Colors.white.withOpacity(0.8),
                                  blurRadius: 4,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      top: 10.h,
                      right: 10.w,
                      child: IconButton(
                        icon: const Icon(
                          Icons.settings,
                          color: AppColors.blackColor,
                          size: 28,
                        ),
                        onPressed: () async {
                          try {
                            await Get.toNamed(Routes.setting);
                          } catch (e) {
                            Get.snackbar(
                              'Error',
                              'Failed to navigate to settings',
                            );
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                color: AppColors.whiteColor,
                child: TabBar(
                  controller: controller.tabController,
                  labelColor: AppColors.primaryColor,
                  unselectedLabelColor: Colors.grey,
                  indicatorColor: AppColors.primaryColor,
                  labelStyle: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                  ),
                  tabs: const [
                    Tab(text: 'Personal'),
                    Tab(text: 'Bank'),
                    Tab(text: 'Documents'),
                    Tab(text: 'Professional'),
                  ],
                ),
              ),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: controller.loadVendorData,
                  child: TabBarView(
                    controller: controller.tabController,
                    children: [
                      _buildTabContent([
                        _buildInfoTile(
                          icon: Icons.email,
                          title: 'Email',
                          value: vendor.email,
                        ),
                        _buildInfoTile(
                          icon: Icons.phone,
                          title: 'Phone',
                          value: vendor.phone,
                        ),
                        _buildInfoTile(
                          icon: Icons.location_on,
                          title: 'Address',
                          value:
                              '${vendor.address}, ${vendor.city}, ${vendor.state} ${vendor.pincode}',
                        ),
                      ]),
                      _buildTabContent([
                        _buildInfoTile(
                          icon: Icons.account_balance,
                          title: 'Account Holder',
                          value: vendor.accountHolderName,
                        ),
                        _buildInfoTile(
                          icon: Icons.credit_card,
                          title: 'Account Number',
                          value: vendor.accountNumber,
                        ),
                        _buildInfoTile(
                          icon: Icons.code,
                          title: 'IFSC Code',
                          value: vendor.ifscCode,
                        ),
                        if (vendor.upiId != null)
                          _buildInfoTile(
                            icon: Icons.payment,
                            title: 'UPI ID',
                            value: vendor.upiId!,
                          ),
                      ]),
                      _buildTabContent([
                        _buildInfoTile(
                          icon: Icons.badge,
                          title: '${vendor.identityDocType} Number',
                          value: vendor.identityDocNumber,
                        ),
                        _buildInfoTile(
                          icon: Icons.account_balance_wallet,
                          title: '${vendor.bankDocType} Number',
                          value: vendor.bankDocNumber,
                        ),
                        _buildInfoTile(
                          icon: Icons.home,
                          title: '${vendor.addressDocType} Number',
                          value: vendor.addressDocNumber,
                        ),
                      ]),
                      _buildTabContent([
                        _buildInfoTile(
                          icon: Icons.category,
                          title: 'Category ID',
                          value: vendor.categoryId.toString(),
                        ),
                        _buildInfoTile(
                          icon: Icons.check_circle,
                          title: 'Status',
                          value: vendor.status,
                        ),
                        _buildInfoTile(
                          icon: Icons.admin_panel_settings,
                          title: 'Admin Status',
                          value: vendor.adminStatus,
                        ),
                        _buildInfoTile(
                          icon: Icons.work,
                          title: 'Work Status',
                          value: vendor.workStatus == 'work_on'
                              ? 'Online'
                              : 'Offline',
                        ),
                        if (vendor.subcategoryCharges != null)
                          ...vendor.subcategoryCharges!.map(
                            (charge) => _buildInfoTile(
                              icon: Icons.monetization_on,
                              title: charge['subcategory'],
                              value: 'Rs ${charge['charge']}',
                            ),
                          ),
                      ]),
                    ],
                  ),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildTabContent(List<Widget> children) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
        child: Column(children: children),
      ),
    );
  }

  Widget _buildInfoTile({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      margin: EdgeInsets.symmetric(vertical: 8.h),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            blurRadius: 6.r,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: CustomListTile(
        leading: icon,
        title: Text(
          title,
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.blackColor,
          ),
        ),
        subtitle: Text(
          value.isEmpty ? 'Not provided' : value,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w400,
            color: (value == 'Online' || value == 'active')
                ? Colors.green
                : (value == 'Offline' || value == 'inactive')
                ? Colors.red
                : Colors.grey,
          ),
        ),
        trailing: Icon(
          Icons.arrow_forward_ios,
          size: 16.sp,
          color: AppColors.primaryColor,
        ),
        onTap: () {
          print('$title tapped: $value');
        },
        backgroundColor: Colors.transparent,
        borderRadius: 12.r,
      ),
    );
  }
}

class WaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height - 40.h);
    path.quadraticBezierTo(
      size.width / 4,
      size.height,
      size.width / 2,
      size.height - 20.h,
    );
    path.quadraticBezierTo(
      3 * size.width / 4,
      size.height - 40.h,
      size.width,
      size.height - 20.h,
    );
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
