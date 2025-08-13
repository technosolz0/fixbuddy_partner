class SubCategoryCharge {
  int subcategoryId;
  double serviceCharge;

  SubCategoryCharge({required this.subcategoryId, required this.serviceCharge});

  Map<String, dynamic> toJson() => {
    'subcategory_id': subcategoryId,
    'service_charge': serviceCharge,
  };

  factory SubCategoryCharge.fromJson(Map<String, dynamic> json) =>
      SubCategoryCharge(
        subcategoryId: json['subcategory_id'] as int,
        serviceCharge: (json['service_charge'] as num).toDouble(),
      );
}

class RegistrationModal {
  int? vendorId;
  String? email;
  String? otp;
  String? fullName;
  String? phone;
  String? password;
  Map<String, dynamic> personalDetails = {};
  Map<String, dynamic> bankDetails = {};
  Map<String, dynamic> workDetails = {};
  bool termsAccepted = false;
  String? fcmToken;
  double? latitude;
  double? longitude;
  String? deviceName;
  List<SubCategoryCharge> subcategoryCharges = [];
  int registrationStep = 0;
  bool isVerified = false;

  // New fields added
  String? identityDocType;
  String? identityDocNumber;
  String? profilePic;

  RegistrationModal({
    this.vendorId,
    this.email,
    this.otp,
    this.fullName,
    this.phone,
    this.password,
    this.personalDetails = const {},
    this.bankDetails = const {},
    this.workDetails = const {},
    this.termsAccepted = false,
    this.fcmToken,
    this.latitude,
    this.longitude,
    this.deviceName,
    this.subcategoryCharges = const [],
    this.registrationStep = 0,
    this.isVerified = false,
    this.identityDocType,
    this.identityDocNumber,
    this.profilePic,
  });

  Map<String, dynamic> toJson() => {
    'vendor_id': vendorId,
    'email': email,
    'otp': otp,
    'full_name': fullName,
    'phone': phone,
    'password': password,
    'personal_details': personalDetails,
    'bank_details': bankDetails,
    'work_details': workDetails,
    'terms_accepted': termsAccepted,
    'fcm_token': fcmToken,
    'latitude': latitude,
    'longitude': longitude,
    'device_name': deviceName,
    'subcategory_charges': subcategoryCharges.map((e) => e.toJson()).toList(),
    'registration_step': registrationStep,
    'is_verified': isVerified,
    // New fields in toJson
    'identity_doc_type': identityDocType,
    'identity_doc_number': identityDocNumber,
    'profile_pic': profilePic,
  };

  factory RegistrationModal.fromJson(Map<String, dynamic> json) {
    final personalDetails = json['personal_details'] is Map<String, dynamic>
        ? {
            for (var key in [
              'address',
              'state',
              'city',
              'pincode',
              'document_type',
              'document_number',
            ])
              key: json['personal_details'][key] is String
                  ? json['personal_details'][key]
                  : null,
          }
        : <String, dynamic>{};

    final bankDetails = json['bank_details'] is Map<String, dynamic>
        ? {
            for (var key in [
              'account_holder_name',
              'account_number',
              'ifsc_code',
              'upi_id',
            ])
              key: json['bank_details'][key] is String
                  ? json['bank_details'][key]
                  : null,
          }
        : <String, dynamic>{};

    return RegistrationModal(
      vendorId: json['vendor_id'] as int?,
      email: json['email'] as String?,
      otp: json['otp'] as String?,
      fullName: json['full_name'] as String?,
      phone: json['phone'] as String?,
      password: json['password'] as String?,
      personalDetails: personalDetails,
      bankDetails: bankDetails,
      workDetails: json['work_details'] is Map<String, dynamic>
          ? json['work_details']
          : {},
      termsAccepted: json['terms_accepted'] as bool? ?? false,
      fcmToken: json['fcm_token'] as String?,
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      deviceName: json['device_name'] as String?,
      subcategoryCharges:
          (json['subcategory_charges'] as List<dynamic>?)
              ?.map(
                (e) => SubCategoryCharge.fromJson(e as Map<String, dynamic>),
              )
              .toList() ??
          [],
      registrationStep: json['registration_step'] as int? ?? 0,
      isVerified: json['is_verified'] as bool? ?? false,
      // New fields fromJson
      identityDocType: json['identity_doc_type'] as String?,
      identityDocNumber: json['identity_doc_number'] as String?,
      profilePic: json['profile_pic'] as String?,
    );
  }
}
