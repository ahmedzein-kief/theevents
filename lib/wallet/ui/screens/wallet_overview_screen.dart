import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../logic/wallet/wallet_cubit.dart';
import '../../logic/wallet/wallet_state.dart';
import '../widgets/overview/overview_content.dart';
import '../widgets/overview/overview_error_view.dart';
import '../widgets/shared/wallet_header.dart';

class WalletOverviewScreen extends StatelessWidget {
  const WalletOverviewScreen({super.key});

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
            Expanded(
              child: Container(
                color: isDark ? Colors.grey[900] : const Color(0xFFF5F5F5),
                child: BlocBuilder<WalletCubit, WalletState>(
                  builder: (context, state) {
                    if (state is WalletLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (state is WalletError) {
                      return OverviewErrorView(message: state.message);
                    }
                    if (state is WalletLoaded) {
                      return OverviewContent(isDark: isDark, state: state);
                    }
                    return const SizedBox();
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
