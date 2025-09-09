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
    // New parameters for flexibility
    this.height,
    this.showSuggestions = true,
    this.isCompact = false,
    this.horizontalPadding,
    this.verticalPadding,
    this.borderRadius,
    this.fontSize,
    this.iconSize,
    this.backgroundColor,
    this.suggestionsTopOffset = 0,
  });

  final TextEditingController? controller;
  final String hintText;
  final bool autofocus;
  final Color borderColor;

  // New flexible parameters
  final double? height;
  final bool showSuggestions;
  final bool isCompact;
  final double? horizontalPadding;
  final double? verticalPadding;
  final double? borderRadius;
  final double? fontSize;
  final double? iconSize;
  final Color? backgroundColor;
  final double suggestionsTopOffset;

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

  Widget _buildSuggestionsOverlay() {
    if (!_showSuggestions || !widget.showSuggestions) return const SizedBox.shrink();

    return Consumer<SearchSuggestionsProvider>(
      builder: (context, provider, child) {
        final suggestions = provider.suggestionsList ?? _lastSuggestions;

        if (provider.suggestionsList != null) {
          _lastSuggestions = provider.suggestionsList;
        }

        if (provider.isLoadingSuggestions && suggestions == null) {
          return Padding(
            padding: EdgeInsets.symmetric(
              horizontal: widget.horizontalPadding ?? 14,
            ),
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                borderRadius: BorderRadius.circular(widget.borderRadius ?? 12),
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
            padding: EdgeInsets.symmetric(
              horizontal: widget.horizontalPadding ?? 14,
            ),
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                borderRadius: BorderRadius.circular(widget.borderRadius ?? 12),
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

        // Limit to 12 items
        final limitedSuggestions = suggestions.take(12).toList();
        final hasMoreResults = suggestions.length > 12;
        final currentQuery = widget.controller?.text ?? '';

        return Padding(
          padding: EdgeInsets.symmetric(
            horizontal: widget.horizontalPadding ?? 14,
          ),
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              borderRadius: BorderRadius.circular(widget.borderRadius ?? 12),
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
              maxHeight: MediaQuery.of(context).size.height * 0.4, // Slightly increased for "See all" button
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Suggestions list
                Flexible(
                  child: ListView.separated(
                    shrinkWrap: true,
                    padding: EdgeInsets.zero,
                    itemCount: limitedSuggestions.length,
                    separatorBuilder: (_, __) => Divider(
                      height: 1,
                      color: AppColors.semiTransparentBlack.withOpacity(0.1),
                    ),
                    itemBuilder: (context, index) {
                      final suggestion = limitedSuggestions[index];
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
                            fontSize: widget.fontSize ?? 14,
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
                                  fontSize: (widget.fontSize ?? 14) - 2,
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
                                  fontSize: (widget.fontSize ?? 14) - 2,
                                  fontWeight: FontWeight.w600,
                                  color: Theme.of(context).colorScheme.onPrimary,
                                ),
                              )
                            : Icon(
                                Icons.arrow_forward_ios,
                                size: (widget.iconSize ?? 18) - 2,
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

                // "See all results" button - only show if there are more than 12 results
                if (hasMoreResults && currentQuery.isNotEmpty) ...[
                  Divider(
                    height: 1,
                    color: AppColors.semiTransparentBlack.withOpacity(0.2),
                  ),
                  InkWell(
                    onTap: () {
                      setState(() => _showSuggestions = false);
                      _focusNode!.unfocus();

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => SearchScreen(
                            query: currentQuery,
                          ),
                        ),
                      );
                    },
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                        color: AppColors.searchBackground.withOpacity(0.3),
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(widget.borderRadius ?? 12),
                          bottomRight: Radius.circular(widget.borderRadius ?? 12),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.search,
                            size: 18,
                            color: Theme.of(context).colorScheme.onPrimary.withOpacity(0.7),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'See all results',
                            style: GoogleFonts.inter(
                              fontSize: (widget.fontSize ?? 14),
                              fontWeight: FontWeight.w500,
                              color: Theme.of(context).colorScheme.onPrimary.withOpacity(0.8),
                            ),
                          ),
                          const SizedBox(width: 4),
                          Icon(
                            Icons.arrow_forward,
                            size: 16,
                            color: Theme.of(context).colorScheme.onPrimary.withOpacity(0.7),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.sizeOf(context).height;
    final double screenWidth = MediaQuery.sizeOf(context).width;
    final searchProvider = Provider.of<SearchBarProvider>(context, listen: false);

    // Calculate responsive values if not provided
    final double searchHeight = widget.height ?? (widget.isCompact ? screenHeight * 0.04 : screenHeight * 0.06);
    final double horizontalPadding = widget.horizontalPadding ?? (widget.isCompact ? 8 : 14);
    final double verticalPadding =
        widget.verticalPadding ?? (widget.isCompact ? screenHeight * 0.002 : screenHeight * 0.005);
    final double radius = widget.borderRadius ?? (widget.isCompact ? 20 : 30);
    final double textSize = widget.fontSize ?? (widget.isCompact ? 12 : 14);
    final double iconSize = widget.iconSize ?? (widget.isCompact ? 18 : 24);

    // For compact mode (app bar), return just the search container without Column
    if (widget.isCompact) {
      return Container(
        height: searchHeight,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(radius),
          color: widget.backgroundColor ?? AppColors.searchBackground,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha((0.05 * 255).toInt()),
              blurRadius: 4,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
          child: _buildSearchContent(searchProvider, textSize, iconSize),
        ),
      );
    }

    // For regular mode, use Column layout with suggestions
    return GestureDetector(
      // Add this to handle tap outside
      onTap: () {
        if (_showSuggestions) {
          setState(() => _showSuggestions = false);
          _focusNode?.unfocus();
        }
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Search bar
          Padding(
            padding: EdgeInsets.only(
              left: screenWidth * 0.02,
              right: screenWidth * 0.02,
              bottom: verticalPadding,
              top: screenHeight * 0.01,
            ),
            child: Container(
              height: searchHeight,
              width: double.infinity,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(radius),
                color: widget.backgroundColor ?? AppColors.searchBackground,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha((0.05 * 255).toInt()),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                child: _buildSearchContent(searchProvider, textSize, iconSize),
              ),
            ),
          ),

          // Suggestions container - only for regular mode
          if (widget.showSuggestions && _showSuggestions) _buildSuggestionsOverlay(),
        ],
      ),
    );
  }

// In _buildSearchContent method, replace the close button section with this:

  Widget _buildSearchContent(SearchBarProvider searchProvider, double textSize, double iconSize) {
    return Row(
      children: [
        SvgPicture.asset(
          'assets/searchBar.svg',
          height: iconSize,
          width: iconSize,
          colorFilter: const ColorFilter.mode(Colors.black, BlendMode.srcIn),
        ),
        SizedBox(width: widget.isCompact ? 6 : 10),
        Flexible(
          child: TextField(
            controller: widget.controller,
            autofocus: widget.autofocus,
            focusNode: _focusNode,
            style: GoogleFonts.inter(
              fontSize: textSize,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
            decoration: InputDecoration(
              hintText: widget.hintText.tr,
              hintStyle: GoogleFonts.inter(
                fontSize: textSize,
                letterSpacing: widget.isCompact ? 0.5 : 1,
                fontWeight: FontWeight.w500,
                color: AppColors.semiTransparentBlack.withAlpha((0.5 * 255).toInt()),
              ),
              border: InputBorder.none,
              isCollapsed: true,
              contentPadding: EdgeInsets.symmetric(
                vertical: widget.isCompact ? 4 : 8,
              ),
            ),
            textAlign: TextAlign.start,
            onChanged: (value) {
              // Force rebuild to show/hide close button
              setState(() {});

              if (!widget.showSuggestions) return;

              final provider = Provider.of<SearchSuggestionsProvider>(
                context,
                listen: false,
              );

              if (value.isNotEmpty) {
                provider.fetchSearchBarSuggestion(value);
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

        // Always show close button when there's text, regardless of showSuggestions
        if (widget.controller?.text.isNotEmpty == true || _showSuggestions)
          GestureDetector(
            onTap: () {
              if (_showSuggestions) {
                // If suggestions are showing, hide them and clear text
                _hideSuggestions();
              } else {
                // If just text, clear text only
                widget.controller?.clear();
                if (widget.showSuggestions) {
                  final provider = Provider.of<SearchSuggestionsProvider>(context, listen: false);
                  provider.clearSearchSuggestions();
                }
                setState(() {}); // Force rebuild to hide close button
              }
            },
            child: Container(
              padding: const EdgeInsets.all(4),
              child: Icon(
                _showSuggestions ? Icons.close : Icons.clear,
                size: iconSize - 2,
                color: AppColors.semiTransparentBlack.withAlpha((0.6 * 255).toInt()),
              ),
            ),
          ),
      ],
    );
  }
}
