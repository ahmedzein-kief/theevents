import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../components/custom_actions_view.dart';
import '../../components/custom_all_product_heading.dart';
import '../../components/custom_search_bar.dart';
import '../../components/vendor_dashboard_appbar.dart';
import '../../components/vendor_text_style.dart';

class ProductsScreen extends StatefulWidget {
  const ProductsScreen({super.key});

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: VendorColors.vendorAppBackground,
      key: _scaffoldKey,
      appBar: const CustomAppBarVendor(
        titleText: 'Products',
        isShowBack: true,
        // onDrawerTap: _openDrawer, // Opens the end drawer when tapped
      ),
      // endDrawer: CustomDrawer(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(
                    top: screenHeight * 0.02,
                    left: screenWidth * 0.02,
                    right: screenHeight * 0.02),
                child: Column(
                  children: [
                    _actionAndSearchBar(),
                    _createReload(),
                  ],
                ),
              ),
              SizedBox(height: screenHeight * 0.02),
              const CustomAllProductHeading(
                text1: 'ID',
                text2: 'Image',
                text3: 'Name',
                text4: 'Operations',
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// --------------------- Widget  bulk Action and Search bar --------------------

  Widget _actionAndSearchBar() => Column(
        children: [
          Row(
            children: [
              CustomIconContainer(
                text: 'Bulk Action',
                suffixIcon: Icons.keyboard_arrow_down_rounded,
                onTap: () {},
                borderColor: Colors.black,
                // Border color
                borderWidth: 0.5, // Border width
              ),
              CustomIconContainer(
                text: 'Filters',
                onTap: () {},
                borderColor: Colors.black, // Border color
                borderWidth: 0.5, // Border width
              ),
              Expanded(
                child: CustomSearchBarVendor(
                  suffixIcon: Icons.search,
                  onSearch: (value) {},
                ),
              ),
            ],
          ),
        ],
      );

  /// --------------------- Widget  create and reload  --------------------

  Widget _createReload() => Column(
        children: [
          Row(
            children: [
              Expanded(
                child: CustomIconContainer(
                  text: 'Create',
                  prefixIcon: Icons.add,
                  suffixIcon: Icons.keyboard_arrow_down_rounded,
                  onTap: () {},
                  borderColor: Colors.black,
                  // Border color
                  borderWidth: 0.5, // Border width
                ),
              ),
              Expanded(
                child: CustomIconContainer(
                  text: 'Export',
                  prefixIcon: CupertinoIcons.cloud_download,
                  suffixIcon: Icons.keyboard_arrow_down_rounded,
                  onTap: () {},
                  borderColor: Colors.black,
                  // Border color
                  borderWidth: 0.5, // Border width
                ),
              ),
              Expanded(
                child: CustomIconContainer(
                  text: 'Reload',
                  prefixIcon: Icons.refresh,
                  onTap: () {},
                  borderColor: Colors.black,
                  // Border color
                  borderWidth: 0.5, // Border width
                ),
              ),
            ],
          ),
        ],
      );
}
