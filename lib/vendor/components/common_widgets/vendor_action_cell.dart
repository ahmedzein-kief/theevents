import 'package:event_app/core/styles/app_colors.dart';
import 'package:event_app/utils/mixins_and_constants/constants.dart';
import 'package:event_app/vendor/components/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class VendorActionCell extends StatelessWidget {
  final bool isDeleting;
  final VoidCallback? onEdit;
  final VoidCallback onDelete;
  final VoidCallback? onView;
  final showEdit;
  final showDelete;
  final showView;
  final Widget? showViewWidget;
  final MainAxisSize mainAxisSize;

  VendorActionCell(
      {Key? key,
      required this.isDeleting,
      this.onEdit,
      required this.onDelete,
      this.onView,
      this.showDelete = true,
      this.showEdit = true,
      this.showView = false,
      this.showViewWidget = null,
      this.mainAxisSize = MainAxisSize.max})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: mainAxisSize,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (showEdit)
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              GestureDetector(
                onTap: onEdit,
                child: SvgPicture.asset("assets/vendor_assets/settings/edit_record.svg"),
              ),
              // Spacer between icons
              kExtraSmallSpace,
            ],
          ),
        if (showDelete)
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              GestureDetector(
                onTap: isDeleting ? null : onDelete,
                child: isDeleting ? Utils.pageLoadingIndicator(context: context) : SvgPicture.asset("assets/vendor_assets/settings/delete_record.svg"),
              ),
            ],
          ),
        if (showView)
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              kExtraSmallSpace,
              GestureDetector(
                onTap: onView,
                child: Icon(Icons.remove_red_eye,color: AppColors.cornflowerBlue),
              ),
            ],
          ),
        if (showViewWidget != null) showViewWidget!
      ],
    );
  }
}
