import 'package:cached_network_image/cached_network_image.dart';
import 'package:event_app/core/constants/vendor_app_strings.dart';
import 'package:event_app/core/helper/extensions/app_localizations_extension.dart';
import 'package:event_app/models/vendor_models/products/create_product/vendor_search_product_data_response.dart';
import 'package:event_app/models/vendor_models/products/holder_models/search_dropdown_model.dart';
import 'package:event_app/vendor/components/text_fields/custom_text_form_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../core/network/api_endpoints/api_contsants.dart';

class SearchDropdown extends StatefulWidget {
  const SearchDropdown({
    super.key,
    required this.searchDropdownModel,
    required this.hint,
    required this.onSelected,
    required this.onSearchChanged,
  });

  final SearchDropdownModel searchDropdownModel;
  final String hint;
  final Function(SearchProductRecord) onSelected;
  final Function(SearchDropdownModel) onSearchChanged;

  @override
  State<SearchDropdown> createState() => _SearchDropdownState();
}

class _SearchDropdownState extends State<SearchDropdown> {
  final TextEditingController _searchController = TextEditingController();
  List<SearchProductRecord> _filteredOptions = [];
  bool _showDropdown = false;

  void _onSearchChanged(String query) {
    widget.searchDropdownModel.searchText = query;
    widget.onSearchChanged(widget.searchDropdownModel);
  }

  @override
  Widget build(BuildContext context) {
    final query = widget.searchDropdownModel.searchText;
    _showDropdown = query.isNotEmpty;
    if (query.isEmpty) {
      _filteredOptions = [];
    } else {
      _filteredOptions = widget.searchDropdownModel.records
          .where(
            (option) => option.name?.toLowerCase().contains(query.toLowerCase()) ?? false,
          )
          .toList();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomTextFormField(
          labelText: '',
          required: false,
          hintText: widget.hint,
          controller: _searchController,
          prefix: const Icon(Icons.search),
          onChanged: _onSearchChanged,
        ),
        const SizedBox(height: 8),
        if (_showDropdown)
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(10),
            ),
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.3, // Limits height to 30% of the screen
            ),
            child: _filteredOptions.isEmpty
                ? Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(child: Text(VendorAppStrings.noResultsFound.tr)),
                  )
                : ListView.separated(
                    shrinkWrap: true,
                    itemCount: _filteredOptions.length,
                    separatorBuilder: (context, index) => Divider(
                      height: 1,
                      color: Colors.grey.shade300,
                    ), // Separator
                    itemBuilder: (context, index) {
                      final option = _filteredOptions[index];
                      return ListTile(
                        leading: CachedNetworkImage(
                          imageUrl: option.image ?? ApiConstants.placeholderImage,
                          fit: BoxFit.cover,
                          width: 32,
                          height: 32,
                          placeholder: (BuildContext context, String url) => Container(
                            height: MediaQuery.sizeOf(context).height * 0.28,
                            width: double.infinity,
                            color: Colors.blueGrey[300],
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                Image.asset(
                                  'assets/placeholder.png',
                                  fit: BoxFit.cover,
                                  height: MediaQuery.sizeOf(context).height * 0.28,
                                  width: double.infinity,
                                ),
                                const CupertinoActivityIndicator(
                                  radius: 16,
                                  animating: true,
                                ),
                              ],
                            ),
                          ),
                        ),
                        title: Text(option.name ?? ''),
                        onTap: () {
                          widget.onSelected(option);
                          _searchController.clear();
                        },
                      );
                    },
                  ),
          )
        else
          const SizedBox(),
      ],
    );
  }
}
