// import 'package:dio/dio.dart';
// import 'package:fixbuddy_partner/app/constants/api_constants.dart';

// class AuthApiService {
//   final Dio _dio = Dio(
//     BaseOptions(
//       baseUrl: ApiConstants.baseUrl,
//       connectTimeout: const Duration(seconds: 30),
//       receiveTimeout: const Duration(seconds: 30),
//       validateStatus: (status) => status! < 500,
//     ),
//   )..interceptors.add(LogInterceptor(responseBody: true, requestBody: true));

//   Future<Response> sendRegistrationOtp({
//     required String name,
//     required String email,
//     required String phone,
//     required String password,
//     required bool termsAccepted,
//     String? fcmToken,
//     double? latitude,
//     double? longitude,
//     String? deviceName,
//   }) async {
//     return await _dio.post(
//       '/api/vendor/register',
//       data: {
//         'full_name': name,
//         'email': email,
//         'phone': phone,
//         'password': password,
//         'terms_accepted': termsAccepted,
//         'fcm_token': fcmToken,
//         'latitude': latitude,
//         'longitude': longitude,
//         'device_name': deviceName,
//       },
//     );
//   }

//   Future<Response> verifyRegistrationOtp({
//     required String email,
//     required String otp,
//   }) async {
//     return await _dio.post(
//       '/api/vendor/verify-otp',
//       data: {'email': email, 'otp': otp},
//     );
//   }

//   Future<Response> resendRegistrationOtp(String email) async {
//     return await _dio.post('/api/vendor/send-otp', data: {'email': email});
//   }


//   Future<Response> sendLoginOtp(String email) async {
//     return await _dio.post(
//       '/api/vendor/send-login-otp',
//       data: {'email': email},
//     );
//   }

//   Future<Response> verifyLoginOtp({
//     required String email,
//     required String otp,
//   }) async {
//     return await _dio.post(
//       '/api/vendor/verify-login-otp',
//       data: {'email': email, 'otp': otp},
//     );
//   }

//   Future<Response> resendLoginOtp(String email) async {
//     return await _dio.post(
//       '/api/vendor/resend-login-otp',
//       data: {'email': email},
//     );
//   }

//   Future<Response> updateVendor({
//     required int vendorId,
//     required Map<String, dynamic> data,
//   }) async {
//     return await _dio.put(
//       '/api/vendor/profile/complete',
//       data: {
//         'full_name': data['full_name'],
//         'phone': data['phone'],
//         'address': data['personal_details']['address'],
//         'state': data['personal_details']['state'],
//         'city': data['personal_details']['city'],
//         'pincode': data['personal_details']['pincode'],
//         'account_holder_name': data['bank_details']['account_holder_name'],
//         'account_number': data['bank_details']['account_number'],
//         'ifsc_code': data['bank_details']['ifsc_code'],
//         'upi_id': data['bank_details']['upi_id'],
//         'document_type': data['personal_details']['document_type'],
//         'document_number': data['personal_details']['document_number'],
//         'terms_accepted': data['terms_accepted'],
//         'fcm_token': data['fcm_token'],
//         'latitude': data['latitude'],
//         'longitude': data['longitude'],
//         'device_name': data['device_name'],
//         'category_id': data['work_details']['category_id'],
//         'subcategory_charges': data['subcategory_charges'],
//       },
//     );
//   }
// }
