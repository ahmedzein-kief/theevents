import 'package:event_app/core/helper/extensions/app_localizations_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/widgets/loading_indicator.dart';
import '../../../logic/notification/notification_settings_cubit.dart';
import '../../../logic/notification/notification_settings_state.dart';
import 'notification_settings_content.dart';
import 'notification_settings_error_widget.dart';

class NotificationSettingsView extends StatelessWidget {
  const NotificationSettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: _buildAppBar(isDark),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Container(
                color: isDark ? Colors.grey[900] : const Color(0xFFF5F5F5),
                // margin: const EdgeInsets.all(8),
                // padding: const EdgeInsets.all(16),
                // decoration: themeHelper.containerDecoration,
                child: BlocBuilder<NotificationSettingsCubit, NotificationSettingsState>(
                  builder: (context, state) => _buildContent(context, state),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  AppBar _buildAppBar(isDark) {
    return AppBar(
      title: Text(
        AppStrings.notificationSettings.tr,
        style: GoogleFonts.openSans(fontSize: 16),
      ),
      elevation: 0,
      // backgroundColor: isDark ? Colors.grey[900] : const Color(0xFFF5F5F5),
      // shadowColor: isDark ? Colors.grey[900] : const Color(0xFFF5F5F5),
    );
  }

  Widget _buildContent(BuildContext context, NotificationSettingsState state) {
    if (state is NotificationSettingsLoading) {
      return const LoadingIndicator();
    } else if (state is NotificationSettingsError) {
      return NotificationSettingsErrorWidget(
        message: state.message,
        onRetry: () => context.read<NotificationSettingsCubit>().loadPreferences(),
      );
    } else if (state is NotificationSettingsLoaded) {
      return NotificationSettingsContent(
        notificationPreferences: state.preferences,
      );
    }
    return const SizedBox.shrink();
  }
}
