import 'package:event_app/core/constants/app_strings.dart';
import 'package:event_app/wallet/ui/screens/wallet_overview_screen.dart';
import 'package:event_app/wallet/ui/widgets/wallet_drawer/wallet_drawer_footer.dart';
import 'package:event_app/wallet/ui/widgets/wallet_drawer/wallet_drawer_menu_items.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/model/drawer_menu_item.dart';
import '../../logic/drawer/drawer_cubit.dart';
import '../../logic/drawer/drawer_state.dart';
import '../widgets/wallet_drawer/wallet_drawer_header.dart';
import 'add_funds_screen.dart';
import 'history_screen.dart';
import 'notifications_screen.dart';

class WalletDrawer extends StatefulWidget {
  const WalletDrawer({super.key});

  @override
  State<WalletDrawer> createState() => _WalletDrawerState();
}

class _WalletDrawerState extends State<WalletDrawer> {
  final List<DrawerMenuItem> _menuItems = [
    DrawerMenuItem(
      title: AppStrings.overview,
      icon: Icons.dashboard_outlined,
      route: null,
    ),
    DrawerMenuItem(
      title: AppStrings.deposits,
      icon: Icons.add_circle_outline,
      route: null,
    ),
    DrawerMenuItem(
      title: AppStrings.history,
      icon: Icons.history,
      route: null,
    ),
    DrawerMenuItem(
      title: AppStrings.notifications,
      icon: Icons.notifications_outlined,
      route: null,
    ),
  ];

  Widget _buildMainContent(int selectedIndex) {
    switch (selectedIndex) {
      case 0:
        return const WalletOverviewScreen();
      case 1:
        return const AddFundsScreen();
      case 2:
        return const HistoryScreen();
      case 3:
        return const NotificationsScreen();
      default:
        return const WalletOverviewScreen();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      body: Stack(
        children: [
          // Main Content
          BlocBuilder<DrawerCubit, DrawerState>(
            builder: (context, drawerState) => _buildMainContent(drawerState.selectedIndex),
          ),

          // Drawer Overlay
          BlocBuilder<DrawerCubit, DrawerState>(
            builder: (context, drawerState) {
              if (!drawerState.isOpen) return const SizedBox.shrink();

              return Stack(
                children: [
                  // Background overlay
                  GestureDetector(
                    onTap: () => context.read<DrawerCubit>().closeDrawer(),
                    child: Container(
                      color: Colors.black.withAlpha((0.5 * 255).toInt()),
                    ),
                  ),

                  // Drawer Content
                  Positioned(
                    right: 0,
                    top: 0,
                    bottom: 0,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                      width: MediaQuery.of(context).size.width * 0.75,
                      decoration: BoxDecoration(
                        color: theme.scaffoldBackgroundColor,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(16),
                          bottomLeft: Radius.circular(16),
                        ),
                        border: isDark ? Border.all(color: Colors.grey[800]!, width: 1) : null,
                      ),
                      child: SafeArea(
                        child: Column(
                          children: [
                            const WalletDrawerHeader(),
                            Divider(color: theme.dividerColor),
                            WalletDrawerMenuItems(
                              selectedIndex: drawerState.selectedIndex,
                              menuItems: _menuItems,
                            ),
                            const WalletDrawerFooter(),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
