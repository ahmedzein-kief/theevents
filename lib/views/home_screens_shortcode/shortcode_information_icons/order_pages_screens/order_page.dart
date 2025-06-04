import 'package:event_app/core/styles/app_colors.dart';
import 'package:event_app/models/orders/order_history_model.dart';
import 'package:event_app/provider/orders_provider/order_data_provider.dart';
import 'package:event_app/views/base_screens/base_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_strings.dart';
import 'order_history_view.dart';

class OrderPageScreen extends StatefulWidget {
  const OrderPageScreen({super.key});

  @override
  State<OrderPageScreen> createState() => _OrderPageScreenState();
}

class _OrderPageScreenState extends State<OrderPageScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: 2, vsync: this);

    _tabController.addListener(() {
      if (_tabController.indexIsChanging ||
          _tabController.index != _tabController.previousIndex) {
        fetchOrders(context, isPending: _tabController.index == 0);
      }
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchOrders(context, isPending: true); // Fetch pending orders initially
    });
  }

  Future<void> fetchOrders(BuildContext? context,
      {required bool isPending}) async {
    if (!mounted) return;
    final provider = Provider.of<OrderDataProvider>(context!, listen: false);
    // provider.clearOrders();
    await provider.getOrders(
      context,
      isPending,
    );
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.sizeOf(context).height;

    return BaseAppBar(
      textBack: 'Back',
      customBackIcon: const Icon(Icons.arrow_back_ios_sharp, size: 16),
      // firstRightIconPath: AppStrings.firstRightIconPath,
      secondRightIconPath: AppStrings.secondRightIconPath,
      thirdRightIconPath: AppStrings.thirdRightIconPath,
      title: 'Orders',
      body: Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(50), // Adjust height as needed
          child: Container(
            color: Colors.white, // Background color for the tab bar area
            child: TabBar(
              controller: _tabController,
              labelColor: AppColors.lightCoral,
              unselectedLabelColor: Colors.grey,
              indicatorColor: AppColors.lightCoral,
              // Thickness of the indicator
              isScrollable: false,
              // Makes tabs take up the full width
              tabs: const [
                Tab(
                  text: 'Pending',
                ),
                Tab(
                  text: 'Completed',
                ),
              ],
              onTap: (index) {
                fetchOrders(context, isPending: index == 0); // Toggle API call
              },
            ),
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: [
            _buildOrderList(context, isCompleted: false),
            _buildOrderList(context, isCompleted: true),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderList(BuildContext context, {required bool isCompleted}) =>
      Consumer<OrderDataProvider>(
        builder: (context, provider, child) {
          final records = isCompleted
              ? provider.completedOrderHistoryModel?.data.records
              : provider.orderHistoryModel?.data.records;
          final List<OrderProduct>? allProducts = records
              ?.expand(
                (record) => record.products.map(
                  (product) => OrderProduct(
                    productSlugPrefix: product.productSlugPrefix,
                    productSlug: product.productSlug,
                    imageUrl: product.imageUrl,
                    productName: product.productName,
                    imageThumb: product.imageThumb,
                    imageSmall: product.imageSmall,
                    productType: product.productType,
                    productOptions: product.productOptions,
                    review: product.review,
                    qty: product.qty,
                    indexNum: product.indexNum,
                    attributes: product.attributes,
                    sku: product.sku,
                    amountFormat: product.amountFormat,
                    totalFormat: product.totalFormat,
                    orderRecord: record,
                  ),
                ),
              )
              .toList();

          if (provider.isLoading) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.black),
            );
          }

          return SafeArea(
            child: allProducts == null || allProducts.isEmpty
                ? const Center(child: Text('No orders found'))
                : SingleChildScrollView(
                    child: Column(
                      children: allProducts
                          .map((order) => OrderHistoryView(order: order))
                          .toList(),
                    ),
                  ),
          );
        },
      );
}
