import 'package:flutter/material.dart';

import '../../../vendor/Components/vendor_text_style.dart';

class VendorModifySectionsAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final Function()? onGoBack;

  const VendorModifySectionsAppBar({super.key, required this.title, this.onGoBack});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AppBar(
      automaticallyImplyLeading: false,
      centerTitle: false,
      backgroundColor: theme.appBarTheme.backgroundColor,
      title: Text(
        title,
        style: vendorName(context),
      ),
      leading: IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: onGoBack,
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
