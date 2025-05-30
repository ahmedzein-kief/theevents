import 'package:event_app/core/styles/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../models/product_packages_models/product_details_models.dart';
import '../../core/styles/custom_text_styles.dart';

class ProductInformationScreen extends StatefulWidget {
  final String? selectedImageUrl;
  final double screenWidth;
  final Function(String?) onImageUpdate;
  final ItemRecord record;
  final List<Images> images;
  final String offPercentage;
  final String productPrice;

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

  @override
  State<ProductInformationScreen> createState() => _ProductInformationScreenState();
}

class _ProductInformationScreenState extends State<ProductInformationScreen> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: widget.screenWidth * 0.06, left: widget.screenWidth * 0.06, right: widget.screenWidth * 0.06),
      child: Column(mainAxisSize: MainAxisSize.max, mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.start, children: [
        //Title:
        Wrap(
          children: [
            Text(
              widget.record.name,
              softWrap: true,
              style: productValueItemsStyle(context),
            ),
            if (widget.record.outOfStock)
              Text(
                ' (Out of stock)',
                softWrap: true,
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
              Text(
                "AED ${widget.productPrice}",
                softWrap: true,
                style: productValueItemsStyle(context),
              ),
              Text(
                " ${(widget.record.prices?.frontSalePrice ?? 0) < (widget.record.prices?.price ?? 0) ? widget.record.prices!.priceWithTaxes : ''}",
                softWrap: true,
                style: productPriceStyle(context),
              ),
              Padding(
                padding: EdgeInsets.only(right: 20),
                child: Text(
                  widget.offPercentage.isNotEmpty ? '${widget.offPercentage}%off' : '',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: Colors.orange, fontSize: 10),
                ),
              ),
            ],
          ),
        ),
        Text('including VAT', style: loginOrStyle(context)),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: Text('interest-free installment available.', style: productDescription(context)),
            )
            // ,Icon(Icons.ac_unit)
          ],
        ),
        /*Padding(
            padding: const EdgeInsets.only(top: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('MORE COLORS', style: productDescription(context)),
                Padding(
                  padding: const EdgeInsets.only(top: 15),
                  child: SizedBox(
                    height: 100,
                    child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        shrinkWrap: true,
                        physics: const BouncingScrollPhysics(),
                        itemCount: widget.images.length,
                        itemBuilder: (context, index) {
                          final image = widget.images[index];

                          return Padding(
                            padding: const EdgeInsets.only(bottom: 0, top: 5),
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  widget.onImageUpdate (image.small);
                                });
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(left: 10, right: 10),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(4),
                                  child: Container(
                                    decoration: BoxDecoration(border: Border.all(color: AppColors.productBackground)),
                                    child: CachedNetworkImage(
                                        imageUrl: image.small,
                                        height: widget.screenWidth * 0.40,
                                        width: widget.screenWidth * 0.25,
                                        fit: BoxFit.cover,
                                        placeholder: (BuildContext context, String url) {
                                          return Container(
                                            height: widget.screenWidth * 0.40,
                                            width: widget.screenWidth * 0.25,
                                            decoration: BoxDecoration(
                                              gradient: LinearGradient(
                                                colors: [AppColors.lightCoral, Colors.black.withOpacity(0.5)],
                                              ),
                                            ),
                                            child: const CupertinoActivityIndicator(
                                              color: Colors.black,
                                              radius: 10,
                                              animating: true,
                                            ),
                                          );
                                        }),
                                  ),
                                ),
                              ),
                            ),
                          );
                        }),
                  ),
                )
              ],
            ),
          )*/
      ]),
    );
  }
}
