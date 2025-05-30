import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../styles/custom_text_styles.dart';

class CustomTextFieldWithCoupon extends StatefulWidget {
  final String labelText;
  final String hintText;
  final Map<String, dynamic> couponData;
  final void Function(String couponCode, bool isApply) onCouponApplyRemove;
  final void Function(String? value) onValueChange;

  const CustomTextFieldWithCoupon({
    Key? key,
    required this.labelText,
    required this.hintText,
    required this.couponData,
    required this.onCouponApplyRemove,
    required this.onValueChange,
  }) : super(key: key);

  @override
  State<CustomTextFieldWithCoupon> createState() => _CustomTextFieldWithCouponState();
}

class _CustomTextFieldWithCouponState extends State<CustomTextFieldWithCoupon> {
  final TextEditingController _couponController = TextEditingController();

  @override
  void initState() {
    _couponController.text = widget.couponData['coupon_code'] ?? '';
    super.initState();
  }

  @override
  void didUpdateWidget(covariant CustomTextFieldWithCoupon oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.couponData['coupon_code'] != oldWidget.couponData['coupon_code']) {
      _couponController.text = widget.couponData['coupon_code'] ?? '';
    }
  }

  @override
  Widget build(BuildContext context) {

    final validCoupon = ((widget.couponData['coupon_code'] as String).isNotEmpty && (widget.couponData['is_valid_coupon'] as bool));
    final invalidCoupon = ((widget.couponData['coupon_code'] as String).isNotEmpty && !(widget.couponData['is_valid_coupon'] as bool));

    dynamic screenWidth = MediaQuery.sizeOf(context).width;
    dynamic screenHeight = MediaQuery.sizeOf(context).height;

    return Padding(
      padding: EdgeInsets.only(
        top: screenHeight * 0.01,
        right: screenWidth * 0.02,
        left: screenWidth * 0.02,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(widget.labelText, style: chooseStyle(context)),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: Stack(
                  children: [
                    TextFormField(
                      enabled: !validCoupon,
                      controller: _couponController,
                      onChanged: widget.onValueChange,
                      autovalidateMode: AutovalidateMode.always,
                      decoration: InputDecoration(
                        hintText: widget.hintText,
                        hintStyle: const TextStyle(color: Colors.grey),
                        enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey), // Unfocused border
                        ),
                        focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey), // Focused border
                        ),
                        focusedErrorBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.red), // Focused border
                        ),
                        disabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                        errorBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.red),
                        ),
                        errorText: invalidCoupon ? widget.couponData['message'] : null,
                        filled: true,
                      ),
                    ),
                    Positioned(
                      right: 8,
                      top: 8,
                      bottom: 8,
                      child: GestureDetector(
                        onTap: () {
                          if (validCoupon) {
                            widget.onCouponApplyRemove(_couponController.text, false);
                          } else {
                            widget.onCouponApplyRemove(_couponController.text, true);
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Text(
                            validCoupon ? 'Remove' : 'Apply',
                            style: GoogleFonts.inter(
                              color: Colors.blue,
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
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
