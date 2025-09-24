import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/helper/di/locator.dart';
import '../../logic/notification/notification_settings_cubit.dart';
import '../widgets/notification_settings/notification_settings_view.dart';

class NotificationSettingsScreen extends StatelessWidget {
  const NotificationSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => locator<NotificationSettingsCubit>()..loadPreferences(),
      child: const NotificationSettingsView(),
    );
  }
}
