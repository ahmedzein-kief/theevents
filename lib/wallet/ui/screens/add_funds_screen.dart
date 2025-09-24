import 'package:event_app/views/payment_screens/payment_view_screen.dart';
import 'package:event_app/wallet/logic/drawer/drawer_cubit.dart';
import 'package:event_app/wallet/ui/widgets/shared/wallet_current_rewards_cards.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/utils/app_utils.dart';
import '../../logic/deposit/deposit_cubit.dart';
import '../../logic/deposit/deposit_state.dart';
import '../../logic/wallet/wallet_cubit.dart';
import '../../logic/wallet/wallet_state.dart';
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
        child: BlocBuilder<WalletCubit, WalletState>(
          builder: (context, walletState) {
            final expiryCount = walletState is WalletLoaded ? walletState.wallet.expiringLotsCount : 0;

            return Column(
              children: [
                WalletHeader(isDark: isDark, expiryCount: expiryCount),
                const WalletCurrentRewardsCards(),
                Expanded(
                  child: BlocConsumer<DepositCubit, DepositState>(
                    listener: _handleDepositStateChange,
                    builder: (context, depositState) => AddFundsForm(
                      state: depositState,
                      amountController: _amountController,
                      couponController: _couponController,
                      quickAmounts: _quickAmounts,
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  void _handleDepositStateChange(BuildContext context, DepositState state) {
    // Handle success states
    if (state.isSuccess) {
      if (state.isGiftCardSuccess) {
        // Gift card success
        AppUtils.showToast(
          state.successMessage ?? 'Gift card redeemed successfully!',
          isSuccess: true,
        );

        // Clear form field immediately (synchronous)
        _couponController.clear();

        // Handle async operations properly
        _handleGiftCardSuccess(context);
      } else if (state.isCreditCardSuccess) {
        // Credit card success
        _handleCreditCardSuccess(context, state);
      }
    }

    // Handle errors
    if (state.hasError) {
      AppUtils.showToast(state.errorMessage!);
    }
  }

  void _handleGiftCardSuccess(BuildContext context) {
    try {
      context.read<WalletCubit>().refreshWallet();

      context.read<DrawerCubit>().setSelectedScreen(0);
    } catch (e) {
      AppUtils.showToast('Failed to refresh wallet');
    }
  }

  Future<void> _handleCreditCardSuccess(BuildContext context, DepositState state) async {
    try {
      final result = await Navigator.of(context).push<bool>(
        MaterialPageRoute(
          builder: (context) => PaymentViewScreen(
            checkoutUrl: state.checkoutUrl!,
            paymentType: 'wallet',
          ),
        ),
      );

      // Check mounted after async navigation
      if (!context.mounted) return;

      if (result == true) {
        // Payment successful
        AppUtils.showToast(
          'Payment completed successfully!',
          isSuccess: true,
        );

        context.read<WalletCubit>().refreshWallet();
        context.read<DrawerCubit>().setSelectedScreen(0);
      } else if (result == false) {
        // Payment failed or canceled - reset the cubit state
        AppUtils.showToast('Payment was canceled or failed');

        // Reset the cubit state back to loaded so the form becomes interactive again
        context.read<DepositCubit>().resetToLoaded();
      }
      // If result is null, do nothing (user just navigated back without completing payment)
      else {
        // Also reset state for null result to ensure form remains functional
        context.read<DepositCubit>().resetToLoaded();
      }
    } catch (e) {
      AppUtils.showToast('Error processing payment');

      // Reset state on error as well
      if (context.mounted) {
        context.read<DepositCubit>().resetToLoaded();
      }
    }
  }
}
