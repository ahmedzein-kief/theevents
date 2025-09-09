import 'package:event_app/core/styles/app_sizes.dart';
import 'package:event_app/models/vendor_models/dashboard/dashboard_data_response.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../core/styles/app_colors.dart';
import '../../Components/vendor_text_style.dart';

class DashboardInfoSection extends StatefulWidget {
  const DashboardInfoSection({
    super.key,
    required this.data,
  });

  final Data? data;

  @override
  _DashboardInfoSectionState createState() => _DashboardInfoSectionState();
}

class _DashboardInfoSectionState extends State<DashboardInfoSection> {
  late List<Map<String, dynamic>> data;

  @override
  void initState() {
    super.initState();
  }

  void populateData() {
    data = [
      {
        'title': 'Earnings',
        'amount': 'AED ${widget.data?.balance?.toString() ?? '0'}', // Use the stateful earnings here
        'onTap': () => print('Earnings'),
        'icon': SvgPicture.asset(
          colorFilter: const ColorFilter.mode(
            AppColors.peachyPink,
            BlendMode.srcIn,
          ),
          width: 28,
          height: 28,
          'assets/vendor_assets/dashboard/earning.svg',
        ),
        'containerColor': VendorColors.vendorDashboard,
      },
      {
        'title': 'Revenue',
        'amount': 'AED ${widget.data?.revenue.amount?.toString() ?? '0'}',
        'onTap': () => print('Revenue'),
        'icon': SvgPicture.asset(
          colorFilter: const ColorFilter.mode(
            AppColors.peachyPink,
            BlendMode.srcIn,
          ),
          width: 28,
          height: 28,
          'assets/vendor_assets/dashboard/revenue.svg',
        ),
        'containerColor': VendorColors.vendorDashboard,
      },
      {
        'title': 'Orders',
        'amount': widget.data?.totalOrders?.toString() ?? '0',
        'onTap': () => print('Orders'),
        'icon': SvgPicture.asset(
          colorFilter: const ColorFilter.mode(
            AppColors.peachyPink,
            BlendMode.srcIn,
          ),
          width: 28,
          height: 28,
          'assets/vendor_assets/dashboard/orders.svg',
        ),
        'containerColor': VendorColors.peachColor,
      },
      {
        'title': 'Return Orders',
        'amount': widget.data?.returnOrders.toString() ?? '0',
        'onTap': () => print('Return Orders'),
        'icon': SvgPicture.asset(
          colorFilter: const ColorFilter.mode(
            AppColors.peachyPink,
            BlendMode.srcIn,
          ),
          width: 28,
          height: 28,
          'assets/vendor_assets/dashboard/return_order.svg',
        ),
        'containerColor': VendorColors.peachColor,
      },
      {
        'title': 'Live Products',
        'amount': widget.data?.liveProducts.toString() ?? '0',
        'onTap': () => print('Live Products'),
        'icon': SvgPicture.asset(
          colorFilter: const ColorFilter.mode(
            AppColors.peachyPink,
            BlendMode.srcIn,
          ),
          width: 28,
          height: 28,
          'assets/vendor_assets/dashboard/products.svg',
        ),
        'containerColor': VendorColors.pastelGreenColor,
      },
      {
        'title': 'Pending Products',
        'amount': widget.data?.pendingProducts.toString() ?? '0',
        'onTap': () => print('Pending Products'),
        'icon': SvgPicture.asset(
          colorFilter: const ColorFilter.mode(
            AppColors.peachyPink,
            BlendMode.srcIn,
          ),
          width: 28,
          height: 28,
          'assets/vendor_assets/dashboard/pending_products.svg',
        ),
        'containerColor': VendorColors.pastelGreenColor,
      },
      {
        'title': 'Live Packages',
        'amount': widget.data?.livePackages.toString() ?? '0',
        'onTap': () => print('Live Packages'),
        'icon': SvgPicture.asset(
          colorFilter: const ColorFilter.mode(
            AppColors.peachyPink,
            BlendMode.srcIn,
          ),
          width: 28,
          height: 28,
          'assets/vendor_assets/dashboard/packages.svg',
        ),
        'containerColor': VendorColors.pastelPinkColor,
      },
      {
        'title': 'Pending Packages',
        'amount': widget.data?.pendingPackages.toString() ?? '0',
        'onTap': () => print('Pending Packages'),
        'icon': SvgPicture.asset(
          colorFilter: const ColorFilter.mode(
            AppColors.peachyPink,
            BlendMode.srcIn,
          ),
          width: 28,
          height: 28,
          'assets/vendor_assets/dashboard/pending_packages.svg',
        ),
        'containerColor': VendorColors.pastelPinkColor,
      },
    ];
  }

  @override
  Widget build(BuildContext context) {
    populateData();

    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: kMediumPadding),
        child: Column(
          children: [
            for (int i = 0; i < data.length; i += 2) ...[
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(bottom: kPadding),
                      child: DashboardInfoCard(
                        title: data[i]['title'],
                        amount: data[i]['amount'],
                        onTap: data[i]['onTap'],
                        icon: data[i]['icon'],
                        containerColor: data[i]['containerColor'],
                      ),
                    ),
                  ),
                  kSmallSpace,
                  if (i + 1 < data.length)
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(bottom: kPadding),
                        child: DashboardInfoCard(
                          title: data[i + 1]['title'],
                          amount: data[i + 1]['amount'],
                          onTap: data[i + 1]['onTap'],
                          icon: data[i + 1]['icon'],
                          containerColor: data[i + 1]['containerColor'],
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class DashboardInfoCard extends StatelessWidget {
  const DashboardInfoCard({
    super.key,
    required this.title,
    required this.amount,
    required this.onTap,
    required this.icon,
    required this.containerColor,
  });

  final String title;
  final String amount;
  final VoidCallback onTap;
  final Widget icon;
  final Color containerColor;

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.symmetric(
            vertical: kExtraSmallPadding,
            horizontal: kTinyPadding,
          ),
          decoration: BoxDecoration(
            color: containerColor,
            borderRadius: BorderRadius.circular(kTinyCardRadius),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withAlpha((0.5 * 255).toInt()),
                blurRadius: 2,
                spreadRadius: 0,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              icon,
              kExtraSmallSpace,
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title.toString(),
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: AppColors.charcoalGray,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      amount.toString(),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppColors.charcoalGray,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
}
