import 'package:event_app/models/product_packages_models/product_filters_model.dart';

class FilterPayloadRequest {
  FilterPayloadRequest({
    required this.categories,
    required this.tags,
    required this.brands,
  });

  // Factory method to convert a map back into a model
  factory FilterPayloadRequest.fromMap(Map<String, dynamic> map) =>
      FilterPayloadRequest(
        categories: List<int>.from(map['categories']),
        tags: List<int>.from(map['tags']),
        brands: List<int>.from(map['brands']),
      );
  List<int> categories = [];
  List<int> tags = [];
  List<int> brands = [];

  // Method to convert the model into a map
  Map<String, dynamic> toMap(ProductFiltersModel filters) => {
        'categories':
            filters.categories.map((category) => category.id).toList(),
        'tags': filters.tags.map((tag) => tag.id).toList(),
        'brands': filters.brands.map((brand) => brand.id).toList(),
      };
}
