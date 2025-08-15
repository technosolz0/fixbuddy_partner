import 'package:dio/dio.dart';
import 'package:get/get.dart';

class AccountController extends GetxController {
  var balance = 2400.0.obs; // Static balance
  var isLoading = false.obs;
  var transactions = <Map<String, dynamic>>[].obs; // Static transactions

  final dio = Dio();
  final baseUrl = "https://192.168.1.11:8000"; // Placeholder for future API
  final userId = 1; // Example

  @override
  void onInit() {
    super.onInit();
    fetchBalance();
  }

  void fetchBalance() {
    isLoading.value = true;
    // Static data for now
    balance.value = 2400.0;
    transactions.assignAll([
      {
        'title': 'Booking Payment',
        'amount': '- ₹500',
        'date': '27 Jun, 2025',
        'type': 'debit',
      },
      {
        'title': 'Referral Bonus',
        'amount': '+ ₹100',
        'date': '26 Jun, 2025',
        'type': 'credit',
      },
      {
        'title': 'Account Top-Up',
        'amount': '+ ₹2000',
        'date': '24 Jun, 2025',
        'type': 'credit',
      },
    ]);
    isLoading.value = false;

    // Future API implementation
    /*
    try {
      final response = await dio.get("$baseUrl/account/$userId");
      if (response.statusCode == 200) {
        balance.value = (response.data['balance'] as num).toDouble();
        transactions.assignAll(response.data['transactions'] ?? []);
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch balance: $e');
    } finally {
      isLoading.value = false;
    }
    */
  }

  Future<String?> withdraw(double amount) async {
    // Static data simulation
    if (amount <= 0) {
      return 'Invalid amount';
    }
    if (amount > balance.value) {
      return 'Insufficient balance';
    }
    balance.value -= amount;
    transactions.insert(0, {
      'title': 'Withdrawal',
      'amount': '- ₹${amount.toStringAsFixed(0)}',
      'date': DateTime.now().toString().substring(0, 10),
      'type': 'debit',
    });
    return 'Success';

    // Future API implementation
    /*
    try {
      final response = await dio.post(
        "$baseUrl/withdraw",
        data: {"user_id": userId, "amount": amount},
      );
      if (response.statusCode == 200) {
        balance.value = (response.data['remaining_balance'] as num).toDouble();
        transactions.insert(0, {
          'title': 'Withdrawal',
          'amount': '- ₹${amount.toStringAsFixed(0)}',
          'date': DateTime.now().toString().substring(0, 10),
          'type': 'debit',
        });
        return response.data['status'];
      } else {
        return response.data['detail'];
      }
    } catch (e) {
      return 'Error: $e';
    }
    */
  }
}
