import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../logic/notification/notification_cubit.dart';
import '../../logic/wallet/wallet_cubit.dart';
import '../../logic/wallet/wallet_state.dart';
import '../widgets/notification/notifications_content.dart';
import '../widgets/shared/wallet_current_rewards_cards.dart';
import '../widgets/shared/wallet_header.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  @override
  void initState() {
    context.read<NotificationsCubit>().initializeNotifications();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: BlocBuilder<WalletCubit, WalletState>(
          builder: (context, state) {
            final expiryCount = state is WalletLoaded ? state.wallet.expiringLotsCount : 0;

            return Column(
              children: [
                WalletHeader(isDark: isDark, expiryCount: expiryCount),
                Expanded(
                  child: Container(
                    color: isDark ? Colors.grey[900] : const Color(0xFFF5F5F5),
                    child: _buildBody(context, state, isDark),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context, WalletState state, bool isDark) {
    return const Column(
      children: [
        WalletCurrentRewardsCards(),
        SizedBox(height: 24),
        Expanded(child: NotificationsContent()),
      ],
    );
  }
}
