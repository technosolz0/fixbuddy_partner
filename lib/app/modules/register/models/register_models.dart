class RegistrationData {
  int? vendorId;
  String? email;
  String? otp;
  String? fullName;
  String? phone;
  String? password;
  Map<String, dynamic> personalDetails = {};
  Map<String, dynamic> bankDetails = {};
  Map<String, dynamic> workDetails = {};
  int registrationStep = 0;
  bool isVerified = false;

  RegistrationData({
    this.vendorId,
    this.email,
    this.otp,
    this.fullName,
    this.phone,
    this.password,
    this.personalDetails = const {},
    this.bankDetails = const {},
    this.workDetails = const {},
    this.registrationStep = 0,
    this.isVerified = false,
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
    'registration_step': registrationStep,
    'is_verified': isVerified,
  };

  factory RegistrationData.fromJson(Map<String, dynamic> json) =>
      RegistrationData(
        vendorId: json['vendor_id'],
        email: json['email'],
        otp: json['otp'],
        fullName: json['full_name'],
        phone: json['phone'],
        password: json['password'],
        personalDetails: json['personal_details'] ?? {},
        bankDetails: json['bank_details'] ?? {},
        workDetails: json['work_details'] ?? {},
        registrationStep: json['registration_step'] ?? 0,
        isVerified: json['is_verified'] ?? false,
      );
}
