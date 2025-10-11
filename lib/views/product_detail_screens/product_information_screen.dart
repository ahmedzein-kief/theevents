import 'package:event_app/core/helper/extensions/app_localizations_extension.dart';
import 'package:event_app/core/styles/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/constants/app_strings.dart'; // <--- IMPORT AppStrings
import '../../core/styles/custom_text_styles.dart';
import '../../core/widgets/price_row.dart';
import '../../models/product_packages_models/product_details_models.dart';

class ProductInformationScreen extends StatefulWidget {
  const ProductInformationScreen({
    super.key,
    this.selectedImageUrl,
    required this.screenWidth,
    required this.onImageUpdate,
    required this.record,
    required this.images,
    required this.offPercentage,
    required this.productPrice,
  });

  final String? selectedImageUrl;
  final double screenWidth;
  final Function(String?) onImageUpdate;
  final ItemRecord record;
  final List<Images> images;
  final String offPercentage;
  final String productPrice;

  @override
  State<ProductInformationScreen> createState() => _ProductInformationScreenState();
}

class _ProductInformationScreenState extends State<ProductInformationScreen> {
  @override
  Widget build(BuildContext context) => Padding(
        padding: EdgeInsets.only(
          top: widget.screenWidth * 0.06,
          left: widget.screenWidth * 0.06,
          right: widget.screenWidth * 0.06,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //Title:
            Wrap(
              spacing: 8.0,
              runSpacing: 4.0,
              children: [
                ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width - 40, // Account for padding
                  ),
                  child: Text(
                    widget.record.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    softWrap: true,
                    style: productValueItemsStyle(context),
                  ),
                ),
                if (widget.record.outOfStock)
                  Text(
                    AppStrings.outOfStockStr.tr,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.inter(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: AppColors.myRed,
                    ),
                  ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (widget.offPercentage.isNotEmpty) // ✅ Has Offer
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              '${widget.offPercentage}${AppStrings.percentOff.tr}',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: Colors.red,
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(width: 10),
                            PriceRow(
                              price: widget.productPrice,
                              currencySize: 16,
                              style: productValueItemsStyle(context),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Text(
                              AppStrings.was.tr,
                              style: productPriceStyle(context).copyWith(
                                decoration: TextDecoration.none,
                              ),
                            ),
                            PriceRow(
                              price:
                                  " ${(widget.record.prices?.frontSalePrice ?? 0) < (widget.record.prices?.price ?? 0) ? widget.record.prices!.priceWithTaxes : ''}",
                              currencySize: 11,
                              currencyColor: Colors.grey,
                              style: productPriceStyle(context).copyWith(
                                decoration: TextDecoration.lineThrough, // strike through
                              ),
                            ),
                          ],
                        ),
                      ],
                    )
                  else // ❌ No Offer → Only show price
                    PriceRow(
                      price: widget.productPrice,
                      currencySize: 16,
                      style: productValueItemsStyle(context),
                    ),
                ],
              ),
            ),

            const SizedBox(height: 10),
            Text(
              AppStrings.includingVAT.tr,
              style: loginOrStyle(context),
            ),
            // <--- REFACTORED
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                  child: Text(
                    AppStrings.interestFreeInstallment.tr, // <--- REFACTORED
                    style: productDescription(context),
                  ),
                ),
                // ,Icon(Icons.ac_unit)
              ],
            ),
            // Padding(
            //   padding: const EdgeInsets.only(top: 20),
            //   child: Column(
            //     mainAxisAlignment: MainAxisAlignment.start,
            //     crossAxisAlignment: CrossAxisAlignment.start,
            //     children: [
            //       Text('MORE COLORS', style: productDescription(context)),
            //       Padding(
            //         padding: const EdgeInsets.only(top: 15),
            //         child: SizedBox(
            //           height: 100,
            //           child: ListView.builder(
            //               scrollDirection: Axis.horizontal,
            //               shrinkWrap: true,
            //               physics: const BouncingScrollPhysics(),
            //               itemCount: widget.images.length,
            //               itemBuilder: (context, index) {
            //                 final image = widget.images[index];
            //
            //                 return Padding(
            //                   padding: const EdgeInsets.only(bottom: 0, top: 5),
            //                   child: GestureDetector(
            //                     onTap: () {
            //                       setState(() {
            //                         widget.onImageUpdate(image.small);
            //                       });
            //                     },
            //                     child: Padding(
            //                       padding: const EdgeInsets.only(left: 10, right: 10),
            //                       child: ClipRRect(
            //                         borderRadius: BorderRadius.circular(4),
            //                         child: Container(
            //                           decoration: BoxDecoration(border: Border.all(color: AppColors.productBackground)),
            //                           child: CachedNetworkImage(
            //                               imageUrl: image.small,
            //                               height: widget.screenWidth * 0.40,
            //                               width: widget.screenWidth * 0.25,
            //                               fit: BoxFit.cover,
            //                               placeholder: (BuildContext context, String url) {
            //                                 return Container(
            //                                   height: widget.screenWidth * 0.40,
            //                                   width: widget.screenWidth * 0.25,
            //                                   decoration: BoxDecoration(
            //                                     gradient: LinearGradient(
            //                                       colors: [AppColors.lightCoral, Colors.black.withAlpha((0.5 * 255).toInt())],
            //                                     ),
            //                                   ),
            //                                   child: const CupertinoActivityIndicator(
            //                                     color: Colors.black,
            //                                     radius: 10,
            //                                     animating: true,
            //                                   ),
            //                                 );
            //                               }),
            //                         ),
            //                       ),
            //                     ),
            //                   ),
            //                 );
            //               }),
            //         ),
            //       )
            //     ],
            //   ),
            // )
          ],
        ),
      );
}
