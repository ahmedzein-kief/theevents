import 'package:flutter_bloc/flutter_bloc.dart';

import 'drawer_state.dart';

class DrawerCubit extends Cubit<DrawerState> {
  DrawerCubit() : super(const DrawerState(isOpen: false, selectedIndex: 0));

  void toggleDrawer() => emit(DrawerState(
        isOpen: !state.isOpen,
        selectedIndex: state.selectedIndex,
      ));

  void closeDrawer() => emit(DrawerState(
        isOpen: false,
        selectedIndex: state.selectedIndex,
      ));

  void openDrawer() => emit(DrawerState(
        isOpen: true,
        selectedIndex: state.selectedIndex,
      ));

  // New method that your WalletOverviewScreen is already trying to call
  void setSelectedScreen(int index) => emit(DrawerState(
        isOpen: false, // Close drawer when selecting screen
        selectedIndex: index,
      ));
}
