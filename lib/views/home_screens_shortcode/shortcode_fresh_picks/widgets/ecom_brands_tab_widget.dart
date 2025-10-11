import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/styles/custom_text_styles.dart';
import '../../../../core/widgets/items_empty_view.dart';
import '../../../../core/widgets/padded_network_banner.dart';
import '../../../../provider/shortcode_fresh_picks_provider/ecom_tags_brands_provider.dart';
import '../../../filters/items_sorting_drop_down.dart';
import '../../shorcode_featured_brands/featured_brands_items_screen.dart';

class EComBrandsTabWidget extends StatefulWidget {
  const EComBrandsTabWidget({
    super.key,
    required this.id,
  });

  final int id;

  @override
  State<EComBrandsTabWidget> createState() => _EComBrandsTabWidgetState();
}

class _EComBrandsTabWidgetState extends State<EComBrandsTabWidget> {
  final ScrollController _scrollController = ScrollController();
  int _currentPageBrand = 1;
  bool _isFetchingMoreBrand = false;
  String _selectedSortBy = 'default_sorting';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchBrands();
      _scrollController.addListener(_onScroll);
    });
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _fetchBrands() async {
    try {
      setState(() {
        _isFetchingMoreBrand = true;
      });
      await Provider.of<EComBrandsProvider>(context, listen: false).fetchBrands(
        id: widget.id,
        context,
        perPage: 12,
        page: _currentPageBrand,
        sortBy: _selectedSortBy,
      );
      if (mounted) {
        setState(() {
          _isFetchingMoreBrand = false;
        });
      }
    } catch (error) {
      if (mounted) {
        setState(() {
          _isFetchingMoreBrand = false;
        });
      }
    }
  }

  void _onScroll() {
    if (_isFetchingMoreBrand) return;
    if (_scrollController.offset >= _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      _currentPageBrand++;
      _isFetchingMoreBrand = true;
      _fetchBrands();
    }
  }

  void _onSortChanged(String newValue) {
    setState(() {
      _selectedSortBy = newValue;
      _currentPageBrand = 1;
    });
    Provider.of<EComBrandsProvider>(context, listen: false).reset();
    _fetchBrands();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final screenHeight = MediaQuery.sizeOf(context).height;

    return Consumer<EComBrandsProvider>(
      builder: (context, provider, child) {
        if (provider.isMoreLoadingBrands && _currentPageBrand == 1) {
          return const Center(
            child: CircularProgressIndicator(
              color: Colors.black,
              strokeWidth: 0.5,
            ),
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ItemsSortingDropDown(
                  selectedSortBy: _selectedSortBy,
                  onSortChanged: _onSortChanged,
                ),
              ],
            ),
            if (provider.records.isEmpty)
              const ItemsEmptyView()
            else
              Padding(
                padding: EdgeInsets.only(
                  left: screenWidth * 0.02,
                  right: screenWidth * 0.02,
                  top: screenHeight * 0.02,
                ),
                child: GridView.builder(
                  controller: _scrollController,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    childAspectRatio: 0.8,
                    mainAxisSpacing: 2,
                    crossAxisSpacing: 10,
                  ),
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: provider.records.length,
                  itemBuilder: (context, index) {
                    final record = provider.records[index];
                    if (_isFetchingMoreBrand && index == provider.records.length) {
                      return const Align(
                        alignment: Alignment.center,
                        child: CircularProgressIndicator(
                          color: Colors.black,
                          strokeWidth: 0.5,
                        ),
                      );
                    }

                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primary,
                            borderRadius: BorderRadius.circular(5),
                            border: Border.all(
                              color: Colors.green,
                              width: 0.1,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withAlpha((0.2 * 255).toInt()),
                                spreadRadius: 1,
                                blurRadius: 5,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => FeaturedBrandsItemsScreen(
                                    slug: record.slug,
                                  ),
                                ),
                              );
                            },
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                PaddedNetworkBanner(
                                  imageUrl: record.image,
                                  height: 120,
                                  fit: BoxFit.fitWidth,
                                  padding: EdgeInsets.zero,
                                ),
                                Text(
                                  maxLines: 2,
                                  record.name,
                                  style: twoSliderAdsTextStyle(),
                                ),
                                const SizedBox(height: 10),
                              ],
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
          ],
        );
      },
    );
  }
}
