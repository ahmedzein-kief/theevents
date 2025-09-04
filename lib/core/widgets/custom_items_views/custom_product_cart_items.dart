import 'package:cached_network_image/cached_network_image.dart';
import 'package:event_app/core/styles/app_colors.dart';
import 'package:event_app/models/cart_items_models/cart_items_models.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../styles/custom_text_styles.dart';

class ProductCartItems extends StatelessWidget {
  const ProductCartItems({
    super.key,
    required this.brandName,
    required this.actualPrice,
    required this.offPrice,
    required this.itemS,
    required this.standardPrice,
    required this.brandDescription,
    required this.quantity,
    required this.imageUrl,
    required this.onAddPressed,
    required this.onSubtractPressed,
    required this.onDeletePressed,
    required this.attributes,
    required this.ceoData,
  });

  final String brandName;
  final String brandDescription;
  final String actualPrice;
  final String standardPrice;
  final String offPrice;
  final String quantity;
  final String itemS;
  final VoidCallback onAddPressed;
  final VoidCallback onSubtractPressed;
  final VoidCallback onDeletePressed;
  final String? imageUrl;
  final String attributes;
  final CartExtraOptionData? ceoData;

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.sizeOf(context).width;
    final double screenHeight = MediaQuery.of(context).size.height;
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 14),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: Theme.of(context).cardColor, // <-- updated
                boxShadow: [
                  BoxShadow(
                    offset: const Offset(0, 1),
                    blurRadius: 0.5,
                    spreadRadius: 0.5,
                    color: Theme.of(context).shadowColor.withOpacity(0.1), // theme-aware shadow
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.only(bottom: 15, top: 15, left: 10),
                child: IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    // crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: SizedBox(
                              width: screenWidth * 0.3,
                              height: screenHeight * 0.1,
                              child: CachedNetworkImage(
                                imageUrl: imageUrl ?? '',
                                fit: BoxFit.contain,
                                width: screenWidth * 0.3,
                                height: screenHeight * 0.1,
                                placeholder: (BuildContext context, String url) => Container(
                                  height: MediaQuery.sizeOf(context).height * 0.28,
                                  width: double.infinity,
                                  color: Theme.of(context).colorScheme.surfaceContainerHighest, // theme-aware
                                  child: Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      Image.asset(
                                        'assets/placeholder.png',
                                        fit: BoxFit.cover,
                                        height: MediaQuery.sizeOf(context).height * 0.28,
                                        width: double.infinity,
                                        color: Theme.of(context).brightness == Brightness.dark
                                            ? Colors.white.withOpacity(0.2)
                                            : null,
                                        colorBlendMode: BlendMode.modulate,
                                      ),
                                      const CupertinoActivityIndicator(
                                        radius: 16,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(brandName, style: wishTopItemStyle(context)),
                            Text(
                              brandDescription,
                              maxLines: 1,
                              style: soldByStyle(context),
                            ),
                            if (attributes.isNotEmpty)
                              Text(
                                attributes,
                                maxLines: 1,
                                style: soldByStyle(context),
                              ),
                            if (ceoData != null)
                              Expanded(
                                child: SingleChildScrollView(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: ceoData?.optionCartValue?.entries
                                            .map(
                                              (entry) => Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  ...entry.value.map(
                                                    (option) => Row(
                                                      children: [
                                                        Text(
                                                          '${ceoData?.optionInfo?[entry.key]}: ',
                                                          style: optionTitle(
                                                            context,
                                                          ),
                                                        ),
                                                        Text(
                                                          '${option.optionValue}',
                                                          style: const TextStyle(
                                                            fontSize: 12,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  const SizedBox(height: 2),
                                                ],
                                              ),
                                            )
                                            .toList() ??
                                        [
                                          const Text('No data available'),
                                        ],
                                  ),
                                ),
                              ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Text(
                                    actualPrice,
                                    style: wishTopItemStyle(context),
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    standardPrice,
                                    style: wishItemSalePrice(context),
                                  ),
                                ),
                                Expanded(
                                  child: Text(offPrice, style: wishItemSaleOff()),
                                ),
                              ],
                            ),
                            Text(quantity, style: cartItemQty(context)),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Material(
                              color: Colors.transparent,
                              child: InkResponse(
                                onTap: onAddPressed,
                                child: Container(
                                  height: 22,
                                  width: 22,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Theme.of(context).dividerColor,
                                      width: 0.2,
                                    ),
                                  ),
                                  child: const Icon(Icons.add, size: 15),
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                vertical: screenHeight * 0.002,
                              ),
                              child: Text(itemS, style: cartItemQty(context)),
                            ),
                            Material(
                              color: Colors.transparent,
                              child: InkResponse(
                                onTap: onSubtractPressed,
                                child: Container(
                                  height: 22,
                                  width: 22,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Theme.of(context).dividerColor,
                                      width: 0.2,
                                    ),
                                  ),
                                  child: const Icon(
                                    CupertinoIcons.minus,
                                    size: 15,
                                  ),
                                ),
                              ),
                            ),
                            // const SizedBox(height: 8),
                            GestureDetector(
                              onTap: onDeletePressed,
                              child: Padding(
                                padding: EdgeInsets.only(top: screenHeight * 0.01),
                                child: const Icon(
                                  CupertinoIcons.delete,
                                  color: AppColors.peachyPink,
                                  size: 24,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          // },
          // ),
        ],
      ),
    );
  }
}
