import 'package:event_app/core/helper/extensions/app_localizations_extension.dart';
import 'package:event_app/wallet/ui/widgets/wallet_drawer/wallet_drawer_menu_item_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/model/drawer_menu_item.dart';
import '../../../logic/drawer/drawer_cubit.dart';

class WalletDrawerMenuItems extends StatelessWidget {
  const WalletDrawerMenuItems({super.key, required this.selectedIndex, required this.menuItems});

  final int selectedIndex;
  final List<DrawerMenuItem> menuItems;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 18),
        itemCount: menuItems.length,
        itemBuilder: (context, index) {
          final item = menuItems[index];
          return DrawerMenuItemWidget(
            title: item.title.tr,
            icon: item.icon,
            isSelected: selectedIndex == index,
            onTap: () {
              // Now uses DrawerCubit instead of setState
              context.read<DrawerCubit>().setSelectedScreen(index);
            },
          );
        },
      ),
    );
  }
}
