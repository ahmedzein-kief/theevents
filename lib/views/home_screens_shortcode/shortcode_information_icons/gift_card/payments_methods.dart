import 'package:event_app/core/helper/extensions/app_localizations_extension.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../provider/information_icons_provider/gift_card_payments_provider.dart';

class PaymentMethods extends StatefulWidget {
  const PaymentMethods({
    super.key,
    this.onSelectionChanged,
    this.subCardShow = true,
    this.amount,
    this.paymentType,
  });

  final void Function(Map<String, String> selectedMethod)? onSelectionChanged;
  final bool? subCardShow;
  final String? amount;
  final String? paymentType;

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
    await paymentMethodProvider.fetchPaymentMethods(
      context,
      paymentType: widget.paymentType,
      amount: widget.amount,
    );

    /// التحقق من وجود عناصر قبل الوصول إليها
    if (paymentMethodProvider.paymentMethods.isNotEmpty) {
      // البحث عن أول طريقة دفع صالحة
      final firstMethod = paymentMethodProvider.paymentMethods.firstOrNull;

      if (firstMethod != null) {
        setState(() {
          expandedMethod = firstMethod.name;

          /// التحقق من وجود خيارات فرعية
          if (firstMethod.subOptions.isNotEmpty && firstMethod.subOptions.first.value.isNotEmpty) {
            selectedSubOption = firstMethod.subOptions.first.value.first.value;

            final callback = widget.onSelectionChanged;
            if (callback != null) {
              callback(
                updatePaymentMethod(
                  firstMethod.code,
                  firstMethod.subOptions.first.key,
                  firstMethod.subOptions.first.value.first.value,
                ),
              );
            }
          }
          paymentMethodProvider.setSelectedMethod(firstMethod.name);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    final dynamic screenWidth = MediaQuery.sizeOf(context).width;
    final dynamic screenHeight = MediaQuery.sizeOf(context).height;

    return Consumer<PaymentMethodProviderGiftCard>(
      builder: (context, paymentProvider, child) {
        if (paymentProvider.isLoading) {
          return const Center(
            child: CircularProgressIndicator(color: Colors.black),
          );
        }

        if (paymentProvider.hasError) {
          return Center(
            child: Text(AppStrings.failedToLoadPaymentMethods.tr),
          );
        }

        if (paymentProvider.paymentMethods.isEmpty) {
          return Center(
            child: Text(AppStrings.noPaymentMethodsAvailable.tr),
          );
        }

        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: paymentProvider.paymentMethods.length,
          itemBuilder: (context, index) {
            final paymentMethod = paymentProvider.paymentMethods[index];

            return Column(
              children: [
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                    color: paymentProvider.selectedMethod == paymentMethod.name
                        ? isDarkMode
                            ? Colors.blue[250]
                            : Colors.blue[50]
                        : Theme.of(context).colorScheme.surface,
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(
                      color: paymentProvider.selectedMethod == paymentMethod.name ? Colors.blue : Colors.grey.shade300,
                    ),
                  ),
                  child: RadioListTile<String>(
                    title: Row(
                      children: [
                        // النص - يأخذ المساحة المتاحة
                        Expanded(
                          flex: 3,
                          child: Text(
                            paymentMethod.label,
                            style: const TextStyle(fontSize: 14),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        // الصور - مساحة محددة
                        Expanded(
                          flex: 2,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // الصورة الأولى
                              if (paymentMethod.image.isNotEmpty && _isValidUrl(paymentMethod.image))
                                Flexible(
                                  child: _buildPaymentImage(
                                    paymentMethod.image,
                                    paymentMethod.imgWidth.toDouble(),
                                  ),
                                ),

                              const SizedBox(width: 4),

                              // الصورة الثانية
                              if (paymentMethod.image1.isNotEmpty && _isValidUrl(paymentMethod.image1))
                                Flexible(
                                  child: _buildPaymentImage(
                                    paymentMethod.image1,
                                    paymentMethod.imgWidth1.toDouble(),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    activeColor: Colors.blue,
                    value: paymentMethod.name,
                    groupValue: paymentProvider.selectedMethod,
                    onChanged: (value) {
                      paymentProvider.setSelectedMethod(value!);
                      setState(() {
                        expandedMethod = paymentMethod.name;

                        // التحقق من وجود خيارات فرعية
                        if (paymentMethod.subOptions.isNotEmpty && paymentMethod.subOptions.first.value.isNotEmpty) {
                          selectedSubOption = paymentMethod.subOptions.first.value.first.value;

                          final callback = widget.onSelectionChanged;
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
                          selectedSubOption = null;
                        }
                      });
                    },
                  ),
                ),

                // الخيارات الفرعية
                if (widget.subCardShow == true &&
                    expandedMethod == paymentMethod.name &&
                    paymentMethod.subOptions.isNotEmpty)
                  ...paymentMethod.subOptions.map(
                    (subOption) => Container(
                      padding: EdgeInsets.only(
                        left: screenWidth * 0.050,
                        right: screenWidth * 0.050,
                      ),
                      child: Column(
                        children: subOption.value
                            .where((type) {
                              // 🔹 Hide Tabby if paymentType = gift_card
                              if (widget.paymentType == 'gift_card' && type.value == 'tabby') {
                                return false;
                              }
                              return true;
                            })
                            .map(
                              (type) => Container(
                                margin: const EdgeInsets.symmetric(vertical: 4),
                                decoration: BoxDecoration(
                                  color: selectedSubOption == type.value
                                      ? isDarkMode
                                          ? Colors.blue[250]
                                          : Colors.blue[50]
                                      : Theme.of(context).colorScheme.surface,
                                  borderRadius: BorderRadius.circular(4),
                                  border: Border.all(
                                    color:
                                        selectedSubOption == type.value ? Colors.blue.shade200 : Colors.grey.shade300,
                                  ),
                                ),
                                child: RadioListTile<String>(
                                  title: Text(type.title),
                                  value: type.value,
                                  groupValue: selectedSubOption,
                                  activeColor: Colors.blue,
                                  onChanged: (value) {
                                    setState(() {
                                      selectedSubOption = value;
                                    });
                                    final callback = widget.onSelectionChanged;
                                    if (callback != null) {
                                      callback(
                                        updatePaymentMethod(
                                          paymentMethod.code,
                                          subOption.key,
                                          value ?? '',
                                        ),
                                      );
                                    }
                                  },
                                ),
                              ),
                            )
                            .toList(),
                      ),
                    ),
                  ),
              ],
            );
          },
        );
      },
    );
  }

  // دالة مساعدة لبناء الصور مع معالجة الأخطاء
  Widget _buildPaymentImage(String imageUrl, double width) {
    return Container(
      constraints: BoxConstraints(
        maxWidth: width > 0 ? width : 50,
        maxHeight: 40,
      ),
      child: Image.network(
        imageUrl,
        width: width > 0 ? width : 50,
        height: 40,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) {
          // في حالة فشل تحميل الصورة
          return Container(
            width: width > 0 ? width : 50,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(4),
            ),
            child: const Icon(
              Icons.payment,
              color: Colors.grey,
              size: 20,
            ),
          );
        },
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return SizedBox(
            width: width > 0 ? width : 50,
            height: 40,
            child: const Center(
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            ),
          );
        },
      ),
    );
  }

  // دالة للتحقق من صحة الرابط
  bool _isValidUrl(String url) {
    if (url.isEmpty) return false;
    try {
      Uri.parse(url);
      return url.startsWith('http://') || url.startsWith('https://');
    } catch (e) {
      return false;
    }
  }

  Map<String, String> updatePaymentMethod(
    String paymentMethod,
    String optionKey,
    String optionValue,
  ) {
    final Map<String, String> paymentMap = {};
    paymentMap['payment_method'] = paymentMethod;
    paymentMap['sub_option_key'] = optionKey;
    paymentMap['sub_option_value'] = optionValue;
    return paymentMap;
  }
}

// إضافة extension مساعد للتحقق من وجود العنصر الأول
extension ListExtension<T> on List<T> {
  T? get firstOrNull => isEmpty ? null : first;
}
