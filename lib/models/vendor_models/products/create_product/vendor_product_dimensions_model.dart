class VendorProductDimensionsModel {
  VendorProductDimensionsModel({
    required this.weight,
    required this.length,
    required this.width,
    required this.height,
  });

  // Factory constructor to create a model from a map
  factory VendorProductDimensionsModel.fromMap(Map<String, dynamic> map) =>
      VendorProductDimensionsModel(
        weight: map['weight'] ?? '',
        length: map['length'] ?? '',
        width: map['width'] ?? '',
        height: map['height'] ?? '',
      );
  String weight;
  String length;
  String width;
  String height;

  // Convert model to a map
  Map<String, dynamic> toMap() => {
        'weight': weight,
        'length': length,
        'width': width,
        'height': height,
      };
}
