// add_funds_screen.dart
import 'package:event_app/wallet/ui/widgets/shared/wallet_current_rewards_cards.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../logic/deposit/deposit_cubit.dart';
import '../../logic/deposit/deposit_state.dart';
import '../../logic/wallet/wallet_cubit.dart';
import '../widgets/deposit/add_funds_form.dart';
import '../widgets/shared/wallet_header.dart';

class AddFundsScreen extends StatefulWidget {
  const AddFundsScreen({super.key});

  @override
  State<AddFundsScreen> createState() => _AddFundsScreenState();
}

class _AddFundsScreenState extends State<AddFundsScreen> {
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _couponController = TextEditingController();
  final List<double> _quickAmounts = [100, 200, 500, 1000];

  @override
  void initState() {
    super.initState();
    context.read<DepositCubit>().loadDepositMethods();
  }

  @override
  void dispose() {
    _amountController.dispose();
    _couponController.dispose();
    super.dispose();
  }

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
            const WalletCurrentRewardsCards(
              currentBalance: 1500,
              rewards: 75,
              currency: 'AED',
            ),
            Expanded(
              child: BlocConsumer<DepositCubit, DepositState>(
                listener: _handleDepositStateChange,
                builder: (context, state) => AddFundsForm(
                  state: state,
                  amountController: _amountController,
                  couponController: _couponController,
                  quickAmounts: _quickAmounts,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleDepositStateChange(BuildContext context, DepositState state) {
    if (state is DepositSuccess) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Successfully added ${state.amount} AED to your wallet'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context);
      context.read<WalletCubit>().refreshWallet();
    } else if (state is DepositError) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(state.message),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
