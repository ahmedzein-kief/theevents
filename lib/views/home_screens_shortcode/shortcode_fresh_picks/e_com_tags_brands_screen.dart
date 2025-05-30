import 'package:event_app/provider/shortcode_fresh_picks_provider/eCom_Tags_brands_Provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/styles/app_colors.dart';
import '../../../core/styles/custom_text_styles.dart';
import '../shorcode_featured_brands/featured_brands_items_screen.dart';

class EComTagsBrandsScreen extends StatefulWidget {
  final dynamic id;

  const EComTagsBrandsScreen({super.key, required this.id});

  @override
  State<EComTagsBrandsScreen> createState() => _EComTagsBrandsScreenState();
}

class _EComTagsBrandsScreenState extends State<EComTagsBrandsScreen> {
  final ScrollController _scrollController = ScrollController();
  int _currentPage = 1;
  bool _isFetchingMore = false;
  String _selectedSortBy = 'default_sorting';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchBrands();
      _scrollController.addListener(_onScroll);
    });
  }

  Future<void> fetchBrands() async {
    if (_isFetchingMore) return;
    try {
      setState(() {
        _isFetchingMore = true; // Start loading state
      });
      await Provider.of<EComBrandsProvider>(context, listen: false).fetchBrands(
        // id: 'widget.id.toString()',
        id: 14,
        context,
        perPage: 12,
        page: _currentPage,
        sortBy: _selectedSortBy,
      );
      if (mounted) {
        setState(() {
          _isFetchingMore = false;
        });
      }
    } catch (erroe) {
      if (mounted) {
        setState(() {
          _isFetchingMore = false;
        });
      }
    }
  }

  void _onScroll() {
    if (_isFetchingMore) return;
    if (_scrollController.offset >= _scrollController.position.maxScrollExtent && _scrollController.position.outOfRange) {
      if (mounted) {
        setState(() {
          _currentPage++;
          _isFetchingMore = true;
        });
      }
      fetchBrands();
    }
  }

  void _onSortChanged(String newValue) {
    if (mounted) {
      setState(() {
        _selectedSortBy = newValue;
        _currentPage = 1; // Reset to the first page
      });
    }
    fetchBrands();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final screenHeight = MediaQuery.sizeOf(context).height;
    return Container(
      child: Consumer<EComBrandsProvider>(
        builder: (context, provider, child) {
          if (provider.isMoreLoadingBrands) {
            return const Center(child: CircularProgressIndicator(color: Colors.black, strokeWidth: 0.5));
          }
          return provider.records.isEmpty
              ? Padding(
                  padding: EdgeInsets.only(left: screenWidth * 0.02, right: screenWidth * 0.02, top: screenHeight * 0.02),
                  child: Container(
                      width: double.infinity,
                      decoration: const BoxDecoration(color: AppColors.lightCoral),
                      height: 50,
                      child: const Align(alignment: Alignment.center, child: Text('No records found!'))))
              : SingleChildScrollView(
                  controller: _scrollController,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: _selectedSortBy,
                          icon: const Icon(Icons.keyboard_arrow_down_rounded),
                          onChanged: (String? newValue) {
                            if (newValue != null) {
                              _onSortChanged(newValue);
                            }
                          },
                          items: [
                            DropdownMenuItem(value: 'default_sorting', child: Text('Default Sorting', style: sortingStyle(context))),
                            DropdownMenuItem(value: 'date_asc', child: Text('Oldest', style: sortingStyle(context))),
                            DropdownMenuItem(value: 'date_desc', child: Text('Newest', style: sortingStyle(context))),
                            DropdownMenuItem(value: 'name_asc', child: Text('Name: A-Z', style: sortingStyle(context))),
                            DropdownMenuItem(value: 'name_desc', child: Text('Name: Z-A', style: sortingStyle(context))),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: screenWidth * 0.02, right: screenWidth * 0.02, top: screenHeight * 0.02),
                        child: GridView.builder(
                          key: ValueKey(_currentPage),
                          // Add this line
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, childAspectRatio: 0.7, mainAxisSpacing: 10, crossAxisSpacing: 10),
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: provider.records.length + (_isFetchingMore ? 1 : 0),
                          itemBuilder: (context, index) {
                            final record = provider.records[index];
                            if (_isFetchingMore && index == provider.records.length) {
                              return const Align(
                                alignment: Alignment.center,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Center(
                                      child: CircularProgressIndicator(
                                        color: Colors.black,
                                        strokeWidth: 0.5,
                                      ),
                                    ),
                                  ],
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
                                        color: Colors.black.withOpacity(0.2),
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
                                              builder: (builder) => FeaturedBrandsItemsScreen(
                                                    slug: record.slug,
                                                  )));
                                    },
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Image.network(
                                          record.image,
                                          height: 120,
                                          fit: BoxFit.fitWidth,
                                          errorBuilder: (context, build, child) {
                                            return const SizedBox.shrink();
                                          },
                                        ),
                                        Text(
                                          maxLines: 2,
                                          record.name,
                                          style: twoSliderAdsTextStyle(),
                                        ),
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
                  ),
                );
        },
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll); // Remove the listener in dispose
    _scrollController.dispose();
    super.dispose();
  }
}
