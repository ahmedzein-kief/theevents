import 'package:event_app/core/helper/extensions/app_localizations_extension.dart';
import 'package:flutter/material.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/styles/custom_text_styles.dart';

class FeaturedTabBar extends StatelessWidget {
  const FeaturedTabBar({
    super.key,
    required this.currentTab,
    required this.onTabChanged,
  });

  final String currentTab;
  final Function(String) onTabChanged;

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.sizeOf(context).width;
    final double screenHeight = MediaQuery.sizeOf(context).height;

    return Padding(
      padding: EdgeInsets.only(
        left: screenWidth * 0.02,
        right: screenWidth * 0.02,
        top: screenHeight * 0.02,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
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
                      if (currentTab == 'Products') Container(),
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
                      if (currentTab == 'Packages') const SizedBox.shrink(),
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
