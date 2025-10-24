import 'dart:io' show Platform;

import 'package:event_app/core/helper/extensions/app_localizations_extension.dart';
import 'package:event_app/core/widgets/loading_indicator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/utils/app_utils.dart';
import '../../../../core/widgets/padded_network_banner.dart';
import '../../../../core/widgets/price_row.dart';
import '../../../../provider/information_icons_provider/payment_methods_provider.dart';

class PaymentMethods extends StatefulWidget {
  const PaymentMethods({
    super.key,
    this.onSelectionChanged,
    this.amount,
    this.paymentType,
  });

  final void Function(Map<String, String> selectedMethod)? onSelectionChanged;
  final String? amount;
  final String? paymentType;

  @override
  State<PaymentMethods> createState() => _PaymentMethodsState();
}

class _PaymentMethodsState extends State<PaymentMethods> {
  String? selectedOption;
  bool _hasSetDefault = false;

  @override
  void initState() {
    super.initState();
    // Schedule the fetch to happen after the first frame is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchDataOfRadio();
    });
  }

  Future<void> fetchDataOfRadio() async {
    final paymentProvider = Provider.of<PaymentMethodsProvider>(
      context,
      listen: false,
    );

    await paymentProvider.fetchPaymentMethods(
      context,
      paymentType: widget.paymentType,
      amount: widget.amount,
    );
  }

  // Helper method to check if amount is below minimum for Tabby
  bool _isAmountBelowTabbyMinimum() {
    if (widget.amount == null) return false;

    try {
      final amount = double.parse(
        AppUtils.cleanPrice(widget.amount!),
      );
      return amount < 25.0;
    } catch (e) {
      return false;
    }
  }

  void _setDefaultSelection(List<Map<String, dynamic>> allOptions) {
    if (!_hasSetDefault && allOptions.isNotEmpty) {
      // Find the first "Card" option or just the first option
      final defaultOption = allOptions.firstWhere(
        (opt) => opt['label'].toString().toLowerCase() == AppStrings.card,

        /// TODO(Apple Pay): Add Default Selection for Apple Pay
        // (opt) => opt['label'].toString().toLowerCase() == AppStrings.applePay,
        orElse: () => allOptions.first,
      );

      selectedOption = defaultOption['optionValue'];
      _hasSetDefault = true;

      // Notify parent about default selection
      WidgetsBinding.instance.addPostFrameCallback((_) {
        widget.onSelectionChanged?.call(updatePaymentMethod(
          defaultOption['method'],
          defaultOption['optionKey'],
          defaultOption['optionValue'],
        ));
      });
    }
  }

// TODO(Apple Pay): Implement when Apple Pay is enabled
  Widget _buildApplePayOption(bool isSelected, bool isDarkMode) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: isDarkMode ? Colors.grey[900] : Colors.white,
        border: Border.all(
          color: isSelected ? Colors.blue : Colors.grey.shade300,
          width: isSelected ? 2 : 1,
        ),
        borderRadius: BorderRadius.circular(6),
        boxShadow: isSelected
            ? [
                BoxShadow(
                  color: Colors.blue.withAlpha((0.2 * 255).toInt()),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ]
            : null,
      ),
      child: ListTile(
        onTap: () {
          setState(() => selectedOption = 'apple_pay');
          widget.onSelectionChanged?.call({
            'payment_method': 'apple_pay',
            'sub_option_key': 'payment_type',
            'sub_option_value': 'apple_pay',
          });
        },
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: Image.asset(
            'assets/apple_pay_logo.png',
            color: Theme.of(context).colorScheme.onPrimary,
            width: 32,
            height: 32,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Icon(
                  Icons.apple,
                  size: 20,
                  color: Colors.grey,
                ),
              );
            },
          ),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppStrings.applePay.tr,
              style: TextStyle(
                fontSize: 14,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                color: isSelected ? Colors.blue : null,
              ),
            ),
            Text(
              AppStrings.applePaySubtitle.tr,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
        trailing: const Radio<String>(
          value: 'apple_pay',
          activeColor: Colors.blue,
        ),
      ),
    );
  }

  Widget _buildPaymentOption(
    Map<String, dynamic> item,
    bool isSelected,
    bool isDarkMode,
  ) {
    final isTabby = item['optionValue'] == 'tabby';
    final isDisabled = isTabby && _isAmountBelowTabbyMinimum();

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: isDisabled
            ? (isDarkMode ? Colors.grey[800] : Colors.grey[100])
            : (isDarkMode ? Colors.grey[900] : Colors.white),
        border: Border.all(
          color: isDisabled ? Colors.grey.shade400 : (isSelected ? Colors.blue : Colors.grey.shade300),
          width: isSelected ? 2 : 1,
        ),
        borderRadius: BorderRadius.circular(6),
        boxShadow: isSelected && !isDisabled
            ? [
                BoxShadow(
                  color: Colors.blue.withAlpha((0.2 * 255).toInt()),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ]
            : null,
      ),
      child: ListTile(
        onTap: isDisabled
            ? null
            : () {
                setState(() {
                  selectedOption = item['optionValue'];
                });
                widget.onSelectionChanged?.call(updatePaymentMethod(
                  item['method'],
                  item['optionKey'],
                  item['optionValue'],
                ));
              },
        leading: Opacity(
          opacity: isDisabled ? 0.5 : 1.0,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: PaddedNetworkBanner(
              imageUrl: item['image'],
              width: 32,
              height: 32,
              fit: BoxFit.contain,
              padding: EdgeInsets.zero,
              borderRadius: 0,
            ),
          ),
        ),
        title: Text(
          (item['label'] as String).tr,
          style: TextStyle(
            fontSize: 14,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            color: isDisabled ? Colors.grey : (isSelected ? Colors.blue : null),
          ),
        ),
        subtitle: isDisabled
            ? Row(
                children: [
                  Expanded(
                    child: Text(
                      'Minimum amount required:',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.red[600],
                      ),
                    ),
                  ),
                  PriceRow(
                    price: '25',
                    currencyColor: Colors.red[600],
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.red[600],
                    ),
                  ),
                ],
              )
            : null,
        trailing: Radio<String>(
          value: item['optionValue'],
          activeColor: Colors.blue,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Consumer<PaymentMethodsProvider>(
      builder: (context, paymentProvider, child) {
        if (paymentProvider.isLoading) {
          return const LoadingIndicator(size: 20);
        }

        if (paymentProvider.hasError) {
          return const Center(child: Text(AppStrings.failedToLoadPaymentMethods));
        }

        if (paymentProvider.paymentMethods.isEmpty) {
          return const Center(child: Text(AppStrings.noPaymentMethodsAvailable));
        }

        // Build flattened list with images
        final List<Map<String, dynamic>> paymentOptions = [];

        for (final method in paymentProvider.paymentMethods) {
          if (method.code == 'tamara') {
            final subOptions = method.subOptions.first.value;
            final installment = subOptions.firstWhere((s) => s.value == 'PAY_BY_INSTALMENTS');

            paymentOptions.add({
              'label': 'Tamara',
              'method': method.code,
              'optionKey': method.subOptions.first.key,
              'optionValue': installment.value,
              'image': method.image,
            });
          }

          if (method.code == 'telr') {
            final subOptions = method.subOptions.first.value;
            for (final sub in subOptions) {
              String? img;

              if (sub.value == 'tabby') {
                img = method.image1;
              } else {
                img = method.image;
              }

              paymentOptions.add({
                'label': sub.title,
                'method': method.code,
                'optionKey': method.subOptions.first.key,
                'optionValue': sub.value,
                'image': img,
              });
            }
          }

          // Add Wallet payment method
          if (method.code == 'wallet') {
            paymentOptions.add({
              'label': 'Wallet',
              'method': method.code,
              'optionKey': 'wallet_payment_type', // Default key for wallet
              'optionValue': 'wallet', // Default value for wallet
              'image': method.image,
            });
          }
        }

        // Filter options based on payment type
        List<Map<String, dynamic>> filteredOptions = paymentOptions;
        if (widget.paymentType == 'gift_card' || widget.paymentType == 'subscription') {
          filteredOptions = paymentOptions
              .where((opt) => opt['label'].toString().toLowerCase() == AppStrings.paymentCard.toLowerCase())
              .toList();
        }

        // Keep "Card" first otherwise
        filteredOptions.sort((a, b) {
          if (a['label'].toString().toLowerCase() == AppStrings.paymentCard.toLowerCase()) return -1;
          if (b['label'].toString().toLowerCase() == AppStrings.paymentCard.toLowerCase()) return 1;
          return 0;
        });

        // Add Apple Pay option if on iOS and not restricted payment type
        final allOptions = <Map<String, dynamic>>[...filteredOptions];
        final bool shouldShowApplePay =
            Platform.isIOS && widget.paymentType != 'gift_card' && widget.paymentType != 'subscription';

        if (shouldShowApplePay) {
          allOptions.insert(0, {
            'label': AppStrings.applePay,
            'method': 'apple_pay',
            'optionKey': 'payment_type',
            'optionValue': 'apple_pay',
            'image': 'assets/apple_pay_logo.png',
            'isApplePay': true,
          });
        }

        // Filter out disabled Tabby options from default selection
        final availableOptions = allOptions.where((opt) {
          if (opt['optionValue'] == 'tabby') {
            return !_isAmountBelowTabbyMinimum();
          }
          return true;
        }).toList();

        // Set default selection after options are available
        _setDefaultSelection(availableOptions);

        return RadioGroup<String>(
          groupValue: selectedOption,
          onChanged: (value) {
            setState(() => selectedOption = value);
          },
          child: Column(
            children: [
              /// TODO(Apple Pay): Add Apple Pay Option
              // Apple Pay option (if available)
              // if (shouldShowApplePay) _buildApplePayOption(selectedOption == 'apple_pay', isDarkMode),

              // Other payment methods
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: filteredOptions.length,
                itemBuilder: (context, index) {
                  final item = filteredOptions[index];
                  final isSelected = selectedOption == item['optionValue'];

                  return _buildPaymentOption(item, isSelected, isDarkMode);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Map<String, String> updatePaymentMethod(String paymentMethod, String optionKey, String optionValue) {
    return {
      'payment_method': paymentMethod,
      'sub_option_key': optionKey,
      'sub_option_value': optionValue,
    };
  }
}
