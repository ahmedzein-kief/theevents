import 'package:event_app/core/widgets/items_empty_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../provider/information_icons_provider/fifty_discount_provider.dart';
import '../../../../filters/product_filters_screen.dart';
import '../../../../filters/sort_an_filter_widget.dart';
import 'discount_product_card.dart';

class DiscountProductsGrid extends StatelessWidget {
  final String selectedSortBy;
  final Map<String, List<int>> selectedFilters;
  final Function(String) onSortChanged;
  final Function(Map<String, List<int>>) onFiltersChanged;
  final bool isFetchingMore;

  const DiscountProductsGrid({
    super.key,
    required this.selectedSortBy,
    required this.selectedFilters,
    required this.onSortChanged,
    required this.onFiltersChanged,
    required this.isFetchingMore,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<FiftyPercentDiscountProvider>(
      builder: (ctx, provider, child) {
        if (provider.isLoadingProducts) {
          return const Center(
            child: CircularProgressIndicator(
              color: Colors.black,
              strokeWidth: 0.5,
            ),
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SortAndFilterWidget(
              selectedSortBy: selectedSortBy,
              onSortChanged: onSortChanged,
              onFilterPressed: () => _showFilterBottomSheet(context, provider),
            ),
            _buildProductsContent(provider),
          ],
        );
      },
    );
  }

  Widget _buildProductsContent(FiftyPercentDiscountProvider provider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (provider.products.isEmpty)
          const ItemsEmptyView()
        else
          GridView.builder(
            scrollDirection: Axis.vertical,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.6,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
            ),
            itemCount: provider.products.length + (isFetchingMore ? 1 : 0),
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              if (isFetchingMore && index == provider.products.length) {
                return _buildLoadingIndicator();
              }

              final product = provider.products[index];

              return DiscountProductCard(
                product: product,
                key: ValueKey(product.id),
              );
            },
          ),
      ],
    );
  }

  Widget _buildLoadingIndicator() {
    return const Align(
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: SizedBox(
              height: 25,
              width: 25,
              child: CircularProgressIndicator(
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showFilterBottomSheet(BuildContext context, FiftyPercentDiscountProvider provider) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => FilterBottomSheet(
        filters: provider.productFilters,
        selectedIds: selectedFilters,
      ),
    ).then((result) {
      if (result != null) {
        onFiltersChanged(result);
      }
    });
  }
}
