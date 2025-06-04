import 'package:event_app/core/styles/app_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../core/styles/custom_text_styles.dart';
import '../../../core/widgets/custom_slider_route.dart';
import '../../cart_screens/order_cancel_screen.dart';

class OrderConfirmationScreen extends StatefulWidget {
  const OrderConfirmationScreen({super.key, required this.onPrevious});
  final VoidCallback onPrevious;

  @override
  State<OrderConfirmationScreen> createState() =>
      _OrderConfirmationScreenState();
}

class _OrderConfirmationScreenState extends State<OrderConfirmationScreen> {
  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.sizeOf(context).width;
    final double screenHeight = MediaQuery.sizeOf(context).height;
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
                          // Icon(Icons.card_giftcard),
                          Text('Order Placed!', style: cartTextStyle(context)),
                          Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: Column(
                              children: [
                                Text('Order No:100000',
                                    style: orderPlaceText(context)),
                                Text('Order date:25 July 2024',
                                    style: orderPlaceText(context)),
                                Text('Estimated delivery date:25 July 2024',
                                    style: orderExpectDateText(context)),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 20, right: 20, top: 20),
                            child: Material(
                              shadowColor: Colors.black,
                              elevation: 15,
                              color: Colors.white,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    top: 20, left: 10, right: 10),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('2 Items', style: itemsText(context)),
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
    // );
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
          color: Colors.white.withOpacity(0.3),
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
                              text: 'Adidas: ',
                              // Main text
                              style: itemsTitleText(context),
                              // Default text style
                              children: <TextSpan>[
                                TextSpan(
                                  text: 'White', // Additional text span
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
                          Text('actualPrice', style: itemsTitleText(context)),
                          Padding(
                            padding: const EdgeInsets.only(left: 5),
                            child: Text('standardPrice',
                                style: wishItemSalePrice(context)),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 5),
                            child:
                                Text('50%offPrice', style: wishItemSaleOff()),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Row(
                        children: [
                          RichText(
                            text: TextSpan(
                              text: 'Color: ',
                              // Main text
                              style: itemsTypeText(context),
                              // Default text style
                              children: <TextSpan>[
                                TextSpan(
                                  text: 'White', // Additional text span
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
                              text: 'Size: ',
                              // Main text
                              style: itemsTypeText(context),
                              // Default text style
                              children: <TextSpan>[
                                TextSpan(
                                  text: 'White', // Additional text span
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
                              text: 'Color: ',
                              // Main text
                              style: itemsTypeText(context),
                              // Default text style
                              children: <TextSpan>[
                                TextSpan(
                                  text: 'UK42', // Additional text span
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
                              text: 'QTY: ',
                              // Main text
                              style: itemsTypeText(context),
                              // Default text style
                              children: <TextSpan>[
                                TextSpan(
                                  text: '2', // Additional text span
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
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('SUB-TOTAL:', style: totalPriceStyle(context)),
            Text('AED-1060', style: totalPriceStyle(context)),
          ],
        ),
        // DISCOUNT
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('DISCOUNT', style: totalPriceStyle(context)),
            Text('AED-1060', style: totalPriceStyle(context)),
          ],
        ),
        // TAX
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('TAX', style: totalPriceStyle(context)),
            Text('AED-1060', style: totalPriceStyle(context)),
          ],
        ),
        // DELIVERY
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('DELIVERY', style: totalPriceStyle(context)),
            Text('AED-1060', style: totalPriceStyle(context)),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(top: 15, bottom: 15),
          child: Container(
            height: 0.2,
            color: Colors.grey,
            width: double.infinity,
          ),
        ),
        // TOTAL SECTION
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('TOTAL', style: totalStyle(context)),
            Text('1060', style: totalPriceStyle(context)),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(top: 15, bottom: 15),
          child: Container(
            height: 0.2,
            color: Colors.grey,
            width: double.infinity,
          ),
        ),
        Text('DELIVERY DETAILS', style: totalStyle(context)),
        Padding(
          padding: const EdgeInsets.only(top: 15, bottom: 15),
          child: Container(
            height: 0.2,
            color: Colors.grey,
            width: double.infinity,
          ),
        ),
        Text('DELIVERY METHOD', style: deliveryMethodsStyle(context)),
        Padding(
            padding: const EdgeInsets.only(top: 8, bottom: 8),
            child: Text('Standard Delivery', style: standardStyle(context))),
        Text('Delivery Address', style: addressStyle(context)),

        Padding(
          padding: const EdgeInsets.only(top: 12, bottom: 12),
          child: Container(
            height: screenHeight * 0.2,
            color: Colors.red,
            width: screenWidth * 0.4,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 12, bottom: 12),
          child: Container(
            height: 0.2,
            color: Colors.grey,
            width: double.infinity,
          ),
        ),
        Text('PAYMENT DETAILS', style: totalStyle(context)),
        Padding(
          padding: const EdgeInsets.only(top: 12, bottom: 12),
          child: Container(
            height: 0.2,
            color: Colors.grey,
            width: double.infinity,
          ),
        ),
        Text('PAYMENT TYPE', style: totalStyle(context)),

        Padding(
          padding: const EdgeInsets.only(top: 12, bottom: 12),
          child: Row(
            children: [
              Container(
                color: Colors.green,
                height: screenHeight * 0.05,
                width: screenWidth * 0.15,
              ),
              Text('MASTERCARD', style: standardStyle(context)),
            ],
          ),
        ),

        Container(
          height: 0.2,
          color: Colors.grey,
          width: double.infinity,
        ),

        Padding(
          padding: const EdgeInsets.only(top: 12, bottom: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [Text('CHANGED TOUR MIND?', style: totalStyle(context))],
          ),
        ),

        Container(
          height: 0.2,
          color: Colors.grey,
          width: double.infinity,
        ),

        Padding(
          padding: const EdgeInsets.only(top: 12, bottom: 12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('CANCELING THE ORDER', style: addressStyle(context)),
              Padding(
                padding: const EdgeInsets.only(top: 12, bottom: 8),
                child: Text(
                    'We are not able to cancel the order but you need to then no way? ',
                    style: standardStyle(context)),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 1, bottom: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset('assets/shipping.png', color: Colors.black),
                    Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Standard Delivery',
                            style: standardTextStyle(context),
                          ),
                          Text('Cancel within one hour',
                              style: standardStyle(context)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                      'We are not able to cancel the order but you need to then no way?',
                      style: standardStyle(context))),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(context,
                            SlidePageRoute(page: const OrderCancelScreen()));

                        // Navigator.push(context, MaterialPageRoute(builder: (context) => OrderCancelScreen()));
                      },
                      child: Container(
                        margin: const EdgeInsets.only(top: 15),
                        padding: EdgeInsets.all(screenWidth * 0.02),
                        decoration: const BoxDecoration(
                          color: Colors.redAccent,
                        ),
                        child:
                            Text('RETURN ORDER', style: returnStyle(context)),
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
                            color: Theme.of(context)
                                .colorScheme
                                .onPrimary
                                .withOpacity(0.6),
                            width: 0.5),
                      ),
                      child: Text('VIEW ORDER', style: addressStyle(context)),
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
