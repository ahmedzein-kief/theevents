import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../provider/information_icons_provider/gift_card_payments_provider.dart';

class PaymentMethods extends StatefulWidget {
  final void Function(Map<String, String> selectedMethod)? onSelectionChanged;
  final bool? subCardShow;

  const PaymentMethods({Key? key, this.onSelectionChanged, this.subCardShow = true}) : super(key: key);

  @override
  State<PaymentMethods> createState() => _PaymentMethodsState();
}

class _PaymentMethodsState extends State<PaymentMethods> {
  String? expandedMethod;
  String? selectedSubOption;

  @override
  void initState() {
    super.initState();
    fetchDataOfRadio();
  }

  Future<void> fetchDataOfRadio() async {
    final paymentMethodProvider = Provider.of<PaymentMethodProviderGiftCard>(context, listen: false);
    await paymentMethodProvider.fetchPaymentMethods(context);

    /// Automatically select the first payment method and its sub-option when data is loaded
    if (paymentMethodProvider.paymentMethods.isNotEmpty) {
      final firstMethod = paymentMethodProvider.paymentMethods.first;
      setState(() {
        expandedMethod = firstMethod.name;

        /// Automatically expand the first method
        if (firstMethod.subOptions.isNotEmpty) {
          selectedSubOption = firstMethod.subOptions.first.value.first.value; // Automatically select the first sub-option
        }

        var callback = widget.onSelectionChanged;

        if (callback != null) {
          callback(
            updatePaymentMethod(
              firstMethod.code,
              firstMethod.subOptions.first.key,
              firstMethod.subOptions.first.value.first.value,
            ),
          );
        }
        paymentMethodProvider.setSelectedMethod(firstMethod.name); // Set the first method as selected
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    dynamic screenWidth = MediaQuery.sizeOf(context).width;
    dynamic screenHeight = MediaQuery.sizeOf(context).height;
    return Consumer<PaymentMethodProviderGiftCard>(
      builder: (context, paymentProvider, child) {
        if (paymentProvider.isLoading) {
          return const Center(
            child: CircularProgressIndicator(color: Colors.black),
          );
        }

        if (paymentProvider.hasError) {
          return const Center(
            child: Text('Failed to load payment methods.'),
          );
        }

        if (paymentProvider.paymentMethods.isEmpty) {
          return const Center(
            child: Text('No payment methods available.'),
          );
        }

        return ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: paymentProvider.paymentMethods.length,
          itemBuilder: (context, index) {
            final paymentMethod = paymentProvider.paymentMethods[index];

            return Column(
              // Main (Parent) Radio Button with Sub-options
              children: [
                Container(
                  margin: EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                      color: paymentProvider.selectedMethod == paymentMethod.name ? Colors.blue[50] : Colors.white,
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(
                        color: paymentProvider.selectedMethod == paymentMethod.name ? Colors.blue : Colors.grey.shade300,
                      )),
                  child: RadioListTile<String>(
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(paymentMethod.label),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Image.network(paymentMethod.image, width: paymentMethod.imgWidth.toDouble(), height: 40),
                            const SizedBox(width: 4),
                            if (paymentMethod.image1.isNotEmpty)
                              Align(
                                alignment: Alignment.centerRight,
                                child: Image.network(paymentMethod.image1, width: paymentMethod.imgWidth1.toDouble(), height: 40),
                              ),
                          ],
                        ),
                      ],
                    ),
                    activeColor: Colors.blue,
                    // Change the color of the selected sub-option radio button
                    value: paymentMethod.name,
                    groupValue: paymentProvider.selectedMethod,
                    onChanged: (value) {
                      paymentProvider.setSelectedMethod(value!);
                      setState(() {
                        // Expand the selected main option
                        expandedMethod = paymentMethod.name;

                        // Auto-select the first sub-option if available
                        if (paymentMethod.subOptions.isNotEmpty) {
                          selectedSubOption = paymentMethod.subOptions.first.value.first.value;

                          var callback = widget.onSelectionChanged;

                          if (callback != null) {
                            callback(
                              updatePaymentMethod(
                                paymentMethod.code,
                                paymentMethod.subOptions.first.key,
                                paymentMethod.subOptions.first.value.first.value,
                              ),
                            );
                          }
                        } else {
                          selectedSubOption = null; // Clear sub-option if none are available
                        }
                      });
                    },
                  ),
                ),

                // Sub-options (nested radio buttons) displayed when the main option is expanded
                if (widget.subCardShow == true && expandedMethod == paymentMethod.name && paymentMethod.subOptions.isNotEmpty)
                  ...paymentMethod.subOptions.map((subOption) {
                    return Container(
                      padding: EdgeInsets.only(left: screenWidth * 0.050, right: screenWidth * 0.050),
                      child: Column(
                        children: subOption.value.map((type) {
                          return Container(
                            margin: const EdgeInsets.symmetric(vertical: 4),
                            decoration: BoxDecoration(
                              color: selectedSubOption == type.value ? Colors.blue[50] : Colors.white,
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(
                                color: selectedSubOption == type.value ? Colors.blue.shade200 : Colors.grey.shade300,
                              ),
                            ),
                            child: RadioListTile<String>(
                              title: Text(type.title),
                              value: type.value,
                              groupValue: selectedSubOption,
                              activeColor: Colors.blue,
                              // Change the color of the selected sub-option radio button
                              selectedTileColor: Colors.red[200],
                              // Change the background color of the selected sub-option tile
                              onChanged: (value) {
                                setState(() {
                                  selectedSubOption = value; // Update selected sub-option
                                });
                                var callback = widget.onSelectionChanged;

                                if (callback != null) {
                                  callback(
                                    updatePaymentMethod(
                                      paymentMethod.code,
                                      subOption.key,
                                      value ?? "",
                                    ),
                                  );
                                }
                              },
                            ),
                          );
                        }).toList(),
                      ),
                    );
                  }).toList(),
              ],
            );
          },
        );
      },
    );
  }

  Map<String, String> updatePaymentMethod(String paymentMethod, String optionKey, String optionValue) {
    Map<String, String> paymentMap = {};

    paymentMap['payment_method'] = paymentMethod;
    paymentMap['sub_option_key'] = optionKey;
    paymentMap['sub_option_value'] = optionValue;

    return paymentMap;
  }
}
