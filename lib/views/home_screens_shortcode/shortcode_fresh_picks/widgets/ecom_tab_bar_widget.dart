import 'package:event_app/core/helper/extensions/app_localizations_extension.dart';
import 'package:flutter/material.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/styles/custom_text_styles.dart';

class EComTabBarWidget extends StatelessWidget {
  const EComTabBarWidget({
    Key? key,
    required this.currentTab,
    required this.onTabChanged,
    required this.screenWidth,
    required this.screenHeight,
  }) : super(key: key);

  final String currentTab;
  final Function(String) onTabChanged;
  final double screenWidth;
  final double screenHeight;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: screenWidth * 0.02,
        right: screenWidth * 0.02,
        top: screenHeight * 0.02,
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              _buildTabButton(
                context: context,
                tabName: 'Brands',
                displayText: AppStrings.brands.tr,
              ),
              _buildTabButton(
                context: context,
                tabName: 'Products',
                displayText: AppStrings.products.tr,
              ),
              _buildTabButton(
                context: context,
                tabName: 'Packages',
                displayText: AppStrings.packages.tr,
              ),
            ],
          ),
          Container(
            color: Colors.grey,
            height: 1,
            width: double.infinity,
          ),
        ],
      ),
    );
  }

  Widget _buildTabButton({
    required BuildContext context,
    required String tabName,
    required String displayText,
  }) {
    final isSelected = currentTab == tabName;

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
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(4),
              child: Text(
                displayText,
                style: topTabBarStyle(context),
              ),
            ),
            if (isSelected) Container(),
          ],
        ),
      ),
    );
  }
}
