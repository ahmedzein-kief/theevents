import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../styles/app_colors.dart';
import '../../styles/custom_text_styles.dart';

class CustomListView extends StatelessWidget {
  const CustomListView({
    super.key,
    required this.items,
    required this.brandName,
    required this.colors,
    required this.actualPrice,
    required this.offPrice,
    required this.standardPrice,
    required this.brandDescription,
    required this.screenWidth,
    required this.screenHeight,
  });
  final List<Map<String, dynamic>> items;
  final List<Color> colors;
  final double screenWidth;
  final double screenHeight;
  final String brandName;

  final String brandDescription;

  final String actualPrice;

  final String standardPrice;

  final String offPrice;

  @override
  Widget build(BuildContext context) => Expanded(
        child: Padding(
          padding: const EdgeInsets.only(top: 20),
          child: ListView.builder(
            scrollDirection: Axis.vertical,
            itemCount: items.length,
            physics: const BouncingScrollPhysics(),
            shrinkWrap: true,
            itemBuilder: (context, index) {
              final Color containerColor = colors[index % colors.length];
              final bool isAvailable = items[index]['available'];

              return Padding(
                padding: const EdgeInsets.only(bottom: 14),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    // color: Theme.of(context).colorScheme.onErrorContainer,
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
                    padding:
                        const EdgeInsets.only(bottom: 15, top: 15, left: 10),
                    child: IntrinsicHeight(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                color: containerColor,
                                width: screenWidth * 0.3,
                                height: screenHeight * 0.1,
                              ),
                            ],
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(brandName,
                                    style: wishTopItemStyle(context),),
                                Flexible(
                                  child: Text(
                                    brandDescription,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontSize: 8,
                                    ),
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(actualPrice,
                                        style: wishTopItemStyle(context),),
                                    const SizedBox(width: 10),
                                    Text(standardPrice,
                                        style: wishItemSalePrice(context),),
                                    const SizedBox(width: 10),
                                    Text(offPrice, style: wishItemSaleOff()),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    if (isAvailable)
                                      GestureDetector(
                                        onTap: () {},
                                        child: Container(
                                          color: Colors.black,
                                          height: 20,
                                          width: 80,
                                          child: const Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Padding(
                                                padding: EdgeInsets.all(5),
                                                child: Icon(
                                                  Icons.shopping_cart,
                                                  size: 13,
                                                  color: Colors.white,
                                                ),
                                              ),
                                              Text(
                                                'Add to cart',
                                                style: TextStyle(
                                                    fontSize: 10,
                                                    color: Colors.white,),
                                              ),
                                            ],
                                          ),
                                        ),
                                      )
                                    else
                                      GestureDetector(
                                        onTap: () {},
                                        child: Container(
                                          color: Colors.redAccent.shade100
                                              .withOpacity(0.8),
                                          height: 20,
                                          width: 80,
                                          child: const Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Text(
                                                'Notify me',
                                                style: TextStyle(
                                                    fontSize: 10,
                                                    color: Colors.white,),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    Padding(
                                      padding: const EdgeInsets.only(right: 10),
                                      child: Icon(
                                        CupertinoIcons.delete,
                                        size: 20,
                                        color: Colors.deepOrangeAccent
                                            .withOpacity(0.5),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      );
}
