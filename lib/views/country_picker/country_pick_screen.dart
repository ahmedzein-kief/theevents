import 'package:event_app/core/styles/app_colors.dart';
import 'package:flutter/material.dart';

import '../../provider/payment_address/country_picks_provider.dart';

class CountryPickerDialog extends StatelessWidget {
  const CountryPickerDialog({
    super.key,
    required this.countryList,
    required this.currentSelection,
    required this.onCountrySelected,
  });
  final List<CountryList> countryList;
  final currentSelection;
  final Function(CountryList) onCountrySelected;

  @override
  Widget build(BuildContext context) => AlertDialog(
        title: const Text('Select Country'),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: countryList.length,
            itemBuilder: (context, index) {
              final country = countryList[index].label;
              return ListTile(
                title: Text(
                  countryList[index].label ?? 'Unknown Country',
                  style: TextStyle(
                    color: country == currentSelection
                        ? AppColors.peachyPink
                        : Colors.black,
                  ),
                ),
                onTap: () {
                  onCountrySelected(countryList[index]);
                  Navigator.pop(context); // Close the dialog
                },
              );
            },
          ),
        ),
      );
}
