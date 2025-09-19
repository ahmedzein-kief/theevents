import 'package:flutter/material.dart';

import '../widgets/notification/notifications_balance_cards.dart';
import '../widgets/notification/notifications_content.dart';
import '../widgets/shared/wallet_header.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            WalletHeader(isDark: isDark),
            const NotificationsBalanceCards(),
            const Expanded(child: NotificationsContent()),
          ],
        ),
      ),
    );
  }
}
