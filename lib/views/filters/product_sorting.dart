import 'dart:convert'; // For JSON decoding

import 'package:event_app/core/styles/custom_text_styles.dart'; // Assuming sortingStyle is defined here
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // For loading the JSON file

class SortAndFilterDropdown extends StatefulWidget {
  final String selectedSortBy;
  final Function(String) onSortChanged;
  final VoidCallback onFilterPressed; // Callback for the filter action

  const SortAndFilterDropdown({
    Key? key,
    required this.selectedSortBy,
    required this.onSortChanged,
    required this.onFilterPressed, // Required for filter button
  }) : super(key: key);

  @override
  _SortAndFilterDropdownState createState() => _SortAndFilterDropdownState();
}

class _SortAndFilterDropdownState extends State<SortAndFilterDropdown> {
  late String _selectedSortBy;
  List<Map<String, String>> sortOptions = [];

  @override
  void initState() {
    super.initState();
    _selectedSortBy = widget.selectedSortBy;
    _loadSortOptions(); // Load sorting options from JSON
  }

  // Load and parse the JSON file for sort options
  Future<void> _loadSortOptions() async {
    final String response = await rootBundle.loadString('assets/sort_options.json');
    final List<dynamic> data = jsonDecode(response);

    setState(() {
      sortOptions = data
          .map((item) => {
                'value': item['value'] as String,
                'label': item['label'] as String,
              })
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.sizeOf(context).width;
    double height = MediaQuery.sizeOf(context).height;
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          // Aligns children to the extremes
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Filter Button
            // IconButton(
            //   icon: Icon(Icons.filter_list_rounded),
            //   onPressed: widget.onFilterPressed, // Triggers the filter callback
            //   tooltip: 'Filter Options',
            // ),

            Container(
              height: height * 0.05, // 5% of the screen height
              width: width * 0.1, // 10% of the screen width
              child: Tooltip(
                message: "Filter Options",
                child: InkWell(
                  onTap: widget.onFilterPressed,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [Icon(size: 25, Icons.filter_list_rounded)],
                  ),
                ),
              ),
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
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
                      items: sortOptions.map((option) {
                        return DropdownMenuItem<String>(
                          value: option['value'],
                          child: Text(option['label']!, style: sortingStyle(context)),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
