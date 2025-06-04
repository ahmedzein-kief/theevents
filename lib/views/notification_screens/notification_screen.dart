import 'package:flutter/material.dart';

import '../../core/styles/app_colors.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) => const Scaffold(
        body: SafeArea(
          child: Center(
            child: Text(
              "You Don't Have Any Notification Yet", // User is not logged in
              style: TextStyle(
                fontFamily: 'FontSF',
                fontSize: 20,
                color: AppColors.peachyPink,
              ),
            ),
          ),
        ),
      );
}
