import 'package:event_app/models/vendor_models/products/create_product/vendor_search_product_data_response.dart';

class SearchDropdownModel {
  SearchDropdownModel({
    this.searchText = '',
    this.records = const [],
    this.showDropdown = false,
  });
  String searchText;
  List<SearchProductRecord> records;
  bool showDropdown;

  @override
  String toString() =>
      'SearchDropdownModel(searchText: $searchText, records: $records, showDropdown: $showDropdown)';
}
