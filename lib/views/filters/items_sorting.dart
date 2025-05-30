import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/styles/custom_text_styles.dart';

class ItemsSortingDropDown extends StatefulWidget {
  final String selectedSortBy;
  final Function(String) onSortChanged;

  const ItemsSortingDropDown({
    super.key,
    required this.selectedSortBy,
    required this.onSortChanged,
  });

  @override
  State<ItemsSortingDropDown> createState() => _ItemsSortingState();
}

class _ItemsSortingState extends State<ItemsSortingDropDown> {
  late String _selectedSortBy;
  List<Map<String, String>> sortOption = [];

  @override
  void initState() {
    super.initState();
    _selectedSortBy = widget.selectedSortBy;
    _loadSorting(); // Load sorting options from JSON
  }

  // Load and parse the JSON file for sort options
  Future<void> _loadSorting() async {
    final String response = await rootBundle.loadString('assets/items_sort_options.json');
    final List<dynamic> data = jsonDecode(response);

    setState(() {
      sortOption = data
          .map((item) => {
                'value': item['value'] as String,
                'label': item['label'] as String,
              })
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            DropdownButtonHideUnderline(
              child: Tooltip(
                message: 'Sort option',
                child: DropdownButton<String>(
                  value: _selectedSortBy,
                  icon: const Icon(Icons.keyboard_arrow_down_rounded),
                  onChanged: (String? newValue) {
                    if (newValue != null) {
                      setState(() {
                        _selectedSortBy = newValue;
                      });
                      widget.onSortChanged(newValue);
                    }
                  },
                  items: sortOption.map((option) {
                    return DropdownMenuItem<String>(
                      value: option['value'],
                      child: Text(option['label']!, style: sortingStyle(context)),
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
        )
      ],
    );
  }
}
