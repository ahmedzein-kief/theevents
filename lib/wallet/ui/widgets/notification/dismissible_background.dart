import 'package:flutter/material.dart';

import '../../../data/model/notification_model.dart';

class DismissibleBackground extends StatelessWidget {
  final NotificationModel notification;
  final bool isLeft;

  const DismissibleBackground({
    super.key,
    required this.notification,
    required this.isLeft,
  });

  @override
  Widget build(BuildContext context) {
    if (isLeft) {
      return _buildReadToggleBackground();
    } else {
      return _buildDeleteBackground();
    }
  }

  Widget _buildReadToggleBackground() {
    final isMarkingAsRead = !notification.isRead;

    return Container(
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: isMarkingAsRead ? Colors.blue : Colors.orange,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isMarkingAsRead ? Icons.mark_email_read : Icons.mark_email_unread,
            color: Colors.white,
          ),
          const SizedBox(width: 8),
          Text(
            isMarkingAsRead ? 'Mark as Read' : 'Mark as Unread',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDeleteBackground() {
    return Container(
      alignment: Alignment.centerRight,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.red,
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Delete',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(width: 8),
          Icon(
            Icons.delete,
            color: Colors.white,
          ),
        ],
      ),
    );
  }
}
