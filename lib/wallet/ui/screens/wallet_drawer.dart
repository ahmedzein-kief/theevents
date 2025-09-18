import 'package:event_app/wallet/ui/screens/wallet_overview_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:event_app/core/helper/extensions/app_localizations_extension.dart';
import 'package:event_app/core/constants/app_strings.dart';

import '../../data/model/drawer_menu_item.dart';
import '../../logic/drawer/drawer_cubit.dart';
import 'add_funds_screen.dart';
import 'history_screen.dart';
import 'notifications_screen.dart';

class WalletDrawer extends StatefulWidget {
  const WalletDrawer({super.key});

  @override
  State<WalletDrawer> createState() => _WalletDrawerState();
}

class _WalletDrawerState extends State<WalletDrawer> {
  int _selectedIndex = 0;

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Main Content
          _buildMainContent(),

          // Drawer Overlay
          BlocBuilder<DrawerCubit, bool>(
            builder: (context, isDrawerOpen) {
              if (!isDrawerOpen) return const SizedBox.shrink();

              return Stack(
                children: [
                  // Drawer Content
                  Positioned(
                    right: 0,
                    top: 0,
                    bottom: 0,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                      width: MediaQuery.of(context).size.width * 0.75,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(16),
                          bottomLeft: Radius.circular(16),
                        ),
                      ),
                      child: SafeArea(
                        child: Column(
                          children: [
                            _buildDrawerHeader(),
                            const Divider(),
                            _buildDrawerMenuItems(),
                            _buildDrawerFooter(),
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

  Widget _buildMainContent() {
    switch (_selectedIndex) {
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

  Widget _buildDrawerHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Menu'.tr,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          IconButton(
            onPressed: () => context.read<DrawerCubit>().closeDrawer(),
            icon: const Icon(Icons.close),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerMenuItems() {
    return Expanded(
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: _menuItems.length,
        itemBuilder: (context, index) {
          final item = _menuItems[index];
          return _DrawerMenuItemWidget(
            title: item.title.tr,
            icon: item.icon,
            isSelected: _selectedIndex == index,
            onTap: () {
              setState(() {
                _selectedIndex = index;
              });
              context.read<DrawerCubit>().closeDrawer();
            },
          );
        },
      ),
    );
  }

  Widget _buildDrawerFooter() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: Colors.red[100],
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.event,
              color: Colors.red,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'events',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '© 2024 The Events. All Rights Reserved.',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }
}

// Missing _DrawerMenuItemWidget
class _DrawerMenuItemWidget extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;
  final bool isSelected;

  const _DrawerMenuItemWidget({
    required this.title,
    required this.icon,
    required this.onTap,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: isSelected ? const Color(0xFFF5E6D3) : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Icon(
          icon,
          color: isSelected ? Colors.brown[700] : Colors.grey[600],
        ),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
            color: isSelected ? Colors.brown[700] : Colors.black,
          ),
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios,
          size: 16,
          color: Colors.grey,
        ),
        onTap: onTap,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}
