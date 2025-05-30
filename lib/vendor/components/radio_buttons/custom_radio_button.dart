import 'package:event_app/core/styles/app_colors.dart';
import 'package:event_app/utils/mixins_and_constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/components/radio/gf_radio.dart';
import 'package:getwidget/types/gf_radio_type.dart';

class VendorCustomRadioListTile extends StatefulWidget {
  final dynamic value; // Value for the individual radio button
  final dynamic groupValue; // The current selected value for the group
  final ValueChanged<dynamic?> onChanged; // Callback for when the value changes
  final String title; // Title text for the list tile
  final TextStyle? textStyle; // Optional custom style for the text
  final EdgeInsets? padding; // Optional padding for the list tile
  final String? tooltipMessage;
  FocusNode? focusNode;

  VendorCustomRadioListTile({
    required this.value,
    required this.groupValue,
    required this.onChanged,
    required this.title,
    this.textStyle,
    this.padding,
    this.focusNode,
    this.tooltipMessage,
  });

  @override
  State<VendorCustomRadioListTile> createState() => _VendorCustomRadioListTileState();
}

class _VendorCustomRadioListTileState extends State<VendorCustomRadioListTile> {
  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: widget.tooltipMessage ?? '',
      child: InkWell(
        onTap: () {
          // Call the onChanged callback with the new value when the list tile is tapped
          widget.onChanged(widget.value);
        },
        child: Container(
          padding: widget.padding ?? const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              GFRadio<dynamic>(
                focusNode: widget.focusNode,
                size: 16,
                activeBorderColor: AppColors.peachyPink,
                inactiveBorderColor: Colors.grey,
                value: widget.value,
                // Individual radio button value
                groupValue: widget.groupValue,
                // The currently selected value
                onChanged: widget.onChanged,
                // Callback for when value changes
                type: GFRadioType.custom,
                activeIcon: Icon(
                  Icons.circle,
                  size: 14,
                  color: AppColors.peachyPink,
                ),
                radioColor: AppColors.lightCoral,
              ),
              kExtraSmallSpace,
              Text(
                widget.title,
                style: widget.textStyle ?? const TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
