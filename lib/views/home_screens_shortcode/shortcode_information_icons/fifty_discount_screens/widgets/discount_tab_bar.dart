import 'package:event_app/core/helper/extensions/app_localizations_extension.dart';
import 'package:flutter/material.dart';

import '../../../../../core/constants/app_strings.dart';
import '../../../../../core/styles/custom_text_styles.dart';

class DiscountTabBar extends StatelessWidget {
  final String currentTab;
  final Function(String) onTabChanged;

  const DiscountTabBar({
    super.key,
    required this.currentTab,
    required this.onTabChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: <Widget>[
              _buildTabItem(
                context: context,
                tabName: 'Products',
                displayName: AppStrings.products.tr,
              ),
              _buildTabItem(
                context: context,
                tabName: 'Packages',
                displayName: AppStrings.packages.tr,
              ),
            ],
          ),
          Container(
            color: Colors.grey,
            height: 1,
          ),
        ],
      ),
    );
  }

  Widget _buildTabItem({
    required BuildContext context,
    required String tabName,
    required String displayName,
  }) {
    final bool isSelected = currentTab == tabName;

    return GestureDetector(
      onTap: () => onTabChanged(tabName),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected ? Colors.grey : Colors.transparent,
          ),
          borderRadius: const BorderRadius.only(
            topRight: Radius.circular(10),
            topLeft: Radius.circular(10),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(4),
          child: Text(
            displayName,
            style: topTabBarStyle(context),
          ),
        ),
      ),
    );
  }
}
