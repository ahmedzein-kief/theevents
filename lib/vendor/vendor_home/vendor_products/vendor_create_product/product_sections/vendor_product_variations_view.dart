import 'package:event_app/core/helper/mixins/media_query_mixin.dart';
import 'package:event_app/core/styles/app_colors.dart';
import 'package:event_app/core/styles/app_sizes.dart';
import 'package:event_app/core/utils/app_utils.dart';
import 'package:event_app/core/widgets/custom_auth_views/app_custom_button.dart';
import 'package:event_app/data/vendor/data/response/apis_status.dart';
import 'package:event_app/models/vendor_models/products/create_product/attribute_sets_data_response.dart';
import 'package:event_app/models/vendor_models/products/edit_product/vendor_get_product_variations_model.dart';
import 'package:event_app/vendor/components/app_bars/vendor_modify_sections_app_bar.dart';
import 'package:event_app/vendor/components/bottom_sheets/draggable_bottom_sheet.dart';
import 'package:event_app/vendor/components/buttons/custom_icon_button_with_text.dart';
import 'package:event_app/vendor/components/checkboxes/custom_checkboxes.dart';
import 'package:event_app/vendor/components/common_widgets/vendor_action_cell.dart';
import 'package:event_app/vendor/components/common_widgets/vendor_data_list_builder.dart';
import 'package:event_app/vendor/components/data_tables/custom_data_tables.dart';
import 'package:event_app/vendor/components/dialogs/delete_item_alert_dialog.dart';
import 'package:event_app/vendor/components/list_tiles/custom_records_list_tile.dart';
import 'package:event_app/vendor/components/radio_buttons/custom_radio_button.dart';
import 'package:event_app/vendor/components/vendor_tool_bar_widgets/vendor_tool_bar_widgets.dart';
import 'package:event_app/vendor/vendor_home/vendor_products/vendor_create_product/product_sections/vendor_edit_variations.dart';
import 'package:event_app/vendor/view_models/vendor_products/vendor_create_product_view_model.dart';
import 'package:event_app/vendor/view_models/vendor_products/vendor_edit_product/vendor_edit_product_attributes_view_model.dart';
import 'package:event_app/vendor/view_models/vendor_products/vendor_edit_product/vendor_generate_all_product_variations_view_model.dart';
import 'package:event_app/vendor/view_models/vendor_products/vendor_edit_product/vendor_get_product_variations_view_model.dart';
import 'package:event_app/vendor/view_models/vendor_products/vendor_edit_product/vendor_get_selected_product_attibutes_view_model.dart';
import 'package:event_app/vendor/view_models/vendor_products/vendor_edit_product/vendor_set_default_product_variation_view_model.dart';
import 'package:event_app/vendor/view_models/vendor_products/vendor_get_products_view_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../components/generics/debouced_search.dart';

class VendorProductHasVariationsView extends StatefulWidget {
  const VendorProductHasVariationsView({super.key, this.productID});

  final String? productID;

  @override
  State<VendorProductHasVariationsView> createState() => _VendorProductHasVariationsViewState();
}

class _VendorProductHasVariationsViewState extends State<VendorProductHasVariationsView> with MediaQueryMixin {
  /// To show modal progress hud
  bool _isProcessing = false;

  void setProcessing(bool value) {
    setState(() {
      _isProcessing = value;
    });
  }

  /// Search controller
  final TextEditingController _searchController = TextEditingController();

  // scroll controller
  final ScrollController _scrollController = ScrollController();

  Future _onRefresh() async {
    try {
      // setProcessing(true);
      if (!mounted) return;
      final provider = Provider.of<VendorGetProductVariationsViewModel>(
        context,
        listen: false,
      );

      /// clear list on refresh
      provider.clearList();
      setState(() {});
      await provider.vendorGetProductVariations(
        productID: widget.productID ?? '',
        searchString: _searchController.text,
      );

      if (provider.list.isEmpty && _searchController.text.isEmpty) {
        if (!mounted) return;
        Navigator.pop(context, null);
        return;
      }

      /// ******** Get attributes set start **********
      if (!mounted) return;
      final vendorGetAttributesSetProvider = Provider.of<VendorCreateProductViewModel>(context, listen: false);
      await vendorGetAttributesSetProvider.getAttributeSetsData();

      /// ******** Get attributes set end **********

      setProcessing(false);
      setState(() {});
    } catch (e) {
      setProcessing(false);
    }
  }

  /// load more data
  Future<void> _loadMoreData() async {
    // Load more data here
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent) {
      final provider = Provider.of<VendorGetProductVariationsViewModel>(
        context,
        listen: false,
      );
      if (provider.apiResponse.status != ApiStatus.LOADING) {
        await provider.vendorGetProductVariations(
          productID: widget.productID ?? '',
          searchString: _searchController.text,
        );
      }
    }
  }

  @override
  void initState() {
    super.initState();

    /// To implement pagination adding listeners
    _scrollController.addListener(() {
      _loadMoreData();
    });

    WidgetsBinding.instance.addPostFrameCallback((callback) async {
      await _onRefresh();
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, result) {
          if (didPop) {
            return;
          }
          Navigator.pop(context);
        },
        child: Scaffold(
          appBar: VendorModifySectionsAppBar(
            title: 'Product has variations',
            onGoBack: () {
              Navigator.pop(context);
            },
          ),
          body: AppUtils.modelProgressHud(
            context: context,
            processing: _isProcessing,
            child: AppUtils.pageRefreshIndicator(
              onRefresh: _onRefresh,
              child: _buildUi(context),
              context: context,
            ),
          ),
        ),
      );

  Widget _buildUi(BuildContext context) => Padding(
        padding: EdgeInsets.symmetric(
          horizontal: kSmallPadding,
        ),
        child: Column(
          children: [
            kFormFieldSpace,
            _toolBar(),
            kSmallSpace,
            Expanded(
              child: Consumer<VendorGetProductVariationsViewModel>(
                builder: (context, provider, _) {
                  /// current api status
                  final ApiStatus? apiStatus = provider.apiResponse.status;
                  if (apiStatus == ApiStatus.LOADING && provider.list.isEmpty) {
                    return AppUtils.pageLoadingIndicator(context: context);
                  }
                  if (apiStatus == ApiStatus.ERROR) {
                    return ListView(
                      children: [
                        AppUtils.somethingWentWrong(),
                      ],
                    );
                  }
                  return Expanded(
                    child: VendorDataListBuilder(
                      scrollController: _scrollController,
                      listLength: provider.list.length,
                      loadingMoreData: provider.apiResponse.status == ApiStatus.LOADING,
                      contentBuilder: (context) => _buildRecordsList(provider: provider),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      );

  Widget _buildRecordsList({
    required VendorGetProductVariationsViewModel provider,
  }) =>
      ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: provider.list.length,
        itemBuilder: (context, index) {
          final productVariation = provider.list[index];
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomRecordListTile(
                onTap: () => _onRowTap(rowData: productVariation, context: context),
                imageAddress: productVariation.imagePath.toString(),
                title: productVariation.id.toString(),
                subtitleAsWidget: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    RichText(
                      text: TextSpan(
                        children: [
                          const TextSpan(
                            text: 'Quantity: ',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 12,
                              color: AppColors.peachyPink,
                            ),
                          ),
                          TextSpan(
                            text: productVariation.quantity?.toString().trim() == '&#8734;'
                                ? '\u221E'
                                : productVariation.quantity?.toString() ?? '--',
                            style: const TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 13,
                              color: Colors.black,
                            ), // Add emphasis if needed
                          ),
                        ],
                      ),
                    ),
                    kSmallSpace,
                    VendorCustomRadioListTile(
                      tooltipMessage: 'Set this variant as default',
                      value: productVariation.isDefault,
                      groupValue: provider.list.any((p) => p.isDefault == true)
                          ? provider.list
                              .firstWhere(
                                (p) => p.isDefault ?? false,
                                orElse: () => provider.list.first,
                              )
                              .isDefault
                          : null,
                      // Set null if no item is default
                      padding: EdgeInsets.zero,
                      onChanged: (value) => _setDefaultVariation(
                        productVariation: productVariation,
                        provider: provider,
                      ),
                      title: 'Is Default',
                      textStyle: dataColumnTextStyle(),
                    ),
                  ],
                ),
                centerWidget: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if ((productVariation.fileInternalCount?.toString() ?? '').isNotEmpty)
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            productVariation.fileInternalCount?.toString() ?? '',
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                            ),
                          ),
                          const Icon(
                            Icons.attach_file,
                            color: Colors.black,
                            size: 20,
                          ),
                        ],
                      )
                    else
                      kShowVoid,
                    kSmallSpace, // Optional spacing between items
                    if ((productVariation.fileExternalCount?.toString() ?? '').isNotEmpty)
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            productVariation.fileExternalCount?.toString() ?? '',
                            style: const TextStyle(
                              fontSize: 13,
                              color: Colors.black,
                            ),
                          ),
                          Transform.rotate(
                            angle: 135 * 3.1415927 / 180, // Rotate the icon 45 degrees to make it diagonal
                            child: const Icon(
                              Icons.link_outlined,
                              color: Colors.black,
                              size: 20,
                            ),
                          ),
                        ],
                      )
                    else
                      kShowVoid,
                  ],
                ),
                multiplePrice: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisSize: MainAxisSize.min, // Prevents Column from taking full height
                  children: [
                    if ((productVariation.price ?? 0) > (productVariation.salePrice ?? 0)) ...{
                      Text(
                        productVariation.salePriceFormat?.toString() ?? '--',
                        style: dataRowTextStyle().copyWith(color: Colors.black),
                      ),
                      Text(
                        productVariation.priceFormat?.toString() ?? '--',
                        style: dataRowTextStyle().copyWith(color: Colors.red).copyWith(
                              decoration: TextDecoration.lineThrough,
                              decorationColor: Colors.red,
                            ),
                      ),
                      kMinorSpace,
                    } else ...{
                      Text(
                        productVariation.priceFormat?.toString() ?? '--',
                        style: dataRowTextStyle().copyWith(color: Colors.black),
                      ),
                      kMinorSpace,
                    },
                  ],
                ),
                actionCell: VendorActionCell(
                  mainAxisSize: MainAxisSize.min,
                  isDeleting: productVariation.isDeleting ?? false,
                  showEdit: true,
                  showDelete: true,
                  showView: false,
                  onEdit: () {
                    _onEditRecord(rowData: productVariation);
                  },
                  onDelete: () {
                    _onDeleteRecord(rowData: productVariation);
                  },
                ),
              ),
              kSmallSpace,
            ],
          );
        },
      );

  /// Tool Bar
  Widget _toolBar() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Expanded(
                child: VendorToolbarWidgets.vendorSearchWidget(
                  onSearchTap: () async {
                    if (_searchController.text.isNotEmpty) {
                      await _onRefresh();
                    }
                  },
                  textEditingController: _searchController,
                  onChanged: (value) => debouncedSearch<VendorGetProductsViewModel>(
                    context: context,
                    value: value,
                    providerGetter: (context) => context.read<VendorGetProductsViewModel>(),
                    refreshFunction: _onRefresh,
                  ),
                ),
              ),
              kExtraSmallSpace,
              VendorToolbarWidgets.vendorCreateButton(
                onTap: () async {
                  await Navigator.push(
                    context,
                    CupertinoPageRoute(
                      builder: (context) => VendorEditVariations(
                        productID: widget.productID!,
                      ),
                    ),
                  );
                },
                isLoading: false,
              ),
            ],
          ),
          kSmallSpace,
          Wrap(
            alignment: WrapAlignment.start,
            spacing: kSmallPadding,
            runSpacing: kSmallPadding,
            children: [
              CustomIconButtonWithText(
                text: 'Edit Attributes',
                borderRadius: kExtraSmallButtonRadius,
                icon: const Icon(
                  Icons.edit_attributes,
                  color: AppColors.peachyPink,
                ),
                isLoading: false,
                onPressed: () async {
                  /// ******** Get selected attributes set start **********
                  setProcessing(true);

                  final vendorGetSelectedAttributesSetProvider = context.read<VendorGetSelectedAttributesViewModel>();
                  final result = await vendorGetSelectedAttributesSetProvider.vendorGetSelectedProductAttributes(
                    productID: widget.productID!,
                  );

                  if (result) {
                    _selectedAttributesSet =
                        vendorGetSelectedAttributesSetProvider.attributeSetsApiResponse.data?.data ?? [];
                  }
                  setProcessing(false);

                  /// ******** Get selected attributes set end **********

                  if (!mounted) return;

                  showDraggableModalBottomSheet(
                    context: context,
                    builder: (scrollController) {
                      final vendorGetAttributesSetProvider = context.read<VendorCreateProductViewModel>();
                      final attributesSet = vendorGetAttributesSetProvider.attributeSetsApiResponse.data?.data ?? [];

                      return StatefulBuilder(
                        builder: (context, setModalState) => Container(
                          color: Theme.of(context).cardColor,
                          child: SingleChildScrollView(
                            controller: scrollController,
                            child: Column(
                              children: [
                                AppUtils.dragHandle(context: context),
                                kFormFieldSpace,
                                const Center(
                                  child: Text(
                                    'Select Attributes',
                                    style: TextStyle(fontSize: 20),
                                  ),
                                ),
                                kFormFieldSpace,
                                const Divider(
                                  color: Colors.grey,
                                  thickness: 0.3,
                                  height: 1,
                                ),

                                /// Attributes selection
                                Padding(
                                  padding: EdgeInsets.all(kMediumPadding),
                                  child: Wrap(
                                    spacing: 8.0,
                                    runSpacing: 8.0,
                                    alignment: WrapAlignment.start,
                                    runAlignment: WrapAlignment.start,
                                    children: attributesSet.map((attribute) {
                                      final bool isSelected = _selectedAttributesSet.any(
                                        (selected) => selected.id == attribute.id,
                                      );

                                      return CustomCheckboxWithTitle(
                                        isTitleExpanded: false,
                                        isChecked: isSelected,
                                        titleStyle: const TextStyle(fontSize: 10),
                                        onChanged: (value) {
                                          setModalState(() {
                                            if (value == true) {
                                              _selectedAttributesSet.add(attribute);
                                            } else {
                                              _selectedAttributesSet.removeWhere(
                                                (selected) => selected.id == attribute.id,
                                              );
                                            }
                                          });
                                        },
                                        title: attribute.title.toString(),
                                      );
                                    }).toList(),
                                  ),
                                ),

                                if (_selectedAttributesSet.isEmpty)
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: kPadding + kPadding,
                                    ),
                                    child: const Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        'Please select at least one attribute.*',
                                        style: TextStyle(color: Colors.red),
                                      ),
                                    ),
                                  ),

                                kMediumSpace,
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    kCancelButton(
                                      screenWidth: screenWidth,
                                      context: context,
                                    ),
                                    kLargeSpace,

                                    /// save button
                                    ChangeNotifierProvider(
                                      create: (context) => VendorEditProductAttributesViewModel(),
                                      child: Consumer<VendorEditProductAttributesViewModel>(
                                        builder: (
                                          context,
                                          editAttributesProvider,
                                          _,
                                        ) =>
                                            SizedBox(
                                          width: screenWidth * 0.25,
                                          child: CustomAppButton(
                                            buttonText: 'Save',
                                            buttonColor: AppColors.lightCoral,
                                            isLoading: editAttributesProvider.apiResponse.status == ApiStatus.LOADING,
                                            onTap: () async {
                                              // Capture navigator before any async operations
                                              final navigator = Navigator.of(context);

                                              if (_selectedAttributesSet.isEmpty) {
                                                AppUtils.showToast('Please select at least 1 attribute.');
                                                navigator.pop();
                                                return;
                                              }

                                              try {
                                                final List<int> attributesIDsSet = [];

                                                /// add all attribute ids
                                                for (final attribute in _selectedAttributesSet) {
                                                  attributesIDsSet.add(attribute.id);
                                                }

                                                final result = await editAttributesProvider.vendorEditProductAttributes(
                                                  productID: widget.productID,
                                                  attributesSet: attributesIDsSet,
                                                  context: context,
                                                );

                                                if (result) {
                                                  navigator.pop();
                                                  await _onRefresh();
                                                }
                                              } catch (error) {
                                                debugPrint(error.toString());
                                              }

                                              setState(() {});
                                            },
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
              ChangeNotifierProvider(
                create: (context) => VendorGenerateAllProductVariationsViewModel(),
                child: Consumer<VendorGenerateAllProductVariationsViewModel>(
                  builder: (context, provider, _) => CustomIconButtonWithText(
                    text: 'Generate All Variations',
                    borderRadius: kExtraSmallButtonRadius,
                    icon: const Icon(
                      Icons.all_out_outlined,
                      color: AppColors.peachyPink,
                    ),
                    isLoading: provider.apiResponse.status == ApiStatus.LOADING,
                    onPressed: () async {
                      deleteItemAlertDialog(
                        context: context,
                        buttonColor: AppColors.cornflowerBlue,
                        buttonText: 'Generate',
                        descriptionText: 'Are you sure you want to generate all variations for this product?',
                        buttonIcon: const Icon(
                          Icons.all_out_outlined,
                          color: Colors.white,
                        ),
                        onDelete: () async {
                          // Capture navigator before async operations
                          final navigator = Navigator.of(context);

                          try {
                            navigator.pop();
                            setProcessing(true);
                            final result = await provider.vendorGenerateAllProductVariations(
                              productID: widget.productID,
                              context: context,
                            );

                            if (result) {
                              setProcessing(false);
                              await _onRefresh();
                            }
                            setProcessing(false);
                          } catch (e) {
                            setProcessing(false);
                          }
                        },
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ],
      );

  void _onRowTap({
    required BuildContext context,
    required ProductVariationRecord rowData,
  }) {
    /// showing through bottom sheet
    showDraggableModalBottomSheet(
      context: context,
      builder: (scrollController) => Container(
        color: Theme.of(context).cardColor,
        child: SingleChildScrollView(
          controller: scrollController,
          child: Column(
            children: [
              AppUtils.dragHandle(context: context),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(kCardRadius),
                ),
                child: SafeArea(
                  child: Padding(
                    padding: EdgeInsets.all(kSmallPadding),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 200,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(kExtraSmallCardRadius),
                              image: DecorationImage(
                                image: NetworkImage(
                                  rowData.imagePath.toString(),
                                ),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          kFormFieldSpace,
                          buildRow('ID', rowData.id?.toString()),
                          buildRow(
                            'Quantity',
                            rowData.quantity?.toString().trim() == '&#8734;'
                                ? '\u221E'
                                : rowData.quantity?.toString() ?? '--',
                          ),
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: rowData.selectedAttributeSets?.keys.length ?? 0,
                            itemBuilder: (context, index) {
                              final entries = rowData.selectedAttributeSets?.entries.toList();
                              return buildRow(
                                getAttributeName(
                                  entries?[index].key.toString() ?? '',
                                ),
                                entries?[index].value.toString() ?? '',
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _onEditRecord({required ProductVariationRecord rowData}) async {
    await Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (context) => VendorEditVariations(
          productVariationsID: rowData.id,
          productID: widget.productID!,
        ),
      ),
    );
  }

  Future<void> _onDeleteRecord({
    required ProductVariationRecord rowData,
  }) async {
    deleteItemAlertDialog(
      context: context,
      onDelete: () async {
        _setDeletionProcessing(rowData: rowData, processing: true);
        Navigator.pop(context);

        final VendorGetProductsViewModel provider = Provider.of<VendorGetProductsViewModel>(context, listen: false);

        final result = await provider.deleteVariation(rowData.id.toString());

        if (result != null) {
          await _onRefresh();
          setState(() {});
        }
        _setDeletionProcessing(rowData: rowData, processing: false);
      },
    );
  }

  /// set product variation as default variation
  void _setDefaultVariation({
    required ProductVariationRecord productVariation,
    required VendorGetProductVariationsViewModel provider,
  }) {
    final vendorSetDefaultProductVariationProvider = context.read<VendorSetDefaultProductVariationViewModel>();

    if (!(productVariation.isDefault ?? false)) {
      deleteItemAlertDialog(
        context: context,
        customDescription: RichText(
          text: TextSpan(
            children: [
              const TextSpan(
                text: 'Do you want to set product variation with id',
                style: TextStyle(color: Colors.black, fontSize: 12),
              ),
              TextSpan(
                text: ''' "${productVariation.id}" ''',
                style: const TextStyle(
                  color: AppColors.peachyPink,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
              const TextSpan(
                text: 'to default.',
                style: TextStyle(color: Colors.black, fontSize: 12),
              ),
            ],
          ),
        ),
        buttonText: 'Save',
        buttonColor: AppColors.peachyPink,
        buttonIcon: const Icon(
          Icons.save_outlined,
          size: 16,
          color: Colors.white,
        ),
        onDelete: () async {
          try {
            Navigator.pop(context);
            setProcessing(true);
            final result = await vendorSetDefaultProductVariationProvider.vendorSetDefaultProductVariation(
              productVariationID: productVariation.id.toString(),
              context: context,
            );
            if (result) {
              setState(() {
                for (final p in provider.list) {
                  p.isDefault = false;
                }
                productVariation.isDefault = true; // Select the clicked one
              });
              setProcessing(false);
            }
            setProcessing(false);
          } catch (e) {
            setProcessing(false);
          }
        },
      );
    }
  }

  /// maintain the deletion indicator visibility by calling setState.
  void _setDeletionProcessing({
    required ProductVariationRecord rowData,
    required bool processing,
  }) {
    setState(() {
      rowData.isDeleting = processing;
      // setProcessing(processing); /// To show model progress hud. toggle this if don't want to show progress hud.
    });
  }

  /// function to get the attribute name
  String getAttributeName(String attributeID) {
    try {
      final vendorGetAttributesSetProvider = context.read<VendorCreateProductViewModel>();
      final attributesSet = vendorGetAttributesSetProvider.attributeSetsApiResponse.data?.data ?? [];
      final attribute = attributesSet.firstWhere(
        (attribute) => attribute.id.toString() == attributeID.toString(),
      );
      return attribute.title.toString();
    } catch (e) {
      return '';
    }
  }

  /// edit attributes
  List<AttributeSetsData> _selectedAttributesSet = [];
}
