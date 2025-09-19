// deposit_methods_list.dart
import 'package:event_app/core/constants/app_strings.dart';
import 'package:event_app/core/helper/extensions/app_localizations_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../data/model/deposit_method.dart';
import '../../../logic/deposit/deposit_cubit.dart';
import 'deposit_method_card.dart';

class DepositMethodsList extends StatelessWidget {
  final List<DepositMethod> methods;
  final DepositMethodType? selectedMethod;

  const DepositMethodsList({
    super.key,
    required this.methods,
    required this.selectedMethod,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppStrings.selectDepositMethod.tr,
          style: GoogleFonts.openSans(
            fontSize: 14,
            color: theme.textTheme.titleMedium?.color,
          ),
        ),
        const SizedBox(height: 16),
        ...methods.map((method) {
          return DepositMethodCard(
            method: method,
            isSelected: selectedMethod == method.type,
            onTap: () => context.read<DepositCubit>().selectDepositMethod(method.type),
          );
        }),
      ],
    );
  }
}
