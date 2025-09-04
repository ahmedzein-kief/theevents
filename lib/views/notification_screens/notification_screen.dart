import 'package:event_app/core/helper/extensions/app_localizations_extension.dart';
import 'package:flutter/material.dart';

import '../../core/constants/app_strings.dart';
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
  Widget build(BuildContext context) => Scaffold(
        body: SafeArea(
          child: Center(
            child: Text(
              AppStrings.notification.tr, // User is not logged in
              style: const TextStyle(
                fontFamily: 'FontSF',
                fontSize: 20,
                color: AppColors.peachyPink,
              ),
            ),
          ),
        ),
      );
}
