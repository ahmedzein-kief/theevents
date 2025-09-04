import 'dart:async';

import 'package:event_app/core/helper/mixins/media_query_mixin.dart';
import 'package:event_app/core/styles/app_sizes.dart';
import 'package:event_app/data/vendor/data/response/apis_status.dart';
import 'package:event_app/models/vendor_models/products/create_product/vendor_product_seo_model.dart';
import 'package:event_app/vendor/components/app_bars/vendor_modify_sections_app_bar.dart';
import 'package:event_app/vendor/components/chips/tag_chip.dart';
import 'package:event_app/vendor/components/enums/enums.dart';
import 'package:event_app/vendor/components/radio_buttons/custom_radio_button.dart';
import 'package:event_app/vendor/components/settings_components/simple_card.dart';
import 'package:event_app/vendor/components/status_constants/seo_index_constants.dart';
import 'package:event_app/vendor/components/text_fields/custom_editable_text_field.dart';
import 'package:event_app/vendor/components/text_fields/custom_text_form_field.dart';
import 'package:event_app/vendor/components/utils/utils.dart';
import 'package:event_app/vendor/vendor_home/vendor_products/vendor_create_product/product_sections/vendor_product_overview_view.dart';
import 'package:event_app/vendor/view_models/vendor_products/vendor_create_product_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class VendorProductSeoView extends StatefulWidget {
  const VendorProductSeoView({super.key, this.vendorProductSeoModel});
  final VendorProductSeoModel? vendorProductSeoModel;

  @override
  _VendorProductSeoViewState createState() => _VendorProductSeoViewState();
}

class _VendorProductSeoViewState extends State<VendorProductSeoView>
    with MediaQueryMixin {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _keywordsTextFieldController =
      TextEditingController();

  final FocusNode _titleFocusNode = FocusNode();
  final FocusNode _descriptionFocusNode = FocusNode();
  final FocusNode _keywordsFocusNode = FocusNode();

  SeoIndexType seoIndexType = SeoIndexType.INDEX;

  /// Defining sets for unique keywords
  Set<String> _availableKeywords = {}; // Set containing keywords for search
  Set<String> _selectedKeywords = {}; // Set storing selected keywords
  Set<String> _filteredKeywords = {}; // Set storing filtered keywords

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((callback) async {
      await _onRefresh();

      // Initialize the text controllers with the values from the model (if available)
      _titleController.text = widget.vendorProductSeoModel?.title ?? '';
      _descriptionController.text = removeHtmlTags(
          htmlString: widget.vendorProductSeoModel?.description ?? '',);

      // Initialize the keywords controller with the items from the model
      if (widget.vendorProductSeoModel?.keywords != null) {
        _selectedKeywords =
            widget.vendorProductSeoModel?.keywords.toSet() ?? {};
      } else {
        _selectedKeywords = {};
      }

      // Initialize the seoIndexType from the model
      seoIndexType = getIndexTypeEnum(widget.vendorProductSeoModel?.type);
      setState(() {});
    });
  }

  bool _isProcessing = false;

  void setProcessing(bool value) {
    setState(() {
      _isProcessing = value;
    });
  }

  Future _onRefresh() async {
    try {
      setProcessing(true);
      final provider =
          Provider.of<VendorCreateProductViewModel>(context, listen: false);
      await provider.vendorGetProductSeoKeywords(context: context);

      if (provider.vendorGetSeoKeywordsApiResponse.status ==
          ApiStatus.COMPLETED) {
        _availableKeywords =
            provider.vendorGetSeoKeywordsApiResponse.data?.data?.toSet() ?? {};
      }
      setProcessing(false);
    } catch (e) {
      setProcessing(false);
      print('Error: $e');
    }
  }

  /// to get the index type as string from index type enum i.e. SeoIndexType
  String getIndexTypeFromEnumAsString() {
    switch (seoIndexType) {
      case SeoIndexType.INDEX:
        return SeoIndexConstants.INDEX;
      case SeoIndexType.NON_INDEX:
        return SeoIndexConstants.NO_INDEX;
    }
  }

  /// to get enum from selected index type as string
  SeoIndexType getIndexTypeEnum(String? value) {
    switch (value) {
      case SeoIndexConstants.INDEX:
        return SeoIndexType.INDEX;
      case SeoIndexConstants.NO_INDEX:
        return SeoIndexType.NON_INDEX;
      default:
        return SeoIndexType.INDEX;
    }
  }

  /// Function to execute when user will leave the page
  void _return() {
    // Construct the KeywordModel object
    final VendorProductSeoModel keywordModel = VendorProductSeoModel(
      title: _titleController.text,
      description: _descriptionController.text,
      keywords: _selectedKeywords.toList(),
      type: getIndexTypeFromEnumAsString(),
    );

    // Uncomment this if you need to pass the object back to the previous screen.
    Navigator.pop(context, keywordModel);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) {
          return;
        }
        _return();
      },
      child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        appBar: VendorModifySectionsAppBar(
          title: 'Edit SEO meta',
          onGoBack: _return,
        ),
        body: Utils.modelProgressHud(
            context: context,
            processing: _isProcessing,
            child: Utils.pageRefreshIndicator(
                onRefresh: _onRefresh,
                child: _buildUi(context),
                context: context,),),
      ),
    );
  }

  Widget _buildUi(BuildContext context) => ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          Padding(
            padding: EdgeInsets.all(kPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// title
                CustomTextFormField(
                  labelText: 'Title',
                  required: false,
                  hintText: 'Enter Title',
                  maxLength: 70,
                  focusNode: _titleFocusNode,
                  nextFocusNode: _descriptionFocusNode,
                  controller: _titleController,
                ),

                /// description
                CustomTextFormField(
                  labelText: 'Description',
                  required: false,
                  hintText: 'Enter Description',
                  maxLength: 160,
                  maxLines: 3,
                  keyboardType: TextInputType.multiline,
                  focusNode: _descriptionFocusNode,
                  nextFocusNode: _keywordsFocusNode,
                  controller: _descriptionController,
                ),

                /// Keywords Section
                Consumer<VendorCreateProductViewModel>(
                  builder: (context, provider, _) => CustomTextFormField(
                    labelText: 'SEO Keywords',
                    required: false,
                    hintText: 'Enter SEO Keywords',
                    focusNode: _keywordsFocusNode,
                    controller: _keywordsTextFieldController,
                    suffix: _keywordsTextFieldController.text.isNotEmpty
                        ? texFieldPrefix(
                            screenWidth: screenWidth,
                            text: 'Add',
                            tooltipMessage: 'Add Keyword',
                            onTap: _onAddCustomKeyword,
                          )
                        : null,
                    onChanged: _searchSuggestKeyword,
                  ),
                ),
                // Show loader when searching
                if (_isSearching) Utils.searching(context: context),

                /// show only when filtered keywords are available
                if (_filteredKeywords.isNotEmpty)
                  SimpleCard(
                    expandedContentPadding: EdgeInsets.zero,
                    expandedContent: Column(
                      children: [
                        Container(
                          constraints:
                              BoxConstraints(maxHeight: screenHeight * 0.4),
                          child: Builder(
                            builder: (context) {
                              // Convert set to list outside the ListView
                              final finalKeywordsList =
                                  _filteredKeywords.toList();
                              return ListView.separated(
                                shrinkWrap: true,
                                physics: const AlwaysScrollableScrollPhysics(),
                                itemCount: finalKeywordsList.length,
                                // Use the length of the list
                                itemBuilder: (context, index) {
                                  final keyword = finalKeywordsList[index];
                                  return ListTile(
                                    isThreeLine: false,
                                    dense: true,
                                    visualDensity: VisualDensity.compact,
                                    contentPadding: EdgeInsets.zero,
                                    tileColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.vertical(
                                        top: index == 0
                                            ? const Radius.circular(8)
                                            : Radius.zero,
                                        bottom: index ==
                                                finalKeywordsList.length - 1
                                            ? const Radius.circular(8)
                                            : Radius.zero,
                                      ),
                                    ),
                                    trailing: texFieldPrefix(
                                      screenWidth: screenWidth,
                                      text: 'Add',
                                      tooltipMessage: 'Add Keyword',
                                      onTap: () => _onAddAvailableKeyword(
                                          keyword,), // Wrap in a closure
                                    ),
                                    title: Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: kSmallPadding,),
                                      child: Text(keyword),
                                    ),
                                  );
                                },
                                separatorBuilder: (context, _) =>
                                    const Divider(thickness: 0.1, height: 1),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),

                /// show available keywords
                Column(
                  children: [
                    kExtraSmallSpace,
                    Wrap(
                      alignment: WrapAlignment.start,
                      spacing: kSmallPadding,
                      runSpacing: kSmallPadding,
                      runAlignment: WrapAlignment.spaceAround,
                      children: _selectedKeywords
                          .map(
                            (element) => TagChip(
                              keyword: element.toString(),
                              onRemove: () {
                                setState(() {
                                  _selectedKeywords.remove(element);
                                });
                              },
                            ),
                          )
                          .toList(),
                    ),
                  ],
                ),
                kExtraSmallSpace,

                /// index or no index radio buttons
                fieldTitle(text: 'Index'),
                kMinorSpace,
                Wrap(
                  spacing: kPadding,
                  children: [
                    VendorCustomRadioListTile(
                      title: 'Index',
                      value: SeoIndexType.INDEX,
                      groupValue: seoIndexType,
                      onChanged: (value) {
                        setState(() {
                          seoIndexType = value;
                        });
                      },
                    ),
                    VendorCustomRadioListTile(
                      title: 'No Index',
                      value: SeoIndexType.NON_INDEX,
                      groupValue: seoIndexType,
                      onChanged: (value) {
                        setState(() {
                          seoIndexType = value;
                        });
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      );

  /// search suggest keyword function
  Timer? _debounce;

  bool _isSearching = false; // Add a state variable

  void _searchSuggestKeyword(String value) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    if (value.isEmpty) {
      setState(() {
        _filteredKeywords.clear();
        _isSearching = false; // Stop searching
      });
      return;
    }

    setState(() {
      _isSearching = true; // Show searching state
    });

    _debounce = Timer(const Duration(milliseconds: 500), () {
      final search = value.toLowerCase();
      setState(() {
        _filteredKeywords = _availableKeywords
            .where((element) => element.toLowerCase().contains(search))
            .toSet();
        _isSearching = false; // Stop searching after filtering
      });
    });
  }

  /// Function to add custom keyword to _selected keywords list
  void _onAddCustomKeyword() {
    try {
      if (_keywordsTextFieldController.text.isNotEmpty) {
        setState(() {
          _selectedKeywords.add(_keywordsTextFieldController.text);
          _keywordsTextFieldController.clear();
          _filteredKeywords.clear();
        });
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  /// Function to add available keyword to _selected keywords list
  void _onAddAvailableKeyword(keyword) {
    try {
      setState(() {
        _selectedKeywords.add(keyword);
        _filteredKeywords.remove(keyword);
      });
    } catch (e) {
      print('Error: $e');
    }
  }
}
