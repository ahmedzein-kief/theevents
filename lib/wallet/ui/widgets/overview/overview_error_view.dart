import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../logic/wallet/wallet_cubit.dart';

class OverviewErrorView extends StatelessWidget {
  const OverviewErrorView({super.key, required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Error: $message', style: TextStyle(color: theme.textTheme.bodyLarge?.color)),
          const SizedBox(height: 12),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: theme.cardColor,
                foregroundColor: theme.textTheme.bodyLarge?.color,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(33),
                )),
            onPressed: () => context.read<WalletCubit>().loadWalletData(),
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }
}
