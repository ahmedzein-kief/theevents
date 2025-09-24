import 'dart:developer';

import 'package:event_app/core/helper/extensions/app_localizations_extension.dart';
import 'package:event_app/core/utils/custom_toast.dart';
import 'package:event_app/views/base_screens/base_app_bar.dart';
import 'package:event_app/views/product_detail_screens/product_actions.dart';
import 'package:event_app/views/product_detail_screens/product_realted_items.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_strings.dart';
import '../../core/helper/functions/functions.dart';
import '../../core/styles/app_colors.dart';
import '../../models/product_packages_models/product_attributes_model.dart';
import '../../models/product_variation_model.dart';
import '../../provider/product_package_provider/product_details_provider.dart';
import '../../provider/shortcode_fresh_picks_provider/fresh_picks_provider.dart';
import '../../provider/store_provider/brand_store_provider.dart';
import '../../provider/wishlist_items_provider/wishlist_provider.dart';
import 'custom_widgets/product_content_section.dart';
import 'custom_widgets/product_details_section.dart';
import 'custom_widgets/product_header_section.dart';
import 'custom_widgets/product_payment_options.dart';
import 'custom_widgets/product_reviews_brand_section.dart';

class ProductDetailScreen extends StatefulWidget {
  const ProductDetailScreen({super.key, required this.slug});

  final dynamic slug;

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

  // Add listener reference to properly dispose
  VoidCallback? _providerListener;

  @override
  void initState() {
    super.initState();
    initRequests();
  }

  @override
  void didUpdateWidget(ProductDetailScreen oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Check if the slug has changed (new product)
    if (widget.slug != oldWidget.slug) {
      // Remove old listener if exists
      if (_providerListener != null) {
        final provider = Provider.of<ProductItemsProvider>(context, listen: false);
        provider.removeListener(_providerListener!);
        _providerListener = null;
      }

      // Reset all state variables for new product
      setState(() {
        _selectedImageUrl = null;
        selectedAttributes.clear();
        isAttributesChanged = false;
        unavailableAttributes.clear();
        selectedExtraOptions.clear();
        extraOptionErrorData.clear();
        cartItemQuantity = 1;
        productID = '';
        productPrice = '';
        updateProductAttributePrice = '';
        productVariationId = -1;
      });

      // Reinitialize for new product
      initRequests();
    }
  }

  @override
  void dispose() {
    // Remove listener to prevent setState after dispose
    if (_providerListener != null) {
      try {
        final provider = Provider.of<ProductItemsProvider>(context, listen: false);
        provider.removeListener(_providerListener!);
      } catch (e) {
        // Provider might already be disposed
        log('Error removing listener: $e');
      }
    }
    super.dispose();
  }

  void initRequests() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted) return;

      final provider = Provider.of<ProductItemsProvider>(context, listen: false);
      provider.resetData();

      // Reset the selected image URL when initializing a new product
      if (mounted) {
        setState(() {
          _selectedImageUrl = null;
        });
      }

      await fetchItems();
      fetchCustomerReviews();

      // Remove old listener if exists
      if (_providerListener != null) {
        provider.removeListener(_providerListener!);
      }

      // Create new listener
      _providerListener = () {
        if (mounted && provider.apiResponse?.data?.record?.images.isNotEmpty == true) {
          try {
            WidgetsBinding.instance.addPostFrameCallback((callback) {
              if (mounted && provider.apiResponse?.data?.record?.images.isNotEmpty == true) {
                setState(() {
                  _selectedImageUrl = provider.apiResponse?.data?.record?.images.first.small;
                });
              }
            });
          } catch (e) {
            log('Error updating selected image: $e');
          }
        }
      };

      provider.addListener(_providerListener!);
    });
  }

  Future<void> fetchBrandStoreData() async {
    if (!mounted) return;
    final brandStore = Provider.of<StoreProvider>(context, listen: false);
    await brandStore.fetchStore(widget.slug, context);
  }

  Future<void> fetchCustomerReviews() async {
    if (!mounted) return;
    final provider = Provider.of<ProductItemsProvider>(context, listen: false);
    await provider.fetchCustomerReviews(
      provider.apiResponse?.data?.record?.id?.toString() ?? '',
      context,
    );
  }

  Future<void> fetchItems() async {
    if (!mounted) return;
    final provider = Provider.of<ProductItemsProvider>(context, listen: false);
    final result = await provider.fetchProductData(widget.slug, context);
    if (result != null && result.data?.record?.attributes?.isNotEmpty == true && mounted) {
      final record = result.data?.record;
      if (record?.attributes?.isNotEmpty == true) {
        record?.attributes?.forEach(
          (newData) {
            final childOption = newData.children.firstWhere((childData) => childData.selected == true);

            final attribute = selectedAttributes.firstWhere(
              (data) => data?['attribute_category_slug'].toString().toLowerCase() == newData.slug.toLowerCase(),
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
        final resultAttributes = await updateProductAttributes(selectedAttributes);
        if (resultAttributes != null && mounted) {
          updateProductAttributePrice = resultAttributes.data.price.toString();
          productVariationId = resultAttributes.data.id;
          unavailableAttributes =
              resultAttributes.data.unavailableAttributeIds.map((e) => int.tryParse(e.toString()) ?? 0).toList();
        }
      }
    }
  }

  Future<ProductVariationModel?> updateProductAttributes(
    List<Map<String, dynamic>?> selectedAttributes,
  ) async {
    if (!mounted) return null;
    final provider = Provider.of<ProductItemsProvider>(context, listen: false);
    return provider.updateProductAttributes(
      productID,
      context,
      selectedAttributes,
    );
  }

  Future<void> _isBrandFetched() async {
    if (!mounted) return;
    final brandStore = Provider.of<StoreProvider>(context, listen: false);
    await brandStore.fetchStore(widget.slug, context);
  }

  void _handleAttributeUpdate(List<Map<String, dynamic>?> selectedAttribute, dynamic record) async {
    if (!mounted) return;

    final result = await updateProductAttributes(selectedAttribute);
    if (result != null && mounted) {
      if (result.data.successMessage == null) {
        CustomSnackbar.showError(context, 'Out of stock');
      }

      // Update selected attributes
      for (final attr in selectedAttribute) {
        final matchingSelected = result.data.selectedAttributes.firstWhere(
          (selected) => selected.setId == attr?['attribute_set_id'],
          orElse: () => SelectedAttribute(
            setSlug: '',
            setId: -1,
            id: -1,
            slug: '',
          ),
        );

        if (matchingSelected.setId != -1) {
          attr?['attribute_name'] = matchingSelected.slug.toUpperCase();
          attr?['attribute_slug'] = matchingSelected.slug;
          attr?['attribute_id'] = matchingSelected.id;
        }
      }

      // Update record attributes
      record.attributes?.forEach((newData) {
        for (final child in newData.children) {
          child.selected = false;
        }

        for (final updateAttr in selectedAttribute) {
          final matchingChild = newData.children.firstWhere(
            (childData) => childData.id == updateAttr?['attribute_id'],
            orElse: () => Child.defaultData(),
          );

          if (matchingChild.id != -1) {
            matchingChild.selected = true;
          }
        }
      });

      if (mounted) {
        setState(() {
          isAttributesChanged = true;
          updateProductAttributePrice = result.data.price.toString();
          unavailableAttributes =
              result.data.unavailableAttributeIds.map((e) => int.tryParse(e.toString()) ?? 0).toList();
          productVariationId = result.data.id;
          selectedAttributes = selectedAttribute;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.sizeOf(context).width;
    final freshPicksProvider = Provider.of<FreshPicksProvider>(context, listen: false);
    final wishlistProvider = Provider.of<WishlistProvider>(context, listen: true);
    final mainProvider = Provider.of<ProductItemsProvider>(context, listen: true);

    final mainData = mainProvider.apiResponse?.data;
    final mainRecord = mainData?.record;

    final appBarIconColor = getOppositeColor(AppColors.productBackground);

    return BaseAppBar(
      iconsColor: appBarIconColor,
      leftTextStyle: TextStyle(color: appBarIconColor),
      color: AppColors.productBackground,
      textBack: AppStrings.back.tr,
      onBackPressed: () {
        mainProvider.resetDetailData();
        Navigator.pop(context);
      },
      customBackIcon: Icon(
        Icons.arrow_back_ios_sharp,
        size: 16,
        color: appBarIconColor,
      ),
      firstRightIconPath: AppStrings.firstRightIconPath.tr,
      secondRightIconPath: AppStrings.secondRightIconPath.tr,
      thirdRightIconPath: AppStrings.thirdRightIconPath.tr,
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

                    // Add null safety checks for all assignments
                    if (record?.id != null) {
                      productID = record!.id.toString();
                    }

                    productPrice = isAttributesChanged
                        ? updateProductAttributePrice
                        : record?.prices?.frontSalePrice?.toString() ?? '';

                    if (record?.attributes?.isNotEmpty == true) {
                      record?.attributes?.forEach((newData) {
                        final childOption = newData.children.firstWhere(
                          (childData) => childData.selected == true,
                          orElse: () => Child.defaultData(),
                        );

                        if (childOption.id != -1) {
                          final attribute = selectedAttributes.firstWhere(
                            (data) =>
                                data?['attribute_category_slug'].toString().toLowerCase() == newData.slug.toLowerCase(),
                            orElse: () => null,
                          );
                          if (attribute != null) {
                            attribute['attribute_key_name'] = newData.keyName;
                            attribute['attribute_category_slug'] = newData.slug;
                            attribute['attribute_name'] = childOption.title;
                            attribute['attribute_slug'] = childOption.slug;
                            attribute['attribute_id'] = childOption.id;
                            attribute['attribute_set_id'] = childOption.attributeSetId;
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
                      });
                    }

                    final images = record?.images;

                    if (record == null) {
                      return Center(child: Text('${AppStrings.loading.tr}...'));
                    }

                    /// Calculate the percentage off
                    final double? frontSalePrice = record.prices?.frontSalePrice?.toDouble();
                    final double? price = record.prices?.price?.toDouble();
                    String offPercentage = '';

                    if (frontSalePrice != null && price != null && price > 0) {
                      final double discount = 100 - ((frontSalePrice / price) * 100);
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
                                // Product Header Section
                                ProductHeaderSection(
                                  selectedImageUrl: images?.isNotEmpty == true ? _selectedImageUrl : null,
                                  screenWidth: screenWidth,
                                  record: record,
                                  images: images,
                                  productPrice: productPrice,
                                  offPercentage: offPercentage,
                                  onImageUpdate: (selectedImageUrl) {
                                    if (mounted) {
                                      setState(() {
                                        _selectedImageUrl = selectedImageUrl;
                                      });
                                    }
                                  },
                                ),

                                // Payment Options Section
                                const ProductPaymentOptions(),

                                // Attributes and Options Section
                                ProductContentSection(
                                  record: record,
                                  screenWidth: screenWidth,
                                  selectedAttributes: selectedAttributes,
                                  unavailableAttributes: unavailableAttributes,
                                  selectedExtraOptions: selectedExtraOptions,
                                  extraOptionErrorData: extraOptionErrorData,
                                  onAttributesChanged: (selectedAttribute) {
                                    _handleAttributeUpdate(selectedAttribute, record);
                                  },
                                  onExtraOptionsChanged: (Map<String, dynamic> selectedExtraOptions) {
                                    if (mounted) {
                                      setState(() {
                                        this.selectedExtraOptions = selectedExtraOptions;
                                      });
                                    }
                                  },
                                ),

                                // Product Details Section
                                ProductDetailsSection(
                                  content: record.content,
                                ),

                                // Related Products Section
                                if (record.relatedProducts.isNotEmpty == true)
                                  ProductRelatedItemsScreen(
                                    screenWidth: screenWidth,
                                    relatedProducts: record.relatedProducts,
                                    offPercentage: offPercentage,
                                    onBackNavigation: () {
                                      if (mounted) {
                                        initRequests();
                                      }
                                    },
                                    onActionUpdate: (loader) {
                                      if (mounted) {
                                        setState(() {
                                          actionLoading = loader;
                                        });
                                      }
                                    },
                                  ),

                                // Customer Reviews and Brand Section
                                ProductReviewsAndBrandSection(
                                  provider: provider,
                                  record: record,
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

              // Product Actions (Bottom Section)
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: ((mainRecord?.id ?? 0) != 0 || productVariationId != -1)
                    ? ProductActions(
                        onExtraOptionsError: (errorData) {
                          if (mounted) {
                            setState(() {
                              extraOptionErrorData = errorData;
                            });
                          }
                        },
                        productVariationID: productVariationId != -1 ? productVariationId : (mainRecord?.id ?? 0),
                        mainProductID: mainRecord?.id ?? 0,
                        wishlistProvider: wishlistProvider,
                        freshPicksProvider: freshPicksProvider,
                        productItemsProvider: mainProvider,
                        screenWidth: screenWidth,
                        selectedExtraOptions: selectedExtraOptions,
                        selectedAttributes: selectedAttributes,
                        updateLoader: (loader) {
                          if (mounted) {
                            setState(() {
                              actionLoading = loader;
                            });
                          }
                        },
                      )
                    : Container(),
              ),

              // Loading Overlay
              if (mainProvider.isOtherLoading || actionLoading)
                Container(
                  color: Colors.black.withAlpha((0.5 * 255).toInt()),
                  child: const Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(AppColors.peachyPink),
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
