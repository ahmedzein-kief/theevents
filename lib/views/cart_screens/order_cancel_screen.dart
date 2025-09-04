import 'package:event_app/core/constants/app_strings.dart';
import 'package:event_app/core/helper/extensions/app_localizations_extension.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/styles/app_colors.dart';
import '../../core/styles/custom_text_styles.dart';

class OrderCancelScreen extends StatefulWidget {
  const OrderCancelScreen({super.key});

  @override
  State<OrderCancelScreen> createState() => _OrderCancelScreenState();
}

class _OrderCancelScreenState extends State<OrderCancelScreen> {
  @override
  Widget build(BuildContext context) {
    final dynamic screenWidth = MediaQuery.sizeOf(context).width;
    final dynamic screenHeight = MediaQuery.sizeOf(context).height;
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: screenWidth * 0.02,
                  vertical: screenHeight * 0.02,),
              child: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                  padding: const EdgeInsets.all(5),
                  child: Row(
                    children: [
                      const Icon(Icons.arrow_back_ios),
                      Text(AppStrings.orders.tr,
                          style: GoogleFonts.inter(
                              color: Theme.of(context).colorScheme.onPrimary,
                              fontWeight: FontWeight.w400,),),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      height: 1,
                      width: screenWidth,
                      color: Theme.of(context)
                          .colorScheme
                          .onPrimary
                          .withOpacity(0.08),
                    ),
                    SizedBox(height: screenHeight * 0.04),
                    Container(
                      height: 80,
                      width: 80,
                      decoration: const BoxDecoration(
                          color: Colors.green, shape: BoxShape.circle,),
                      child: Icon(
                        Icons.check,
                        size: 55,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    Text(AppStrings.ordersCancelled.tr,
                        style: productValueItemsStyle(context),),
                    SizedBox(height: screenHeight * 0.04),
                    Container(
                      height: 1,
                      width: screenWidth,
                      color: Theme.of(context)
                          .colorScheme
                          .onPrimary
                          .withOpacity(0.08),
                    ),
                    Material(
                      elevation: 10,
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: screenWidth * 0.02,
                            vertical: screenHeight * 0.02,),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Align(
                                alignment: Alignment.centerLeft,
                                child: Text(AppStrings.oneItemCancelled.tr,
                                    style: productValueItemsStyle(context),),),
                            SizedBox(height: screenHeight * 0.05),
                            Container(
                              color: AppColors.paleSkyBlue,
                              height: 100,
                              width: screenWidth,
                              child: Row(
                                children: [
                                  SizedBox(width: screenWidth * 0.02),
                                  Container(
                                      color: Colors.blue,
                                      height: 80,
                                      width: 60,),
                                  SizedBox(width: screenWidth * 0.02),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(AppStrings.perfume.tr,
                                          style: GoogleFonts.inter(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w800,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .onPrimary,),),
                                      Text(
                                        AppStrings.productDescription.tr,
                                        style: GoogleFonts.inter(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w400,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onPrimary,),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: screenHeight * 0.05),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  height: 22,
                                  width: 22,
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(color: Colors.green),),
                                  child: const Center(
                                      child: Icon(Icons.check,
                                          color: Colors.green, size: 16,),),
                                ),
                                SizedBox(width: screenWidth * 0.02),
                                Expanded(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        AppStrings.refundDetails.tr,
                                        style: GoogleFonts.inter(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w700,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onPrimary
                                                .withOpacity(0.6),),
                                      ),
                                      SizedBox(height: screenHeight * 0.01),
                                      Text(AppStrings.refundNotApplicable.tr),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: screenHeight * 0.04),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  height: 22,
                                  width: 22,
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(color: Colors.green),),
                                  child: const Center(
                                      child: Icon(Icons.check,
                                          color: Colors.green, size: 16,),),
                                ),
                                SizedBox(width: screenHeight * 0.02),
                                Expanded(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        AppStrings.refundDetails.tr,
                                        style: GoogleFonts.inter(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w700,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onPrimary
                                                .withOpacity(0.6),),
                                      ),
                                      SizedBox(height: screenHeight * 0.01),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.04),
                    Container(
                      height: 50,
                      width: screenWidth * 0.5,
                      margin: const EdgeInsets.all(10),
                      color: AppColors.peachyPink,
                      child: Align(
                        alignment: Alignment.center,
                        child: Text(AppStrings.refund.tr,
                            style: GoogleFonts.inter(
                                color: Theme.of(context).colorScheme.primary,),),
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
}
