import 'package:dio/dio.dart';
import 'package:fixbuddy_partner/app/constants/api_constants.dart';
import 'package:fixbuddy_partner/app/data/models/vendor_model.dart';
import 'package:fixbuddy_partner/app/modules/register/models/category.dart';
import 'package:fixbuddy_partner/app/modules/register/models/sub_category.dart';
import 'package:fixbuddy_partner/app/utils/local_storage.dart';

class WorkDetailsServices {
  final Dio _dio = Dio(BaseOptions(baseUrl: ApiConstants.baseUrl));
  final LocalStorage _localStorage = LocalStorage();

  // Add authentication token to headers
  Future<void> _addAuthHeader() async {
    String? token = await _localStorage.getToken();
    if (token != null) {
      _dio.options.headers['Authorization'] = 'Bearer $token';
    }
  }

  // Fetch categories
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

  // Update vendor work details
  Future<VendorModel> updateVendorWork({
    required int vendorId,
    required int categoryId,
    required List<Map<String, dynamic>> subcategoryCharges,
  }) async {
    try {
      await _addAuthHeader();
      final response = await _dio.put(
        '/api/vendor/$vendorId/work',
        data: {
          'category_id': categoryId,
          'subcategory_charges': subcategoryCharges,
        },
      );
      return VendorModel.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  // Handle Dio errors
  Exception _handleDioError(DioException e) {
    if (e.response != null) {
      switch (e.response!.statusCode) {
        case 403:
          return Exception(
            'Unauthorized access: ${e.response!.data['detail']}',
          );
        case 404:
          return Exception('Not found: ${e.response!.data['detail']}');
        case 400:
          return Exception('Bad request: ${e.response!.data['detail']}');
        default:
          return Exception('Error: ${e.response!.data['detail'] ?? e.message}');
      }
    }
    return Exception('Network error: ${e.message}');
  }
}
