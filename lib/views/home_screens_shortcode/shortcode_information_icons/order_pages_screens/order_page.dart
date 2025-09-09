import 'dart:developer';

import 'package:event_app/core/helper/extensions/app_localizations_extension.dart';
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

class _OrderPageScreenState extends State<OrderPageScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: 2, vsync: this);

    _tabController.addListener(() {
      if (_tabController.indexIsChanging || _tabController.index != _tabController.previousIndex) {
        fetchOrders(context, isPending: _tabController.index == 0);
      }
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      log('Fetching orders OrderPageScreen initState');
      fetchOrders(context, isPending: true); // Fetch pending orders initially
    });
  }

  Future<void> fetchOrders(
    BuildContext? context, {
    required bool isPending,
  }) async {
    if (!mounted) return;
    final provider = Provider.of<OrderDataProvider>(context!, listen: false);

    // Clear existing orders to force refresh
    provider.clearOrders();

    await provider.getOrders(context, isPending);
  }

  @override
  Widget build(BuildContext context) {
    return BaseAppBar(
      textBack: AppStrings.back.tr,
      customBackIcon: const Icon(Icons.arrow_back_ios_sharp, size: 16),
      secondRightIconPath: AppStrings.secondRightIconPath.tr,
      thirdRightIconPath: AppStrings.thirdRightIconPath.tr,
      title: AppStrings.orders.tr,
      body: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(50),
          child: Container(
            color: Theme.of(context).colorScheme.primary,
            child: TabBar(
              controller: _tabController,
              labelColor: AppColors.lightCoral,
              unselectedLabelColor: Colors.grey,
              indicatorColor: AppColors.lightCoral,
              isScrollable: false,
              tabs: [
                Tab(
                  text: AppStrings.pending.tr,
                ),
                Tab(
                  text: AppStrings.completed.tr,
                ),
              ],
              onTap: (index) {
                fetchOrders(context, isPending: index == 0);
              },
            ),
          ),
        ),
        body: RefreshIndicator(
          color: Colors.black,
          onRefresh: () async {
            await fetchOrders(context, isPending: _tabController.index == 0);
          },
          child: TabBarView(
            controller: _tabController,
            children: [
              _buildOrderList(context, isCompleted: false),
              _buildOrderList(context, isCompleted: true),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOrderList(BuildContext context, {required bool isCompleted}) => Consumer<OrderDataProvider>(
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
                ? SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height * 0.6,
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.shopping_bag_outlined,
                              size: 64,
                              color: Colors.grey[400],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              AppStrings.noOrders.tr,
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                : SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: Column(
                      children: allProducts.map((order) => OrderHistoryView(order: order)).toList(),
                    ),
                  ),
          );
        },
      );

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}
