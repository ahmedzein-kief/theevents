import 'package:another_stepper/dto/stepper_data.dart';
import 'package:another_stepper/widgets/another_stepper.dart';
import 'package:event_app/core/constants/app_strings.dart';
import 'package:event_app/core/constants/vendor_app_strings.dart';
import 'package:event_app/core/helper/extensions/app_localizations_extension.dart';
import 'package:event_app/core/helper/mixins/media_query_mixin.dart';
import 'package:event_app/core/styles/app_colors.dart';
import 'package:event_app/core/styles/app_sizes.dart';
import 'package:event_app/core/utils/app_utils.dart';
import 'package:event_app/core/widgets/custom_auth_views/app_custom_button.dart';
import 'package:event_app/data/vendor/data/response/apis_status.dart';
import 'package:event_app/provider/payment_address/customer_address.dart';
import 'package:event_app/vendor/components/app_bars/vendor_common_app_bar.dart';
import 'package:event_app/vendor/components/buttons/custom_icon_button_with_text.dart';
import 'package:event_app/vendor/components/data_tables/custom_data_tables.dart';
import 'package:event_app/vendor/components/dialogs/delete_item_alert_dialog.dart';
import 'package:event_app/vendor/components/dropdowns/custom_dropdown.dart';
import 'package:event_app/vendor/components/settings_components/simple_card.dart';
import 'package:event_app/vendor/components/status_constants/order_confirmation_constants.dart';
import 'package:event_app/vendor/components/status_constants/order_status_constants.dart';
import 'package:event_app/vendor/components/status_constants/payment_status_constants.dart';
import 'package:event_app/vendor/components/status_constants/shipment_status_constants.dart';
import 'package:event_app/vendor/components/text_fields/custom_text_form_field.dart';
import 'package:event_app/vendor/vendor_home/vendor_orders/vendor_update_shipping_address_bottom_sheet_view.dart';
import 'package:event_app/vendor/view_models/vendor_orders/vendor_cancel_order.dart';
import 'package:event_app/vendor/view_models/vendor_orders/vendor_confirm_order_view_model.dart';
import 'package:event_app/vendor/view_models/vendor_orders/vendor_generate_order_invoice_view_model.dart';
import 'package:event_app/vendor/view_models/vendor_orders/vendor_get_order_details_view_model.dart';
import 'package:event_app/vendor/view_models/vendor_orders/vendor_get_orders_view_model.dart';
import 'package:event_app/vendor/view_models/vendor_orders/vendor_send_confirmation_email.dart';
import 'package:event_app/vendor/view_models/vendor_orders/vendor_update_order_view_model.dart';
import 'package:event_app/vendor/view_models/vendor_orders/vendor_update_shipment_status_view_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class VendorEditOrderView extends StatefulWidget {
  const VendorEditOrderView({super.key, required this.orderID});

  final String orderID;

  @override
  State<VendorEditOrderView> createState() => _VendorEditOrderViewState();
}

class _VendorEditOrderViewState extends State<VendorEditOrderView> with MediaQueryMixin {
  /// create history stepper list
  List<StepperData> stepperData = [];

  void _initializeStepper({required VendorGetOrderDetailsViewModel provider}) {
    final history = provider.apiResponse.data?.data?.history ?? [];
    stepperData = history
        .map(
          (element) => StepperData(
            title: StepperText(
              element.historyVariables?.toString() ?? '',
              textStyle: detailsTitleStyle,
            ),
            subtitle: StepperText(
              element.createdAt?.toString() ?? '',
              textStyle: detailsDescriptionStyle,
            ),
            iconWidget: Container(
              decoration: const BoxDecoration(
                color: AppColors.lightCoral,
                borderRadius: BorderRadius.all(Radius.circular(30)),
              ),
              child: kShowVoid,
            ),
          ),
        )
        .toList();
  }

  bool _isProcessing = false;

  void setProcessing(bool value) {
    setState(() {
      _isProcessing = value;
    });
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((callback) async {
      await _onRefresh();
    });
    super.initState();
  }

  Future _onRefresh() async {
    final provider = context.read<VendorGetOrderDetailsViewModel>();
    await provider.vendorGetOrderDetails(orderId: widget.orderID);
    _initializeStepper(provider: provider);
  }

  @override
  void dispose() {
    super.dispose(); // Always call super.dispose()
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: const VendorCommonAppBar(title: 'Orders'),
        body: AppUtils.modelProgressHud(
          context: context,
          processing: _isProcessing,
          child: AppUtils.pageRefreshIndicator(
            onRefresh: _onRefresh,
            child: _buildUi(context),
            context: context,
          ),
        ),
      );

  final _noteController = TextEditingController();
  final _shipmentStatusController = TextEditingController();

  Widget _buildUi(BuildContext context) => Consumer<VendorGetOrderDetailsViewModel>(
        builder: (context, provider, _) {
          /// current api status
          final ApiStatus? apiStatus = provider.apiResponse.status;
          if (apiStatus == ApiStatus.LOADING) {
            return AppUtils.pageLoadingIndicator(context: context);
          }
          if (apiStatus == ApiStatus.ERROR) {
            return ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              children: [AppUtils.somethingWentWrong()],
            );
          }
          return _orderDetails(context: context, provider: provider);
        },
      );

  Widget _orderDetails({
    required context,
    required VendorGetOrderDetailsViewModel provider,
  }) {
    final orderData = provider.apiResponse.data?.data;
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(kPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Mention the order number
            Text(
              "Edit Order${orderData?.code.toString() ?? '--'}",
              textAlign: TextAlign.start,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            kExtraSmallSpace,

            /// order Information
            Column(
              children: [
                _orderInformation(provider: provider),
                kMediumSpace,
              ],
            ),

            /// Shipment history
            if (orderData?.history != null && stepperData.isNotEmpty) _shipmentHistory(provider: provider),

            /// Custom Details
            _customerInformation(provider: provider),
            kSmallSpace,
          ],
        ),
      ),
    );
  }

  /// order info
  Widget _orderInformation({required VendorGetOrderDetailsViewModel provider}) {
    final orderData = provider.apiResponse.data?.data;
    final shipment = provider.apiResponse.data?.data?.shipment;
    return SimpleCard(
      borderRadius: 5,
      expandedContentPadding: EdgeInsets.zero,
      expandedContent: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // order information
          Padding(
            padding: EdgeInsets.only(
              top: kSmallPadding,
              left: kPadding,
              right: kPadding,
            ),
            child: Row(
              children: [
                /// order id
                Expanded(
                  child: RichText(
                    text: TextSpan(
                      children: [
                        const TextSpan(
                          text: 'Order Information ',
                          style: TextStyle(color: Colors.black),
                        ),
                        TextSpan(
                          text: orderData?.code.toString() ?? '--',
                          style: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                /// Status Button : only shows the order status
                if (orderData?.orderCompleted ?? false)
                  CustomIconButtonWithText(
                    text: orderData?.orderStatus?.label ?? '',
                    icon: const Icon(
                      Icons.shopping_cart,
                      color: Colors.white,
                      size: 15,
                    ),
                    borderColor: Colors.transparent,
                    color: AppColors.getOrderStatusColor(
                      orderData?.orderStatus?.value,
                    ),
                    textColor: Colors.white,
                    borderRadius: kExtraSmallCardRadius,
                    visualDensity: VisualDensity.compact,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 2),
                    onPressed: () {},
                  ),
              ],
            ),
          ),
          const Divider(
            thickness: 0.3,
          ),

          /// order name
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: orderData?.items?.length ?? 0,
            itemBuilder: (context, index) {
              final item = orderData?.items?[index];
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: kExtraSmallPadding,
                      horizontal: screenWidth / 18,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item?.name?.toString() ?? '--',
                          style: const TextStyle(
                            color: AppColors.lightCoral,
                            fontSize: 17,
                          ),
                        ),
                        kMinorSpace,

                        /// SKU
                        RichText(
                          text: TextSpan(
                            children: [
                              // TextSpan(
                              //     text: "(",
                              //     style: TextStyle(color: Colors.black)),
                              const TextSpan(
                                text: 'SKU: ',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 13,
                                ),
                              ),
                              TextSpan(
                                text: item?.sku?.toString() ?? '--', // Dynamic SKU
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              // TextSpan(
                              //     text: ")",
                              //     style: TextStyle(color: Colors.black)),
                            ],
                          ),
                        ),
                        kExtraSmallSpace,

                        /// Quantity and Status
                        if (orderData?.shipment?.id != null)
                          RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: "${item?.qty?.toString() ?? ''} ",
                                  style: const TextStyle(
                                    color: AppColors.stoneGray,
                                    fontSize: 12,
                                  ),
                                ),
                                const TextSpan(
                                  text: 'Completed',
                                  style: TextStyle(
                                    color: AppColors.stoneGray,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        kMinorSpace,

                        /// Shipping Methods
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              CupertinoIcons.arrow_turn_down_right,
                              color: Colors.black,
                              size: 15,
                            ),
                            RichText(
                              text: TextSpan(
                                children: [
                                  const TextSpan(
                                    text: 'Shipping ',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 11,
                                    ),
                                  ),
                                  TextSpan(
                                    text: item?.shippingMethodName?.toString() ?? '',
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        kExtraSmallSpace,

                        /// Amount * Quantity
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            RichText(
                              text: TextSpan(
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 12,
                                ),
                                children: [
                                  TextSpan(
                                    text: item?.priceFormat?.toString() ?? '',
                                  ),
                                  const WidgetSpan(
                                    child: SizedBox(width: 8),
                                  ),
                                  const TextSpan(text: 'X'),
                                  const WidgetSpan(
                                    child: SizedBox(width: 10),
                                  ),
                                  TextSpan(text: '${item?.qty?.toString()}'),
                                  const WidgetSpan(
                                    child: SizedBox(width: 8),
                                  ),
                                  TextSpan(
                                    text: item?.totalAmountFormat?.toString(),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  if (index < (orderData?.items?.length ?? 0) - 1) const Divider(thickness: 0.1),
                ],
              );
            },
          ),
          const Divider(thickness: 0.1),
          //// Total and sub amounts calculation
          Table(
            columnWidths: {
              0: FlexColumnWidth(screenWidth / 22),
              1: FlexColumnWidth(screenWidth / 50),
              // Adjust width of the second column to add more space
            },
            children: [
              TableRow(
                children: [
                  _buildCell(text: 'Sub Amount', isEndAligned: true),
                  _buildCell(text: orderData?.subTotalFormat?.toString()),
                ],
              ),
              TableRow(
                children: [
                  _buildCell(text: 'Discount', isEndAligned: true),
                  _buildCell(text: orderData?.discountAmountFormat?.toString()),
                ],
              ),
              TableRow(
                children: [
                  _buildCell(
                    customText: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(VendorAppStrings.shippingFee.tr),
                        Text(
                          orderData?.shippingMethodName?.toString() ?? '',
                          style: const TextStyle(fontSize: 12),
                        ),
                        Text(
                          orderData?.weight?.toString() ?? '',
                          style: const TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                    isEndAligned: true,
                    isBold: true,
                  ),
                  _buildCell(text: orderData?.shippingAmountFormat?.toString()),
                ],
              ),
              TableRow(
                children: [
                  _buildCell(text: 'Tax', isEndAligned: true),
                  _buildCell(text: orderData?.taxAmountFormat),
                ],
              ),
              TableRow(
                children: [
                  _buildCell(text: 'Total Amount', isEndAligned: true),
                  _buildCell(text: orderData?.amountFormat?.toString()),
                ],
              ),
              TableRow(
                decoration: const BoxDecoration(
                  border: Border(
                    top: BorderSide(
                      width: 0.09, // Specify the thickness of the border
                    ),
                  ),
                ),
                children: [
                  _buildCell(
                    text: 'Paid Amount',
                    isEndAligned: true,
                    isBold: true,
                  ),

                  /// show full amount here if payment status is completed
                  _buildCell(
                    text: orderData?.paymentStatus?.value == PaymentStatusConst.COMPLETED
                        ? orderData?.amountFormat?.toString() ?? '--'
                        : '--',
                    isBold: true,
                  ),
                ],
              ),
            ],
          ),
          kSmallSpace,

          /// download invoice button
          Padding(
            padding: EdgeInsets.symmetric(horizontal: screenWidth / 18),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Consumer<VendorGenerateOrderInvoiceViewModel>(
                  builder: (context, generateInvoiceProvider, _) => CustomIconButtonWithText(
                    text: 'Download Invoice',
                    icon: const Icon(
                      CupertinoIcons.down_arrow,
                      size: 12,
                    ),
                    borderRadius: kExtraSmallButtonRadius,
                    isLoading: generateInvoiceProvider.apiResponse.status == ApiStatus.LOADING,
                    onPressed: () async {
                      await generateInvoiceProvider.vendorGenerateOrderInvoice(
                        orderId: widget.orderID.toString(),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),

          /// Note:
          Padding(
            padding: EdgeInsets.symmetric(horizontal: kPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomTextFormField(
                  labelText: VendorAppStrings.note.tr,
                  required: false,
                  hintText: VendorAppStrings.addNote.tr,
                  controller: _noteController,
                  maxLines: 2,
                  borderRadius: kSmallButtonRadius,
                ),
                kSmallSpace,

                /// Save button
                ChangeNotifierProvider(
                  create: (context) => VendorUpdateOrderViewModel(),
                  child: Consumer<VendorUpdateOrderViewModel>(
                    builder: (context, vendorUpdateOrderProvider, _) => CustomAppButton(
                      buttonText: 'Save',
                      textStyle: const TextStyle(color: Colors.black),
                      borderColor: AppColors.stoneGray,
                      borderRadius: kSmallButtonRadius,
                      buttonColor: Colors.transparent,
                      loadingIndicatorColor: AppColors.lightCoral,
                      padding: EdgeInsets.symmetric(
                        horizontal: kPadding,
                        vertical: kExtraSmallPadding,
                      ),
                      isLoading: vendorUpdateOrderProvider.apiResponse.status == ApiStatus.LOADING,
                      onTap: () async {
                        try {
                          if (_noteController.text.isEmpty) {
                            AppUtils.showToast('Please add note.');
                          } else {
                            await vendorUpdateOrderProvider.vendorUpdateOrder(
                              orderID: widget.orderID.toString(),
                              description: _noteController.text,
                              context: context,
                            );
                          }
                        } catch (error) {
                          debugPrint(error.toString());
                        }
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),

          /// confirm order
          Padding(
            padding: EdgeInsets.symmetric(horizontal: kPadding),
            child: Column(
              children: [
                kMediumSpace,

                /// Confirm Button
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    StatusLabel(
                      label: showOrderConfirmationLabel(
                        !(orderData?.isConfirmed ?? false),
                      ),
                      icon: CupertinoIcons.checkmark_alt,
                      iconColor: !(orderData?.isConfirmed ?? false)
                          ? AppColors.stoneGray
                          : AppColors.success, // Pass the color you need
                    ),
                    if (!(orderData?.isConfirmed ?? false))
                      ChangeNotifierProvider(
                        create: (context) => VendorConfirmOrderViewModel(),
                        child: Consumer<VendorConfirmOrderViewModel>(
                          builder: (context, vendorConfirmOrderProvider, _) => CustomAppButton(
                            buttonText: VendorAppStrings.confirm.tr,
                            buttonColor: Colors.blue,
                            padding: const EdgeInsets.symmetric(
                              vertical: 4,
                              horizontal: 10,
                            ),
                            borderRadius: kSmallButtonRadius,
                            textStyle: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                            isLoading: vendorConfirmOrderProvider.apiResponse.status == ApiStatus.LOADING,
                            onTap: () async {
                              try {
                                // Get provider before async operation
                                final vendorAllOrdersProvider = context.read<VendorGetOrdersViewModel>();

                                final result = await vendorConfirmOrderProvider.vendorConfirmOrder(
                                  orderID: widget.orderID.toString(),
                                  context: context,
                                );

                                if (result && context.mounted) {
                                  // Check if context is still valid
                                  await _onRefresh();
                                  vendorAllOrdersProvider.clearList();
                                  vendorAllOrdersProvider.vendorGetOrders();
                                }
                              } catch (e) {
                                if (context.mounted) {
                                  AppUtils.showToast('Failed to confirm order.');
                                }
                              }
                            },
                          ),
                        ),
                      ),
                  ],
                ),
                kSmallSpace,
              ],
            ),
          ),

          const Divider(thickness: 0.3),

          /// delivery details
          Padding(
            padding: EdgeInsets.symmetric(horizontal: kPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                kSmallSpace,

                /// header
                const StatusLabel(
                  label: 'DELIVERY',
                  icon: CupertinoIcons.checkmark_alt,
                  iconColor: AppColors.success, // Pass the color you need
                ),
                kLargeSpace,

                /// shipping id
                Text(
                  'SHIPPING',
                  style: dataColumnTextStyle(),
                ),
                kExtraSmallSpace,
                Text(
                  shipment?.name?.toString() ?? '--',
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                kMediumSpace,

                /// status
                Text(
                  'STATUS',
                  style: dataColumnTextStyle(),
                ),
                kExtraSmallSpace,
                showStatusBox(
                  statusText: shipment?.status?.label ?? '',
                  color: AppColors.getShipmentStatusColor(
                    shipment?.status?.value,
                  ),
                ),

                kMediumSpace,

                /// Shipping method
                Text(
                  'SHIPPING METHOD',
                  style: dataColumnTextStyle(),
                ),
                kExtraSmallSpace,
                Text(shipment?.shippingMethodName?.toString() ?? ''),

                kMediumSpace,

                /// weight
                Text(
                  'WEIGHT (G)',
                  style: dataColumnTextStyle(),
                ),
                kExtraSmallSpace,
                Text(shipment?.weight?.toString() ?? ''),

                kMediumSpace,

                /// last update
                Text(
                  'LAST UPDATE',
                  style: dataColumnTextStyle(),
                ),
                kExtraSmallSpace,
                Text(
                  AppUtils.formatTimestamp(
                    shipment?.updatedAt?.toString() ?? '',
                  ),
                ),
              ],
            ),
          ),
          kSmallSpace,

          /// show update status button bases on conditions
          if (orderData != null && (orderData.shippingEnabled ?? false) ||
              isShipmentStatusValid(shipment?.status?.value))
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: kPadding,
                vertical: kSmallPadding,
              ),
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                border: Border(top: BorderSide(color: Colors.grey.shade300)),
              ),
              child: Row(
                children: [
                  CustomIconButtonWithText(
                    text: 'Update Shipping Status',
                    icon: const Icon(
                      Icons.local_shipping_outlined

                      /// TODO: REPLACE WITH ORIGINAL ICON
                      ,
                      size: 12,
                    ),
                    borderRadius: kExtraSmallButtonRadius,
                    onPressed: () {
                      /// clear the shipmentStatusController firs?
                      _shipmentStatusController.clear();
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(kCardRadius),
                          ),
                          title: Container(
                            padding: const EdgeInsets.only(bottom: 5),
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  color: Colors.grey.shade300,
                                ),
                              ),
                            ),
                            child: Text(
                              VendorAppStrings.updateShippingStatus.tr,
                              style: detailsTitleStyle.copyWith(fontSize: 16),
                            ),
                          ),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              fieldTitle(text: VendorAppStrings.status.tr),
                              CustomDropdown<String>(
                                // ← Add type parameter
                                hintText: VendorAppStrings.selectShipmentStatus.tr,
                                textStyle: const TextStyle(color: Colors.black),
                                menuItemsList: provider.apiResponse.data?.data?.shippingStatuses
                                        ?.map(
                                          (element) => DropdownMenuItem<String>(
                                            // ← Add type parameter
                                            value: element.value?.toString(),
                                            child: Text(
                                              element.label?.toString() ?? '',
                                              style: const TextStyle(color: Colors.black),
                                            ),
                                          ),
                                        )
                                        .toList() ??
                                    [],
                                onChanged: (value) {
                                  setState(() {
                                    _shipmentStatusController.text = value ?? ''; // ← Handle nullable
                                  });
                                },
                              ),
                            ],
                          ),
                          actions: [
                            CustomAppButton(
                              buttonText: AppStrings.cancel.tr,
                              buttonColor: Colors.white,
                              borderRadius: kSmallButtonRadius,
                              padding: const EdgeInsets.symmetric(
                                vertical: 5,
                                horizontal: 10,
                              ),
                              textStyle: TextStyle(color: Colors.grey.shade900),
                              borderColor: Colors.grey,
                              onTap: () {
                                Navigator.of(context).pop();
                              },
                            ),
                            ChangeNotifierProvider(
                              create: (context) => VendorUpdateShipmentStatusViewModel(),
                              child: Consumer<VendorUpdateShipmentStatusViewModel>(
                                builder: (context, updateStatusProvider, _) => CustomAppButton(
                                  buttonText: AppStrings.update.tr,
                                  buttonColor: AppColors.lightCoral,
                                  borderRadius: kSmallButtonRadius,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 5,
                                    horizontal: 10,
                                  ),
                                  textStyle: const TextStyle(color: Colors.white),
                                  isLoading: updateStatusProvider.apiResponse.status == ApiStatus.LOADING,
                                  onTap: () async {
                                    try {
                                      if (_shipmentStatusController.text.isEmpty) {
                                        AppUtils.showToast(VendorAppStrings.pleaseSelectShipmentStatus.tr);
                                      } else {
                                        final bool result = await updateStatusProvider.vendorUpdateShipmentStatus(
                                          shipmentID: shipment?.id?.toString().trim() ?? '',
                                          shipmentStatus: _shipmentStatusController.text.toString().trim(),
                                          context: context,
                                        );
                                        if (result && context.mounted) {
                                          // Check if context is still valid
                                          Navigator.of(context).pop();
                                          await _onRefresh();
                                        }
                                      }
                                    } catch (e) {
                                      if (context.mounted) {
                                        AppUtils.showToast(VendorAppStrings.failedToUpdateShipmentStatus.tr);
                                      }
                                    }
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  ///history with stepper widget
  Widget _shipmentHistory({required VendorGetOrderDetailsViewModel provider}) {
    final history = provider.apiResponse.data?.data?.history ?? [];
    return Column(
      children: [
        SimpleCard(
          expandedContentPadding: EdgeInsets.zero,
          expandedContent: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(
                  top: kPadding,
                  left: kPadding,
                  right: kPadding,
                  bottom: kExtraSmallPadding,
                ),
                child: Text(
                  AppStrings.history.tr,
                  style: titleTextStyle(),
                ),
              ),
              const Divider(
                thickness: 0.3,
              ),

              /// History
              Padding(
                padding: EdgeInsets.symmetric(horizontal: kPadding),
                child: AnotherStepper(
                  stepperList: stepperData,
                  stepperDirection: Axis.vertical,
                  activeBarColor: AppColors.lightCoral,
                  inActiveBarColor: Colors.grey,
                  iconHeight: 10,
                  iconWidth: 10,
                  activeIndex: stepperData.length,
                  barThickness: 1,
                  verticalGap: 35,
                ),
              ),

              /// Resend email button
              if (history.isNotEmpty == true &&
                  history.any(
                        (element) => element.action?.toString() == 'send_order_confirmation_email',
                      ) ==
                      true)
                Padding(
                  padding: EdgeInsets.only(
                    left: kPadding,
                    right: kPadding,
                    bottom: kPadding,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ChangeNotifierProvider(
                        create: (context) => VendorSendConfirmationEmailViewModel(),
                        child: Consumer<VendorSendConfirmationEmailViewModel>(
                          builder: (context, sendConfirmationEmailProvider, _) => CustomAppButton(
                            buttonText: VendorAppStrings.resendEmail.tr,
                            buttonColor: Colors.transparent,
                            textStyle: const TextStyle(color: AppColors.lightCoral),
                            borderRadius: kSmallButtonRadius,
                            borderColor: AppColors.lightCoral,
                            loadingIndicatorColor: AppColors.lightCoral,
                            isLoading: sendConfirmationEmailProvider.apiResponse.status == ApiStatus.LOADING,
                            onTap: () async {
                              try {
                                final bool result = await sendConfirmationEmailProvider.vendorSendConfirmationEmail(
                                  orderID: widget.orderID.toString(),
                                  context: context,
                                );
                                if (result) {
                                  await _onRefresh();
                                }
                              } catch (error) {
                                debugPrint(error.toString());
                              }
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
        kMediumSpace,
      ],
    );
  }

  /// custom details
  Widget _customerInformation({
    required VendorGetOrderDetailsViewModel provider,
  }) {
    final orderData = provider.apiResponse.data?.data;
    final customer = provider.apiResponse.data?.data?.customer;
    final shipping = provider.apiResponse.data?.data?.shipping;
    return SimpleCard(
      borderRadius: 5,
      expandedContentPadding: EdgeInsets.zero,
      expandedContent: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// header
          Row(
            children: [
              Padding(
                padding: EdgeInsets.only(
                  left: kPadding,
                  right: kPadding,
                  top: kPadding,
                  bottom: kSmallPadding,
                ),
                child: Text(VendorAppStrings.customer.tr, style: titleTextStyle()),
              ),
            ],
          ),
          const Divider(
            thickness: 0.1,
          ),

          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: kPadding,
              vertical: kSmallPadding,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// profile image
                CircleAvatar(
                  radius: 25,
                  // Half of width/height (50/2)
                  backgroundColor: AppColors.lightCoral,
                  // Optional: background color
                  backgroundImage: customer?.avatarUrl != null && customer!.avatarUrl!.isNotEmpty
                      ? NetworkImage(customer.avatarUrl!)
                      : null,
                  onBackgroundImageError: (_, __) {},
                  // Handles image errors gracefully
                  child: (customer?.avatarUrl == null || customer!.avatarUrl!.isEmpty)
                      ? const Icon(
                          Icons.person,
                          color: Colors.grey,
                          size: 30,
                        ) // Placeholder icon
                      : null,
                ),

                kExtraSmallSpace,
                Text(
                  customer?.name?.toString() ?? '',
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.normal,
                  ),
                ),
                kMinorSpace,
                // number of orders
                Row(
                  children: [
                    const Icon(Icons.image_aspect_ratio_sharp, size: 14),
                    kExtraSmallSpace,
                    Text(customer?.totalOrders?.toString() ?? ''),
                    kExtraSmallSpace,
                    Text(VendorAppStrings.orderSuffix.tr),
                  ],
                ),
                kMinorSpace,

                /// email
                GestureDetector(
                  onTap: () async {
                    await AppUtils.launchEmail(customer?.email?.toString() ?? '');
                  },
                  child: Text(
                    customer?.email?.toString() ?? '',
                    style: const TextStyle(color: AppColors.lightCoral),
                  ),
                ),
                kMinorSpace,
                Text(customer?.haveAccountMessage?.toString() ?? ''),
              ],
            ),
          ),

          /// shipping information
          const Divider(
            thickness: 0.1,
          ),
          Padding(
            padding: EdgeInsets.only(
              left: kPadding,
              right: kPadding,
              top: kSmallPadding,
              bottom: 0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// edit shipping information
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        VendorAppStrings.shippingInformation.tr,
                        style: detailsTitleStyle.copyWith(
                          fontSize: 17,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    if (isOrderStatusValid(orderData?.orderStatus?.value))
                      GestureDetector(
                        onTap: () {
                          showModalBottomSheet(
                            showDragHandle: true,
                            context: context,
                            isScrollControlled: true,
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(
                                top: Radius.circular(4),
                              ),
                            ),
                            builder: (context) => VendorUpdateShippingAddressBottomSheetView(
                              orderId: widget.orderID.toString(),
                              shipmentId: shipping?.id?.toString() ?? '',
                              formKey: GlobalKey<FormState>(),
                              onSave: () {
                                // Handle save logic
                                Navigator.pop(context);
                              },
                              onUpdate: () {
                                // Handle update logic
                                Navigator.pop(context);
                              },
                              customerAddress: CustomerRecords(
                                name: shipping?.name,
                                phone: shipping?.phone,
                                email: shipping?.email,
                                address: shipping?.address,
                                country: shipping?.countryName,
                                state: shipping?.stateName,
                                city: shipping?.cityName,
                              ),
                              showUseDefaultButton: false,
                            ),
                          );
                        },
                        child: const Icon(
                          Icons.edit,
                          size: 16,
                          color: AppColors.stoneGray,
                        ),
                      ),
                  ],
                ),
                kExtraSmallSpace,

                /// name
                Text(
                  shipping?.name?.toString() ?? '',
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.normal,
                  ),
                ),
                kMinorSpace,

                /// phone number
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.phone,
                      color: AppColors.lightCoral,
                      size: 15,
                    ),
                    kExtraSmallSpace,
                    Expanded(
                      child: GestureDetector(
                        onTap: () async {
                          await AppUtils.makePhoneCall(
                            phoneNumber: shipping?.phone?.toString() ?? '',
                            context: context,
                          );
                        },
                        child: Text(
                          shipping?.phone?.toString() ?? '',
                          style: const TextStyle(color: AppColors.lightCoral),
                        ),
                      ),
                    ),
                  ],
                ),
                kMinorSpace,

                /// email
                GestureDetector(
                  onTap: () async {
                    await AppUtils.launchEmail(shipping?.email?.toString() ?? '');
                  },
                  child: Text(
                    shipping?.email?.toString() ?? '',
                    style: const TextStyle(color: AppColors.lightCoral),
                  ),
                ),
                kMinorSpace,

                ///address
                Text(shipping?.address?.toString() ?? ''),
                kMinorSpace,

                /// city
                Text(shipping?.cityName?.toString() ?? ''),
                kMinorSpace,

                /// state
                Text(shipping?.stateName?.toString() ?? ''),
                kMinorSpace,

                /// country
                Text(shipping?.countryName?.toString() ?? ''),
                kMinorSpace,
              ],
            ),
          ),

          /// cancel button
          if (orderData?.cancelEnabled ?? false)
            Container(
              width: double.infinity,
              padding: EdgeInsets.only(
                left: kPadding,
                right: kPadding,
                top: kExtraSmallPadding,
                bottom: kExtraSmallPadding,
              ),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                border: Border(top: BorderSide(color: Colors.grey.shade300)),
              ),
              child: Row(
                children: [
                  ChangeNotifierProvider(
                    create: (context) => VendorCancelOrderViewModel(),
                    child: Consumer<VendorCancelOrderViewModel>(
                      builder: (context, cancelOrderProvider, _) => CustomAppButton(
                        buttonText: AppStrings.cancel.tr,
                        borderColor: AppColors.stoneGray,
                        borderRadius: kSmallButtonRadius,
                        buttonColor: Colors.white,
                        loadingIndicatorColor: AppColors.lightCoral,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 7,
                        ),
                        textStyle: const TextStyle(color: Colors.black),
                        isLoading: cancelOrderProvider.apiResponse.status == ApiStatus.LOADING,
                        onTap: () async {
                          deleteItemAlertDialog(
                            context: context,
                            descriptionText: AppStrings.cancelOrderConfirmationMessage.tr,
                            buttonText: AppStrings.cancel.tr,
                            onDelete: () async {
                              try {
                                Navigator.of(context).pop();
                                final result = await cancelOrderProvider.vendorCancelOrder(
                                  orderID: widget.orderID.toString(),
                                  context: context,
                                );
                                if (result) {
                                  await _onRefresh();
                                }
                              } catch (error) {
                                debugPrint(error.toString());
                              }
                            },
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

Widget _buildCell({
  Widget? customText,
  String? text,
  bool isBold = false,
  bool isEndAligned = false,
}) =>
    Padding(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8.0),
      // Horizontal padding for spacing between columns
      child: customText ??
          Text(
            text ?? '--',
            textAlign: isEndAligned ? TextAlign.end : TextAlign.start,
            // Align text to the right or left
            style: TextStyle(
              fontSize: 14,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
    );

TextStyle titleTextStyle() => detailsTitleStyle.copyWith(fontSize: 16, fontWeight: FontWeight.w600);

class StatusLabel extends StatelessWidget {
  const StatusLabel({
    super.key,
    required this.label,
    required this.icon,
    this.iconColor = Colors.green, // Default color for the icon
    this.iconSize = 15.0, // Default size for the icon
  });

  final String label;
  final IconData icon;
  final Color iconColor;
  final double iconSize;

  @override
  Widget build(BuildContext context) => Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: iconSize, color: iconColor),
          const SizedBox(width: 4), // Adds spacing between icon and text
          Text(label),
        ],
      );
}

bool isShipmentStatusValid(String? status) {
  const validStatuses = [
    ShipmentStatusConst.PENDING,
    ShipmentStatusConst.APPROVED,
    ShipmentStatusConst.ARRANGE_SHIPMENT,
    ShipmentStatusConst.READY_TO_BE_SHIPPED_OUT,
  ];
  return validStatuses.contains(status);
}

bool isOrderStatusValid(String? status) {
  const validStatuses = [OrderStatusConst.PENDING, OrderStatusConst.PROCESSING];
  return validStatuses.contains(status);
}

String showOrderConfirmationLabel(bool isConfirmed) =>
    !isConfirmed ? OrderConfirmationConst.ORDER_WAS_CONFIRMED : OrderConfirmationConst.CONFIRM_ORDER;
