import 'package:event_app/core/helper/extensions/app_localizations_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/widgets/loading_indicator.dart';
import '../../../logic/fund_expiry/fund_expiry_cubit.dart';
import 'fund_expiry_item.dart';

class FundExpiryList extends StatelessWidget {
  const FundExpiryList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FundExpiryCubit, FundExpiryState>(
      builder: (context, state) {
        if (state is FundExpiryLoading) {
          return const LoadingIndicator();
        }

        if (state is FundExpiryError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Error: ${state.message}'),
                ElevatedButton(
                  onPressed: () => context.read<FundExpiryCubit>().loadExpiringFunds(),
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        if (state is FundExpiryLoaded) {
          if (state.funds.isEmpty) {
            return Center(
              child: Text(AppStrings.noExpiringFundsFound.tr),
            );
          }

          return ListView.separated(
            itemCount: state.funds.length,
            separatorBuilder: (context, index) => const SizedBox(height: 16),
            itemBuilder: (context, index) {
              return FundExpiryItem(fund: state.funds[index]);
            },
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}
