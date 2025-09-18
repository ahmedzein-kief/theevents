import 'package:event_app/core/helper/extensions/app_localizations_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/model/notification_model.dart';
import '../../logic/drawer/drawer_cubit.dart';
import '../../logic/wallet/wallet_cubit.dart';
import '../../logic/wallet/wallet_state.dart';
import '../widgets/notification_item.dart';
import '../widgets/wallet_card.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: Column(
          children: [
            // Header
            _buildHeader(context),
            // Balance Cards
            _buildBalanceCards(context),
            // Notifications Content
            Expanded(
              child: Container(
                margin: const EdgeInsets.all(20),
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header with actions
                    Row(
                      children: [
                        const Icon(Icons.notifications_outlined, size: 24),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'notifications'.tr,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        // Mark all as read button
                        TextButton(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('markAllRead'.tr),
                                duration: const Duration(seconds: 2),
                              ),
                            );
                          },
                          child: Text(
                            'markAllRead'.tr,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.blue,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    // Notifications List
                    Expanded(
                      child: _getNotifications().isEmpty
                          ? _buildEmptyState(context)
                          : RefreshIndicator(
                              onRefresh: () async {
                                await Future.delayed(const Duration(seconds: 1));
                              },
                              child: ListView.builder(
                                itemCount: _getNotifications().length,
                                itemBuilder: (context, index) {
                                  final notification = _getNotifications()[index];
                                  return NotificationItem(notification: notification);
                                },
                              ),
                            ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      color: Colors.white,
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.account_balance_wallet,
              color: Colors.white,
              size: 24,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'digitalWallet'.tr,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Text(
                  'Hi, Ahmed Al-Mahmoud',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              'expirySoon'.tr,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(width: 12),
          BlocBuilder<DrawerCubit, bool>(
            builder: (context, isOpen) {
              return IconButton(
                onPressed: () => context.read<DrawerCubit>().toggleDrawer(),
                icon: const Icon(Icons.menu),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildBalanceCards(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      child: BlocBuilder<WalletCubit, WalletState>(
        builder: (context, state) {
          double currentBalance = 1500.0;
          double rewardsEarned = 75.0;
          if (state is WalletLoaded) {
            currentBalance = state.wallet.currentBalance;
            rewardsEarned = state.wallet.rewardsEarned;
          }
          return Row(
            children: [
              Expanded(
                child: WalletCard(
                  title: 'currentBalanceTitle'.tr,
                  amount: currentBalance,
                  currency: 'AED',
                  icon: Icons.account_balance_wallet_outlined,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: WalletCard(
                  title: 'rewardsEarnedTitle'.tr,
                  amount: rewardsEarned,
                  currency: 'AED',
                  icon: Icons.stars_outlined,
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.notifications_none,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'noNotificationsYet'.tr,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'notificationsEmptyMessage'.tr,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  List<NotificationModel> _getNotifications() {
    return [
      NotificationModel(
        id: '1',
        title: 'Deposit Successful',
        message: 'Your deposit of AED 500.00 has been processed successfully.',
        type: NotificationType.success,
        date: DateTime.now().subtract(const Duration(minutes: 30)),
        isRead: false,
      ),
      NotificationModel(
        id: '2',
        title: 'Reward Earned',
        message: 'You\'ve earned AED 75.00 in cashback rewards from your recent purchase!',
        type: NotificationType.reward,
        date: DateTime.now().subtract(const Duration(hours: 2)),
        isRead: false,
      ),
      NotificationModel(
        id: '3',
        title: 'Wallet Expiry Warning',
        message: 'Your wallet will expire soon. Please renew to continue using all features.',
        type: NotificationType.warning,
        date: DateTime.now().subtract(const Duration(days: 1)),
        isRead: true,
      ),
      NotificationModel(
        id: '4',
        title: 'Payment Completed',
        message: 'Payment of AED 250.00 for Event Ticket has been completed successfully.',
        type: NotificationType.info,
        date: DateTime.now().subtract(const Duration(days: 2)),
        isRead: true,
      ),
      NotificationModel(
        id: '5',
        title: 'Security Alert',
        message: 'Your account was accessed from a new device. If this wasn\'t you, please contact support.',
        type: NotificationType.warning,
        date: DateTime.now().subtract(const Duration(days: 3)),
        isRead: true,
      ),
    ];
  }
}
