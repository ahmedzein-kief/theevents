import 'package:event_app/data/vendor/data/response/apis_status.dart';
import 'package:event_app/models/vendor_models/vendor_withdrawals_model/vendor_get_withdrawals_model.dart';
import 'package:event_app/provider/navigation_service.dart';
import 'package:event_app/core/styles/app_colors.dart';
import 'package:event_app/core/widgets/custom_auth_views/app_custom_button.dart';
import 'package:event_app/utils/mixins_and_constants/constants.dart';
import 'package:event_app/utils/mixins_and_constants/media_query_mixin.dart';
import 'package:event_app/utils/validator/validator.dart';
import 'package:event_app/vendor/Components/data_tables/custom_data_tables.dart';
import 'package:event_app/vendor/components/app_bars/vendor_common_app_bar.dart';
import 'package:event_app/vendor/components/buttons/custom_action_button.dart';
import 'package:event_app/vendor/components/buttons/custom_icon_button_with_text.dart';
import 'package:event_app/vendor/components/checkboxes/custom_checkboxes.dart';
import 'package:event_app/vendor/components/date_time_picker/date_time_picker.dart';
import 'package:event_app/vendor/components/dropdowns/custom_dropdown.dart';
import 'package:event_app/vendor/components/enums/enums.dart';
import 'package:event_app/vendor/components/settings_components/simple_card.dart';
import 'package:event_app/vendor/components/status_constants/payment_channel_constants.dart';
import 'package:event_app/vendor/components/status_constants/withdrawal_status_constants.dart';
import 'package:event_app/vendor/components/text_fields/custom_date_time_picker_field.dart';
import 'package:event_app/vendor/components/text_fields/custom_text_form_field.dart';
import 'package:event_app/vendor/components/utils/utils.dart';
import 'package:event_app/vendor/components/vendor_text_style.dart';
import 'package:event_app/vendor/vendor_home/vendor_coupons/coupon_view_utils.dart';
import 'package:event_app/vendor/vendor_home/vendor_settings/vendor_profile_settings_view.dart';
import 'package:event_app/vendor/view_models/dashboard/vendor_dashboard_view_model.dart';
import 'package:event_app/vendor/view_models/vendor_coupons/vendor_create_coupon_view_model.dart';
import 'package:event_app/vendor/view_models/vendor_coupons/vendor_generate_coupon_code_view_model.dart';
import 'package:event_app/vendor/view_models/vendor_coupons/vendor_get_coupons_view_model.dart';
import 'package:event_app/vendor/view_models/vendor_settings/vendor_get_settings_view_model.dart';
import 'package:event_app/vendor/view_models/vendor_withdrawal/vendor_create_upate_withdrawal_view_model.dart';
import 'package:event_app/vendor/view_models/vendor_withdrawal/vendor_show_withdrawal_view_model.dart';
import 'package:event_app/vendor/view_models/vendor_withdrawal/vendor_withdrawal_view_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../models/vendor_models/vendor_withdrawals_model/vendor_show_withdrawal_model.dart';

class VendorCreateUpdateWithdrawalView extends StatefulWidget {
  String? withdrawalID;
   VendorCreateUpdateWithdrawalView({super.key,this.withdrawalID
   });

  @override
  State<VendorCreateUpdateWithdrawalView> createState() => _VendorCreateUpdateWithdrawalViewState();
}

class _VendorCreateUpdateWithdrawalViewState extends State<VendorCreateUpdateWithdrawalView>
    with MediaQueryMixin {
  // Form key
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  /// controllers and focus nodes
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _feeController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  /// do you want to cancel withdrawal
  bool _cancelWithdrawal = false;

  String formatEndDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
  String formatStartDate = DateFormat('yyyy-MM-dd').format(DateTime.now().subtract(Duration(days: 365)));


  bool _isProcessing = false;

  setProcessing(bool value) {
    setState(() {
      _isProcessing = value;
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((callback)async{
      await _onRefresh();
    });
  }


  Future _onRefresh() async {
    try{
      setProcessing(true);
      final vendorDashboard =  context.read<VendorDashboardViewModel>();
      await vendorDashboard.getDashboardData(formatStartDate, formatEndDate);

      if (widget.withdrawalID!= null) {
        setProcessing(true);
        final showWithdrawalProvider =  context.read<VendorShowWithdrawalViewModel>();

        await showWithdrawalProvider.vendorShowWithdrawal(withdrawalID: widget.withdrawalID!);

        if(showWithdrawalProvider.apiResponse.status == ApiStatus.COMPLETED){
          final withdrawal = showWithdrawalProvider.apiResponse.data?.data;
          _amountController.text = withdrawal?.amount.toString() ?? '';
          _feeController.text = withdrawal?.fee.toString() ?? '';
          _descriptionController.text = withdrawal?.description?.toString() ?? '';

          setProcessing(false);
        }
        setProcessing(false);
      }
      setProcessing(false);
    }
    catch (e){
      setProcessing(false);
      print("Error: $e");
    }
  }


  @override
  void dispose() {
    // Dispose of all TextEditingControllers
    _amountController.dispose();
    _feeController.dispose();
    _descriptionController.dispose();

    super.dispose(); // Always call super.dispose()
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: VendorCommonAppBar(title: widget.withdrawalID == null ? "Create Withdrawal" : "Withdrawal #${widget.withdrawalID}"),
      body: Utils.modelProgressHud(
          processing: _isProcessing, child: _buildUi(context)),
      backgroundColor: AppColors.bgColor,
    );
  }

  Widget _buildUi(BuildContext context) {

   final dashboardProvider =  context.read<VendorDashboardViewModel>();
   final balance = dashboardProvider.apiResponse.data?.data.balanceFormat ?? '';
   final status  = context.read<VendorShowWithdrawalViewModel>().apiResponse.data?.data?.status;

   /// showProvider
    final showWithdrawalProvider =  context.read<VendorShowWithdrawalViewModel>();
    return Padding(
        padding: EdgeInsets.all(kSmallPadding),
        child: Form(
            key: _formKey,
            child: SingleChildScrollView(
                child: Column(children: [

              /// Basic Information
              SimpleCard(
                expandedContentPadding: EdgeInsets.zero,
                expandedContent: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// status
                  if(widget.withdrawalID != null)
                  Column(
                    children: [
                      Padding(
                        padding:  EdgeInsets.symmetric(horizontal: kMediumPadding,vertical: kMediumPadding),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Expanded(
                              child: Text("Status",style: TextStyle(fontWeight: FontWeight.w500,),),
                            ),
                            showStatusBox(statusText: status?.label ?? '',color: AppColors.getWithdrawalStatusColor(status?.value))
                          ],
                        ),
                      ),
                      Divider(color: Colors.grey,thickness: 0.5,height: 0.5,),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.all(kMediumPadding),
                    child: Column(
                      children: [
                        /// amount
                        CustomTextFormField(
                          labelText: "Amount (Balance: ${balance})",
                          labelTextStyle: CouponViewUtils.couponLabelTextStyle(),
                          required: true,
                          showTitle: true,
                          readOnly: widget.withdrawalID != null,
                          hintText: "Enter Amount",
                          controller: _amountController,
                          validator: Validator.fieldCannotBeEmpty,
                          keyboardType: TextInputType.number,
                        ),
                        kFormFieldSpace,

                        /// fee
                        if(widget.withdrawalID != null)
                          Column(
                            children: [
                              CustomTextFormField(
                                labelText: "Fee",
                                showTitle: true,
                                required: true,
                                readOnly: widget.withdrawalID != null,
                                validator: Validator.fieldCannotBeEmpty,
                                hintText: "Enter Fee",
                                keyboardType: TextInputType.number,
                                controller: _feeController,
                              ),
                              kFormFieldSpace,
                            ],
                          ),

                        /// description
                        CustomTextFormField(
                          labelText: "Description",
                          showTitle: true,
                          required: false,
                          readOnly: (showWithdrawalProvider.apiResponse.data?.data?.status?.value != WithdrawalStatusConstants.PENDING && widget.withdrawalID != null),
                          maxLines: 3,
                          hintText: "Enter Description",
                          keyboardType: TextInputType.multiline,
                          controller: _descriptionController,
                        ),

                        /// payout info text
                        if(widget.withdrawalID == null)Column(
                          children: [
                            kMinorSpace,
                            Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                RichText(text: TextSpan(
                                    children: [
                                      TextSpan(
                                          text: "You will receive money as per ",
                                          style: TextStyle(color: Colors.black, fontSize: 13)
                                      ),
                                      TextSpan(
                                          recognizer: TapGestureRecognizer()..onTap = ()=> Navigator.of(context).push(CupertinoPageRoute(builder: (context) => VendorProfileSettingsView(initialIndex: 2,),),),
                                          text: "Payout Info.",
                                          style: TextStyle(color: AppColors.peachyPink,fontSize: 13,fontWeight: FontWeight.w500,)
                                      ),
                                    ]
                                ),
                                ),
                              ],
                            )],
                        ),

                        /// show bank details
                        if(widget.withdrawalID != null)_showBankDetails(context),

                      ],
                    ),
                  )
                ]


                ,
              )),
              kFormFieldSpace,


              /// do you want to cancel withdrawal
                  if(showWithdrawalProvider.apiResponse.data?.data?.status?.value == WithdrawalStatusConstants.PENDING && widget.withdrawalID != null)
                    Column(
                      children: [
                        _cancelWithdrawalView(context),
                        kSmallSpace,
                      ],
                    ),

                  /// save button
                  if(showWithdrawalProvider.apiResponse.data?.data?.status?.value == WithdrawalStatusConstants.PENDING || widget.withdrawalID == null)
                    _saveButton(),
            ]))));
  }




  Widget _showBankDetails(context){
    return Consumer<VendorShowWithdrawalViewModel>(builder: (context,provider,_){
        final details = provider.apiResponse.data?.data?.bankInfo;
        final paymentChannel = provider.apiResponse.data?.data?.paymentChannel;
        return   areAllDetailsNull(details) ? kShowVoid : Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            kSmallSpace,
            RichText(text: TextSpan(text: "You will receive money through the information: ",style: TextStyle(color: Colors.black,fontSize: 12,fontWeight: FontWeight.w500)),),
            kMinorSpace,
          Container(
              padding:  EdgeInsets.symmetric(vertical: kExtraSmallPadding,horizontal: kSmallPadding),
              decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade400),
              borderRadius: BorderRadius.circular(kButtonRadius),
            ),
              child: Column(
                children: [
                  if(details?.name != null) buildRow("Bank Name", details?.name),
                  if(details?.code != null) buildRow("Bank Code/IFSC", details?.code),
                  if(details?.fullName != null) buildRow("Account Holder Name", details?.fullName),
                  if(details?.number != null) buildRow("Account Number", details?.number),
                  if(details?.paypalId != null) buildRow("Paypal ID", details?.paypalId, isLastRow: paymentChannel == PaymentChannelConstants.PAYPAL ),
                  if(details?.upiId != null) buildRow("Upi ID", details?.upiId),
                  if(details?.description != null) buildRow("Description", details?.description, isLastRow: paymentChannel == PaymentChannelConstants.BANK_TRANSFER),
                ],
              ),
            ),
          ],
        );
      });
  }

  Widget _cancelWithdrawalView(context){
    return SimpleCard(
        expandedContentPadding: EdgeInsets.zero,
        expandedContent: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding:  EdgeInsets.symmetric(horizontal: kMediumPadding,vertical: kMediumPadding),
              child: Text("Do you want to cancel this withdrawal?",style: TextStyle(fontWeight: FontWeight.w500,),),
            ),

            Divider(color: Colors.grey,thickness: 0.5,height: 0.5,),
            Transform.scale(
              scale: 0.7,
              child: CupertinoSwitch(
                activeTrackColor: AppColors.peachyPink,
                  value: _cancelWithdrawal, onChanged: (value){
                setState(() {
                  _cancelWithdrawal = value;
                });
              }),
            ),
            Padding(
              padding: EdgeInsets.only(left: kSmallPadding,right: kSmallPadding,bottom: kPadding),
              child: Text("After cancel amount and fee will be refunded back in your balance.",style: TextStyle(fontSize: 12,color: AppColors.darkGrey),)
            ),
          ],
        ));
  }

  Widget _saveButton(){
    return SimpleCard(
        expandedContentPadding: EdgeInsets.zero,
        expandedContent: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding:  EdgeInsets.symmetric(horizontal: kMediumPadding,vertical: kMediumPadding),
              child: Text("Publish",style: TextStyle(fontWeight: FontWeight.w500),),
            ),

            Divider(color: Colors.grey,thickness: 0.5,height: 0.5,),
            Padding(
              padding: EdgeInsets.all(kMediumPadding),
              child: ChangeNotifierProvider(
                create: (context) => VendorCreateUpdateWithdrawalViewModel(),
                child: Consumer<VendorCreateUpdateWithdrawalViewModel>(
                  builder: (context, provider, _) {
                    return
                      CustomIconButtonWithText(
                          text: "Request",
                          color: AppColors.peachyPink,
                          icon: Icon(
                            Icons.currency_exchange,
                            color: Colors.white,
                            size: 15,
                          ),
                          borderRadius: kSmallButtonRadius,
                          borderColor: Colors.transparent,
                          textColor: Colors.white,
                          isLoading: provider.apiResponse.status == ApiStatus.LOADING,
                          onPressed: () async {
                            /// We have to refresh the coupons list so clear list and call the coupons api again
                            try {
                              setProcessing(true);
                              if (_formKey.currentState?.validate() ?? false) {
                                _creteForm();
                                /// create withdrawal
                                if(widget.withdrawalID == null){
                                 final result =  await provider.vendorCreateUpdateWithdrawal(requestType: RequestType.CREATE, form: form, context: context);
                                 if(result){
                                   _descriptionController.clear();
                                   _amountController.clear();
                                   _feeController.clear();
                                   await _onRefresh();
                                 }
                                }
                                /// update withdrawal
                               else{
                                  await provider.vendorCreateUpdateWithdrawal(requestType: RequestType.UPDATE,withdrawalID: widget.withdrawalID, form: form, context: context);
                                  context.read<VendorWithdrawalsViewModel>().clearList();
                                  context.read<VendorWithdrawalsViewModel>().vendorWithdrawals();
                                  await _onRefresh();
                                }
                                setProcessing(false);

                                /// Calling the get vendor coupons api
                                final withdrawalsProvider = context.read<VendorWithdrawalsViewModel>();
                                withdrawalsProvider.clearList();
                                withdrawalsProvider.vendorWithdrawals();
                              }
                            } catch (e) {
                              print("Error: $e");
                              setProcessing(false);
                            }
                            setProcessing(false);
                          });
                  },
                ),
              ),
            )
          ],
        ));
  }


  bool areAllDetailsNull(BankInfo? details) {
    return details == null ||
        (details.name == null &&
            details.code == null &&
            details.fullName == null &&
            details.number == null &&
            details.paypalId == null &&
            details.upiId == null &&
            details.description == null);
  }


  dynamic form = {};

  _creteForm() {
    form = {
      if(widget.withdrawalID == null)"amount": _amountController.text,
      "description": _descriptionController.text,
      if(widget.withdrawalID != null)"cancel": _cancelWithdrawal ? '1' : '0'
    };
  }
}
