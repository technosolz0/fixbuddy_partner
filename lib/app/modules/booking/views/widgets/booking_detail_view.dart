import 'package:fixbuddy_partner/app/modules/booking/controllers/booking_controller.dart';
import 'package:fixbuddy_partner/app/utils/theme.dart';
import 'package:fixbuddy_partner/app/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BookingDetailView extends StatelessWidget {
  final int bookingId;

  const BookingDetailView({Key? key, required this.bookingId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final BookingController controller = Get.put(BookingController());
    controller.fetchAllBookingDetails(bookingId);

    return Scaffold(
      backgroundColor: AppColors.lightGrayColor,
      appBar: const CustomAppBar(title: 'Booking Details', centerTitle: true),
      body: Obx(() {
        if (controller.isLoadingBooking.value ||
            controller.isLoadingPayment.value ||
            controller.isLoadingVendor.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.errorMessage.isNotEmpty) {
          return Center(
            child: Text(
              controller.errorMessage.value,
              style: const TextStyle(color: AppColors.errorColor),
            ),
          );
        }

        final booking = controller.bookingDetails.value;
        final payment = controller.paymentDetails.value;
        final vendor = controller.vendorDetails.value;

        if (booking == null) {
          return const Center(child: Text('No booking details available'));
        }

        return SingleChildScrollView(
          child: Column(
            children: [
              _buildHeaderSection(booking.status),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    _buildDetailsCard(
                      'Booking Information',
                      Icons.receipt_long,
                      [
                        _buildInfoRow(
                          'Booking ID',
                          '#${booking.id}',
                          Icons.tag,
                        ),
                        _buildInfoRow(
                          'Category',
                          booking.category.name,
                          Icons.category,
                        ),
                        _buildInfoRow(
                          'Subcategory',
                          booking.subcategory.name,
                          Icons.subdirectory_arrow_right,
                        ),
                        _buildInfoRow(
                          'Scheduled Time',
                          booking.scheduledTime?.toLocal().toString().split('.')[0] ?? 'Not Scheduled',
                          Icons.schedule,
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    if (payment != null)
                      _buildDetailsCard('Payment Details', Icons.credit_card, [
                        _buildInfoRow(
                          'Amount',
                          '₹${payment.amount}',
                          Icons.currency_rupee,
                        ),
                        _buildInfoRow(
                          'Payment Status',
                          payment.status,
                          Icons.check_circle_outline,
                        ),
                      ]),
                    if (payment == null)
                      const Text('No payment details available'),
                    const SizedBox(height: 20),
                    if (vendor != null)
                      _buildDetailsCard('Vendor Details', Icons.person, [
                        _buildInfoRow('Name', vendor.name, Icons.person),
                        _buildInfoRow('Email', vendor.email, Icons.email),
                        _buildInfoRow('Phone', vendor.phone, Icons.phone),
                        _buildInfoRow(
                          'Address',
                          '${vendor.address}, ${vendor.city}',
                          Icons.location_on,
                        ),
                      ]),
                    if (vendor == null)
                      const Text('No vendor details available'),
                  ],
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  // Header section with status
  Widget _buildHeaderSection(String status) {
    Color statusColor = AppColors.grayColor;
    if (status == 'Completed') {
      statusColor = AppColors.successGreen;
    } else if (status == 'Scheduled') {
      statusColor = AppColors.infoYellow;
    } else if (status == 'Cancelled') {
      statusColor = AppColors.errorColor;
    }

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      padding: const EdgeInsets.symmetric(vertical: 40.0, horizontal: 20.0),
      child: Column(
        children: [
          const Text(
            'Booking Details',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: AppColors.blackColor,
            ),
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.whiteColor,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Text(
              status.toUpperCase(),
              style: TextStyle(
                color: statusColor,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Details card widget
  Widget _buildDetailsCard(String title, IconData icon, List<Widget> children) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: AppColors.primaryColor),
                const SizedBox(width: 10),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            const DashedLine(),
            const SizedBox(height: 10),
            ...children,
          ],
        ),
      ),
    );
  }

  // Info row widget
  Widget _buildInfoRow(String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: AppColors.primaryColor),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.textColor.withOpacity(0.7),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Custom DashedLine Widget
class DashedLine extends StatelessWidget {
  const DashedLine({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final boxWidth = constraints.constrainWidth();
        const dashWidth = 8.0;
        const dashSpace = 4.0;
        final dashCount = (boxWidth / (dashWidth + dashSpace)).floor();
        return Flex(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          direction: Axis.horizontal,
          children: List.generate(dashCount, (_) {
            return const SizedBox(
              width: dashWidth,
              height: 1.5,
              child: DecoratedBox(
                decoration: BoxDecoration(color: AppColors.grayColor),
              ),
            );
          }),
        );
      },
    );
  }
}