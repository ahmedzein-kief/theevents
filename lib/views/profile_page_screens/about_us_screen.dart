import 'package:event_app/core/constants/app_strings.dart';
import 'package:flutter/material.dart';

import '../../core/styles/app_colors.dart';
import '../../core/styles/custom_text_styles.dart';
import '../../core/widgets/custom_back_icon.dart';

class _AboutUsScreenState extends State<AboutUsScreen> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      setState(() {
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final screenHeight = MediaQuery.sizeOf(context).height;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white, // Customize the app bar background color
        leading: const BackIcon(),
        leadingWidth: 100,
      ),
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.only(bottom: screenWidth * 0.04),
                child: Column(
                  children: [
                    Container(
                      color: AppColors.orange,
                      height: 200,
                      width: double.infinity,
                      child: Padding(
                        padding: EdgeInsets.only(
                            left: screenWidth * 0.05,
                            right: screenHeight * 0.02),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/Frame.png',
                              height: 180,
                            ),
                          ],
                        ),
                      ),
                    ),
                    _whoWeAre(),
                    _description(),
                    _ourMission(),
                    _ourVision(),
                    Padding(
                      padding: EdgeInsets.only(
                          left: screenWidth * 0.05,
                          right: screenWidth * 0.02,
                          top: screenHeight * 0.02),
                      child: SizedBox(
                        height: 100,
                        width: screenWidth,
                        child: Image.asset(
                          'assets/aboutBanner.png',
                          fit: BoxFit.fitWidth,
                          width: screenWidth,
                        ),
                      ),
                    ),
                    _ourValues(),
                    _ourLocation(),
                    Padding(
                      padding: EdgeInsets.only(top: screenHeight * 0.02),
                      child: Container(
                        padding: const EdgeInsets.only(left: 40, right: 40),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: AppColors.orange,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text('United Arab Emirates',
                                      style: valueItemsStyle(context)),
                                  Padding(
                                    padding: EdgeInsets.only(
                                        top: screenHeight * 0.01,
                                        bottom: screenHeight * 0.01),
                                    child: Container(
                                        height: 1,
                                        color: Colors.white,
                                        width: 100),
                                  ),
                                  Text('Saudi Arabia',
                                      style: valueItemsStyle(context)),
                                  Padding(
                                    padding: EdgeInsets.only(
                                        top: screenHeight * 0.01,
                                        bottom: screenHeight * 0.01),
                                    child: Container(
                                        height: 1,
                                        color: Colors.white,
                                        width: 100),
                                  ),
                                  Text(' Bahrain',
                                      style: valueItemsStyle(context)),
                                  Padding(
                                    padding: EdgeInsets.only(
                                        top: screenHeight * 0.01,
                                        bottom: screenHeight * 0.01),
                                    child: Container(
                                        height: 1,
                                        color: Colors.white,
                                        width: 100),
                                  ),
                                  Text(' Kuwait',
                                      style: valueItemsStyle(context)),
                                  Padding(
                                    padding: EdgeInsets.only(
                                        top: screenHeight * 0.01,
                                        bottom: screenHeight * 0.01),
                                    child: Container(
                                        height: 1,
                                        color: Colors.white,
                                        width: 100),
                                  ),
                                  Text(' Oman',
                                      style: valueItemsStyle(context)),
                                  Padding(
                                    padding: EdgeInsets.only(
                                        top: screenHeight * 0.01,
                                        bottom: screenHeight * 0.01),
                                    child: Container(
                                        height: 1,
                                        color: Colors.white,
                                        width: 100),
                                  ),
                                  Text(' Qatar',
                                      style: valueItemsStyle(context)),
                                  Padding(
                                    padding: EdgeInsets.only(
                                        top: screenHeight * 0.01,
                                        bottom: screenHeight * 0.01),
                                    child: Container(
                                        height: 1,
                                        color: Colors.white,
                                        width: 100),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
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

  Widget _whoWeAre() {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final screenHeight = MediaQuery.sizeOf(context).height;
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(
              left: screenWidth * 0.05, top: screenHeight * 0.02),
          child: Row(
            children: [
              Text(
                'WHO'.toUpperCase(),
                style: headingTextStyle(context),
                softWrap: true,
              ),
              Text(
                ' WE ARE'.toUpperCase(),
                style: headingsTextStyle(context),
                softWrap: true,
              ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.only(
              left: screenWidth * 0.05, top: screenHeight * 0.02),
          child: Row(
            children: [
              Expanded(
                child: Container(
                  margin: const EdgeInsets.only(right: 5),
                  decoration: BoxDecoration(
                    // color: AppColors.orange,
                    color: AppColors.peachyPink,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Image.asset(
                    'assets/aboutUs.png',
                    fit: BoxFit.cover,
                    width: double.infinity,
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.orange,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: Text(
                        softWrap: true,
                        style: headingDescriptionStyleText(context),
                        AppStrings.whoWeAre),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _description() {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final screenHeight = MediaQuery.sizeOf(context).height;
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(top: screenHeight * 0.02),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: AppColors.orange,
                ),
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Text(
                          softWrap: true,
                          style: headingDescriptionStyleText(context),
                          AppStrings.aboutUsEvents)
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _ourMission() {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final screenHeight = MediaQuery.sizeOf(context).height;
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(
              left: screenWidth * 0.05, top: screenHeight * 0.02),
          child: Row(
            children: [
              Text(
                'OUR',
                style: headingTextStyle(context),
                softWrap: true,
              ),
              Text(
                ' MISSION',
                style: headingsTextStyle(context),
                softWrap: true,
              ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.only(
              left: screenWidth * 0.05,
              top: screenHeight * 0.02,
              right: screenWidth * 0.05),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                // color: AppColors.orange,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(10),
                      topLeft: Radius.circular(10)),
                  color: AppColors.orange,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 0.1,
                      blurRadius: 10,
                    ),
                  ],
                ),

                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Text(
                          softWrap: true,
                          style: headingDescriptionStyleText(context),
                          AppStrings.ourMission),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _ourVision() {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final screenHeight = MediaQuery.sizeOf(context).height;
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(
              left: screenWidth * 0.05, top: screenHeight * 0.02),
          child: Row(
            children: [
              Text(
                'OUR',
                style: headingTextStyle(context),
                softWrap: true,
              ),
              Text(
                ' VISION',
                style: headingsTextStyle(context),
                softWrap: true,
              ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.only(
              left: screenWidth * 0.05,
              top: screenHeight * 0.02,
              right: screenWidth * 0.05),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                // color: AppColors.orange,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(10),
                      topLeft: Radius.circular(10)),
                  color: AppColors.orange,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 0.1,
                      blurRadius: 10,
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Text(
                          softWrap: true,
                          style: headingDescriptionStyleText(context),
                          AppStrings.ourVision)
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _ourValues() {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final screenHeight = MediaQuery.sizeOf(context).height;
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(
              left: screenWidth * 0.05,
              right: screenWidth * 0.02,
              top: screenHeight * 0.02),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                // color: AppColors.orange,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: AppColors.orange,
                ),
                child: Padding(
                  padding: EdgeInsets.only(
                      left: screenWidth * 0.02,
                      right: screenWidth * 0.02,
                      bottom: screenWidth * 0.04,
                      top: screenWidth * 0.04),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Our'.toUpperCase(),
                            style: ourItemsStyle(context),
                          ),
                          Text(' Values'.toUpperCase(),
                              style: valueItemsStyle(context)),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                children: [
                                  Image.network(
                                    'https://theevents.ae/assets/frontend/img/profile/about-icon1.png',
                                    height: 35,
                                    errorBuilder: (builder, context, _) =>
                                        Container(
                                      decoration: const BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [
                                            Color(0xff2196F3),
                                            Color(0xff00BCD4),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(6),
                                    child: Text('Simplicity',
                                        style: ourItemsTextStyle(context)),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Column(
                                children: [
                                  Image.network(
                                      'https://theevents.ae/assets/frontend/img/profile/about-icon2.png',
                                      height: 35),
                                  Padding(
                                    padding: const EdgeInsets.all(6),
                                    child: Text('Innovation',
                                        style: ourItemsTextStyle(context)),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Column(
                                children: [
                                  Image.network(
                                      'https://theevents.ae/assets/frontend/img/profile/about-icon3.png',
                                      height: 35),
                                  Padding(
                                    padding: const EdgeInsets.all(6),
                                    child: Text('Thoughtfulness',
                                        style: ourItemsTextStyle(context)),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Column(
                                children: [
                                  Image.network(
                                      'https://theevents.ae/assets/frontend/img/profile/about-icon4.png',
                                      height: 35),
                                  Padding(
                                    padding: const EdgeInsets.all(6),
                                    child: Text('Reliability',
                                        style: ourItemsTextStyle(context)),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _ourLocation() {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final screenHeight = MediaQuery.sizeOf(context).height;
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(
              left: screenWidth * 0.05, top: screenHeight * 0.02),
          child: Row(
            children: [
              Text(
                'OUR',
                style: headingTextStyle(context),
                softWrap: true,
              ),
              Text(
                ' LOCATION',
                style: headingsTextStyle(context),
                softWrap: true,
              ),
            ],
          ),
        ),
        Padding(
            padding: EdgeInsets.only(
                left: screenWidth * 0.05,
                top: screenHeight * 0.02,
                right: screenWidth * 0.05),
            child: Image.asset('assets/map.png')),
      ],
    );
  }
}

class AboutUsScreen extends StatefulWidget {
  const AboutUsScreen({super.key});

  @override
  State<AboutUsScreen> createState() => _AboutUsScreenState();
}
