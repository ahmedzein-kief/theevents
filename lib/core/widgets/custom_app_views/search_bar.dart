import 'package:event_app/core/helper/extensions/app_localizations_extension.dart';
import 'package:event_app/views/search_screen/search_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../../provider/search_bar_provider/search_bar_provider.dart' hide Records;
import '../../../provider/search_suggestions_provider.dart';
import '../../styles/app_colors.dart';

class CustomSearchBar extends StatefulWidget {
  const CustomSearchBar({
    super.key,
    this.hintText = 'Search Events',
    this.controller,
    this.autofocus = false,
    this.borderColor = const Color(0xFFF3A095),
  });

  final TextEditingController? controller;
  final String hintText;
  final bool autofocus;
  final Color borderColor;

  @override
  State<CustomSearchBar> createState() => _CustomSearchBarState();
}

class _CustomSearchBarState extends State<CustomSearchBar> {
  FocusNode? _focusNode;
  bool _showSuggestions = false;
  List<dynamic>? _lastSuggestions; // Keep track of last suggestions

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _focusNode!.addListener(() {
      if (!_focusNode!.hasFocus) {
        // Only hide suggestions when focus is lost AND text field is empty
        if (widget.controller?.text.isEmpty ?? true) {
          setState(() => _showSuggestions = false);
        }
      }
    });
  }

  @override
  void dispose() {
    _focusNode?.dispose();
    super.dispose();
  }

  void _hideSuggestions() {
    // Clear the search text and hide suggestions
    widget.controller?.clear();
    final provider = Provider.of<SearchSuggestionsProvider>(context, listen: false);
    provider.clearSearchSuggestions();
    setState(() => _showSuggestions = false);
    _focusNode?.unfocus();
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.sizeOf(context).height;
    final double screenWidth = MediaQuery.sizeOf(context).width;
    final searchProvider = Provider.of<SearchBarProvider>(context, listen: false);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Search bar
        Padding(
          padding: EdgeInsets.only(
            left: screenWidth * 0.02,
            right: screenWidth * 0.02,
            bottom: screenHeight * 0.005,
            top: screenHeight * 0.01,
          ),
          child: Container(
            height: screenHeight * 0.06,
            width: double.infinity,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              color: AppColors.searchBackground,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: Row(
                children: [
                  SvgPicture.asset(
                    'assets/searchBar.svg',
                    height: 24,
                    width: 24,
                    colorFilter: const ColorFilter.mode(Colors.black, BlendMode.srcIn),
                  ),
                  const SizedBox(width: 10),
                  Flexible(
                    child: TextField(
                      controller: widget.controller,
                      autofocus: widget.autofocus,
                      focusNode: _focusNode,
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Theme.of(context).colorScheme.onPrimary,
                      ),
                      decoration: InputDecoration(
                        hintText: widget.hintText.tr,
                        hintStyle: GoogleFonts.inter(
                          fontSize: 14,
                          letterSpacing: 1,
                          fontWeight: FontWeight.w500,
                          color: AppColors.semiTransparentBlack.withOpacity(0.5),
                        ),
                        border: InputBorder.none,
                        isCollapsed: true,
                      ),
                      textAlign: TextAlign.start,
                      onChanged: (value) {
                        final provider = Provider.of<SearchSuggestionsProvider>(
                          context,
                          listen: false,
                        );

                        if (value.isNotEmpty) {
                          provider.fetchSearchBarSuggestion(value);
                          // Only show suggestions if not already showing
                          if (!_showSuggestions) {
                            setState(() => _showSuggestions = true);
                          }
                        } else {
                          provider.clearSearchSuggestions();
                          setState(() => _showSuggestions = false);
                        }
                      },
                      onSubmitted: (value) {
                        setState(() => _showSuggestions = false);
                        _focusNode!.unfocus();

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => SearchScreen(query: value),
                          ),
                        );

                        if (value.isEmpty) {
                          searchProvider.fetchProductsNew(
                            query: value,
                            context,
                          );
                        }
                      },
                    ),
                  ),
                  Consumer<SearchSuggestionsProvider>(
                    builder: (context, provider, child) {
                      return Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Close suggestions icon - clears search and hides suggestions
                          if (_showSuggestions)
                            GestureDetector(
                              onTap: _hideSuggestions,
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                child: Icon(
                                  Icons.close,
                                  size: 18,
                                  color: AppColors.semiTransparentBlack.withOpacity(0.6),
                                ),
                              ),
                            ),
                          // Clear text icon - only clears text but keeps focus
                          if (widget.controller?.text.isNotEmpty == true && !_showSuggestions)
                            GestureDetector(
                              onTap: () {
                                widget.controller?.clear();
                                provider.clearSearchSuggestions();
                              },
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                child: Icon(
                                  Icons.clear,
                                  size: 18,
                                  color: AppColors.semiTransparentBlack.withOpacity(0.6),
                                ),
                              ),
                            ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),

        // Suggestions container
        if (_showSuggestions)
          Consumer<SearchSuggestionsProvider>(
            builder: (context, provider, child) {
              // Use current suggestions if available, otherwise use last suggestions
              final suggestions = provider.suggestionsList ?? _lastSuggestions;

              // Update last suggestions when we have new data
              if (provider.suggestionsList != null) {
                _lastSuggestions = provider.suggestionsList;
              }

              if (provider.isLoadingSuggestions && suggestions == null) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).scaffoldBackgroundColor,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppColors.searchBackground,
                        width: 1,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const SizedBox(
                      height: 60,
                      child: Center(
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    ),
                  ),
                );
              }

              if (suggestions == null || suggestions.isEmpty) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).scaffoldBackgroundColor,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppColors.searchBackground,
                        width: 1,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const SizedBox(
                      height: 60,
                      child: Center(child: Text('No results found')),
                    ),
                  ),
                );
              }

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppColors.searchBackground,
                      width: 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(context).size.height * 0.3,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Suggestions list
                      Flexible(
                        child: ListView.separated(
                          shrinkWrap: true,
                          padding: const EdgeInsets.only(bottom: 8),
                          itemCount: suggestions.length,
                          separatorBuilder: (_, __) => Divider(
                            height: 1,
                            color: AppColors.semiTransparentBlack.withOpacity(0.1),
                          ),
                          itemBuilder: (context, index) {
                            final suggestion = suggestions[index];
                            return ListTile(
                              dense: true,
                              leading: suggestion.image != null
                                  ? ClipRRect(
                                      borderRadius: BorderRadius.circular(6),
                                      child: Image.network(
                                        suggestion.image!,
                                        width: 32,
                                        height: 32,
                                        fit: BoxFit.cover,
                                      ),
                                    )
                                  : const Icon(Icons.shopping_bag_outlined),
                              title: Text(
                                suggestion.name ?? 'No Name',
                                style: GoogleFonts.inter(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Theme.of(context).colorScheme.onPrimary,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              subtitle: suggestion.store?.name != null
                                  ? Text(
                                      suggestion.store!.name!,
                                      style: GoogleFonts.inter(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400,
                                        color: Theme.of(context).colorScheme.onPrimary.withOpacity(0.6),
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    )
                                  : null,
                              trailing: suggestion.prices?.frontSalePrice != null
                                  ? Text(
                                      'AED ${suggestion.prices!.frontSalePrice}',
                                      style: GoogleFonts.inter(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        color: Theme.of(context).colorScheme.primary,
                                      ),
                                    )
                                  : const Icon(
                                      Icons.arrow_forward_ios,
                                      size: 16,
                                    ),
                              onTap: () {
                                widget.controller?.text = suggestion.name ?? '';
                                setState(() => _showSuggestions = false);
                                _focusNode!.unfocus();

                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => SearchScreen(
                                      query: suggestion.name ?? '',
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
      ],
    );
  }
}
