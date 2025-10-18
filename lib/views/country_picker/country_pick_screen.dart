import 'package:event_app/core/helper/extensions/app_localizations_extension.dart';
import 'package:event_app/core/styles/app_colors.dart';
import 'package:flutter/material.dart';

import '../../core/constants/app_strings.dart';
import '../../models/wishlist_models/states_cities_models.dart';
import '../../provider/payment_address/country_picks_provider.dart';

class CountryPickerDialog extends StatelessWidget {
  const CountryPickerDialog({
    super.key,
    required this.countryList,
    required this.currentSelection,
    required this.onCountrySelected,
  });

  final List<CountryList> countryList;
  final String? currentSelection;
  final Function(CountryList) onCountrySelected;

  @override
  Widget build(BuildContext context) => AlertDialog(
        title: Text(AppStrings.selectCountry.tr),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: countryList.length,
            itemBuilder: (context, index) {
              final country = countryList[index].name;
              return ListTile(
                title: Text(
                  countryList[index].name ?? AppStrings.unknownCountry.tr,
                  style: TextStyle(
                    color: country == currentSelection ? AppColors.peachyPink : Theme.of(context).colorScheme.onPrimary,
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

class StatePickerDialog extends StatelessWidget {
  const StatePickerDialog({
    super.key,
    required this.stateList,
    required this.currentSelection,
    required this.onStateSelected,
  });

  final List<StateRecord> stateList;
  final StateRecord? currentSelection;
  final Function(StateRecord) onStateSelected;

  @override
  Widget build(BuildContext context) => AlertDialog(
        title: Text(AppStrings.selectState.tr),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: stateList.length,
            itemBuilder: (context, index) {
              final state = stateList[index];
              return ListTile(
                title: Text(
                  state.name ?? AppStrings.unknownState.tr,
                  style: TextStyle(
                    color: state.id == currentSelection?.id ? Colors.blue : Theme.of(context).colorScheme.onPrimary,
                  ),
                ),
                onTap: () {
                  onStateSelected(state);
                  Navigator.pop(context);
                },
              );
            },
          ),
        ),
      );
}

class CityPickerDialog extends StatelessWidget {
  const CityPickerDialog({
    super.key,
    required this.cityList,
    required this.currentSelection,
    required this.onCitySelected,
  });

  final List<CityRecord> cityList;
  final CityRecord? currentSelection;
  final Function(CityRecord) onCitySelected;

  @override
  Widget build(BuildContext context) => AlertDialog(
        title: Text(AppStrings.selectCity.tr),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: cityList.length,
            itemBuilder: (context, index) {
              final city = cityList[index];
              return ListTile(
                title: Text(
                  city.name ?? AppStrings.unknownCity.tr,
                  style: TextStyle(
                    color: city.id == currentSelection?.id ? Colors.green : Theme.of(context).colorScheme.onPrimary,
                  ),
                ),
                onTap: () {
                  onCitySelected(city);
                  Navigator.pop(context);
                },
              );
            },
          ),
        ),
      );
}
