// Individual Rejection History Item Widget
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../models/rejection_history_model.dart';

class RejectionHistoryTile extends StatelessWidget {
  final RejectionHistoryModel item;

  const RejectionHistoryTile({super.key, required this.item});

  String _formatDate(DateTime? dateTime) {
    if (dateTime == null) return 'N/A';

    try {
      return DateFormat('M/d/yyyy, h:mm:ss a').format(dateTime);
    } catch (e) {
      return dateTime
          .toString(); // Return original string representation if formatting fails
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header row with rejected by and status
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: RichText(
                  text: TextSpan(
                    style: DefaultTextStyle.of(context).style,
                    children: const [
                      TextSpan(
                        text: 'Rejected by: ',
                        style: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      TextSpan(
                        text: 'Unknown',
                        style: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: item.submissionStatus.toLowerCase() == 'submitted'
                      ? Colors.green[100]
                      : Colors.grey[100],
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  item.submissionStatus,
                  style: TextStyle(
                    color: item.submissionStatus.toLowerCase() == 'submitted'
                        ? Colors.green[700]
                        : Colors.grey[600],
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Date
          RichText(
            text: TextSpan(
              style: DefaultTextStyle.of(context).style,
              children: [
                TextStyle(
                  color: Colors.grey[600],
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ).toTextSpan('Date: '),
                TextSpan(
                  text: _formatDate(item.createdAt),
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          // Reason with label
          RichText(
            text: TextSpan(
              style: DefaultTextStyle.of(context).style,
              children: [
                const TextSpan(
                  text: 'Reason: ',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                TextSpan(
                  text: item.reason,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Extension to help with TextStyle to TextSpan conversion
extension TextStyleExtension on TextStyle {
  TextSpan toTextSpan(String text) {
    return TextSpan(text: text, style: this);
  }
}
