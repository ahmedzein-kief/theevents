import 'package:event_app/core/constants/app_strings.dart';
import 'package:event_app/core/helper/extensions/app_localizations_extension.dart';
import 'package:event_app/core/helper/functions/functions.dart';
import 'package:event_app/core/styles/app_colors.dart';
import 'package:event_app/models/product_packages_models/product_filters_model.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart'; // Import the syncfusion slider package

class FilterBottomSheet extends StatefulWidget {
  FilterBottomSheet({
    super.key,
    this.filters,
    this.isCategory = false,
    Map<String, List<int>>? selectedIds,
  }) : selectedIds = selectedIds ??
            {
              'Categories': [],
              'Brands': [],
              'Tags': [],
              'Prices': [],
              'Colors': [],
            };
  final ProductFiltersModel? filters;
  final Map<String, List<int>> selectedIds; // Pass the previously selected IDs
  final bool isCategory;

  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  String selectedFilter = 'Categories';

  // Local copy of selected IDs to be modified inside the bottom sheet
  late Map<String, List<int>> selectedIds;

  // Add this to manage the selected price range
  late SfRangeValues _priceRange; // Set initial price range (min: 0, max: 1000)

  @override
  void initState() {
    super.initState();
    // Initialize selectedIds with the passed data
    selectedIds = Map<String, List<int>>.from(widget.selectedIds);

    // Ensure all filter keys are initialized with default empty lists if not provided
    selectedIds.addEntries([
      MapEntry('Categories', selectedIds['Categories'] ?? []),
      MapEntry('Brands', selectedIds['Brands'] ?? []),
      MapEntry('Tags', selectedIds['Tags'] ?? []),
      MapEntry('Prices', selectedIds['Prices'] ?? []),
      MapEntry('Colors', selectedIds['Colors'] ?? []),
    ]);

    // Remove keys if they have no pre-selected values and no available filter data
    selectedIds.removeWhere((key, value) {
      switch (key) {
        case 'Categories':
          return widget.isCategory || (value.isEmpty && (widget.filters?.categories.isEmpty ?? true));
        case 'Brands':
          return value.isEmpty && (widget.filters?.brands.isEmpty ?? true);
        case 'Tags':
          return value.isEmpty && (widget.filters?.tags.isEmpty ?? true);
        case 'Colors':
          final hasColors = widget.filters?.attributesSet.any((attr) => attr.slug == 'colors') ?? false;
          return value.isEmpty && !hasColors;
        case 'Prices':
          return widget.filters?.maxPrice == 0; // Always keep Prices as it's a range filter
        default:
          return true; // Remove unknown keys
      }
    });

    // Set the first available filter as the default selectedFilter
    selectedFilter = selectedIds.keys.isNotEmpty ? selectedIds.keys.first : '';

    // Initialize _priceRange from selectedIds if it exists, otherwise use default values
    if (selectedIds['Prices'] != null && selectedIds['Prices']!.length == 2) {
      _priceRange = SfRangeValues(
        selectedIds['Prices']![0].toDouble(),
        selectedIds['Prices']![1].toDouble(),
      );
    } else {
      _priceRange = SfRangeValues(0, widget.filters?.maxPrice); // Default range
    }
  }

  @override
  Widget build(BuildContext context) => Container(
        height: MediaQuery.of(context).size.height * 0.6,
        padding: const EdgeInsets.all(0),
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            // Full-width Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: AppColors.peachyPink,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Center(
                child: Text(
                  AppStrings.filters.tr,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: ListView(
                      children: selectedIds.keys
                          .map(
                            (filter) => ListTile(
                              title: Text(
                                getFilterText(filter),
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Theme.of(context).colorScheme.onPrimary,
                                  fontWeight: selectedFilter == filter ? FontWeight.bold : FontWeight.normal,
                                ),
                              ),
                              selected: selectedFilter == filter,
                              onTap: () {
                                setState(() {
                                  selectedFilter = filter;
                                });
                              },
                            ),
                          )
                          .toList(),
                    ),
                  ),
                  // Vertical separator
                  const VerticalDivider(width: 1, color: Colors.grey),
                  Expanded(
                    flex: 2,
                    child: selectedFilter == 'Prices'
                        ? // If the selected filter is 'Price', show the slider
                        Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: SfRangeSlider(
                              min: 0,
                              max: widget.filters?.maxPrice,
                              values: _priceRange,
                              onChanged: (SfRangeValues values) {
                                setState(() {
                                  _priceRange = values; // Update the price range
                                  // Save the values as integers in the selectedIds map
                                  selectedIds['Prices'] = [
                                    values.start.toInt(),
                                    values.end.toInt(),
                                  ];
                                });
                              },
                              enableTooltip: true,
                              shouldAlwaysShowTooltip: true,
                              showLabels: true,
                              // Show labels at the ends of the slider
                              labelFormatterCallback: (actualValue, index) {
                                return '${actualValue.toStringAsFixed(0)}'; // Display only the number for the label
                              },
                              tooltipTextFormatterCallback: (actualValue, index) {
                                return '${actualValue.toStringAsFixed(0)}'; // Show number as the tooltip text
                              },
                              activeColor: Colors.blue,
                              // Active color of the range
                              inactiveColor: Colors.grey, // Inactive color of the range
                            ),
                          )
                        : // Otherwise, show the checkbox list
                        ListView.builder(
                            itemCount: getFilterValues().length,
                            itemBuilder: (context, index) {
                              final filterValue = getFilterValues()[index];
                              final String value = filterValue['name'];
                              final int id = filterValue['id'];
                              final bool isSelected = selectedIds[selectedFilter]!.contains(id);

                              // Check if the current filter is a color and extract the color
                              Color? color;
                              if (selectedFilter == 'Colors') {
                                final String colorName = filterValue['color'];
                                color = getColorFromString(colorName);
                              }

                              return CheckboxListTile(
                                title: Row(
                                  children: [
                                    // If it's a color filter, show a color swatch
                                    if (color != null)
                                      Container(
                                        width: 20,
                                        height: 20,
                                        margin: const EdgeInsets.only(
                                          right: 8,
                                        ), // Margin between color and text
                                        decoration: BoxDecoration(
                                          color: color,
                                          borderRadius: BorderRadius.circular(4),
                                          border: Border.all(
                                            color: Theme.of(context).colorScheme.outline.withAlpha((0.3 * 255).toInt()),
                                            width: 1,
                                          ),
                                        ),
                                      ),
                                    Text(
                                      value,
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Theme.of(context).colorScheme.onSurface,
                                      ),
                                    ),
                                  ],
                                ),
                                value: isSelected,
                                fillColor: WidgetStateProperty.resolveWith((states) {
                                  return Theme.of(context).colorScheme.primary;
                                }),
                                checkColor: Theme.of(context).colorScheme.onPrimary,
                                side: WidgetStateBorderSide.resolveWith((states) {
                                  return BorderSide(
                                    color: Theme.of(context).colorScheme.outline,
                                    width: 2,
                                  );
                                }),
                                onChanged: (bool? value) {
                                  setState(() {
                                    if (value == true) {
                                      selectedIds[selectedFilter]!.add(id);
                                    } else {
                                      selectedIds[selectedFilter]!.remove(id);
                                    }
                                  });
                                },
                              );
                            },
                          ),
                  ),
                ],
              ),
            ),
            const Divider(height: 1, color: Colors.grey),
            // Buttons
            Container(
              margin: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context); // Close the bottom sheet
                    },
                    child: Text(
                      AppStrings.cancel.tr,
                      style: const TextStyle(color: Colors.blue),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      // Return the selected IDs when Apply is pressed
                      Navigator.pop(context, selectedIds);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                    ),
                    child: Text(
                      AppStrings.apply.tr,
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );

  // Modify this function to return both names and IDs
  List<Map<String, dynamic>> getFilterValues() {
    switch (selectedFilter) {
      case 'Categories':
        return widget.filters!.categories.map((category) => {'name': category.name, 'id': category.id}).toList();
      case 'Brands':
        return widget.filters!.brands.map((brand) => {'name': brand.name, 'id': brand.id}).toList();
      case 'Tags':
        return widget.filters!.tags.map((tag) => {'name': tag.name, 'id': tag.id}).toList();
      case 'Colors':
        final AttributeSet colorAttributeSet = widget.filters!.attributesSet.firstWhere(
          (attributeSet) => attributeSet.slug == 'colors',
        );
        final colorAttributes = colorAttributeSet.attributes;
        return colorAttributes
            .map(
              (attribute) => {
                'name': attribute.title,
                'id': attribute.id,
                'color': attribute.color,
              },
            )
            .toList();
      default:
        return [];
    }
  }

  Color getColorFromString(String colorString) {
    try {
      final match = RegExp(r'rgb\((\d+), (\d+), (\d+)\)').firstMatch(colorString);
      if (match != null) {
        final r = int.parse(match.group(1)!);
        final g = int.parse(match.group(2)!);
        final b = int.parse(match.group(3)!);
        return Color.fromRGBO(r, g, b, 1.0);
      }
      if (colorString.startsWith('#')) {
        return Color(int.parse('0xFF${colorString.replaceAll('#', '')}'));
      }
    } catch (error) {
      debugPrint(error.toString());
    }
    return Colors.transparent; // Default to transparent color if parsing fails
  }
}
