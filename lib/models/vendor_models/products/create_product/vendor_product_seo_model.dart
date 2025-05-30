class VendorProductSeoModel {
  String title;
  String description;
  List<String> keywords;
  String type;

  VendorProductSeoModel({
    required this.title,
    required this.description,
    required this.keywords,
    required this.type,
  });

  // Convert VendorProductSeoModel to a map
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'keywords': keywords.toList(),
      'type': type,
    };
  }

  // Create VendorProductSeoModel from a map
  factory VendorProductSeoModel.fromMap(Map<String, dynamic> map) {
    return VendorProductSeoModel(
      title: map['title'],
      description: map['description'],
      keywords: map['keywords']?.map((x) => x).toList(),
      type: map['type'],
    );
  }
}
