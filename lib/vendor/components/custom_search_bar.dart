import 'package:event_app/core/helper/extensions/app_localizations_extension.dart';
import 'package:flutter/material.dart';

import '../../core/constants/vendor_app_strings.dart';

class CustomSearchBarVendor extends StatefulWidget {
  const CustomSearchBarVendor({
    super.key,
    required this.suffixIcon,
    required this.onSearch,
    this.hintText,
  });

  final IconData suffixIcon;
  final Function(String) onSearch;
  final String? hintText;

  @override
  State<CustomSearchBarVendor> createState() => _CustomSearchBarState();
}

class _CustomSearchBarState extends State<CustomSearchBarVendor> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) => Container(
        height: 40,
        margin: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey, width: 1.5),
          borderRadius: const BorderRadius.all(Radius.circular(2)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: TextField(
                controller: _controller,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.only(left: 8),
                  hintStyle: const TextStyle(color: Colors.grey),
                  hintText: widget.hintText ?? VendorAppStrings.search.tr,
                  border: InputBorder.none,
                  suffixIcon: IconButton(
                    color: Colors.grey,
                    icon: Icon(widget.suffixIcon),
                    onPressed: () {},
                  ),
                ),
                maxLines: 1,
              ),
            ),
          ],
        ),
      );
}
