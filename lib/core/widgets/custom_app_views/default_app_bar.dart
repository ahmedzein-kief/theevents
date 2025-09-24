import 'package:flutter/material.dart';

class DefaultAppBar extends StatelessWidget implements PreferredSizeWidget {
  const DefaultAppBar({
    super.key,
    this.backgroundColor,
    this.leading,
    this.leadingWidth = 100,
    this.title,
    this.actions,
    this.centerTitle = false,
    this.elevation,
  });

  final Color? backgroundColor;
  final Widget? leading;
  final double leadingWidth;
  final Widget? title;
  final List<Widget>? actions;
  final bool centerTitle;
  final double? elevation;

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return AppBar(
      actionsPadding: const EdgeInsetsGeometry.directional(end: 20),
      backgroundColor: backgroundColor ?? Theme.of(context).colorScheme.primary,
      leading: leading,
      leadingWidth: leadingWidth,
      title: title,
      centerTitle: centerTitle,
      actions: actions,
      elevation: elevation,
      iconTheme: IconThemeData(
        color: isDarkMode ? Colors.white : Colors.black,
      ),
      titleTextStyle: TextStyle(
        color: isDarkMode ? Colors.white : Colors.black,
        fontSize: 20,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
