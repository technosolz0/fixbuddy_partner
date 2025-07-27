import 'dart:io';
import 'package:dio/dio.dart';

class ServiceProviderRegisterModel {
  final String category;
  final List<String> serviceLocations;
  final String address;
  final String? road;
  final String? landmark;
  final String? pinCode;
  final int? experienceYears;
  final String? about;
  final String bankName;
  final String accountName;
  final String accountNumber;
  final String ifscCode;
  final File profilePic;
  final File addressProof;
  final File bankStatement;

  ServiceProviderRegisterModel({
    required this.category,
    required this.serviceLocations,
    required this.address,
    this.road,
    this.landmark,
    this.pinCode,
    this.experienceYears,
    this.about,
    required this.bankName,
    required this.accountName,
    required this.accountNumber,
    required this.ifscCode,
    required this.profilePic,
    required this.addressProof,
    required this.bankStatement,
  });

  /// Converts this model into multipart FormData for Dio
  Future<FormData> toFormData() async {
    return FormData.fromMap({
      'category': category,
      'service_locations': serviceLocations,
      'address': address,
      'road': road,
      'landmark': landmark,
      'pin_code': pinCode,
      'experience_years': experienceYears,
      'about': about,
      'bank_name': bankName,
      'account_name': accountName,
      'account_number': accountNumber,
      'ifsc_code': ifscCode,
      'profile_pic': await MultipartFile.fromFile(profilePic.path, filename: profilePic.path.split('/').last),
      'address_proof': await MultipartFile.fromFile(addressProof.path, filename: addressProof.path.split('/').last),
      'bank_statement': await MultipartFile.fromFile(bankStatement.path, filename: bankStatement.path.split('/').last),
    });
  }
}
