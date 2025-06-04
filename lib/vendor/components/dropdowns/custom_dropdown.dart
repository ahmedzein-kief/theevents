import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:event_app/core/styles/app_colors.dart';
import 'package:event_app/core/helper/mixins/media_query_mixin.dart';
import 'package:event_app/vendor/components/input_borders_hub/input_border_hub.dart';
import 'package:flutter/material.dart';

class CustomDropdown extends StatefulWidget {
  final Widget? prefix;
  final Widget? suffix;

  // final List<String> genderList;
  final List<DropdownMenuItem> menuItemsList;

  // final List<dynamic> menuList;
  final void Function(dynamic value) onChanged;
  final FocusNode? currentFocusNode;
  final FocusNode? nextFocusNode;

  // final TextDirection textDirection;
  bool? filled;
  Color? textColor;
  String? errorText;
  bool? readOnly;
  dynamic value;

  // InputBorder? border;
  double? borderRadius;
  String? hintText;
  bool isOutlinedBorder;
  double? borderWidth;
  Color? borderColor;
  String? Function(dynamic)? validator;
  TextStyle? textStyle;
  EdgeInsetsGeometry? contentPadding;

  CustomDropdown({
    super.key,
    this.prefix,
    this.suffix,
    // required this.textDirection,
    required this.menuItemsList, // required this.menuList,
    required this.onChanged,
    this.currentFocusNode,
    this.value,
    this.nextFocusNode,
    this.filled,
    this.textColor,
    this.hintText,
    this.errorText,
    this.isOutlinedBorder = true,
    this.borderRadius,
    this.readOnly,
    this.borderWidth,
    this.borderColor,
    this.validator,
    this.textStyle,
    this.contentPadding,
  });

  @override
  State<CustomDropdown> createState() => _CustomDropdownState();
}

class _CustomDropdownState extends State<CustomDropdown>
    with MediaQueryMixin<CustomDropdown> {
  String? selectedValue;
  final TextEditingController textEditingController = TextEditingController();

  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // creating border for text field
    final border = widget.isOutlinedBorder
        ? InputBordersHub.getOutlinedInputBorder(
            borderColor: widget.borderColor,
            borderWidth: widget.borderWidth,
            borderRadius: widget.borderRadius)
        : InputBordersHub.getUnderlinedInputBorder(
            borderColor: widget.borderColor,
            borderWidth: widget.borderWidth,
            borderRadius: widget.borderRadius);

    // final localization = AppLocalizations.of(context)!;
    return IgnorePointer(
      ignoring: widget.readOnly ?? false,
      child:
          // DropdownButtonFormField(
          DropdownButtonFormField2(
        // alignment: getTextDirection(langProvider) == TextDirection.ltr ? Alignment.centerLeft : Alignment.centerRight,
        alignment: Alignment.centerLeft,
        isExpanded: true,
        enableFeedback: true,
        isDense: true,
        // dropdownColor: AppColors.scoButtonColor,
        // dropdownColor: Colors.white,
        items: widget.menuItemsList,
        value: widget.value,
        onChanged: (value) {
          setState(() {
            widget.onChanged(value);
            FocusScope.of(context).requestFocus(widget.nextFocusNode);
          });
        },
        focusNode: widget.currentFocusNode,
        decoration: InputDecoration(
          errorText: widget.errorText,
          errorMaxLines: 5,
          // isCollapsed: true,
          isDense: true,
          // contentPadding: widget.contentPadding ?? EdgeInsets.symmetric(vertical: 12.0, horizontal: screenWidth * 0.03),
          contentPadding: widget.contentPadding ??
              const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),

          prefixIcon: widget.prefix,
          prefixIconConstraints: const BoxConstraints(
            minWidth: 30,
            minHeight: 0,
          ),
          // suffix: widget.suffix ?? Icon(Icons.keyboard_arrow_down,size: 25),
          // alignLabelWithHint: false,
          hintText: widget.hintText,
          hintFadeDuration: const Duration(milliseconds: 500),
          hintStyle: const TextStyle(
              color: AppColors.softBlueGrey,
              fontSize: 14,
              fontWeight: FontWeight.w500),
          border: border,
          focusedBorder: border,
          // errorBorder: border,
          enabledBorder: border,
          focusedErrorBorder: border,
          filled: widget.filled,
          fillColor: Colors.grey.shade200,
        ),

        // cursorColor: AppColors.darkGrey,
        style: widget.textStyle ??
            TextStyle(
                color: widget.textColor ?? AppColors.softBlueGrey,
                overflow: TextOverflow.ellipsis),
        // padding: EdgeInsets.zero,
        hint: Text(
          widget.hintText ?? 'Select',
          style: widget.textStyle ??
              TextStyle(
                  color: widget.textColor ?? AppColors.softBlueGrey,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  overflow: TextOverflow.ellipsis),
          overflow: TextOverflow.ellipsis,
        ),
        iconStyleData: const IconStyleData(
          icon: Icon(
            Icons.keyboard_arrow_down_sharp,
            color: AppColors.darkGrey,
          ),
          openMenuIcon: Icon(
            Icons.keyboard_arrow_up_sharp,
            color: AppColors.darkGrey,
            // weight: 10000,
          ),
          // iconSize: 20
        ),
        menuItemStyleData: const MenuItemStyleData(
            padding: EdgeInsets.symmetric(horizontal: 0)),
        dropdownStyleData: DropdownStyleData(
          useSafeArea: true,
          width: screenWidth - 10,

          /// This is responsible for spacing between the prefix icon and Dropdown text.
          maxHeight: screenHeight / 1.5,
          padding: const EdgeInsets.only(left: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        // keyboardType: widget.textInputType ?? TextInputType.text,
        // dropdownSearchData: DropdownSearchData(
        //   searchController: textEditingController,
        //   searchInnerWidgetHeight: 50,
        //   searchInnerWidget: Container(
        //     // height: 50,
        //     padding: const EdgeInsets.only(
        //       top: 10,
        //       bottom: 4,
        //       right: 5,
        //       left: 5,
        //     ),
        //     child: CustomTextFormField(
        //       controller: textEditingController,
        //       focusNode: FocusNode(),
        //       hintText: "search",
        //       onChanged: (String? value) {},
        //       labelText: '',
        //       required: false,
        //       showTitle: false,
        //     ),
        //   ),
        //   searchMatchFn: (item, searchValue) {
        //     return item.child.toString().toLowerCase().contains(searchValue.toLowerCase());
        //   },
        // ),
        validator: widget.validator,
      ),
    );
  }
}
