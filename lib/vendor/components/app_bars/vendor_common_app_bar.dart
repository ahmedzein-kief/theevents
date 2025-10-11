import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../vendor/Components/vendor_text_style.dart';

class VendorCommonAppBar extends StatelessWidget implements PreferredSizeWidget {
  const VendorCommonAppBar({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AppBar(
      automaticallyImplyLeading: false,
      centerTitle: false,
      //
      backgroundColor: theme.appBarTheme.backgroundColor,
      title: Text(
        title,
        style: vendorName(context),
      ),
      actions: [
        IconButton(
          icon: const Icon(CupertinoIcons.clear_thick),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
