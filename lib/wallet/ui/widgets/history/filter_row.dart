import 'package:event_app/core/helper/extensions/app_localizations_extension.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/helper/enums/enums.dart';

class FilterRow extends StatelessWidget {
  final TransactionTypeFilter selectedType;
  final MethodFilter selectedMethod;
  final PeriodFilter selectedPeriod;

  final ValueChanged<TransactionTypeFilter> onTypeChanged;
  final ValueChanged<MethodFilter> onMethodChanged;
  final ValueChanged<PeriodFilter> onPeriodChanged;
  final VoidCallback onReset;

  const FilterRow({
    super.key,
    required this.selectedType,
    required this.selectedMethod,
    required this.selectedPeriod,
    required this.onTypeChanged,
    required this.onMethodChanged,
    required this.onPeriodChanged,
    required this.onReset,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        Expanded(
          child: _buildDropdown<TransactionTypeFilter>(
            context,
            value: selectedType,
            items: TransactionTypeFilter.values,
            labelBuilder: (val) => _typeLabel(val),
            onChanged: onTypeChanged,
          ),
        ),
        const SizedBox(width: 6),
        Expanded(
          child: _buildDropdown<MethodFilter>(
            context,
            value: selectedMethod,
            items: MethodFilter.values,
            labelBuilder: (val) => _methodLabel(val),
            onChanged: onMethodChanged,
          ),
        ),
        const SizedBox(width: 6),
        Expanded(
          child: _buildDropdown<PeriodFilter>(
            context,
            value: selectedPeriod,
            items: PeriodFilter.values,
            labelBuilder: (val) => _periodLabel(val),
            onChanged: onPeriodChanged,
          ),
        ),
        const SizedBox(width: 6),
        SizedBox(
          height: 32,
          child: ElevatedButton(
            onPressed: onReset,
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.zero,
              backgroundColor: theme.primaryColor,
              foregroundColor: theme.colorScheme.onPrimary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6),
              ),
            ),
            child: Text('reset'.tr),
          ),
        ),
      ],
    );
  }

  // Generic dropdown builder
  Widget _buildDropdown<T>(
    BuildContext context, {
    required T value,
    required List<T> items,
    required String Function(T) labelBuilder,
    required ValueChanged<T> onChanged,
  }) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      height: 32,
      decoration: BoxDecoration(
        color: theme.cardColor,
        border: Border.all(
          color: isDark ? Colors.grey[700]! : const Color(0xFFF5F5F5),
        ),
        borderRadius: BorderRadius.circular(3),
      ),
      child: DropdownButton<T>(
        value: value,
        padding: const EdgeInsets.symmetric(horizontal: 3),
        items: items.map((item) => DropdownMenuItem<T>(value: item, child: Text(labelBuilder(item)))).toList(),
        onChanged: (val) {
          if (val != null) onChanged(val);
        },
        underline: const SizedBox.shrink(),
        isExpanded: true,
        icon: Icon(Icons.keyboard_arrow_down, color: theme.iconTheme.color),
        dropdownColor: theme.cardColor,
        style: GoogleFonts.openSans(
          fontSize: 11,
          color: theme.textTheme.bodyMedium?.color,
        ),
      ),
    );
  }

  // 🔹 Label helpers
  String _typeLabel(TransactionTypeFilter type) {
    switch (type) {
      case TransactionTypeFilter.all:
        return 'allTypes'.tr;
      case TransactionTypeFilter.deposit:
        return 'deposit'.tr;
      case TransactionTypeFilter.payment:
        return 'payment'.tr;
      case TransactionTypeFilter.reward:
        return 'reward'.tr;
      case TransactionTypeFilter.refund:
        return 'refund'.tr;
    }
  }

  String _methodLabel(MethodFilter method) {
    switch (method) {
      case MethodFilter.all:
        return 'allMethods'.tr;
      case MethodFilter.creditCard:
        return 'creditCard'.tr;
      case MethodFilter.giftCard:
        return 'GiftCard'.tr;
      case MethodFilter.bankTransfer:
        return 'bankTransfer'.tr;
    }
  }

  String _periodLabel(PeriodFilter period) {
    switch (period) {
      case PeriodFilter.days7:
        return '7Days'.tr;
      case PeriodFilter.days30:
        return '30Days'.tr;
      case PeriodFilter.days90:
        return '90Days'.tr;
      case PeriodFilter.currentMonth:
        return 'currentMonth'.tr;
      case PeriodFilter.lastMonth:
        return 'lastMonth'.tr;
      case PeriodFilter.currentYear:
        return 'currentYear'.tr;
      case PeriodFilter.lastYear:
        return 'lastYear'.tr;
      case PeriodFilter.allTime:
        return 'allTime'.tr;
    }
  }
}
