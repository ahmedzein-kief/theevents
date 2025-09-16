import 'package:event_app/core/helper/extensions/app_localizations_extension.dart';
import 'package:flutter/material.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/styles/custom_text_styles.dart';

class TabNavigationSection extends StatelessWidget {
  final String currentTab;
  final Function(String) onTabChanged;

  const TabNavigationSection({
    super.key,
    required this.currentTab,
    required this.onTabChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 25,
        left: 10,
        right: 10,
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              GestureDetector(
                onTap: () => onTabChanged('Products'),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: currentTab == 'Products' ? Colors.grey : Colors.transparent,
                    ),
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(10),
                      topLeft: Radius.circular(10),
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(4),
                        child: Text(
                          AppStrings.products.tr,
                          style: topTabBarStyle(context),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              GestureDetector(
                onTap: () => onTabChanged('Packages'),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: currentTab == 'Packages' ? Colors.grey : Colors.transparent,
                    ),
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(10),
                      topLeft: Radius.circular(10),
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(4),
                        child: Text(
                          AppStrings.packages.tr,
                          style: topTabBarStyle(context),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Column(
            children: [
              Container(
                color: Colors.grey,
                height: 1,
                width: double.infinity,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
