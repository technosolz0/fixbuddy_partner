import 'package:dio/dio.dart';
import 'package:fixbuddy_partner/app/constants/api_constants.dart';
import 'package:fixbuddy_partner/app/data/models/vendor_model.dart';

class VendorApiService {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: ApiConstants.baseUrl, // Replace with your API base URL
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    ),
  );

  Future<VendorModel> fetchVendorData(String vendorId, String token) async {
    try {
      final response = await _dio.get(
        '/vendors/$vendorId',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      return VendorModel.fromJson(response.data);
    } catch (e) {
      throw DioException(
        requestOptions: RequestOptions(path: '/vendors/$vendorId'),
        error: e,
      );
    }
  }

  Future<VendorModel> updateVendorData(
    String vendorId,
    VendorModel vendor,
    String token,
  ) async {
    try {
      final response = await _dio.put(
        '/vendors/$vendorId',
        data: vendor.toJson(),
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      return VendorModel.fromJson(response.data);
    } catch (e) {
      throw DioException(
        requestOptions: RequestOptions(path: '/vendors/$vendorId'),
        error: e,
      );
    }
  }
}
