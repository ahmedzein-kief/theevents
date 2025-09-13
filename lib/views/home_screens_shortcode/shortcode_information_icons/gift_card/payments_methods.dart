import 'dart:io' show Platform;

import 'package:event_app/core/helper/extensions/app_localizations_extension.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../provider/information_icons_provider/gift_card_payments_provider.dart';

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
  bool _hasSetDefault = false; // Track if we've set the default

  @override
  void initState() {
    super.initState();
    fetchDataOfRadio();
  }

  Future<void> fetchDataOfRadio() async {
    final paymentProvider = Provider.of<PaymentMethodProviderGiftCard>(context, listen: false);

    await paymentProvider.fetchPaymentMethods(
      context,
      paymentType: widget.paymentType,
      amount: widget.amount,
    );
  }

  void _setDefaultSelection(List<Map<String, dynamic>> allOptions) {
    if (!_hasSetDefault && allOptions.isNotEmpty) {
      // Find the first "Card" option or just the first option
      final defaultOption = allOptions.firstWhere(
        (opt) => opt['label'].toString().toLowerCase() == 'card',
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
                  color: Colors.blue.withOpacity(0.2),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ]
            : null,
      ),
      child: RadioListTile<String>(
        activeColor: Colors.blue,
        value: 'apple_pay',
        groupValue: selectedOption,
        onChanged: (value) {
          setState(() {
            selectedOption = value;
          });
          widget.onSelectionChanged?.call({
            'payment_method': 'apple_pay',
            'sub_option_key': 'payment_type',
            'sub_option_value': 'apple_pay',
          });
        },
        title: Row(
          children: [
            ClipRRect(
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
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Apple Pay',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                      color: isSelected ? Colors.blue : null,
                    ),
                  ),
                  Text(
                    'Pay with your Apple Wallet',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Consumer<PaymentMethodProviderGiftCard>(
      builder: (context, paymentProvider, child) {
        if (paymentProvider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (paymentProvider.hasError) {
          return Center(child: Text(AppStrings.failedToLoadPaymentMethods.tr));
        }

        if (paymentProvider.paymentMethods.isEmpty) {
          return Center(child: Text(AppStrings.noPaymentMethodsAvailable.tr));
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
        }

        // Filter options based on payment type
        List<Map<String, dynamic>> filteredOptions = paymentOptions;
        if (widget.paymentType == 'gift_card' || widget.paymentType == 'subscription') {
          filteredOptions = paymentOptions.where((opt) => opt['label'].toString().toLowerCase() == 'card').toList();
        }

        // Keep "Card" first otherwise
        filteredOptions.sort((a, b) {
          if (a['label'].toString().toLowerCase() == 'card') return -1;
          if (b['label'].toString().toLowerCase() == 'card') return 1;
          return 0;
        });

        // Add Apple Pay option if on iOS and not restricted payment type
        final allOptions = <Map<String, dynamic>>[...filteredOptions];
        final bool shouldShowApplePay =
            Platform.isIOS && widget.paymentType != 'gift_card' && widget.paymentType != 'subscription';

        if (shouldShowApplePay) {
          allOptions.insert(0, {
            'label': 'Apple Pay',
            'method': 'apple_pay',
            'optionKey': 'payment_type',
            'optionValue': 'apple_pay',
            'image': 'assets/apple_pay_logo.png',
            'isApplePay': true,
          });
        }

        // Set default selection after options are available
        _setDefaultSelection(allOptions);

        return Column(
          children: [
            // Apple Pay option (if available)
            if (shouldShowApplePay) _buildApplePayOption(selectedOption == 'apple_pay', isDarkMode),

            // Other payment methods
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: filteredOptions.length,
              itemBuilder: (context, index) {
                final item = filteredOptions[index];
                final isSelected = selectedOption == item['optionValue'];

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
                              color: Colors.blue.withOpacity(0.2),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ]
                        : null,
                  ),
                  child: RadioListTile<String>(
                    activeColor: Colors.blue,
                    value: item['optionValue'],
                    groupValue: selectedOption,
                    onChanged: (value) {
                      setState(() {
                        selectedOption = value;
                      });

                      widget.onSelectionChanged?.call(updatePaymentMethod(
                        item['method'],
                        item['optionKey'],
                        value ?? '',
                      ));
                    },
                    title: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: Image.network(
                            item['image'],
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
                                  Icons.payment,
                                  size: 20,
                                  color: Colors.grey,
                                ),
                              );
                            },
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return Container(
                                width: 32,
                                height: 32,
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade100,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: const SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            item['label'],
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                              color: isSelected ? Colors.blue : null,
                            ),
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
