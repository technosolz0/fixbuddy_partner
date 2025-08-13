import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:fixbuddy_partner/app/constants/api_constants.dart';
import 'package:fixbuddy_partner/app/modules/register/models/category.dart';
import 'package:fixbuddy_partner/app/modules/register/models/sub_category.dart';
import 'package:fixbuddy_partner/app/utils/local_storage.dart';
import 'package:fixbuddy_partner/app/utils/servex_utils.dart';

class AuthApiService {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: ApiConstants.baseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      validateStatus: (status) => status! < 500,
    ),
  )..interceptors.add(LogInterceptor(responseBody: true, requestBody: true));

  final localStorage = LocalStorage();

  Future<Options> _getAuthOptions() async {
    final token = await localStorage.getToken();
    return Options(
      headers: token != null ? {'Authorization': 'Bearer $token'} : {},
    );
  }

  Future<List<CategoryModel>> fetchCategories() async {
    final response = await _dio.get('/api/vendor/categories');
    if (response.statusCode == 200) {
      return (response.data as List<dynamic>)
          .map((json) => CategoryModel.fromJson(json as Map<String, dynamic>))
          .toList();
    }
    return [];
  }

  Future<List<SubcategoryModel>> fetchSubcategories(int? categoryId) async {
    final response = await _dio.get(
      '/api/vendor/subcategories',
      queryParameters: categoryId != null ? {'category_id': categoryId} : {},
    );
    if (response.statusCode == 200) {
      return (response.data as List<dynamic>)
          .map(
            (json) => SubcategoryModel.fromJson(json as Map<String, dynamic>),
          )
          .toList();
    }
    return [];
  }

  Future<Response> login({
    required String email,
    required String password,
  }) async {
    return await _dio.post(
      '/api/vendor/login',
      data: {'email': email, 'password': password},
    );
  }

  Future<Response> sendRegistrationOtp({
    required String name,
    required String email,
    required String phone,
    required String password,
    required bool termsAccepted,
    required String identityDocType,
    required String identityDocNumber,
    String? fcmToken,
    double? latitude,
    double? longitude,
    String? deviceName,
    String? profilePic,
  }) async {
    return await _dio.post(
      '/api/vendor/register',
      data: {
        'full_name': name,
        'email': email,
        'phone': phone,
        'password': password,
        'terms_accepted': termsAccepted,
        'identity_doc_type': identityDocType,
        'identity_doc_number': identityDocNumber,
        'fcm_token': fcmToken,
        'latitude': latitude,
        'longitude': longitude,
        'device_name': deviceName,
        'profile_pic': profilePic,
      },
    );
  }

  Future<Response> verifyRegistrationOtp({
    required String email,
    required String otp,
  }) async {
    return await _dio.post(
      '/api/vendor/verify-otp',
      data: {'email': email, 'otp': otp},
    );
  }

  Future<Response> resendRegistrationOtp(String email) async {
    return await _dio.post('/api/vendor/send-otp', data: {'email': email});
  }

  Future<Response> getCurrentVendor(String token) async {
    return await _dio.get(
      '/api/vendor/me',
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
  }

  Future<Response> updateVendorAddress({
    required int vendorId,
    required String address,
    required String state,
    required String city,
    required String pincode,
    required String documentType,
    required String documentNumber,
  }) async {
    final formData = FormData.fromMap({
      'vendor_id': vendorId.toString(),
      'address': address,
      'state': state,
      'city': city,
      'pincode': pincode,
      'address_doc_type': documentType,
      'address_doc_number': documentNumber,
    });
    ServexUtils.logPrint('Sending address data: ${formData.fields}');
    try {
      final response = await _dio.put(
        '/api/vendor/profile/address',
        data: formData,
        options: await _getAuthOptions(),
      );
      ServexUtils.logPrint('Response status: ${response.statusCode}');
      ServexUtils.logPrint('Response data: ${response.data}');
      return response;
    } catch (e) {
      ServexUtils.logPrint('Error in updateVendorAddress: $e');
      rethrow;
    }
  }

  Future<Response> updateVendorBank({
    required int vendorId,
    required String accountHolderName,
    required String accountNumber,
    required String ifscCode,
    required String upiId,
    required String bankDocType,
    required String bankDocNumber,
  }) async {
    final formData = FormData.fromMap({
      'vendor_id': vendorId.toString(),
      'account_holder_name': accountHolderName,
      'account_number': accountNumber,
      'ifsc_code': ifscCode,
      'upi_id': upiId,
      'bank_doc_type': bankDocType,
      'bank_doc_number': bankDocNumber,
    });
    return await _dio.put(
      '/api/vendor/profile/bank',
      data: formData,
      options: await _getAuthOptions(),
    );
  }



  Future<Response> updateVendorWork({
    required int vendorId,
    required int categoryId,
    required List<Map<String, dynamic>> subcategoryCharges,
  }) async {
    final data = {
      'category_id': categoryId,
      'subcategory_charges': subcategoryCharges,
    };
    ServexUtils.logPrint(
      'Sending work details to API: $data for vendor_id=$vendorId',
    );
    try {
      final response = await _dio.put(
        '/api/vendor/profile/work',
        queryParameters: {
          'vendor_id': vendorId,
        }, // Add vendor_id as query parameter
        data: data,
        options: await _getAuthOptions(),
      );
      ServexUtils.logPrint(
        'Work details response: status=${response.statusCode}, data=${response.data}',
      );
      return response;
    } catch (e) {
      ServexUtils.logPrint('Error in updateVendorWork: $e');
      rethrow;
    }
  }

  Future<Response> uploadVendorDocuments({
    required int vendorId,
    required Uint8List? profilePicBytes,
    required Uint8List identityDocBytes,
    required Uint8List bankDocBytes,
    required Uint8List addressDocBytes,
  }) async {
    final formData = FormData.fromMap({
      'vendor_id': vendorId.toString(),
      if (profilePicBytes != null)
        'profile_pic': MultipartFile.fromBytes(
          profilePicBytes,
          filename: 'profile_$vendorId.jpg',
        ),
      'identity_doc': MultipartFile.fromBytes(
        identityDocBytes,
        filename: 'identity_$vendorId.pdf',
      ),
      'bank_doc': MultipartFile.fromBytes(
        bankDocBytes,
        filename: 'bank_$vendorId.pdf',
      ),
      'address_doc': MultipartFile.fromBytes(
        addressDocBytes,
        filename: 'address_$vendorId.pdf',
      ),
    });
    ServexUtils.logPrint(
      'Sending document upload form data: ${formData.fields}',
    );
    try {
      final response = await _dio.post(
        '/api/vendor/profile/documents',
        data: formData,
        options: await _getAuthOptions(),
      );
      ServexUtils.logPrint(
        'Document upload response: status=${response.statusCode}, data=${response.data}',
      );
      return response;
    } catch (e) {
      ServexUtils.logPrint('Error in uploadVendorDocuments: $e');
      rethrow;
    }
  }

  Future<Response> updateWorkStatus({
    required int vendorId,
    required String workStatus,
  }) async {
    final formData = FormData.fromMap({
      'vendor_id': vendorId.toString(),
      'work_status': workStatus,
    });
    return await _dio.put(
      '/api/vendor/profile/work-status',
      data: formData,
      options: await _getAuthOptions(),
    );
  }

  Future<Response> updateAdminStatus({
    required int vendorId,
    required String adminStatus,
  }) async {
    final formData = FormData.fromMap({
      'vendor_id': vendorId.toString(),
      'admin_status': adminStatus,
    });
    return await _dio.put(
      '/api/vendor/admin/status',
      data: formData,
      options: await _getAuthOptions(),
    );
  }

  Future<Response> updateDeviceDetails({
    required int vendorId,
    required Map<String, dynamic> data,
  }) async {
    return await _dio.put(
      '/api/vendor/device/update',
      data: {
        'vendor_id': vendorId,
        'fcm_token': data['fcm_token'],
        'latitude': data['latitude'],
        'longitude': data['longitude'],
        'device_name': data['device_name'],
      },
      options: await _getAuthOptions(),
    );
  }
}
