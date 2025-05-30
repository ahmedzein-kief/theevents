import 'package:custom_date_range_picker/custom_date_range_picker.dart';
import 'package:event_app/data/vendor/data/response/apis_status.dart';
import 'package:event_app/models/vendor_models/dashboard/dashboard_data_response.dart';
import 'package:event_app/core/styles/app_colors.dart';
import 'package:event_app/utils/mixins_and_constants/constants.dart';
import 'package:event_app/vendor/components/data_tables/custom_data_tables.dart';
import 'package:event_app/vendor/components/list_tiles/records_list_tile.dart';
import 'package:event_app/vendor/components/utils/utils.dart';
import 'package:event_app/vendor/components/vendor_text_style.dart';
import 'package:event_app/vendor/vendor_home/vendor_coupons/dashboard_info_section.dart';
import 'package:event_app/vendor/view_models/dashboard/vendor_dashboard_view_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class VendorDashBoardScreen extends StatefulWidget {
  final void Function(int index) onIndexUpdate;

  const VendorDashBoardScreen({
    super.key,
    required this.onIndexUpdate,
  });

  @override
  State<VendorDashBoardScreen> createState() => _VendorDashBoardScreenState();
}

class _VendorDashBoardScreenState extends State<VendorDashBoardScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  bool _isProcessing = false;
  DateTime? startDate = DateTime(DateTime.now().year, DateTime.now().month, 1);
  DateTime? endDate = DateTime.now();
  String formatEndDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
  String formatStartDate = DateFormat('yyyy-MM-dd').format(DateTime(DateTime.now().year, DateTime.now().month, 1));


  setProcessing(bool value) {
    setState(() {
      _isProcessing = value;
    });
  }

  Future _onRefresh() async {
    try {
      setProcessing(true);
      WidgetsBinding.instance.addPostFrameCallback((callback) async {
        formatDates();
        final provider = Provider.of<VendorDashboardViewModel>(context, listen: false);
        await provider.getDashboardData(formatStartDate, formatEndDate);
        setProcessing(false);
        setState(() {});
      });
    } catch (e) {
      setProcessing(false);
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((callback) async {
      await _onRefresh();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: VendorColors.vendorAppBackground,
      key: _scaffoldKey,
      body: Utils.modelProgressDashboardHud(
        processing: _isProcessing,
        child: Utils.pageRefreshIndicator(
          onRefresh: _onRefresh,
          child: _buildUi(context),
        ),
      ),
    );
  }

  void formatDates() {
    if (startDate != null) {
      formatStartDate = DateFormat('yyyy-MM-dd').format(startDate!);
    }

    if (endDate != null) {
      formatEndDate = DateFormat('yyyy-MM-dd').format(endDate!);
    }
  }

  Widget _buildUi(BuildContext context) {
    double screenWidth = MediaQuery.sizeOf(context).width;
    double screenHeight = MediaQuery.sizeOf(context).height;

    formatDates();

    return ListView(
      physics: AlwaysScrollableScrollPhysics(),
      children: [
        Consumer<VendorDashboardViewModel>(
          builder: (context, provider, _) {
            final ApiStatus? apiStatus = provider.apiResponse.status;
            // if (apiStatus == ApiStatus.LOADING) {
            //   return Utils.pageLoadingIndicator(context: context);
            // }
            if (apiStatus == ApiStatus.ERROR) {
              return ListView(
                shrinkWrap: true,
                physics: AlwaysScrollableScrollPhysics(),
                children: [Utils.somethingWentWrong()],
              );
            }
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: screenHeight * 0.02),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: kExtraSmallPadding),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Container(
                        height: 40,
                        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.02),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(3),
                          border: Border.all(color: AppColors.peachyPink),
                        ),
                        child: GestureDetector(
                          onTap: () {
                            showCustomDateRangePicker(
                              context,
                              dismissible: true,
                              minimumDate: DateTime(1900),
                              // Allows any past date
                              maximumDate: DateTime.now(),
                              // Restricts selection up to today
                              endDate: endDate,
                              startDate: startDate,
                              backgroundColor: Colors.white,
                              primaryColor: AppColors.peachyPink,
                              onApplyClick: (start, end) async {
                                setState(() {
                                  endDate = end;
                                  startDate = start;
                                });
                                await _onRefresh();
                              },
                              onCancelClick: () {
                                setState(() {});
                              },
                            );
                          },
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.calendar_today_outlined,
                                color: AppColors.peachyPink,
                                size: 18,
                              ),
                              SizedBox(width: screenWidth * 0.02),
                              Text("From ${formatStartDate} to ${formatEndDate}", style: vendorDate(context)),
                            ],
                          ),
                        )),
                  ),
                ),
                SizedBox(height: screenHeight * 0.02),
                DashboardInfoSection(
                  data: provider.apiResponse.data?.data,
                ),

                /// tiles
                SizedBox(height: screenHeight * 0.06),
                _buildOrdersAndProducts(provider.apiResponse.data),

                /// top selling and recent orders
                SizedBox(height: screenHeight * 0.02),
              ],
            );
          },
        ),
      ],
    );
  }

  Widget _buildOrdersAndProducts(DashboardDataResponse? dataResponse) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: kExtraSmallPadding),
      child: Column(
        children: [
          if (dataResponse?.data.orders.isNotEmpty == true) ...[
            _buildSection(
                title: "Recent Orders",
                actionText: "View All Orders",
                onTapViewAll: () {
                  /// navigate to all orders view at index 3 of Main scaffold
                  widget.onIndexUpdate(3);
                }),
            kMinorSpace,
            ..._buildRecords(dataResponse!.data.orders),
          ],
          SizedBox(height: 20),
          if (dataResponse?.data.products.isNotEmpty == true) ...[
            _buildSection(
                title: "Top Selling Products",
                actionText: "View All Products",
                onTapViewAll: () {
                  /// navigate to all orders view at index 1 of Main scaffold
                  widget.onIndexUpdate(1);
                }),
            kMinorSpace,
            ..._buildRecords(dataResponse!.data.products),
          ],
        ],
      ),
    );
  }

  Widget _buildSection({required String title, required String actionText, dynamic onTapViewAll}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: vendorSell(context).copyWith(
            color: Colors.black,
            fontSize: 16,
          ),
        ),
        Row(
          children: [
            GestureDetector(
              onTap: onTapViewAll,
              child: Text(
                actionText,
                style: views(context).copyWith(color: AppColors.peachyPink),
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: AppColors.peachyPink,
              size: 16,
            ),
          ],
        ),
      ],
    );
  }

  List<Widget> _buildRecords(List<dynamic>? records) {
    if (records == null || records.isEmpty) return [SizedBox.shrink()];
    return records.take(5).map((record) {
      RegExp regExp = RegExp(r'<span.*?>(.*?)<\/span>', dotAll: true);
      var statusGroup = regExp.firstMatch(record?.status ?? '');
      final status = statusGroup?.group(1)?.trim();
      return Column(
        children: [
          RecordListTile(
            onTap: () {},
            leading: Text(
              record?.id?.toString() ?? '',
              style: dataRowTextStyle(),
            ),
            status: status,
            statusTextStyle: TextStyle(color: AppColors.getOrderStatusColor(status)),
            title: record?.name?.toString() ?? '',
            subtitle: record?.amount?.toString().replaceAll('AED', 'AED ') ?? '',
          ),
          kSmallSpace,
        ],
      );
    }).toList();
  }
}
