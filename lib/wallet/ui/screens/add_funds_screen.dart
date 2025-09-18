import 'package:flutter/material.dart';
import 'package:event_app/core/helper/extensions/app_localizations_extension.dart';
import 'package:event_app/core/constants/app_strings.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/constants/app_assets.dart';
import '../../data/model/deposit_method.dart';
import '../../logic/deposit/deposit_cubit.dart';
import '../../logic/deposit/deposit_state.dart';
import '../../logic/drawer/drawer_cubit.dart';
import '../../logic/wallet/wallet_cubit.dart';
import '../widgets/deposit_method_card.dart';
import '../widgets/wallet_card.dart';

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
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(20),
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
                          AppStrings.digitalWallet.tr,
                          style: GoogleFonts.openSans(fontSize: 15),
                        ),
                        Text(
                          'Hi, Ahmed Al-Mahmoud',
                          style: GoogleFonts.openSans(
                            fontSize: 12,
                            color: const Color(0xFF4A5565),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(3),
                    ),
                    child: Text(
                      AppStrings.expirySoon.tr,
                      style: GoogleFonts.openSans(
                        fontSize: 10,
                        color: Colors.white,
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
            ),

            // Balance Cards
            Container(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
              child: Row(
                children: [
                  Expanded(
                    child: WalletCard(
                      title: AppStrings.currentBalanceTitle.tr,
                      amount: 1500.0,
                      currency: 'AED',
                      icon: Icons.account_balance_wallet_outlined,
                    ),
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: WalletCard(
                      title: AppStrings.rewardsEarnedTitle.tr,
                      amount: 75.0,
                      currency: 'AED',
                      icon: Icons.stars_outlined,
                    ),
                  ),
                ],
              ),
            ),

            // Add Funds Form
            Expanded(
              child: BlocConsumer<DepositCubit, DepositState>(
                listener: (context, state) {
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
                },
                builder: (context, state) {
                  if (state is DepositMethodsLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is DepositMethodsLoaded) {
                    return SingleChildScrollView(
                      padding: const EdgeInsets.all(20),
                      child: Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(6),
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
                            // Title
                            Row(
                              children: [
                                const Icon(Icons.account_balance_wallet, size: 24),
                                const SizedBox(width: 12),
                                Text(
                                  AppStrings.addFundsToWallet.tr,
                                  style: GoogleFonts.openSans(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 24),

                            // Deposit Methods
                            Text(
                              AppStrings.selectDepositMethod.tr,
                              style: GoogleFonts.openSans(
                                fontSize: 14,
                                color: const Color(0xFF101828),
                              ),
                            ),
                            const SizedBox(height: 16),

                            ...state.methods.map((method) {
                              return DepositMethodCard(
                                method: method,
                                isSelected: state.selectedMethod == method.type,
                                onTap: () => context.read<DepositCubit>().selectDepositMethod(method.type),
                              );
                            }),

                            const SizedBox(height: 24),

                            // Coupon Code (only for Gift Card)
                            if (state.selectedMethod == DepositMethodType.giftCard) ...[
                              Text(
                                AppStrings.couponCodeGiftCard.tr,
                                style: GoogleFonts.openSans(
                                  fontSize: 14,
                                  color: const Color(0xFF101828),
                                ),
                              ),
                              const SizedBox(height: 12),
                              TextField(
                                controller: _couponController,
                                decoration: InputDecoration(
                                  hintText: 'Enter your coupon code',
                                  hintStyle: GoogleFonts.openSans(
                                    fontSize: 12,
                                    color: Colors.grey,
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5),
                                    borderSide: BorderSide(color: Colors.grey[300]!),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5),
                                    borderSide: BorderSide(color: Colors.grey[300]!),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5),
                                    borderSide: const BorderSide(color: Colors.black),
                                  ),
                                ),
                                onChanged: (value) => context.read<DepositCubit>().updateCouponCode(value),
                              ),
                              const SizedBox(height: 24),
                            ],

                            // Amount (only for Credit Card)
                            if (state.selectedMethod == DepositMethodType.creditCard) ...[
                              Text(
                                AppStrings.amountAed.tr,
                                style: GoogleFonts.openSans(
                                  fontSize: 14,
                                  color: const Color(0xFF101828),
                                ),
                              ),
                              const SizedBox(height: 12),
                              TextField(
                                controller: _amountController,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  hintText: 'AED 100.00',
                                  hintStyle: GoogleFonts.openSans(
                                    fontSize: 12,
                                    color: Colors.grey,
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5),
                                    borderSide: BorderSide(color: Colors.grey[300]!),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5),
                                    borderSide: BorderSide(color: Colors.grey[300]!),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5),
                                    borderSide: const BorderSide(color: Colors.black),
                                  ),
                                ),
                                onChanged: (value) {
                                  final amount = double.tryParse(value) ?? 0.0;
                                  context.read<DepositCubit>().updateAmount(amount);
                                },
                              ),
                              const SizedBox(height: 16),

                              // Quick Amount Buttons
                              Wrap(
                                spacing: 12,
                                runSpacing: 8,
                                children: _quickAmounts.map((amount) {
                                  return GestureDetector(
                                    onTap: () {
                                      _amountController.text = amount.toString();
                                      context.read<DepositCubit>().updateAmount(amount);
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                                      decoration: BoxDecoration(
                                        color: state.amount == amount ? Colors.black : Colors.grey[200],
                                        borderRadius: BorderRadius.circular(3),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          SvgPicture.asset(
                                            AppAssets.dirham,
                                            width: 10,
                                            height: 10,
                                            colorFilter: state.amount == amount
                                                ? const ColorFilter.mode(
                                                    Colors.white,
                                                    BlendMode.srcIn,
                                                  )
                                                : const ColorFilter.mode(
                                                    Colors.black,
                                                    BlendMode.srcIn,
                                                  ),
                                          ),
                                          const SizedBox(width: 3),
                                          Text(
                                            '${amount.toInt()}',
                                            style: GoogleFonts.openSans(
                                              fontSize: 14,
                                              color: state.amount == amount ? Colors.white : Colors.black,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                              const SizedBox(height: 32),
                            ],

                            // Continue Button
                            SizedBox(
                              height: 48,
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: state is DepositProcessing
                                    ? null
                                    : () {
                                        context.read<DepositCubit>().processDeposit();
                                      },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.black,
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(3),
                                  ),
                                ),
                                child: state is DepositProcessing
                                    ? const SizedBox(
                                        height: 20,
                                        width: 20,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                        ),
                                      )
                                    : Text(
                                        AppStrings.continueToPayment.tr,
                                        style: GoogleFonts.openSans(
                                          fontSize: 16,
                                          color: Colors.white,
                                        ),
                                      ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  } else if (state is DepositError) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Error: ${state.message}'),
                          ElevatedButton(
                            onPressed: () => context.read<DepositCubit>().loadDepositMethods(),
                            child: const Text('Retry'),
                          ),
                        ],
                      ),
                    );
                  }
                  return const SizedBox();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
