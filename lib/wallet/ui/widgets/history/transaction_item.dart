import 'package:event_app/core/helper/extensions/app_localizations_extension.dart';
import 'package:event_app/core/widgets/price_row.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/utils/formatters.dart';
import '../../../data/model/transaction_model.dart';

class TransactionItem extends StatelessWidget {
  final TransactionModel transaction;

  const TransactionItem({super.key, required this.transaction});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey[200]!),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Left icon
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: _getTransactionColor().withAlpha((0.1 * 255).toInt()),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              _getTransactionIcon(),
              color: _getTransactionColor(),
              size: 16,
            ),
          ),
          const SizedBox(width: 12),

          /// Middle column (title, method, chips + balance in same row)
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// Row 1: Title
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        transaction.description,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.openSans(
                          fontSize: 14,
                          color: Theme.of(context).textTheme.bodyMedium?.color,
                        ),
                      ),
                    ),

                    /// Right column (amount + date/time)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        /// Amount
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              transaction.type == TransactionType.payment ? '-' : '+',
                              style: GoogleFonts.openSans(
                                fontSize: 13,
                                color: const Color(0xFF34C759),
                              ),
                            ),
                            PriceRow(
                              price: transaction.amount.toStringAsFixed(2),
                              currencyColor: const Color(0xFF34C759),
                              currencySize: 11,
                              style: GoogleFonts.openSans(
                                fontSize: 13,
                                color: const Color(0xFF34C759),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),

                        /// Date & Time
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              Formatters.formatDate(transaction.date),
                              style: GoogleFonts.openSans(
                                fontSize: 12,
                                color: Theme.of(context).textTheme.bodyMedium?.color,
                              ),
                            ),
                            Text(
                              Formatters.formatTime(transaction.date),
                              style: GoogleFonts.openSans(
                                fontSize: 12,
                                color: Theme.of(context).textTheme.bodyMedium?.color,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                /// Row 2: Payment Method
                Row(
                  children: [
                    Icon(
                      _getPaymentMethodIcon(),
                      size: 16,
                      color: Theme.of(context).textTheme.bodyMedium?.color,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      _getPaymentMethodText(),
                      style: GoogleFonts.openSans(
                        fontSize: 12,
                        color: Theme.of(context).textTheme.bodyMedium?.color,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                /// Row 3: Chips + Balance aligned
                Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 4,
                  runSpacing: 6,
                  children: [
                    _buildStatusChip(context),
                    _buildTransactionIdChip(context),
                    _buildBalanceChip(),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // --- Helper Widgets ---

  Widget _buildStatusChip(context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
      decoration: BoxDecoration(
        color: _getStatusColor(),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Text(
        _getStatusText(),
        style: GoogleFonts.openSans(
          fontSize: 11,
          color: const Color(0xFF101828),
        ),
      ),
    );
  }

  Widget _buildTransactionIdChip(context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
      decoration: BoxDecoration(
        color: _getStatusColor(),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Text(
        '#${transaction.id}${transaction.refId != null ? '-${transaction.refId}' : ''}',
        style: GoogleFonts.openSans(fontSize: 11, color: const Color(0xFF101828)),
      ),
    );
  }

  Widget _buildBalanceChip() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFF3A195),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            AppStrings.balanceLabel.tr,
            style: GoogleFonts.openSans(
              fontSize: 12,
              color: Colors.white,
            ),
          ),
          PriceRow(
            price: transaction.currentBalance.toStringAsFixed(2),
            currencyColor: Colors.white,
            style: GoogleFonts.openSans(
              fontSize: 12,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  // --- Helpers for icons & colors ---

  IconData _getTransactionIcon() {
    switch (transaction.type) {
      case TransactionType.deposit:
        return transaction.method == PaymentMethod.giftCard ? Icons.card_giftcard : Icons.account_balance_wallet;
      case TransactionType.payment:
        return Icons.shopping_bag_outlined;
      case TransactionType.reward:
        return Icons.star_outline;
      case TransactionType.refund:
        return Icons.refresh;
    }
  }

  Color _getTransactionColor() {
    switch (transaction.type) {
      case TransactionType.deposit:
        return Colors.green;
      case TransactionType.payment:
        return Colors.red;
      case TransactionType.reward:
        return Colors.orange;
      case TransactionType.refund:
        return Colors.blue;
    }
  }

  IconData _getPaymentMethodIcon() {
    switch (transaction.method) {
      case PaymentMethod.creditCard:
        return Icons.credit_card;
      case PaymentMethod.purchase:
        return Icons.shopping_cart;
      case PaymentMethod.giftCard:
        return Icons.card_giftcard;
      case PaymentMethod.bankTransfer:
        return Icons.account_balance;
      case PaymentMethod.other:
      case null:
        return Icons.payment;
    }
  }

  String _getPaymentMethodText() {
    switch (transaction.method) {
      case PaymentMethod.creditCard:
        return 'creditCard'.tr;
      case PaymentMethod.purchase:
        return 'purchased'.tr;
      case PaymentMethod.giftCard:
        return 'giftCard'.tr;
      case PaymentMethod.bankTransfer:
        return 'bankTransfer'.tr;
      case PaymentMethod.other:
        return 'Other'.tr;
      case null:
        return 'Unknown';
    }
  }

  Color _getStatusColor() {
    switch (transaction.status) {
      case TransactionStatus.pending:
        return Colors.orange.shade100;
      case TransactionStatus.completed:
        return const Color(0xFFF5F5F5);
      case TransactionStatus.failed:
        return Colors.red.shade100;
      case TransactionStatus.cancelled:
        return Colors.grey.shade100;
    }
  }

  String _getStatusText() {
    switch (transaction.status) {
      case TransactionStatus.pending:
        return AppStrings.pending.tr;
      case TransactionStatus.completed:
        return AppStrings.completed.tr;
      case TransactionStatus.failed:
        return AppStrings.paymentFailed.tr;
      case TransactionStatus.cancelled:
        return 'payment_cancelled'.tr;
    }
  }
}
