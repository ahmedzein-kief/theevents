import 'package:event_app/core/constants/app_assets.dart';
import 'package:event_app/core/constants/app_strings.dart';
import 'package:event_app/core/helper/extensions/app_localizations_extension.dart';
import 'package:flutter/material.dart';

import '../../core/styles/app_colors.dart';
import '../../core/styles/custom_text_styles.dart';
import '../../core/widgets/custom_app_views/default_app_bar.dart';
import '../../core/widgets/custom_back_icon.dart';
import '../../core/widgets/styled_localized_title.dart';

class _AboutUsScreenState extends State<AboutUsScreen> {
  // bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    // Future.delayed(const Duration(seconds: 3), () {
    //   setState(() {
    //     _isLoading = false;
    //   });
    // });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final screenHeight = MediaQuery.sizeOf(context).height;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: const DefaultAppBar(
        leading: BackIcon(),
        leadingWidth: 100,
      ),
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    const SizedBox(height: 16),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Image.asset(
                        'assets/Frame.png',
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(height: 48),
                    _description(isDarkMode),
                    const SizedBox(height: 48),
                    _ourMission(context, isDarkMode),
                    const SizedBox(height: 48),
                    _ourVision(context, isDarkMode),
                    const SizedBox(height: 48),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.25),
                            offset: const Offset(0, 4),
                            blurRadius: 100,
                            spreadRadius: 0,
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.asset(
                          AppAssets.aboutBanner,
                          fit: BoxFit.cover,
                          width: screenWidth,
                        ),
                      ),
                    ),

                    // Padding(
                    //   padding: EdgeInsets.only(left: screenWidth * 0.05, right: screenWidth * 0.02, top: screenHeight * 0.02),
                    //   child: SizedBox(
                    //     height: 100,
                    //     width: screenWidth,
                    //     child: Image.asset(
                    //       'assets/aboutBanner.png',
                    //       fit: BoxFit.fitWidth,
                    //       width: screenWidth,
                    //     ),
                    //   ),
                    // ),
                    const SizedBox(height: 48),
                    _ourValues(context, isDarkMode),
                    const SizedBox(height: 48),
                    _ourLocation(context, isDarkMode),
                    const SizedBox(height: 48),

                    Container(
                      padding: const EdgeInsets.all(20),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color: isDarkMode
                            ? AppColors.orange.withAlpha((0.85 * 255).toInt()) // darker shade in dark mode
                            : AppColors.orange, // normal in light mode,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start, // 👈 aligns text to start
                        children: [
                          Text(
                            AppStrings.unitedArabEmirates.tr,
                            style: valueItemsStyle(context),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                              vertical: screenHeight * 0.01,
                            ),
                            child: Container(
                              height: 1,
                              color: Colors.white,
                              width: double.infinity, // 👈 take all available width
                            ),
                          ),
                          Text(
                            AppStrings.saudiArabia.tr,
                            style: valueItemsStyle(context),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                              vertical: screenHeight * 0.01,
                            ),
                            child: Container(
                              height: 1,
                              color: Colors.white,
                              width: double.infinity,
                            ),
                          ),
                          Text(
                            AppStrings.bahrain.tr,
                            style: valueItemsStyle(context),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                              vertical: screenHeight * 0.01,
                            ),
                            child: Container(
                              height: 1,
                              color: Colors.white,
                              width: double.infinity,
                            ),
                          ),
                          Text(
                            AppStrings.kuwait.tr,
                            style: valueItemsStyle(context),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                              vertical: screenHeight * 0.01,
                            ),
                            child: Container(
                              height: 1,
                              color: Colors.white,
                              width: double.infinity,
                            ),
                          ),
                          Text(
                            AppStrings.oman.tr,
                            style: valueItemsStyle(context),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                              vertical: screenHeight * 0.01,
                            ),
                            child: Container(
                              height: 1,
                              color: Colors.white,
                              width: double.infinity,
                            ),
                          ),
                          Text(
                            AppStrings.qatar.tr,
                            style: valueItemsStyle(context),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                              vertical: screenHeight * 0.01,
                            ),
                            child: Container(
                              height: 1,
                              color: Colors.white,
                              width: double.infinity,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 48),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Image.asset(
                        'assets/map.png',
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _description(isDarkMode) {
    return Column(
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: isDarkMode
                    ? AppColors.orange.withAlpha((0.85 * 255).toInt()) // darker shade in dark mode
                    : AppColors.orange, // normal in light mode, // normal in light mode
              ),
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Text(
                          AppStrings.who.tr.toUpperCase(),
                          style: headingTextStyle(context),
                          softWrap: true,
                        ),
                        Text(
                          AppStrings.weAre.tr.toUpperCase(),
                          style: headingsTextStyle(context),
                          softWrap: true,
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      softWrap: true,
                      style: headingDescriptionStyleText(context),
                      AppStrings.aboutUsEvents.tr,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

// Your widgets

  Widget _ourMission(BuildContext context, isDarkMode) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(10),
          topLeft: Radius.circular(10),
        ),
        color: isDarkMode
            ? AppColors.orange.withAlpha((0.85 * 255).toInt()) // darker shade in dark mode
            : AppColors.orange, // normal in light mode,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withAlpha((0.5 * 255).toInt()),
            blurRadius: 10,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            StyledLocalizedTitle(
              fullTextKey: AppStrings.ourMission,
              splitWords: const ['OUR', 'MISSION'],
              style1: headingTextStyle(context),
              style2: headingsTextStyle(context),
            ),
            const SizedBox(height: 16),
            Text(
              AppStrings.ourMissionText.tr,
              softWrap: true,
              style: headingDescriptionStyleText(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _ourVision(BuildContext context, isDarkMode) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(10),
          topLeft: Radius.circular(10),
        ),
        color: isDarkMode
            ? AppColors.orange.withAlpha((0.85 * 255).toInt()) // darker shade in dark mode
            : AppColors.orange, // normal in light mode,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withAlpha((0.5 * 255).toInt()),
            blurRadius: 10,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            StyledLocalizedTitle(
              fullTextKey: AppStrings.ourVision,
              splitWords: const ['OUR', 'VISION'],
              style1: headingTextStyle(context),
              style2: headingsTextStyle(context),
            ),
            const SizedBox(height: 16),
            Text(
              AppStrings.ourVisionText.tr,
              softWrap: true,
              style: headingDescriptionStyleText(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _ourValues(BuildContext context, isDarkMode) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: isDarkMode
            ? AppColors.orange.withAlpha((0.85 * 255).toInt()) // darker shade in dark mode
            : AppColors.orange, // normal in light mode,
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            StyledLocalizedTitle(
              fullTextKey: AppStrings.ourValues,
              splitWords: const ['OUR', 'VALUES'],
              style1: headingTextStyle(context),
              style2: headingsTextStyle(context),
            ),
            const SizedBox(height: 16),
            Wrap(
              alignment: WrapAlignment.center,
              spacing: 20,
              runSpacing: 20,
              children: [
                _buildValueItem(
                  imageUrl: 'https://theevents.ae/assets/frontend/img/profile/about-icon1.png',
                  label: AppStrings.simplicity.tr,
                ),
                _buildValueItem(
                  imageUrl: 'https://theevents.ae/assets/frontend/img/profile/about-icon2.png',
                  label: AppStrings.innovation.tr,
                ),
                _buildValueItem(
                  imageUrl: 'https://theevents.ae/assets/frontend/img/profile/about-icon3.png',
                  label: AppStrings.thoughtfulness.tr,
                ),
                _buildValueItem(
                  imageUrl: 'https://theevents.ae/assets/frontend/img/profile/about-icon4.png',
                  label: AppStrings.reliability.tr,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _ourLocation(BuildContext context, isDarkMode) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        StyledLocalizedTitle(
          fullTextKey: AppStrings.ourLocation,
          splitWords: const ['WE', 'ARE', 'COVERING'],
          style1: headingTextStyle(context),
          style2: headingsTextStyle(context),
        ),
      ],
    );
  }

  Widget _buildValueItem({
    required String imageUrl,
    required String label,
  }) =>
      Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.network(
            imageUrl,
            height: 35,
            errorBuilder: (context, error, stackTrace) => Container(
              height: 35,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xff2196F3), Color(0xff00BCD4)],
                ),
              ),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: ourItemsTextStyle(context),
            textAlign: TextAlign.center,
            softWrap: true,
            maxLines: 1,
            // Optional
            overflow: TextOverflow.visible, // Ensures no clipping
          ),
        ],
      );
}

class AboutUsScreen extends StatefulWidget {
  const AboutUsScreen({super.key});

  @override
  State<AboutUsScreen> createState() => _AboutUsScreenState();
}
