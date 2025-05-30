import 'package:flutter/material.dart';

import '../../styles/custom_text_styles.dart';

class ResponsiveProductCard extends StatefulWidget {
  final String? imageUrl;
  final int reviewsCount;
  final String frontSalePriceWithTaxes;
  final bool isHeartObscure;
  final VoidCallback? onHeartTap;
  final String? name;
  final String storeName;
  final double? price;
  final String? priceWithTaxes;
  final double? discountPercentage;

  const ResponsiveProductCard({
    Key? key,
    this.imageUrl,
    required this.reviewsCount,
    required this.frontSalePriceWithTaxes,
    required this.isHeartObscure,
    this.onHeartTap,
    this.name,
    required this.storeName,
    this.price,
    this.priceWithTaxes,
    this.discountPercentage,
  }) : super(key: key);

  @override
  State<ResponsiveProductCard> createState() => _ResponsiveProductCardState();
}

class _ResponsiveProductCardState extends State<ResponsiveProductCard> {
  bool _isClicked = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              flex: 2,
              child: Stack(
                children: [
                  LayoutBuilder(
                    builder: (context, constraints) {
                      return Image.network(
                        widget.imageUrl ?? 'https://api.staging.theevents.ae/storage/products/tobacco-rose-600x600.png',
                        fit: BoxFit.cover,
                        height: constraints.maxHeight,
                        width: constraints.maxWidth,
                        errorBuilder: (context, error, stackTrace) {
                          return Image.asset(
                            'assets/vendor_profile.jpg',
                            fit: BoxFit.cover,
                            height: constraints.maxHeight,
                            width: constraints.maxWidth,
                          );
                        },
                      );
                    },
                  ),
                  Positioned(
                    left: 5,
                    bottom: 5,
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      color: Colors.white,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 2),
                            child: Text(
                              widget.reviewsCount.toString(),
                              maxLines: 1,
                              style: ratings(context),
                            ),
                          ),
                          const Icon(Icons.star, size: 13, color: Colors.yellow),
                          Container(
                            height: 15,
                            width: 1,
                            color: Colors.black.withOpacity(0.5),
                            margin: const EdgeInsets.symmetric(horizontal: 5),
                          ),
                          Text(
                            widget.frontSalePriceWithTaxes,
                            maxLines: 1,
                            style: ratings(context),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                      right: 5,
                      top: 5,
                      child: GestureDetector(
                        onTap: () {},
                        child: Container(
                            padding: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              color: _isClicked ? Colors.green : Colors.white,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.shopping_cart_outlined, size: 20)),
                      )),
                  Positioned(
                    bottom: 5,
                    right: 5,
                    child: GestureDetector(
                      onTap: widget.onHeartTap,
                      child: Icon(
                        widget.isHeartObscure ? Icons.favorite : Icons.favorite_border,
                        size: 25,
                        color: widget.isHeartObscure ? Colors.red : Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 5),
                    child: Text(
                      widget.name ?? "",
                      maxLines: 1,
                      style: productsName(context),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 5),
                    child: Text(
                      widget.storeName,
                      maxLines: 1,
                      style: productsName(context),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Text(
                            widget.price != null ? 'AED ${widget.price}' : '',
                            maxLines: 1,
                            style: priceStyle(context),
                          ),
                        ),
                        Expanded(
                          child: Align(
                            alignment: Alignment.center,
                            child: Text(
                              widget.priceWithTaxes ?? '',
                              maxLines: 1,
                              style: standardPriceStyle(context),
                            ),
                          ),
                        ),
                        const Expanded(
                          child: Align(
                            alignment: Alignment.bottomRight,
                            child: Text(
                              "50%off",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: Colors.orange,
                                fontSize: 10,
                              ),
                            ),
                          ),
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
    );
  }
}
