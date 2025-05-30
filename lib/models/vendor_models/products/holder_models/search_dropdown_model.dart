import 'package:event_app/models/vendor_models/products/create_product/vendor_search_product_data_response.dart';

class SearchDropdownModel {
  String searchText;
  List<SearchProductRecord> records;
  bool showDropdown;

  SearchDropdownModel({
    this.searchText = '',
    this.records = const [],
    this.showDropdown = false,
  });

  @override
  String toString() {
    return 'SearchDropdownModel(searchText: $searchText, records: $records, showDropdown: $showDropdown)';
  }
}
