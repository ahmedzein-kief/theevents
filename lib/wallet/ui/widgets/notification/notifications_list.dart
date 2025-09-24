import 'package:flutter/material.dart';

import '../../../../core/widgets/loading_indicator.dart';
import '../../../data/model/notification_model.dart';
import 'notification_item.dart';

class NotificationsList extends StatefulWidget {
  final List<NotificationModel> notifications;
  final NotificationMeta meta;
  final VoidCallback onLoadMore;
  final Function(String) onMarkAsRead;
  final Function(String) onMarkAsUnread;
  final Function(String) onDelete;

  const NotificationsList({
    super.key,
    required this.notifications,
    required this.meta,
    required this.onLoadMore,
    required this.onMarkAsRead,
    required this.onMarkAsUnread,
    required this.onDelete,
  });

  @override
  State<NotificationsList> createState() => _NotificationsListState();
}

class _NotificationsListState extends State<NotificationsList> {
  final ScrollController _scrollController = ScrollController();
  bool _isLoadingMore = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
      if (!_isLoadingMore && widget.meta.currentPage < widget.meta.lastPage) {
        _loadMore();
      }
    }
  }

  void _loadMore() {
    setState(() {
      _isLoadingMore = true;
    });
    widget.onLoadMore();
    // Reset loading state after a delay
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _isLoadingMore = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            controller: _scrollController,
            itemCount: widget.notifications.length + (_isLoadingMore ? 1 : 0),
            itemBuilder: (context, index) {
              if (index >= widget.notifications.length) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: LoadingIndicator(),
                  ),
                );
              }

              final notification = widget.notifications[index];
              return NotificationItem(
                notification: notification,
                onMarkAsRead: widget.onMarkAsRead,
                onMarkAsUnread: widget.onMarkAsUnread,
                onDelete: widget.onDelete,
              );
            },
          ),
        ),

        // Pagination info
        if (widget.meta.total > widget.notifications.length)
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Showing ${widget.notifications.length} of ${widget.meta.total} notifications',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).textTheme.bodySmall?.color?.withOpacity(0.6),
                  ),
            ),
          ),
      ],
    );
  }
}
