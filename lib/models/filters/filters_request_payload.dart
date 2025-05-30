import 'package:event_app/models/product_packages_models/product_filters_model.dart';

class FilterPayloadRequest {
  List<int> categories = [];
  List<int> tags = [];
  List<int> brands = [];

  FilterPayloadRequest({
    required this.categories,
    required this.tags,
    required this.brands,
  });

  // Method to convert the model into a map
  Map<String, dynamic> toMap(ProductFiltersModel filters) {
    return {
      'categories': filters.categories.map((category) => category.id).toList(),
      'tags': filters.tags.map((tag) => tag.id).toList(),
      'brands': filters.brands.map((brand) => brand.id).toList(),
    };
  }

  // Factory method to convert a map back into a model
  factory FilterPayloadRequest.fromMap(Map<String, dynamic> map) {
    return FilterPayloadRequest(
      categories: List<int>.from(map['categories']),
      tags: List<int>.from(map['tags']),
      brands: List<int>.from(map['brands']),
    );
  }
}
