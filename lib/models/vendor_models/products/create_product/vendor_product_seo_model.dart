class VendorProductSeoModel {
  VendorProductSeoModel({
    required this.title,
    required this.description,
    required this.keywords,
    required this.type,
  });

  // Create VendorProductSeoModel from a map
  factory VendorProductSeoModel.fromMap(Map<String, dynamic> map) =>
      VendorProductSeoModel(
        title: map['title'],
        description: map['description'],
        keywords: map['keywords']?.map((x) => x).toList(),
        type: map['type'],
      );
  String title;
  String description;
  List<String> keywords;
  String type;

  // Convert VendorProductSeoModel to a map
  Map<String, dynamic> toMap() => {
        'title': title,
        'description': description,
        'keywords': keywords.toList(),
        'type': type,
      };
}
