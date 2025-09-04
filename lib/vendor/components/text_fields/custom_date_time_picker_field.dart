import 'package:event_app/vendor/vendor_home/vendor_coupons/coupon_view_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../core/styles/app_colors.dart';

class CustomDateTimePickerField extends StatelessWidget {
  const CustomDateTimePickerField({
    super.key,
    required this.date,
    required this.time,
    required this.onDateTap,
    required this.onTimeTap,
    required this.readOnly,
  });
  final TextEditingController date;
  final TextEditingController time;
  final VoidCallback onDateTap;
  final VoidCallback onTimeTap;
  final bool readOnly;

  @override
  Widget build(BuildContext context) => Row(
        children: [
          // Date Field
          Expanded(
            flex: 2,
            child: GestureDetector(
              onTap: readOnly ? null : onDateTap,
              child: Container(
                height: 48,
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                decoration: BoxDecoration(
                  color: readOnly ? Colors.grey.shade300 : Colors.transparent,
                  border: Border.all(color: AppColors.softBlueGrey),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(4),
                    bottomLeft: Radius.circular(4),
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Text(
                        date.text,
                        style: CouponViewUtils.couponLabelTextStyle(),
                      ),
                    ),
                    SvgPicture.asset(
                        'assets/vendor_assets/settings/choose_date.svg',),
                  ],
                ),
              ),
            ),
          ),
          // Time Field
          Expanded(
            child: GestureDetector(
              onTap: readOnly ? null : onTimeTap,
              child: Container(
                height: 48,
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                decoration: BoxDecoration(
                  color: readOnly ? Colors.grey.shade300 : Colors.transparent,
                  border: const Border(
                    top: BorderSide(color: AppColors.softBlueGrey),
                    right: BorderSide(color: AppColors.softBlueGrey),
                    bottom: BorderSide(color: AppColors.softBlueGrey),
                  ),
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(4),
                    bottomRight: Radius.circular(4),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      time.text,
                      style: CouponViewUtils.couponLabelTextStyle(),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      );
}
