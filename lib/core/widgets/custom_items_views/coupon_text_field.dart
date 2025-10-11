import 'package:event_app/core/helper/extensions/app_localizations_extension.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../constants/app_strings.dart';
import '../../utils/app_utils.dart';

class CustomTextFieldWithCoupon extends StatefulWidget {
  const CustomTextFieldWithCoupon({
    super.key,
    required this.labelText,
    required this.hintText,
    required this.couponData,
    required this.onCouponApplyRemove,
    required this.onValueChange,
    required this.enabled,
  });

  final bool enabled;
  final String labelText;
  final String hintText;
  final Map<String, dynamic> couponData;
  final void Function(String couponCode, bool isApply) onCouponApplyRemove;
  final ValueChanged<String> onValueChange;

  @override
  State<CustomTextFieldWithCoupon> createState() => _CustomTextFieldWithCouponState();
}

class _CustomTextFieldWithCouponState extends State<CustomTextFieldWithCoupon> {
  final TextEditingController _couponController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _updateControllerText();
  }

  @override
  void didUpdateWidget(covariant CustomTextFieldWithCoupon oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Only update if the coupon code actually changed
    if (widget.couponData['coupon_code'] != oldWidget.couponData['coupon_code']) {
      _updateControllerText();
    }
  }

  void _updateControllerText() {
    final newText = widget.couponData['coupon_code'] ?? '';
    if (_couponController.text != newText) {
      _couponController.text = newText;
    }
  }

  @override
  void dispose() {
    _couponController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final couponCode = widget.couponData['coupon_code'] as String? ?? '';
    final isValid = widget.couponData['is_valid_coupon'] as bool? ?? false;

    final validCoupon = couponCode.isNotEmpty && isValid;
    final invalidCoupon = couponCode.isNotEmpty && !isValid;

    final dynamic screenHeight = MediaQuery.sizeOf(context).height;
    final bool isRTL = AppUtils.isRTL(context);

    return Padding(
      padding: EdgeInsets.only(top: screenHeight * 0.01),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Stack(
                  children: [
                    TextFormField(
                      enabled: widget.enabled && !validCoupon,
                      controller: _couponController,
                      onChanged: widget.enabled ? widget.onValueChange : null,
                      autovalidateMode: AutovalidateMode.always,
                      decoration: InputDecoration(
                        hintText: widget.hintText,
                        hintStyle: const TextStyle(color: Colors.grey),
                        enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                        focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                        focusedErrorBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.red),
                        ),
                        disabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: validCoupon ? Colors.green : Colors.grey,
                          ),
                        ),
                        errorBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.red),
                        ),
                        errorText: invalidCoupon ? widget.couponData['message'] : null,
                        filled: true,
                        fillColor: widget.enabled
                            ? (validCoupon ? Colors.green.withAlpha((0.05 * 255).toInt()) : null)
                            : Colors.grey.withAlpha((0.1 * 255).toInt()),
                      ),
                    ),
                    Positioned(
                      right: isRTL ? null : 8,
                      left: isRTL ? 8 : null,
                      top: 8,
                      bottom: invalidCoupon ? 32 : 8,
                      // Account for error text
                      child: GestureDetector(
                        onTap: widget.enabled
                            ? () {
                                if (validCoupon) {
                                  widget.onCouponApplyRemove(
                                    _couponController.text,
                                    false,
                                  );
                                } else if (_couponController.text.isNotEmpty) {
                                  widget.onCouponApplyRemove(
                                    _couponController.text,
                                    true,
                                  );
                                }
                              }
                            : null,
                        child: Container(
                          padding: const EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.0),
                            color: !widget.enabled ? Colors.grey.withAlpha((0.3 * 255).toInt()) : null,
                          ),
                          child: !widget.enabled
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 1.5,
                                    valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                                  ),
                                )
                              : Text(
                                  validCoupon ? AppStrings.delete.tr : AppStrings.apply.tr,
                                  style: GoogleFonts.inter(
                                    color: validCoupon ? Colors.red : Colors.blue,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
