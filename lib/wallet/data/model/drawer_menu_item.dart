import 'package:flutter/cupertino.dart';

class DrawerMenuItem {
  final String title;
  final IconData icon;
  final String? route;

  DrawerMenuItem({
    required this.title,
    required this.icon,
    this.route,
  });
}
