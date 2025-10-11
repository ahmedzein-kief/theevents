import 'package:event_app/core/helper/extensions/app_localizations_extension.dart';
import 'package:event_app/core/styles/app_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../core/constants/app_strings.dart';
import '../../../core/styles/custom_text_styles.dart';
import '../../../core/widgets/custom_slider_route.dart';
import '../../cart_screens/order_cancel_screen.dart';

class OrderConfirmationScreen extends StatefulWidget {
  const OrderConfirmationScreen({super.key, required this.onPrevious});

  final VoidCallback onPrevious;

  @override
  State<OrderConfirmationScreen> createState() => _OrderConfirmationScreenState();
}

class _OrderConfirmationScreenState extends State<OrderConfirmationScreen> {
  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    return Center(
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Container(
                color: AppColors.paleSkyBlue,
                child: Column(
                  children: [
                    Container(
                      width: double.infinity,
                      color: AppColors.paleSkyBlue,
                      child: Column(
                        children: [
                          const Icon(CupertinoIcons.gift_fill),
                          Text(
                            AppStrings.orderPlaced.tr,
                            style: cartTextStyle(context),
                          ), // <--- REFACTORED
                          Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: Column(
                              children: [
                                Text(
                                  '${AppStrings.orderNoPrefix.tr}100000',
                                  style: orderPlaceText(
                                    context,
                                  ),
                                ), // <--- REFACTORED
                                Text(
                                  '${AppStrings.orderDatePrefix.tr}25 July 2024',
                                  style: orderPlaceText(
                                    context,
                                  ),
                                ), // <--- REFACTORED
                                Text(
                                  '${AppStrings.estimatedDeliveryPrefix.tr}25 July 2024',
                                  style: orderExpectDateText(
                                    context,
                                  ),
                                ), // <--- REFACTORED
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                              left: 20,
                              right: 20,
                              top: 20,
                            ),
                            child: Material(
                              shadowColor: Colors.black,
                              elevation: 15,
                              color: Colors.white,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                  top: 20,
                                  left: 10,
                                  right: 10,
                                ),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '2${AppStrings.itemsSuffix.tr}',
                                      style: itemsText(
                                        context,
                                      ),
                                    ), // <--- REFACTORED
                                    Padding(
                                      padding: const EdgeInsets.only(top: 10),
                                      child: Container(
                                        height: 0.2,
                                        color: Colors.grey,
                                        width: double.infinity,
                                      ),
                                    ),
                                    _buildItemList(context),
                                    _buildItemList(context),
                                    _amountSection(context),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.04),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Widget _buildItemList(BuildContext context) {
  final double screenHeight = MediaQuery.sizeOf(context).height;
  final double screenWidth = MediaQuery.sizeOf(context).width;
  return Container(
    margin: EdgeInsets.only(bottom: screenHeight * 0.02),
    decoration: BoxDecoration(
      color: AppColors.itemContainerBack,
      boxShadow: [
        BoxShadow(
          offset: const Offset(0, 1),
          blurRadius: 0.5,
          spreadRadius: 0.5,
          color: Colors.white.withAlpha((0.3 * 255).toInt()),
        ),
      ],
    ),
    child: Padding(
      padding: const EdgeInsets.only(top: 20, left: 10, bottom: 20),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Container(
                    // color: Colors.red,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/product.png'),
                        fit: BoxFit.contain,
                      ),
                    ),
                    width: screenWidth * 0.2,
                  ),
                ),
              ],
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 8),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          RichText(
                            text: TextSpan(
                              text: AppStrings.itemBrandPrefix.tr,
                              // Main text
                              style: itemsTitleText(context),
                              // Default text style
                              children: <TextSpan>[
                                TextSpan(
                                  text: AppStrings.itemColor.tr, // Additional text span
                                  style: itemsColorText(context),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            AppStrings.actualPrice.tr,
                            style: itemsTitleText(context),
                          ), // <--- REFACTORED
                          Padding(
                            padding: const EdgeInsets.only(left: 5),
                            child: Text(
                              AppStrings.standardPrice.tr,
                              style: wishItemSalePrice(
                                context,
                              ),
                            ), // <--- REFACTORED
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 5),
                            child: Text(
                              AppStrings.fiftyPercentOffPrice.tr,
                              style: wishItemSaleOff(),
                            ), // <--- REFACTORED
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Row(
                        children: [
                          RichText(
                            text: TextSpan(
                              text: AppStrings.colorLabel.tr,
                              // Main text
                              style: itemsTypeText(context),
                              // Default text style
                              children: <TextSpan>[
                                TextSpan(
                                  text: AppStrings.itemColor.tr, // Additional text span
                                  style: itemsColorText(context),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Row(
                        children: [
                          RichText(
                            text: TextSpan(
                              text: AppStrings.sizeLabel.tr,
                              // Main text
                              style: itemsTypeText(context),
                              // Default text style
                              children: <TextSpan>[
                                TextSpan(
                                  text: AppStrings.itemColor.tr, // Additional text span
                                  style: itemsColorText(context),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Row(
                        children: [
                          RichText(
                            text: TextSpan(
                              text: AppStrings.colorLabel.tr,
                              // Main text
                              style: itemsTypeText(context),
                              // Default text style
                              children: <TextSpan>[
                                TextSpan(
                                  text: AppStrings.itemUKSize.tr, // Additional text span
                                  style: itemsColorText(context),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Row(
                        children: [
                          RichText(
                            text: TextSpan(
                              text: AppStrings.quantityLabel.tr,
                              // Main text
                              style: itemsTypeText(context),
                              // Default text style
                              children: <TextSpan>[
                                TextSpan(
                                  text: AppStrings.itemQuantityValue.tr, // Additional text span
                                  style: itemsColorText(context),
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
    ),
  );
}

///  AMOUNT SECTION  - - - - - - - - - - - - - - - - - - - -  - - - - - - - - - - - -

Widget _amountSection(BuildContext context) {
  final double screenHeight = MediaQuery.sizeOf(context).height;
  final double screenWidth = MediaQuery.sizeOf(context).width;

  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 10),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // SUB-TOTAL
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(AppStrings.subTotal.tr, style: totalPriceStyle(context)),
            Text('AED-1060', style: totalPriceStyle(context)),
          ],
        ),
        // DISCOUNT
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              AppStrings.discount.tr.toUpperCase(),
              style: totalPriceStyle(context),
            ),
            Text('AED-1060', style: totalPriceStyle(context)),
          ],
        ),
        // TAX
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              AppStrings.tax.tr.toUpperCase(),
              style: totalPriceStyle(context),
            ),
            Text('AED-1060', style: totalPriceStyle(context)),
          ],
        ),
        // DELIVERY
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(AppStrings.delivery.tr, style: totalPriceStyle(context)),
            Text('AED-1060', style: totalPriceStyle(context)),
          ],
        ),
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 15),
          child: Divider(height: 0.2, color: Colors.grey),
        ),
        // TOTAL
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(AppStrings.total.tr, style: totalStyle(context)),
            Text('1060', style: totalPriceStyle(context)),
          ],
        ),
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 15),
          child: Divider(height: 0.2, color: Colors.grey),
        ),
        // DELIVERY DETAILS
        Text(AppStrings.deliveryDetails.tr, style: totalStyle(context)),
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 15),
          child: Divider(height: 0.2, color: Colors.grey),
        ),
        Text(
          AppStrings.deliveryMethod.tr,
          style: deliveryMethodsStyle(context),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Text(
            AppStrings.standardDelivery.tr,
            style: standardStyle(context),
          ),
        ),
        Text(AppStrings.deliveryAddress.tr, style: addressStyle(context)),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Container(
            height: screenHeight * 0.2,
            color: Colors.red,
            width: screenWidth * 0.4,
          ),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 12),
          child: Divider(height: 0.2, color: Colors.grey),
        ),
        // PAYMENT DETAILS
        Text(AppStrings.paymentDetails.tr, style: totalStyle(context)),
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 12),
          child: Divider(height: 0.2, color: Colors.grey),
        ),
        Text(AppStrings.paymentType.tr, style: totalStyle(context)),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Row(
            children: [
              Container(
                color: Colors.green,
                height: screenHeight * 0.05,
                width: screenWidth * 0.15,
              ),
              Text(AppStrings.mastercard.tr, style: standardStyle(context)),
            ],
          ),
        ),
        const Divider(height: 0.2, color: Colors.grey),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(AppStrings.changedYourMind.tr, style: totalStyle(context)),
            ],
          ),
        ),
        const Divider(height: 0.2, color: Colors.grey),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppStrings.cancellingTheOrder.tr,
                style: addressStyle(context),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Text(
                  AppStrings.cancellationInfo.tr,
                  style: standardStyle(context),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset('assets/shipping.png', color: Colors.black),
                    Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            AppStrings.standardDelivery.tr,
                            style: standardTextStyle(context),
                          ),
                          Text(
                            AppStrings.cancelWithinOneHour.tr,
                            style: standardStyle(context),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  AppStrings.cancellationInfo.tr,
                  style: standardStyle(context),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          SlidePageRoute(page: const OrderCancelScreen()),
                        );
                      },
                      child: Container(
                        margin: const EdgeInsets.only(top: 15),
                        padding: EdgeInsets.all(screenWidth * 0.02),
                        decoration: const BoxDecoration(
                          color: Colors.redAccent,
                        ),
                        child: Text(
                          AppStrings.returnOrder.tr,
                          style: returnStyle(context),
                        ),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Container(
                      margin: const EdgeInsets.only(top: 15, bottom: 5),
                      padding: EdgeInsets.all(screenWidth * 0.02),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Theme.of(context).colorScheme.onPrimary.withAlpha((0.6 * 255).toInt()),
                          width: 0.5,
                        ),
                      ),
                      child: Text(
                        AppStrings.viewOrderUppercase.tr,
                        style: addressStyle(context),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
