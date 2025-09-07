import 'package:fixbuddy_partner/app/modules/booking/models/booking_model.dart';
import 'package:fixbuddy_partner/app/modules/booking/models/payment_model.dart';
import 'package:fixbuddy_partner/app/modules/booking/models/vendor_model.dart';
import 'package:fixbuddy_partner/app/modules/booking/services/booking_services.dart';
import 'package:get/get.dart';

class BookingController extends GetxController {
  // Observables for booking, payment, and vendor details
  var bookingDetails = Rxn<BookingResponse>();
  var paymentDetails = Rxn<PaymentResponse>();
  var vendorDetails = Rxn<VendorResponse>();

  var allBookings = <BookingResponse>[].obs;

  // Loading states
  var isLoadingBooking = false.obs;
  var isLoadingPayment = false.obs;
  var isLoadingVendor = false.obs;
  var isLoadingAllBookings = false.obs;

  // Error messages
  var errorMessage = ''.obs;

  final BookingServices _bookingServices = BookingServices();

  @override
  void onInit() {
    super.onInit();
    fetchAllBookings();
  }

  // Fetch all bookings for the current vendor
  Future<void> fetchAllBookings() async {
    try {
      errorMessage.value = '';
      isLoadingAllBookings.value = true;

      final bookings = await _bookingServices.fetchAllBookings();
      allBookings.assignAll(bookings);
      print('Total bookings fetched for vendor: ${allBookings.length}');
    } catch (e) {
      errorMessage.value = e.toString();
      Get.snackbar('Error', e.toString());
    } finally {
      isLoadingAllBookings.value = false;
    }
  }

  // Fetch all details related to a booking by booking_id
  Future<void> fetchAllBookingDetails(int bookingId) async {
    try {
      errorMessage.value = '';

      isLoadingBooking.value = true;
      final booking = await _bookingServices.fetchBookingDetails(bookingId);
      bookingDetails.value = booking;
      print('Fetched booking details: ${bookingDetails.value}');

      isLoadingPayment.value = true;
      final payment = await _bookingServices.fetchPaymentDetails(bookingId);
      paymentDetails.value = payment;
      print('Fetched payment details: ${paymentDetails.value}');

      isLoadingVendor.value = true;
      final vendor = await _bookingServices.fetchVendorDetails(
        booking.serviceproviderId,
      );
      vendorDetails.value = vendor;
      print('Fetched vendor details: ${vendorDetails.value}');
    } catch (e) {
      errorMessage.value = e.toString();
      Get.snackbar('Error', e.toString());
    } finally {
      isLoadingBooking.value = false;
      isLoadingPayment.value = false;
      isLoadingVendor.value = false;
    }
  }

  // Method to update selected tab
  void changeTab(int index, dynamic selectedIndex) {
    selectedIndex.value = index;
  }
}