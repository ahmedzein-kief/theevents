import 'package:event_app/core/widgets/PriceRow.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/utils/formatters.dart';
import '../../data/model/transaction_model.dart';

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
              color: _getTransactionColor().withOpacity(0.1),
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
                          color: const Color(0xFF101828),
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
                                color: const Color(0xFF4A5565),
                              ),
                            ),
                            Text(
                              Formatters.formatTime(transaction.date),
                              style: GoogleFonts.openSans(
                                fontSize: 12,
                                color: const Color(0xFF4A5565),
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
                      color: const Color(0xFF101828),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      _getPaymentMethodText(),
                      style: GoogleFonts.openSans(
                        fontSize: 12,
                        color: const Color(0xFF101828),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                /// Row 3: Chips + Balance aligned
                Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 8,
                  runSpacing: 6,
                  children: [
                    _buildStatusChip(),
                    _buildTransactionIdChip(),
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

  Widget _buildStatusChip() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
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

  Widget _buildTransactionIdChip() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: _getStatusColor(),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Text(
        'GC01234567', // TODO: replace with actual transaction id
        style: GoogleFonts.openSans(
          fontSize: 11,
          color: const Color(0xFF101828),
        ),
      ),
    );
  }

  Widget _buildBalanceChip() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFF3A195),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Balance: ',
            style: GoogleFonts.openSans(
              fontSize: 12,
              color: Colors.white,
            ),
          ),
          PriceRow(
            price: transaction.amount.toStringAsFixed(2),
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
        if (transaction.description.contains('Gift Card')) {
          return Icons.card_giftcard;
        }
        return Icons.refresh; // Wallet recharge
      case TransactionType.payment:
        return Icons.error_outline; // Purchase
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
    if (transaction.description.contains('Gift Card')) {
      return Icons.card_giftcard;
    }
    return Icons.credit_card;
  }

  String _getPaymentMethodText() {
    if (transaction.description.contains('Gift Card')) {
      return 'Gift Card';
    }
    return 'Credit Card';
  }

  Color _getStatusColor() {
    switch (transaction.status) {
      case TransactionStatus.pending:
        return Colors.teal;
      case TransactionStatus.completed:
        return const Color(0xFFF5F5F5);
      case TransactionStatus.failed:
        return Colors.red;
      case TransactionStatus.cancelled:
        return Colors.grey;
    }
  }

  String _getStatusText() {
    switch (transaction.status) {
      case TransactionStatus.pending:
        return 'Progress';
      case TransactionStatus.completed:
        return 'Completed';
      case TransactionStatus.failed:
        return 'Failed';
      case TransactionStatus.cancelled:
        return 'Cancelled';
    }
  }
}
