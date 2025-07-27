import 'package:dio/dio.dart';
import 'package:fixbuddy_partner/app/constants/api_constants.dart';
import 'package:fixbuddy_partner/app/modules/VendorRegister/models/service_provider_register_model.dart';

class ProviderApiService {
  final Dio _dio = Dio(BaseOptions(baseUrl: ApiConstants.baseUrl));

  /// Register service provider with multipart form data
  Future<Response> registerServiceProvider(
    ServiceProviderRegisterModel data,
  ) async {
    final formData = await data.toFormData();
    final response = await _dio.post('/vendor/register', data: formData);

    if (response.statusCode != 200) {
      throw Exception('Registration failed: ${response.statusCode}');
    }

    return response;
  }

  /// Fetch service categories
  Future<Response> getServiceCategories() async {
    final response = await _dio.get('/vendor/categories');
    if (response.statusCode != 200) {
      throw Exception('Failed to load categories: ${response.statusCode}');
    }
    return response;
  }
}
