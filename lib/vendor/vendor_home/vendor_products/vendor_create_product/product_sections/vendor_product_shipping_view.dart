import 'package:event_app/models/vendor_models/products/create_product/vendor_product_dimensions_model.dart';
import 'package:event_app/utils/mixins_and_constants/constants.dart';
import 'package:event_app/utils/mixins_and_constants/media_query_mixin.dart';
import 'package:event_app/utils/vendor_utils.dart' show formatDecimal;
import 'package:event_app/vendor/components/app_bars/vendor_modify_sections_app_bar.dart';
import 'package:event_app/vendor/components/text_fields/custom_text_form_field.dart';
import 'package:event_app/vendor/vendor_home/vendor_products/vendor_create_product/product_sections/vendor_product_overview_view.dart';
import 'package:event_app/vendor/view_models/vendor_products/vendor_create_product_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class VendorProductShippingView extends StatefulWidget {
  final VendorProductDimensionsModel? vendorProductDimensionsModel;

  VendorProductShippingView({required this.vendorProductDimensionsModel});

  @override
  _VendorProductShippingViewState createState() => _VendorProductShippingViewState();
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
    Map<String, dynamic> map = {
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
            title: "Product Overview (Shipping)",
            onGoBack: _return,
          ),
          body: _buildUi(context),
        ));
  }

  Widget _buildUi(BuildContext context) {
    final VendorCreateProductViewModel generalSettingsViewModel = Provider.of<VendorCreateProductViewModel>(context, listen: false);
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(kPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomTextFormField(
              labelText: "Weight (g)",
              required: false,
              maxLength: 10,
              hintText: "Enter Weight",
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              prefix: texFieldPrefix(screenWidth: screenWidth, text: 'g'),
              focusNode: _weightFocusNode,
              nextFocusNode: _lengthFocusNode,
              controller: _weightController,
            ),
            // kFormFieldSpace,
            CustomTextFormField(
              labelText: "Length (cm)",
              required: false,
              maxLength: 10,
              hintText: "Enter Length",
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              prefix: texFieldPrefix(screenWidth: screenWidth, text: 'cm'),
              focusNode: _lengthFocusNode,
              nextFocusNode: _widthFocusNode,
              controller: _lengthController,
            ),
            // kFormFieldSpace,
            CustomTextFormField(
              labelText: "Width (cm)",
              required: false,
              maxLength: 10,
              hintText: "Enter Width",
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              prefix: texFieldPrefix(screenWidth: screenWidth, text: 'cm'),
              focusNode: _widthFocusNode,
              nextFocusNode: _heightFocusNode,
              controller: _widthController,
            ),
            // kFormFieldSpace,
            CustomTextFormField(
              labelText: "Height (cm)",
              required: false,
              maxLength: 10,
              hintText: "Enter Height",
              keyboardType: TextInputType.numberWithOptions(decimal: true),
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
