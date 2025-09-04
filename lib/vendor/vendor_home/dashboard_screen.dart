import 'package:event_app/core/styles/app_colors.dart';
import 'package:event_app/core/styles/app_sizes.dart';
import 'package:event_app/data/vendor/data/response/apis_status.dart';
import 'package:event_app/models/vendor_models/dashboard/dashboard_data_response.dart';
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
  const VendorDashBoardScreen({
    super.key,
    required this.onIndexUpdate,
  });

  final void Function(int index) onIndexUpdate;

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

  void setProcessing(bool value) {
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
  Widget build(BuildContext context) => Scaffold(
        key: _scaffoldKey,
        body: Utils.modelProgressDashboardHud(
          context: context,
          processing: _isProcessing,
          child: Utils.pageRefreshIndicator(
            context: context,
            onRefresh: _onRefresh,
            child: _buildUi(context),
          ),
        ),
      );

  void formatDates() {
    if (startDate != null) {
      formatStartDate = DateFormat('yyyy-MM-dd').format(startDate!);
    }

    if (endDate != null) {
      formatEndDate = DateFormat('yyyy-MM-dd').format(endDate!);
    }
  }

  // Custom Calendar Date Range Picker
// Replace your existing _showCustomDateRangePicker method with this fixed version

  Future<void> _showCustomDateRangePicker() async {
    DateTime? tempStartDate = startDate;
    DateTime? tempEndDate = endDate;
    DateTime displayMonth = startDate ?? DateTime.now();
    bool isSelectingStartDate = true; // Add this flag to track which date we're selecting

    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => StatefulBuilder(
        builder: (context, setDialogState) => Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.symmetric(horizontal: 25),
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Date Selection Header
                Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),
                  child: Row(
                    children: [
                      // From Section
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            setDialogState(() {
                              isSelectingStartDate = true;
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: isSelectingStartDate ? AppColors.peachyPink.withOpacity(0.1) : Colors.transparent,
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(20),
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  'From',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: isSelectingStartDate
                                        ? AppColors.peachyPink
                                        : Theme.of(context).colorScheme.onPrimary,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  tempStartDate != null
                                      ? DateFormat('EEE, dd MMM').format(tempStartDate!)
                                      : 'Select date',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: isSelectingStartDate
                                        ? AppColors.peachyPink
                                        : Theme.of(context).colorScheme.onPrimary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      // Divider
                      Container(
                        width: 1,
                        height: 60,
                        color: Colors.grey.shade300,
                      ),

                      // To Section
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            setDialogState(() {
                              isSelectingStartDate = false;
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: !isSelectingStartDate ? AppColors.peachyPink.withOpacity(0.1) : Colors.transparent,
                              borderRadius: const BorderRadius.only(
                                topRight: Radius.circular(20),
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  'To',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: !isSelectingStartDate
                                        ? AppColors.peachyPink
                                        : Theme.of(context).colorScheme.onPrimary,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  tempEndDate != null ? DateFormat('EEE, dd MMM').format(tempEndDate!) : 'Select date',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: !isSelectingStartDate
                                        ? AppColors.peachyPink
                                        : Theme.of(context).colorScheme.onPrimary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                // Calendar Section
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      // Month Navigation
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: () {
                              setDialogState(() {
                                displayMonth = DateTime(
                                  displayMonth.year,
                                  displayMonth.month - 1,
                                );
                              });
                            },
                            child: Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.grey.shade300),
                              ),
                              child: Icon(
                                Icons.chevron_left,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ),
                          Text(
                            DateFormat('MMMM, yyyy').format(displayMonth),
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              setDialogState(() {
                                displayMonth = DateTime(
                                  displayMonth.year,
                                  displayMonth.month + 1,
                                );
                              });
                            },
                            child: Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.grey.shade300),
                              ),
                              child: Icon(
                                Icons.chevron_right,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),

                      // Weekday Headers
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          'Mon',
                          'Tue',
                          'Wed',
                          'Thu',
                          'Fri',
                          'Sat',
                          'Sun',
                        ]
                            .map(
                              (day) => Container(
                                width: 35,
                                height: 35,
                                alignment: Alignment.center,
                                child: Text(
                                  day,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: AppColors.peachyPink.withOpacity(0.7),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                      ),

                      const SizedBox(height: 10),

                      // Calendar Grid with fixed logic
                      _buildCalendarGrid(displayMonth, tempStartDate, tempEndDate, setDialogState, (selectedDate) {
                        setDialogState(() {
                          if (isSelectingStartDate) {
                            // User is selecting start date
                            tempStartDate = selectedDate;
                            // If end date exists and is before new start date, clear it
                            if (tempEndDate != null && selectedDate.isAfter(tempEndDate!)) {
                              tempEndDate = null;
                            }
                            // Auto switch to selecting end date after start is selected
                            isSelectingStartDate = false;
                          } else {
                            // User is selecting end date
                            if (tempStartDate != null && selectedDate.isBefore(tempStartDate!)) {
                              // If selected date is before start date, make it the new start date
                              tempEndDate = tempStartDate;
                              tempStartDate = selectedDate;
                            } else {
                              // Normal end date selection
                              tempEndDate = selectedDate;
                            }
                          }
                        });
                      }),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                // Action Buttons
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () => Navigator.of(context).pop(),
                          child: Container(
                            height: 50,
                            decoration: BoxDecoration(
                              color: AppColors.peachyPink.withOpacity(0.8),
                              borderRadius: BorderRadius.circular(25),
                            ),
                            child: const Center(
                              child: Text(
                                'Cancel',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: GestureDetector(
                          onTap: () async {
                            if (tempStartDate != null && tempEndDate != null) {
                              setState(() {
                                startDate = tempStartDate;
                                endDate = tempEndDate;
                              });
                              Navigator.of(context).pop();
                              await _onRefresh();
                            }
                          },
                          child: Container(
                            height: 50,
                            decoration: BoxDecoration(
                              color: AppColors.peachyPink,
                              borderRadius: BorderRadius.circular(25),
                            ),
                            child: const Center(
                              child: Text(
                                'Apply',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCalendarGrid(
    DateTime displayMonth,
    DateTime? startDate,
    DateTime? endDate,
    StateSetter setState,
    Function(DateTime) onDateSelected,
  ) {
    // Get first day of the month and calculate padding
    final DateTime firstDayOfMonth = DateTime(displayMonth.year, displayMonth.month, 1);
    final int firstWeekday = firstDayOfMonth.weekday; // Monday = 1, Sunday = 7
    final int daysInMonth = DateTime(displayMonth.year, displayMonth.month + 1, 0).day;

    // Calculate previous month days to show
    final DateTime prevMonth = DateTime(displayMonth.year, displayMonth.month - 1);
    final int daysInPrevMonth = DateTime(prevMonth.year, prevMonth.month + 1, 0).day;

    final List<Widget> calendarDays = [];

    // Add previous month days (greyed out)
    for (int i = firstWeekday - 1; i > 0; i--) {
      final int prevDay = daysInPrevMonth - i + 1;
      calendarDays.add(
        _buildCalendarDay(
          day: prevDay,
          isCurrentMonth: false,
          date: DateTime(prevMonth.year, prevMonth.month, prevDay),
          startDate: startDate,
          endDate: endDate,
          onTap: onDateSelected,
        ),
      );
    }

    // Add current month days
    for (int day = 1; day <= daysInMonth; day++) {
      final DateTime currentDate = DateTime(displayMonth.year, displayMonth.month, day);
      calendarDays.add(
        _buildCalendarDay(
          day: day,
          isCurrentMonth: true,
          date: currentDate,
          startDate: startDate,
          endDate: endDate,
          onTap: onDateSelected,
        ),
      );
    }

    // Add next month days to complete the grid
    final int remainingCells = 42 - calendarDays.length; // 6 weeks * 7 days
    final DateTime nextMonth = DateTime(displayMonth.year, displayMonth.month + 1);
    for (int day = 1; day <= remainingCells && calendarDays.length < 42; day++) {
      calendarDays.add(
        _buildCalendarDay(
          day: day,
          isCurrentMonth: false,
          date: DateTime(nextMonth.year, nextMonth.month, day),
          startDate: startDate,
          endDate: endDate,
          onTap: onDateSelected,
        ),
      );
    }

    return Column(
      children: [
        for (int week = 0; week < 6; week++)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 2),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: calendarDays.skip(week * 7).take(7).toList(),
            ),
          ),
      ],
    );
  }

  Widget _buildCalendarDay({
    required int day,
    required bool isCurrentMonth,
    required DateTime date,
    required DateTime? startDate,
    required DateTime? endDate,
    required Function(DateTime) onTap,
  }) {
    final bool isSelected =
        (startDate != null && _isSameDay(date, startDate)) || (endDate != null && _isSameDay(date, endDate));
    final bool isInRange = startDate != null &&
        endDate != null &&
        date.isAfter(startDate.subtract(const Duration(days: 1))) &&
        date.isBefore(endDate.add(const Duration(days: 1)));
    final bool isToday = _isSameDay(date, DateTime.now());
    final bool isDisabled = date.isAfter(DateTime.now());

    return GestureDetector(
      onTap: isDisabled ? null : () => onTap(date),
      child: Container(
        width: 35,
        height: 35,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isSelected
              ? AppColors.peachyPink
              : isInRange
                  ? AppColors.peachyPink.withOpacity(0.2)
                  : Colors.transparent,
        ),
        child: Center(
          child: Text(
            day.toString(),
            style: TextStyle(
              fontSize: 14,
              fontWeight: isSelected || isToday ? FontWeight.w600 : FontWeight.w400,
              color: isDisabled
                  ? Colors.grey.shade400
                  : isSelected
                      ? Colors.white
                      : isCurrentMonth
                          ? isInRange
                              ? AppColors.peachyPink
                              : Colors.black87
                          : Colors.grey.shade400,
            ),
          ),
        ),
      ),
    );
  }

  bool _isSameDay(DateTime date1, DateTime date2) =>
      date1.year == date2.year && date1.month == date2.month && date1.day == date2.day;

  Widget _buildUi(BuildContext context) {
    final double screenWidth = MediaQuery.sizeOf(context).width;
    final double screenHeight = MediaQuery.sizeOf(context).height;

    formatDates();

    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      children: [
        Consumer<VendorDashboardViewModel>(
          builder: (context, provider, _) {
            final ApiStatus? apiStatus = provider.apiResponse.status;
            if (apiStatus == ApiStatus.ERROR) {
              return ListView(
                shrinkWrap: true,
                physics: const AlwaysScrollableScrollPhysics(),
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
                        onTap: _showCustomDateRangePicker,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.calendar_today_outlined,
                              color: AppColors.peachyPink,
                              size: 18,
                            ),
                            SizedBox(width: screenWidth * 0.02),
                            Text(
                              'From $formatStartDate to $formatEndDate',
                              // style: vendorDate(context),
                            ),
                          ],
                        ),
                      ),
                    ),
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

  Widget _buildOrdersAndProducts(DashboardDataResponse? dataResponse) => Padding(
        padding: EdgeInsets.symmetric(horizontal: kExtraSmallPadding),
        child: Column(
          children: [
            if (dataResponse?.data.orders.isNotEmpty == true) ...[
              _buildSection(
                title: 'Recent Orders',
                actionText: 'View All Orders',
                onTapViewAll: () {
                  /// navigate to all orders view at index 3 of Main scaffold
                  widget.onIndexUpdate(3);
                },
              ),
              kMinorSpace,
              ..._buildRecords(dataResponse!.data.orders),
            ],
            const SizedBox(height: 20),
            if (dataResponse?.data.products.isNotEmpty == true) ...[
              _buildSection(
                title: 'Top Selling Products',
                actionText: 'View All Products',
                onTapViewAll: () {
                  /// navigate to all orders view at index 1 of Main scaffold
                  widget.onIndexUpdate(1);
                },
              ),
              kMinorSpace,
              ..._buildRecords(dataResponse!.data.products),
            ],
          ],
        ),
      );

  Widget _buildSection({
    required String title,
    required String actionText,
    onTapViewAll,
  }) =>
      Row(
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
              const Icon(
                Icons.arrow_forward_ios,
                color: AppColors.peachyPink,
                size: 16,
              ),
            ],
          ),
        ],
      );

  List<Widget> _buildRecords(List<dynamic>? records) {
    if (records == null || records.isEmpty) return [const SizedBox.shrink()];
    return records.take(5).map((record) {
      final RegExp regExp = RegExp(r'<span.*?>(.*?)<\/span>', dotAll: true);
      final statusGroup = regExp.firstMatch(record?.status ?? '');
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
