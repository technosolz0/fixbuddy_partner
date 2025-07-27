class ServiceLocationModel {
  final String category;
  final String subCategory;
  final String state;
  final String city;
  final String charge;
  final String experience;

  ServiceLocationModel({
    required this.category,
    required this.subCategory,
    required this.state,
    required this.city,
    required this.charge,
    required this.experience,
  });

  Map<String, dynamic> toJson() {
    return {
      'category': category,
      'subCategory': subCategory,
      'state': state,
      'city': city,
      'charge': charge,
      'experience': experience,
    };
  }
}
