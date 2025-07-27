
import 'package:dio/dio.dart';
import 'package:fixbuddy_partner/app/constants/api_constants.dart';

class AuthApiService {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: ApiConstants.baseUrl,
      connectTimeout: Duration(seconds: 30),
      receiveTimeout: Duration(seconds: 30),
      validateStatus: (status) => status! < 500,
    ),
  )..interceptors.add(LogInterceptor(responseBody: true, requestBody: true));

  Future<Response> sendRegistrationOtp({
    required String name,
    required String email,
    required String mobile,
    required String password,
  }) async {
    return await _dio.post(
      '/vendors/register-otp',
      data: {
        'full_name': name,
        'email': email,
        'phone': mobile,
        'password': password,
        'category_id': 1, // Default, update based on your category system
        'service_locations': {}, // Default empty JSONB
      },
    );
  }

  Future<Response> verifyRegistrationOtp({
    required String email,
    required String otp,
  }) async {
    return await _dio.post(
      '/vendors/verify-otp',
      data: {'email': email, 'otp': otp},
    );
  }

  Future<Response> resendRegistrationOtp(String email) async {
    return await _dio.post('/vendors/resend-otp', data: {'email': email});
  }

  Future<Response> sendLoginOtp(String email) async {
    return await _dio.post('/vendors/send-login-otp', data: {'email': email});
  }

  Future<Response> verifyLoginOtp({
    required String email,
    required String otp,
  }) async {
    return await _dio.post(
      '/vendors/verify-login-otp',
      data: {'email': email, 'otp': otp},
    );
  }

  Future<Response> resendLoginOtp(String email) async {
    return await _dio.post('/vendors/resend-login-otp', data: {'email': email});
  }

  Future<Response> updateVendor({
    required int vendorId,
    required Map<String, dynamic> data,
  }) async {
    return await _dio.put(
      '/vendors/$vendorId',
      data: {
        'address': data['personal_details']['address'],
        'road': data['personal_details']['road'],
        'landmark': data['personal_details']['landmark'],
        'pin_code': data['personal_details']['pin_code'],
        'bank_name': data['bank_details']['bank_name'],
        'account_name': data['bank_details']['account_name'],
        'account_number': data['bank_details']['account_number'],
        'ifsc_code': data['bank_details']['ifsc_code'],
        'experience_years': data['work_details']['experience_years'],
        'about': data['work_details']['about'],
        'category_id': data['work_details']['category_id'],
        'sub_category_id': data['work_details']['sub_category_id'],
        'service_ids': data['work_details']['service_ids'],
        'service_locations': data['work_details']['service_locations'] ?? {},
      },
    );
  }
}
