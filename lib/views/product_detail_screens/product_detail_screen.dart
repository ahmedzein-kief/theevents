import 'package:event_app/core/utils/custom_toast.dart';
import 'package:event_app/views/base_screens/base_app_bar.dart';
import 'package:event_app/views/home_screens_shortcode/shorcode_featured_brands/featured_brands_items_screen.dart';
import 'package:event_app/views/product_detail_screens/customer_reviews_view.dart';
import 'package:event_app/views/product_detail_screens/extra_product_options.dart';
import 'package:event_app/views/product_detail_screens/product_actions.dart';
import 'package:event_app/views/product_detail_screens/product_attributes_screen.dart';
import 'package:event_app/views/product_detail_screens/product_image_screen.dart';
import 'package:event_app/views/product_detail_screens/product_information_screen.dart';
import 'package:event_app/views/product_detail_screens/product_realted_items.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_strings.dart';
import '../../core/styles/app_colors.dart';
import '../../core/styles/custom_text_styles.dart';
import '../../models/product_packages_models/product_attributes_model.dart';
import '../../models/product_variation_model.dart';
import '../../provider/product_package_provider/product_details_provider.dart';
import '../../provider/shortcode_fresh_picks_provider/fresh_picks_provider.dart';
import '../../provider/store_provider/brand_store_provider.dart';
import '../../provider/wishlist_items_provider/wishlist_provider.dart';

class ProductDetailScreen extends StatefulWidget {
  const ProductDetailScreen({super.key, required this.slug});
  final slug;

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  int cartItemQuantity = 1;
  String productID = '';
  String productPrice = '';
  String updateProductAttributePrice = '';
  int productVariationId = -1;
  bool actionLoading = false;
  String? _selectedImageUrl;
  List<Map<String, dynamic>?> selectedAttributes = [];
  bool isAttributesChanged = false;
  List<int> unavailableAttributes = [];

  Map<String, dynamic> selectedExtraOptions = {};
  List<Map<String, dynamic>> extraOptionErrorData = [];

  @override
  void initState() {
    super.initState();
    initRequests();
  }

  void initRequests() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final provider =
          Provider.of<ProductItemsProvider>(context, listen: false);
      provider.resetData();
      await fetchItems();
      await _isBrandFetched();
      await fetchBrandStoreData();
      fetchCustomerReviews();
      provider.addListener(() {
        if (provider.apiResponse?.data?.record?.images != null &&
            _selectedImageUrl == null) {
          WidgetsBinding.instance.addPostFrameCallback((callback) {
            setState(() {
              _selectedImageUrl =
                  provider.apiResponse?.data?.record?.images.first.small;
            });
          });
        }
      });
    });
  }

  Future<void> fetchBrandStoreData() async {
    final brandStore = Provider.of<StoreProvider>(context, listen: false);
    await brandStore.fetchStore(widget.slug, context);
  }

  Future<void> fetchCustomerReviews() async {
    final provider = Provider.of<ProductItemsProvider>(context, listen: false);
    await provider.fetchCustomerReviews(
        provider.apiResponse?.data?.record?.id?.toString() ?? '', context);
  }

  Future<void> fetchItems() async {
    final provider = Provider.of<ProductItemsProvider>(context, listen: false);
    final result = await provider.fetchProductData(widget.slug, context);
    if (result != null) {
      final record = result.data?.record;
      if (record?.attributes?.isNotEmpty == true) {
        record?.attributes?.forEach(
          (newData) {
            final childOption = newData.children
                .firstWhere((childData) => childData.selected == true);

            final attribute = selectedAttributes.firstWhere(
              (data) =>
                  data?['attribute_category_slug'].toString().toLowerCase() ==
                  newData.slug.toLowerCase(),
              orElse: () => null,
            );
            if (attribute != null) {
              attribute['attribute_key_name'] = newData.keyName;
              attribute['attribute_category_slug'] = newData.slug;
              attribute['attribute_name'] = childOption.title;
              attribute['attribute_slug'] = childOption.slug;
              attribute['attribute_id'] = childOption.id;
            } else {
              final newAttribute = {
                'attribute_key_name': newData.keyName,
                'attribute_category_slug': newData.slug,
                'attribute_name': childOption.title,
                'attribute_slug': childOption.slug,
                'attribute_id': childOption.id,
              };
              selectedAttributes.add(newAttribute);
            }
          },
        );
        final resultAttributes =
            await updateProductAttributes(selectedAttributes);
        if (resultAttributes != null) {
          updateProductAttributePrice =
              resultAttributes.data.price.toString() ?? '';
          productVariationId = resultAttributes.data.id;
          unavailableAttributes = resultAttributes.data.unavailableAttributeIds
              .map((e) => int.tryParse(e.toString()) ?? 0)
              .toList();
        }
      }
    }
  }

  Future<ProductVariationModel?> updateProductAttributes(
      List<Map<String, dynamic>?> selectedAttributes) async {
    final provider = Provider.of<ProductItemsProvider>(context, listen: false);
    return provider.updateProductAttributes(
        productID, context, selectedAttributes);
  }

  /// ------------------------- fetch the  view of the brands ----------------------------------------------------------------

  Future<void> _isBrandFetched() async {
    final brandStore = Provider.of<StoreProvider>(context, listen: false);
    await brandStore.fetchStore(widget.slug, context);
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.sizeOf(context).width;
    final freshPicksProvider =
        Provider.of<FreshPicksProvider>(context, listen: false);
    final wishlistProvider =
        Provider.of<WishlistProvider>(context, listen: true);
    final mainProvider =
        Provider.of<ProductItemsProvider>(context, listen: true);

    final mainData = mainProvider.apiResponse?.data;
    final mainRecord = mainData?.record;

    print('Test 1 == ${mainRecord?.inWishList}');

    return BaseAppBar(
      color: AppColors.productBackground,
      textBack: 'Back',
      onBackPressed: () {
        mainProvider.resetDetailData();
        Navigator.pop(context);
      },
      customBackIcon: const Icon(Icons.arrow_back_ios_sharp, size: 16),
      firstRightIconPath: AppStrings.firstRightIconPath,
      secondRightIconPath: AppStrings.secondRightIconPath,
      thirdRightIconPath: AppStrings.thirdRightIconPath,
      body: Scaffold(
        body: SafeArea(
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Consumer<ProductItemsProvider>(
                  builder: (context, provider, child) {
                    if (provider.isLoading) {
                      return const Center(
                        child: CircularProgressIndicator(
                          color: Colors.black,
                          strokeWidth: 0.5,
                        ),
                      );
                    }
                    final data = provider.apiResponse?.data;
                    final record = data?.record;
                    productID = (record?.id ?? 0).toString();
                    productPrice = isAttributesChanged
                        ? updateProductAttributePrice
                        : record?.prices?.frontSalePrice?.toString() ?? '';

                    if (record?.attributes?.isNotEmpty == true) {
                      record?.attributes?.forEach(
                        (newData) {
                          final childOption = newData.children.firstWhere(
                              (childData) => childData.selected == true,
                              orElse: () => Child.defaultData());

                          if (childOption.id != -1) {
                            final attribute = selectedAttributes.firstWhere(
                              (data) =>
                                  data?['attribute_category_slug']
                                      .toString()
                                      .toLowerCase() ==
                                  newData.slug.toLowerCase(),
                              orElse: () => null,
                            );
                            if (attribute != null) {
                              attribute['attribute_key_name'] = newData.keyName;
                              attribute['attribute_category_slug'] =
                                  newData.slug;
                              attribute['attribute_name'] = childOption.title;
                              attribute['attribute_slug'] = childOption.slug;
                              attribute['attribute_id'] = childOption.id;
                              attribute['attribute_set_id'] =
                                  childOption.attributeSetId;
                            } else {
                              final newAttribute = {
                                'attribute_key_name': newData.keyName,
                                'attribute_category_slug': newData.slug,
                                'attribute_name': childOption.title,
                                'attribute_slug': childOption.slug,
                                'attribute_id': childOption.id,
                                'attribute_set_id': childOption.attributeSetId,
                              };
                              selectedAttributes.add(newAttribute);
                            }
                          }
                        },
                      );
                    }

                    final images = record?.images;

                    if (record == null || images == null) {
                      return const Center(child: Text('Loading...'));
                    }

                    /// Calculate the percentage off
                    final double? frontSalePrice =
                        record.prices?.frontSalePrice?.toDouble();
                    final double? price = record.prices?.price?.toDouble();
                    String offPercentage = '';

                    if (frontSalePrice != null && price != null && price > 0) {
                      final double discount =
                          100 - ((frontSalePrice / price) * 100);
                      if (discount > 0) {
                        offPercentage = discount.toStringAsFixed(0);
                      }
                    }

                    return Column(
                      children: [
                        Expanded(
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                ProductImageScreen(
                                  selectedImageUrl: _selectedImageUrl,
                                  screenWidth: screenWidth,
                                  onImageUpdate: (selectedImageUrl) {
                                    setState(() {
                                      _selectedImageUrl = selectedImageUrl;
                                    });
                                  },
                                  record: record,
                                  images: images,
                                ),
                                ProductInformationScreen(
                                  productPrice: productPrice,
                                  selectedImageUrl: _selectedImageUrl,
                                  screenWidth: screenWidth,
                                  onImageUpdate: (selectedImageUrl) {
                                    setState(() {
                                      _selectedImageUrl = selectedImageUrl;
                                    });
                                  },
                                  record: record,
                                  images: images,
                                  offPercentage: offPercentage,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 10, right: 20, left: 20),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Flexible(
                                        child: Image.asset(
                                          'assets/tabby.png',
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      Flexible(
                                        child: Image.asset(
                                          'assets/tamara.png',
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                if (record.attributes?.isNotEmpty == true)
                                  ProductAttributesScreen(
                                    screenWidth: screenWidth,
                                    attributes: record.attributes!,
                                    selectedAttributes: selectedAttributes,
                                    unavailableAttributes:
                                        unavailableAttributes,
                                    onSelectedAttributes:
                                        (selectedAttribute) async {
                                      final result =
                                          await updateProductAttributes(
                                              selectedAttribute);
                                      if (result != null) {
                                        if (result.data.successMessage ==
                                            null) {
                                          CustomSnackbar.showError(
                                              context, 'Out of stock');
                                        }
                                        // Update selected attributes
                                        for (final attr in selectedAttribute) {
                                          final matchingSelected = result
                                              .data.selectedAttributes
                                              .firstWhere(
                                            (selected) =>
                                                selected.setId ==
                                                attr?['attribute_set_id'],
                                            orElse: () => SelectedAttribute(
                                                setSlug: '',
                                                setId: -1,
                                                id: -1,
                                                slug: ''),
                                          );

                                          if (matchingSelected.setId != -1) {
                                            attr?['attribute_name'] =
                                                matchingSelected.slug
                                                    .toUpperCase();
                                            attr?['attribute_slug'] =
                                                matchingSelected.slug;
                                            attr?['attribute_id'] =
                                                matchingSelected.id;
                                          }
                                        }

                                        // Update record attributes
                                        record.attributes?.forEach((newData) {
                                          // Reset selection for all children
                                          for (final child
                                              in newData.children) {
                                            child.selected = false;
                                          }

                                          for (final updateAttr
                                              in selectedAttribute) {
                                            final matchingChild =
                                                newData.children.firstWhere(
                                              (childData) =>
                                                  childData.id ==
                                                  updateAttr?['attribute_id'],
                                              orElse: () => Child.defaultData(),
                                            );

                                            if (matchingChild.id != -1) {
                                              matchingChild.selected = true;
                                            }
                                          }
                                        });

                                        setState(() {
                                          isAttributesChanged = true;
                                          updateProductAttributePrice =
                                              result.data.price.toString();
                                          unavailableAttributes = result
                                              .data.unavailableAttributeIds
                                              .map((e) =>
                                                  int.tryParse(e.toString()) ??
                                                  0)
                                              .toList();
                                          productVariationId = result.data.id;
                                          selectedAttributes =
                                              selectedAttribute;
                                        });
                                      }
                                    },
                                  ),
                                if (record.options.isNotEmpty == true)
                                  ExtraProductOptions(
                                    options: record.options,
                                    screenWidth: screenWidth,
                                    selectedOptions: selectedExtraOptions,
                                    extraOptionsError: extraOptionErrorData,
                                    onSelectedOptions: (Map<String, dynamic>
                                        selectedExtraOptions) {
                                      setState(() {
                                        this.selectedExtraOptions =
                                            selectedExtraOptions;
                                      });
                                    },
                                  ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 10, right: 20, left: 20),
                                  child: Column(
                                    children: [
                                      if (record.content.isNotEmpty)
                                        Text('Product Details',
                                            style: productValueItemsStyle(
                                                context)),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            top: 4, right: 4, left: 4),
                                        child: Html(
                                          data: record.content,
                                          style: {
                                            'div': Style(
                                              margin: Margins.only(bottom: 4.0),
                                              lineHeight:
                                                  LineHeight.number(1.4),
                                              whiteSpace: WhiteSpace.normal,
                                              padding: HtmlPaddings.zero,
                                            ),
                                            'p': Style(
                                              margin: Margins.only(bottom: 4.0),
                                              lineHeight:
                                                  LineHeight.number(1.4),
                                              padding: HtmlPaddings.zero,
                                              whiteSpace: WhiteSpace.normal,
                                            ),
                                            'li': Style(
                                              margin: Margins.only(bottom: 4.0),
                                              lineHeight:
                                                  LineHeight.number(1.2),
                                              padding: HtmlPaddings.zero,
                                              listStyleType: ListStyleType.disc,
                                            ),
                                            'strong': Style(
                                                fontWeight: FontWeight.w600),
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                if (record.relatedProducts.isNotEmpty)
                                  ProductRelatedItemsScreen(
                                    screenWidth: screenWidth,
                                    relatedProducts: record.relatedProducts,
                                    offPercentage: offPercentage,
                                    onBackNavigation: () {
                                      initRequests();
                                    },
                                    onActionUpdate: (loader) {
                                      setState(() {
                                        actionLoading = loader;
                                      });
                                    },
                                  ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 20, right: 20, left: 20),
                                  child: Column(
                                    children: [
                                      Text('Customer Reviews',
                                          style:
                                              productValueItemsStyle(context)),
                                      Padding(
                                          padding:
                                              const EdgeInsets.only(top: 10),
                                          child: Container(
                                              height: 0.5, color: Colors.grey)),
                                      Padding(
                                        padding: const EdgeInsets.only(top: 10),
                                        child: Column(
                                          children: [
                                            if (provider.isReviewLoading) ...{
                                              Container(
                                                color: Colors
                                                    .transparent, // Semi-transparent background
                                                child: const Center(
                                                  child:
                                                      CircularProgressIndicator(
                                                    valueColor:
                                                        AlwaysStoppedAnimation<
                                                                Color>(
                                                            AppColors
                                                                .peachyPink),
                                                  ),
                                                ),
                                              ),
                                            } else ...{
                                              if (record.review != null &&
                                                  provider.apiReviewsResponse !=
                                                      null) ...{
                                                CustomerReviews(
                                                  review: record.review!,
                                                  customerReviews: provider
                                                          .apiReviewsResponse
                                                          ?.data
                                                          ?.records ??
                                                      [],
                                                ),
                                                Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 20),
                                                    child: Container(
                                                        height: 0.5,
                                                        color: Colors.grey)),
                                              },
                                            },
                                            if (record.brand != null)
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 20),
                                                child: Column(
                                                  children: [
                                                    Text(
                                                        'ProductCode - 202t86876',
                                                        style:
                                                            productsReviewDescription(
                                                                context)),
                                                    Text(
                                                        'Selling By ${record.brand!.name}',
                                                        style:
                                                            productsReviewDescription(
                                                                context)),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              top: 10),
                                                      child: GestureDetector(
                                                        onTap: () {
                                                          Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                              builder: (context) =>
                                                                  FeaturedBrandsItemsScreen(
                                                                      slug: record
                                                                              .brand
                                                                              ?.slug ??
                                                                          ''),
                                                            ),
                                                          );
                                                        },
                                                        child: Column(
                                                          children: [
                                                            Text(
                                                                'View ${record.brand!.name}->',
                                                                style:
                                                                    viewShopText(
                                                                        context)),
                                                          ],
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
                              ],
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: ((mainRecord?.id ?? 0) != 0 || productVariationId != -1)
                    ? ProductActions(
                        onExtraOptionsError: (errorData) {
                          setState(() {
                            extraOptionErrorData = errorData;
                          });
                        },
                        productVariationID: productVariationId != -1
                            ? productVariationId
                            : mainRecord?.id,
                        mainProductID: mainRecord?.id,
                        wishlistProvider: wishlistProvider,
                        freshPicksProvider: freshPicksProvider,
                        productItemsProvider: mainProvider,
                        screenWidth: screenWidth,
                        selectedExtraOptions: selectedExtraOptions,
                        selectedAttributes: selectedAttributes,
                        updateLoader: (loader) {
                          setState(() {
                            actionLoading = loader;
                          });
                        },
                      )
                    : Container(),
              ),
              if (mainProvider.isOtherLoading || actionLoading)
                Container(
                  color: Colors.black
                      .withOpacity(0.5), // Semi-transparent background
                  child: const Center(
                    child: CircularProgressIndicator(
                      valueColor:
                          AlwaysStoppedAnimation<Color>(AppColors.peachyPink),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
