import 'package:fixbuddy_partner/app/constants/app_constants.dart';

class VendorModel {
  final int id;
  final String name;
  final String email;
  final String phone;
  final String address;
  final String state;
  final String city;
  final String pincode;

  final String accountHolderName;
  final String accountNumber;
  final String ifscCode;
  final String? upiId;

  final String identityDocType;
  final String identityDocNumber;
  final String? identityDocUrl;

  final String bankDocType;
  final String bankDocNumber;
  final String? bankDocUrl;

  final String addressDocType;
  final String addressDocNumber;
  final String? addressDocUrl;

  final int categoryId;
  final String? profilePic;

  final String status;
  final String adminStatus;
  final String workStatus;

  final List<dynamic>? subcategoryCharges;

  VendorModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.address,
    required this.state,
    required this.city,
    required this.pincode,
    required this.accountHolderName,
    required this.accountNumber,
    required this.ifscCode,
    this.upiId,
    required this.identityDocType,
    required this.identityDocNumber,
    this.identityDocUrl,
    required this.bankDocType,
    required this.bankDocNumber,
    this.bankDocUrl,
    required this.addressDocType,
    required this.addressDocNumber,
    this.addressDocUrl,
    required this.categoryId,
    this.profilePic,
    required this.status,
    required this.adminStatus,
    required this.workStatus,
    this.subcategoryCharges,
  });

  // factory VendorModel.fromJson(Map<String, dynamic> json) {
  //   return VendorModel(
  //     id: json['id'] ?? 0,
  //     name: json['name'] ?? '',
  //     email: json['email'] ?? '',
  //     phone: json['phone'] ?? '',
  //     address: json['address'] ?? '',
  //     state: json['state'] ?? '',
  //     city: json['city'] ?? '',
  //     pincode: json['pincode'] ?? '',

  //     accountHolderName: json['bank_account_holder_name'] ?? '',
  //     accountNumber: json['bank_account_number'] ?? '',
  //     ifscCode: json['ifsc_code'] ?? '',
  //     upiId: json['upi_id'],

  //     identityDocType: json['identity_doc_type'] ?? '',
  //     identityDocNumber: json['identity_doc_number'] ?? '',
  //     identityDocUrl: json['identity_doc_url'],

  //     bankDocType: json['bank_doc_type'] ?? '',
  //     bankDocNumber: json['bank_doc_number'] ?? '',
  //     bankDocUrl: json['bank_doc_url'],

  //     addressDocType: json['address_doc_type'] ?? '',
  //     addressDocNumber: json['address_doc_number'] ?? '',
  //     addressDocUrl: json['address_doc_url'],

  //     categoryId: json['category_id'] ?? 0,
  //     profilePic: json['profile_pic'],
  //     status: json['status'] ?? '',
  //     adminStatus: json['admin_status'] ?? '',
  //     workStatus: json['work_status'] ?? '',
  //     subcategoryCharges: json['subcategory_charges'],
  //   );
  // }

  factory VendorModel.fromJson(Map<String, dynamic> json) {
    return VendorModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      address: json['address'] ?? '',
      state: json['state'] ?? '',
      city: json['city'] ?? '',
      pincode: json['pincode'] ?? '',

      accountHolderName: json['bank_account_holder_name'] ?? '',
      accountNumber: json['bank_account_number'] ?? '',
      ifscCode: json['ifsc_code'] ?? '',
      upiId: json['upi_id'],

      // Use address doc as fallback for identity doc if identity doc is missing
      identityDocType:
          json['identity_doc_type'] ?? json['address_doc_type'] ?? '',
      identityDocNumber:
          json['identity_doc_number'] ?? json['address_doc_number'] ?? '',
      identityDocUrl: json['identity_doc_url'] ?? json['address_doc_url'],

      bankDocType: json['bank_doc_type'] ?? '',
      bankDocNumber: json['bank_doc_number'] ?? '',
      bankDocUrl: json['bank_doc_url'],

      addressDocType: json['address_doc_type'] ?? '',
      addressDocNumber: json['address_doc_number'] ?? '',
      addressDocUrl: json['address_doc_url'],

      categoryId: json['category_id'] ?? 0,
      profilePic: json['profile_pic'],
      status: json['status'] ?? '',
      adminStatus: json['admin_status'] ?? '',
      workStatus: json['work_status'] ?? '',
      subcategoryCharges: json['subcategory_charges'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'address': address,
      'state': state,
      'city': city,
      'pincode': pincode,
      'bank_account_holder_name': accountHolderName,
      'bank_account_number': accountNumber,
      'ifsc_code': ifscCode,
      'upi_id': upiId,
      'identity_doc_type': identityDocType,
      'identity_doc_number': identityDocNumber,
      'identity_doc_url': identityDocUrl,
      'bank_doc_type': bankDocType,
      'bank_doc_number': bankDocNumber,
      'bank_doc_url': bankDocUrl,
      'address_doc_type': addressDocType,
      'address_doc_number': addressDocNumber,
      'address_doc_url': addressDocUrl,
      'category_id': categoryId,
      'profile_pic': profilePic,
      'status': status,
      'admin_status': adminStatus,
      'work_status': workStatus,
      'subcategory_charges': subcategoryCharges,
    };
  }

  VendorModel copyWith({
    int? id,
    String? name,
    String? email,
    String? phone,
    String? address,
    String? state,
    String? city,
    String? pincode,
    String? accountHolderName,
    String? accountNumber,
    String? ifscCode,
    String? upiId,
    String? identityDocType,
    String? identityDocNumber,
    String? identityDocUrl,
    String? bankDocType,
    String? bankDocNumber,
    String? bankDocUrl,
    String? addressDocType,
    String? addressDocNumber,
    String? addressDocUrl,
    int? categoryId,
    String? profilePic,
    String? status,
    String? adminStatus,
    String? workStatus,
    List<dynamic>? subcategoryCharges,
  }) {
    return VendorModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      state: state ?? this.state,
      city: city ?? this.city,
      pincode: pincode ?? this.pincode,
      accountHolderName: accountHolderName ?? this.accountHolderName,
      accountNumber: accountNumber ?? this.accountNumber,
      ifscCode: ifscCode ?? this.ifscCode,
      upiId: upiId ?? this.upiId,
      identityDocType: identityDocType ?? this.identityDocType,
      identityDocNumber: identityDocNumber ?? this.identityDocNumber,
      identityDocUrl: identityDocUrl ?? this.identityDocUrl,
      bankDocType: bankDocType ?? this.bankDocType,
      bankDocNumber: bankDocNumber ?? this.bankDocNumber,
      bankDocUrl: bankDocUrl ?? this.bankDocUrl,
      addressDocType: addressDocType ?? this.addressDocType,
      addressDocNumber: addressDocNumber ?? this.addressDocNumber,
      addressDocUrl: addressDocUrl ?? this.addressDocUrl,
      categoryId: categoryId ?? this.categoryId,
      profilePic: profilePic ?? this.profilePic,
      status: status ?? this.status,
      adminStatus: adminStatus ?? this.adminStatus,
      workStatus: workStatus ?? this.workStatus,
      subcategoryCharges: subcategoryCharges ?? this.subcategoryCharges,
    );
  }

  static VendorModel initialize() {
    return VendorModel(
      id: 0,
      name: '',
      email: '',
      phone: '',
      address: '',
      state: '',
      city: '',
      pincode: '',
      accountHolderName: '',
      accountNumber: '',
      ifscCode: '',
      upiId: null,
      identityDocType: '',
      identityDocNumber: '',
      identityDocUrl: null,
      bankDocType: '',
      bankDocNumber: '',
      bankDocUrl: null,
      addressDocType: '',
      addressDocNumber: '',
      addressDocUrl: null,
      categoryId: 0,
      profilePic: null,
      status: '',
      adminStatus: '',
      workStatus: '',
      subcategoryCharges: [],
    );
  }
}
