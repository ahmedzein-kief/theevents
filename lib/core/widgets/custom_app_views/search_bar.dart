import 'package:event_app/views/search_screen/search_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../../provider/search_bar_provider/search_bar_provider.dart';
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

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
  }

  @override
  void dispose() {
    _focusNode!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.sizeOf(context).height;
    final double screenWidth = MediaQuery.sizeOf(context).width;
    final searchProvider =
        Provider.of<SearchBarProvider>(context, listen: false);
    return Padding(
      padding: EdgeInsets.only(
          left: screenWidth * 0.02,
          right: screenWidth * 0.02,
          bottom: screenHeight * 0.005,
          top: screenHeight * 0.01),
      child: Container(
        height: screenHeight * 0.06,
        width: double.infinity,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: AppColors.searchBackground,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SvgPicture.asset(
                'assets/searchBar.svg',
                height: 24,
                width: 24,
                // color: Colors.black,
                color: Theme.of(context).colorScheme.onPrimary,
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
                    hintText: widget.hintText,
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
                  onSubmitted: (value) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (builder) => SearchScreen(
                          query: value,
                        ),
                      ),
                    );
                    //    ert
                    if (value.isEmpty) {
                      searchProvider.fetchProductsNew(
                        query: value,
                        context,
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

//  +++++++++++++++++++++++++++++++++  SEARCH BAR SCREEN +++++++++++++++++++++++++++++++++
