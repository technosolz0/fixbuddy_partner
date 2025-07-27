import 'package:fixbuddy_partner/app/constants/app_constants.dart';

class UserCachedModel {
  final int id;
  final String fullName;
  final String email;
  final String profilePhoto;
  final Gender? gender;
  final DateTime? dob;
  final String? companyId;
  final String mobile;

  UserCachedModel({
    required this.id,
    required this.fullName,
    required this.email,
    required this.profilePhoto,
    this.gender,
    this.dob,
    this.companyId,
    required this.mobile,
  });

  static UserCachedModel fromJSON(Map<String, dynamic> json) {
    return UserCachedModel(
      id: json['userId'] ?? '',
      fullName: json['fullName'] ?? '',
      email: json['email'] ?? '',
      profilePhoto: json['profilePhoto'] ?? '',
      gender: Gender.fromValue(int.parse(json['gender'].toString())),
      dob: DateTime.parse(json['dob']),
      companyId: json['companyId'] ?? '',
      mobile: json['companyId'] ?? '',
    );
  }

  Map<String, dynamic> toJSON() {
    return {
      'userId': id,
      'fullName': fullName,
      'email': email,
      'profilePhoto': profilePhoto,
      'gender': gender?.value,
      'dob': dob.toString(),
      'companyId': companyId,
      'mobile': mobile,
    };
  }

  static UserCachedModel initialize() {
    return UserCachedModel(
      id: 0,
      fullName: '',
      email: '',
      profilePhoto: '',
      gender: Gender.others,
      dob: DateTime.now(),
      companyId: '',
      mobile: '',
    );
  }

  UserCachedModel copyWith({
    int? id,
    String? fullName,
    String? email,
    String? profilePhoto,
    Gender? gender,
    DateTime? dob,
    String? companyId,
    String? mobile,
  }) {
    return UserCachedModel(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      profilePhoto: profilePhoto ?? this.profilePhoto,
      gender: gender ?? this.gender,
      dob: dob ?? this.dob,
      companyId: companyId ?? this.companyId,
      mobile: mobile ?? this.mobile,
    );
  }
}
