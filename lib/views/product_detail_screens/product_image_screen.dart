import 'package:cached_network_image/cached_network_image.dart';
import 'package:event_app/models/product_packages_models/product_details_models.dart';
import 'package:event_app/views/product_detail_screens/full_screen_image_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../core/styles/app_colors.dart';
import '../../core/styles/custom_text_styles.dart';

class ProductImageScreen extends StatefulWidget {
  const ProductImageScreen({
    super.key,
    this.selectedImageUrl,
    required this.screenWidth,
    required this.onImageUpdate,
    required this.record,
    required this.images,
  });
  final String? selectedImageUrl;
  final double screenWidth;
  final Function(String?) onImageUpdate;
  final ItemRecord record;
  final List<Images> images;

  @override
  State<ProductImageScreen> createState() => _ProductImageScreenState();
}

class _ProductImageScreenState extends State<ProductImageScreen> {
  @override
  Widget build(BuildContext context) => Material(
        elevation: 3,
        shadowColor: Colors.black,
        child: Container(
          height: widget.screenWidth * 0.80,
          decoration: const BoxDecoration(color: AppColors.productBackground),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(left: 0, right: 0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(5),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => FullScreenImageView(
                                    imageUrl: widget.selectedImageUrl),
                              ),
                            );
                          },
                          child: CachedNetworkImage(
                            imageUrl: widget.selectedImageUrl ?? '',
                            height: widget.screenWidth * 0.55,
                            width: widget.screenWidth * 0.6,
                            fit: BoxFit.fill,
                            errorWidget: (context, object, error) =>
                                Image.asset(
                              'assets/placeholder.png', // Replace with your actual image path
                              fit: BoxFit.cover, // Adjust fit if needed
                              height: MediaQuery.sizeOf(context).height * 0.28,
                              width: double.infinity,
                            ),
                            errorListener: (object) {
                              Image.asset(
                                'assets/placeholder.png', // Replace with your actual image path
                                fit: BoxFit.cover, // Adjust fit if needed
                                height:
                                    MediaQuery.sizeOf(context).height * 0.28,
                                width: double.infinity,
                              );
                            },
                            placeholder: (BuildContext context, String url) =>
                                Container(
                              height: MediaQuery.sizeOf(context).height * 0.28,
                              width: double.infinity,
                              color: Colors.blueGrey[300], // Background color
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  Image.asset(
                                    'assets/placeholder.png', // Replace with your actual image path
                                    fit: BoxFit.cover, // Adjust fit if needed
                                    height: MediaQuery.sizeOf(context).height *
                                        0.28,
                                    width: double.infinity,
                                  ),
                                  const CupertinoActivityIndicator(
                                    radius: 16, // Adjust size of the loader
                                    animating: true,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: widget.screenWidth * 0.55,
                        width: widget.screenWidth * 0.18,
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: widget.images.length,
                                itemBuilder: (context, index) {
                                  final image = widget.images[index];

                                  return Padding(
                                    padding: const EdgeInsets.only(
                                        bottom: 0, top: 5),
                                    child: GestureDetector(
                                      onTap: () {
                                        widget.onImageUpdate(image.small);
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(4),
                                            border: Border.all(
                                                color: Colors.black,
                                                width: 0.2)),
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(4),
                                          child: CachedNetworkImage(
                                            imageUrl: image.small,
                                            height: widget.screenWidth * 0.18,
                                            width: widget.screenWidth,
                                            fit: BoxFit.cover,
                                            errorListener: (object) {
                                              Image.asset(
                                                'assets/placeholder.png', // Replace with your actual image path
                                                fit: BoxFit
                                                    .cover, // Adjust fit if needed
                                                height:
                                                    MediaQuery.sizeOf(context)
                                                            .height *
                                                        0.28,
                                                width: double.infinity,
                                              );
                                            },
                                            errorWidget:
                                                (context, object, error) =>
                                                    Image.asset(
                                              'assets/placeholder.png', // Replace with your actual image path
                                              fit: BoxFit
                                                  .cover, // Adjust fit if needed
                                              height: MediaQuery.sizeOf(context)
                                                      .height *
                                                  0.28,
                                              width: double.infinity,
                                            ),
                                            placeholder: (BuildContext context,
                                                    String url) =>
                                                Container(
                                              height: MediaQuery.sizeOf(context)
                                                      .height *
                                                  0.28,
                                              width: double.infinity,
                                              color: Colors.blueGrey[
                                                  300], // Background color
                                              child: Stack(
                                                alignment: Alignment.center,
                                                children: [
                                                  Image.asset(
                                                    'assets/placeholder.png', // Replace with your actual image path
                                                    fit: BoxFit
                                                        .cover, // Adjust fit if needed
                                                    height: MediaQuery.sizeOf(
                                                                context)
                                                            .height *
                                                        0.28,
                                                    width: double.infinity,
                                                  ),
                                                  const CupertinoActivityIndicator(
                                                    radius:
                                                        16, // Adjust size of the loader
                                                    animating: true,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        left: widget.screenWidth * 0.06,
                        right: widget.screenWidth * 0.06),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(2),
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey)),
                          child: Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 5),
                                child: Text(
                                  widget.record.review!.reviewsCount.toString(),
                                  maxLines: 1,
                                  style: ratings(context),
                                ),
                              ),
                              const Icon(Icons.star,
                                  size: 13, color: Colors.green),
                              Container(
                                height: 15,
                                width: 1,
                                color: AppColors.semiTransparentBlack,
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 5),
                              ),
                              Text(
                                // '5k ratings',
                                '${widget.record.review!.reviewsCount.toString()} k ratings',
                                maxLines: 1,
                                style: ratings(context),
                              ),
                            ],
                          ),
                        ),
                        /*Container(
                        padding:  EdgeInsets.all(2),
                        decoration: BoxDecoration(border: Border.all(color: Colors.grey)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                             Icon(CupertinoIcons.viewfinder_circle_fill, size: 13, color: Colors.grey),
                            Text(
                              "View Similar",
                              maxLines: 1,
                              style: ratings(context),
                            ),
                          ],
                        ),
                      ),*/
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
}
