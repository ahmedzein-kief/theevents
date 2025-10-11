import 'package:event_app/core/constants/vendor_app_strings.dart';
import 'package:event_app/core/helper/extensions/app_localizations_extension.dart';
import 'package:event_app/core/helper/mixins/media_query_mixin.dart';
import 'package:event_app/core/styles/app_sizes.dart';
import 'package:event_app/core/utils/vendor_utils.dart' show formatDecimal;
import 'package:event_app/models/vendor_models/products/create_product/vendor_product_dimensions_model.dart';
import 'package:event_app/vendor/components/app_bars/vendor_modify_sections_app_bar.dart';
import 'package:event_app/vendor/components/text_fields/custom_text_form_field.dart';
import 'package:event_app/vendor/vendor_home/vendor_products/vendor_create_product/product_sections/vendor_product_overview_view.dart';
import 'package:flutter/material.dart';

class VendorProductShippingView extends StatefulWidget {
  const VendorProductShippingView({
    super.key,
    required this.vendorProductDimensionsModel,
  });

  final VendorProductDimensionsModel? vendorProductDimensionsModel;

  @override
  State<VendorProductShippingView> createState() => _VendorProductShippingViewState();
}

class _VendorProductShippingViewState extends State<VendorProductShippingView> with MediaQueryMixin {
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _lengthController = TextEditingController();
  final TextEditingController _widthController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();

  final FocusNode _weightFocusNode = FocusNode();
  final FocusNode _lengthFocusNode = FocusNode();
  final FocusNode _widthFocusNode = FocusNode();
  final FocusNode _heightFocusNode = FocusNode();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((callback) async {
      setState(() {
        _weightController.text = widget.vendorProductDimensionsModel?.weight ?? '';
        _lengthController.text = widget.vendorProductDimensionsModel?.length ?? '';
        _widthController.text = widget.vendorProductDimensionsModel?.width ?? '';
        _heightController.text = widget.vendorProductDimensionsModel?.height ?? '';
      });
    });
    super.initState();
  }

  void _return() {
    final Map<String, dynamic> map = {
      'weight': formatDecimal(_weightController.text),
      'length': formatDecimal(_lengthController.text),
      'width': formatDecimal(_widthController.text),
      'height': formatDecimal(_heightController.text),
    };
    Navigator.pop(context, VendorProductDimensionsModel.fromMap(map));
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
          title: VendorAppStrings.productOverviewShipping.tr,
          onGoBack: _return,
        ),
        body: _buildUi(context),
      ),
    );
  }

  Widget _buildUi(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(kPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomTextFormField(
              labelText: VendorAppStrings.weightG.tr,
              required: false,
              maxLength: 10,
              hintText: VendorAppStrings.enterWeight.tr,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              prefix: texFieldPrefix(screenWidth: screenWidth, text: 'g'),
              focusNode: _weightFocusNode,
              nextFocusNode: _lengthFocusNode,
              controller: _weightController,
            ),
            // kFormFieldSpace,
            CustomTextFormField(
              labelText: VendorAppStrings.lengthCm.tr,
              required: false,
              maxLength: 10,
              hintText: VendorAppStrings.enterLength.tr,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              prefix: texFieldPrefix(screenWidth: screenWidth, text: 'cm'),
              focusNode: _lengthFocusNode,
              nextFocusNode: _widthFocusNode,
              controller: _lengthController,
            ),
            // kFormFieldSpace,
            CustomTextFormField(
              labelText: VendorAppStrings.widthCm.tr,
              required: false,
              maxLength: 10,
              hintText: VendorAppStrings.enterWidth.tr,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              prefix: texFieldPrefix(screenWidth: screenWidth, text: 'cm'),
              focusNode: _widthFocusNode,
              nextFocusNode: _heightFocusNode,
              controller: _widthController,
            ),
            // kFormFieldSpace,
            CustomTextFormField(
              labelText: VendorAppStrings.heightCm.tr,
              required: false,
              maxLength: 10,
              hintText: VendorAppStrings.enterHeight.tr,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              prefix: texFieldPrefix(screenWidth: screenWidth, text: 'cm'),
              focusNode: _heightFocusNode,
              nextFocusNode: null,
              // No next focus if it's the last field
              controller: _heightController,
            ),
          ],
        ),
      ),
    );
  }
}
