import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_strings.dart';
import '../../../core/helper/extensions/app_localizations_extension.dart';
import '../../../core/styles/app_colors.dart';
import '../../../core/widgets/address_form_bottom_sheet.dart';
import '../../../core/widgets/address_list_widget.dart';
import '../../../core/widgets/custom_auth_views/app_custom_button.dart';
import '../../../core/widgets/custom_profile_views/custom_back_appbar_view.dart';
import '../../../provider/payment_address/customer_address.dart';

class ProfileAddressScreen extends StatefulWidget {
  const ProfileAddressScreen({super.key});

  @override
  State<ProfileAddressScreen> createState() => _ProfileAddressScreenState();
}

class _ProfileAddressScreenState extends State<ProfileAddressScreen> {
  int _currentPage = 1;
  bool _isFetchingMore = false;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _initializeData() {
    _fetchCustomerAddresses();
    _scrollController.addListener(_onScroll);
  }

  Future<void> _fetchCustomerAddresses() async {
    if (!mounted) return;

    try {
      setState(() {
        _isFetchingMore = true;
      });

      final provider = Provider.of<CustomerAddressProvider>(context, listen: false);
      await provider.fetchCustomerAddresses(
        context,
        perPage: 12,
        page: _currentPage,
      );

      if (mounted) {
        setState(() {
          _isFetchingMore = false;
        });
      }
    } catch (error) {
      if (mounted) {
        setState(() {
          _isFetchingMore = false;
        });
      }
    }
  }

  void _onScroll() {
    if (_isFetchingMore) return;
    if (_scrollController.offset >= _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      _currentPage++;
      _isFetchingMore = true;
      _fetchCustomerAddresses();
    }
  }

  Future<void> _refreshAddressList() async {
    _currentPage = 1;
    await _fetchCustomerAddresses();
  }

  void _showAddressForm([CustomerRecords? existingAddress]) {
    AddressFormBottomSheet.show(
      context,
      existingAddress: existingAddress,
      onAddressSaved: _refreshAddressList,
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final screenHeight = MediaQuery.sizeOf(context).height;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // App Bar
            BackAppBarStyle(
              icon: Icons.arrow_back_ios,
              text: AppStrings.myAccount.tr,
            ),

            SizedBox(height: screenHeight * 0.04),

            // Header with Create button
            Padding(
              padding: EdgeInsets.only(
                top: screenHeight * 0.04,
                left: screenWidth * 0.04,
                right: screenWidth * 0.04,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    AppStrings.address.tr,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  CustomAppButton(
                    buttonText: AppStrings.create.tr,
                    onTap: () => _showAddressForm(),
                    prefixIcon: Icons.add,
                    buttonColor: AppColors.peachyPink,
                  ),
                ],
              ),
            ),

            SizedBox(height: screenHeight * 0.04),

            // Address List
            Expanded(
              child: Consumer<CustomerAddressProvider>(
                builder: (context, provider, child) {
                  return AddressListWidget(
                    addresses: provider.addresses,
                    onEditAddress: _showAddressForm,
                    isLoading: provider.isLoadingAddresses && _currentPage == 1,
                    errorMessage: provider.errorMessage,
                    scrollController: _scrollController,
                    isFetchingMore: _isFetchingMore,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
