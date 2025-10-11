import 'dart:developer';

import 'package:equatable/equatable.dart';

enum NotificationType { redeem, giftCardRedeem, purchase, deposit, recharge, refundCredit, adminAdjustment }

enum NotificationCategory { transaction, expiryReminder, promotional, security, system, achievements }

class NotificationModel extends Equatable {
  final String id;
  final String? title;
  final String message;
  final NotificationType type;
  final NotificationCategory category;
  final DateTime createdAt;
  final bool isRead;
  final String? actionUrl;
  final String? icon;
  final String? color;
  final NotificationData? data;
  final DateTime? readAt;
  final String? createdAtFormatted;
  final DateTime? expiresAt;
  final String? notificationType; // The full class name from API

  const NotificationModel({
    required this.id,
    this.title,
    required this.message,
    required this.type,
    this.category = NotificationCategory.transaction,
    required this.createdAt,
    this.isRead = false,
    this.actionUrl,
    this.icon,
    this.color,
    this.data,
    this.readAt,
    this.createdAtFormatted,
    this.expiresAt,
    this.notificationType,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    try {
      // Parse data object if it exists
      final data =
          json['data'] != null && json['data'] is Map<String, dynamic> ? NotificationData.fromJson(json['data']) : null;

      // Extract type information - try different sources
      final String? typeValue = json['color'] ?? data?.type ?? json['type'];

      // Extract category - default to transaction if not found
      final String? categoryValue = json['category'] ?? data?.category ?? 'transaction';

      return NotificationModel(
        id: json['id']?.toString() ?? '',
        title: json['title'],
        // Can be null as seen in the API response
        message: json['message']?.toString() ?? '',
        type: _parseNotificationType(typeValue),
        category: _parseNotificationCategory(categoryValue),
        createdAt: _parseDateTime(json['created_at']),
        isRead: json['is_read'] == true,
        // Handle boolean conversion safely
        actionUrl: json['action_url']?.toString(),
        icon: json['icon']?.toString(),
        color: json['color']?.toString(),
        data: data,
        readAt: json['read_at'] != null ? _parseDateTime(json['read_at']) : null,
        createdAtFormatted: json['created_at_formatted']?.toString(),
        expiresAt: json['expires_at'] != null ? _parseDateTime(json['expires_at']) : null,
        notificationType: json['type']?.toString(),
      );
    } catch (e) {
      // Log the error and return a default notification
      log('Error parsing NotificationModel: $e');
      return NotificationModel(
        id: json['id']?.toString() ?? DateTime.now().millisecondsSinceEpoch.toString(),
        title: 'Error parsing notification',
        message: json['message']?.toString() ?? 'Unknown notification',
        type: NotificationType.deposit,
        category: NotificationCategory.transaction,
        createdAt: DateTime.now(),
        isRead: false,
      );
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'message': message,
      'type': notificationType,
      'created_at': createdAt.toIso8601String(),
      'is_read': isRead,
      'action_url': actionUrl,
      'icon': icon,
      'color': color,
      'data': data?.toJson(),
      'read_at': readAt?.toIso8601String(),
      'created_at_formatted': createdAtFormatted,
      'expires_at': expiresAt?.toIso8601String(),
    };
  }

  String get displayName {
    switch (type) {
      case NotificationType.redeem:
        return 'Redeem';
      case NotificationType.giftCardRedeem:
        return 'Gift Card Redeem';
      case NotificationType.purchase:
        return 'Purchase';
      case NotificationType.deposit:
        return 'Deposit';
      case NotificationType.recharge:
        return 'Recharge';
      case NotificationType.refundCredit:
        return 'Refund Credit';
      case NotificationType.adminAdjustment:
        return 'Admin Adjustment';
    }
  }

  bool get isPositive {
    switch (type) {
      case NotificationType.redeem:
      case NotificationType.giftCardRedeem:
      case NotificationType.deposit:
      case NotificationType.recharge:
      case NotificationType.refundCredit:
        return true;
      case NotificationType.purchase:
      case NotificationType.adminAdjustment:
        return false;
    }
  }

  bool get isUnread => !isRead;

  static NotificationType _parseNotificationType(typeValue) {
    if (typeValue == null) return NotificationType.deposit;

    final typeString = typeValue.toString().toLowerCase();
    switch (typeString) {
      case 'redeem':
        return NotificationType.redeem;
      case 'gift_card_redeem':
      case 'gift_card':
      case 'giftcard':
        return NotificationType.giftCardRedeem;
      case 'purchase':
        return NotificationType.purchase;
      case 'deposit':
        return NotificationType.deposit;
      case 'recharge':
        return NotificationType.recharge;
      case 'refund_credit':
      case 'refund':
        return NotificationType.refundCredit;
      case 'admin_adjustment':
      case 'admin':
        return NotificationType.adminAdjustment;
      default:
        return NotificationType.deposit; // Default fallback
    }
  }

  static NotificationCategory _parseNotificationCategory(categoryValue) {
    if (categoryValue == null) return NotificationCategory.transaction;
    final categoryString = categoryValue.toString().toLowerCase();
    switch (categoryString) {
      case 'transaction':
        return NotificationCategory.transaction;
      case 'expiry_reminder':
        return NotificationCategory.expiryReminder;
      case 'promotional':
        return NotificationCategory.promotional;
      case 'security':
        return NotificationCategory.security;
      case 'system':
        return NotificationCategory.system;
      case 'achievements':
        return NotificationCategory.achievements;
      default:
        return NotificationCategory.transaction;
    }
  }

  static DateTime _parseDateTime(dateValue) {
    if (dateValue == null) return DateTime.now();

    if (dateValue is DateTime) {
      return dateValue;
    }

    if (dateValue is String) {
      try {
        return DateTime.parse(dateValue);
      } catch (e) {
        try {
          final timestamp = int.tryParse(dateValue);
          if (timestamp != null) {
            return DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
          }
        } catch (e) {
          // Ignore and fall through
        }
        return DateTime.now();
      }
    }

    if (dateValue is int) {
      final timestamp = dateValue;
      if (timestamp > 1000000000000) {
        return DateTime.fromMillisecondsSinceEpoch(timestamp);
      } else {
        return DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
      }
    }

    return DateTime.now();
  }

  @override
  List<Object?> get props => [
        id,
        title,
        message,
        type,
        createdAt,
        isRead,
        actionUrl,
        icon,
        color,
        data,
        readAt,
        createdAtFormatted,
        expiresAt,
        notificationType,
      ];

  @override
  String toString() {
    return 'NotificationModel(id: $id, title: $title, message: $message, type: $type, createdAt: $createdAt, isRead: $isRead)';
  }

  NotificationModel copyWith({
    String? id,
    String? title,
    String? message,
    NotificationType? type,
    DateTime? createdAt,
    bool? isRead,
    String? actionUrl,
    String? icon,
    String? color,
    NotificationData? data,
    DateTime? readAt,
    String? createdAtFormatted,
    DateTime? expiresAt,
    String? notificationType,
  }) {
    return NotificationModel(
      id: id ?? this.id,
      title: title ?? this.title,
      message: message ?? this.message,
      type: type ?? this.type,
      createdAt: createdAt ?? this.createdAt,
      isRead: isRead ?? this.isRead,
      actionUrl: actionUrl ?? this.actionUrl,
      icon: icon ?? this.icon,
      color: color ?? this.color,
      data: data ?? this.data,
      readAt: readAt ?? this.readAt,
      createdAtFormatted: createdAtFormatted ?? this.createdAtFormatted,
      expiresAt: expiresAt ?? this.expiresAt,
      notificationType: notificationType ?? this.notificationType,
    );
  }
}

class NotificationData extends Equatable {
  final int? transactionId;
  final String? type;
  final String? category;
  final String? direction;
  final String? amount;
  final String? currency;
  final String? runningBalance;
  final String? message;
  final String? actionUrl;
  final String? icon;
  final String? color;
  final DateTime? timestamp;

  const NotificationData({
    this.transactionId,
    this.type,
    this.category,
    this.direction,
    this.amount,
    this.currency,
    this.runningBalance,
    this.message,
    this.actionUrl,
    this.icon,
    this.color,
    this.timestamp,
  });

  factory NotificationData.fromJson(Map<String, dynamic> json) {
    try {
      return NotificationData(
        transactionId: json['transaction_id'] is int
            ? json['transaction_id']
            : int.tryParse(json['transaction_id']?.toString() ?? ''),
        type: json['type']?.toString(),
        category: json['category']?.toString(),
        direction: json['direction']?.toString(),
        amount: json['amount']?.toString(),
        currency: json['currency']?.toString(),
        runningBalance: json['running_balance']?.toString(),
        message: json['message']?.toString(),
        actionUrl: json['action_url']?.toString(),
        icon: json['icon']?.toString(),
        color: json['color']?.toString(),
        timestamp: json['timestamp'] != null ? _parseDateTime(json['timestamp']) : null,
      );
    } catch (e) {
      log('Error parsing NotificationData: $e');
      return const NotificationData();
    }
  }

  static DateTime? _parseDateTime(dateValue) {
    if (dateValue == null) return null;

    if (dateValue is DateTime) return dateValue;

    if (dateValue is String) {
      try {
        return DateTime.parse(dateValue);
      } catch (e) {
        log('Error parsing DateTime from string: $dateValue');
        return null;
      }
    }

    return null;
  }

  Map<String, dynamic> toJson() {
    return {
      'transaction_id': transactionId,
      'type': type,
      'category': category,
      'direction': direction,
      'amount': amount,
      'currency': currency,
      'running_balance': runningBalance,
      'message': message,
      'action_url': actionUrl,
      'icon': icon,
      'color': color,
      'timestamp': timestamp?.toIso8601String(),
    };
  }

  @override
  List<Object?> get props => [
        transactionId,
        type,
        category,
        direction,
        amount,
        currency,
        runningBalance,
        message,
        actionUrl,
        icon,
        color,
        timestamp,
      ];
}

class NotificationResponse {
  final bool success;
  final List<NotificationModel> notifications;
  final NotificationMeta meta;

  const NotificationResponse({
    required this.success,
    required this.notifications,
    required this.meta,
  });

  factory NotificationResponse.fromJson(Map<String, dynamic> json) {
    // Handle the case where data can be either a List or Map
    final dynamic dataObj = json['data'];

    List<NotificationModel> notifications = [];
    NotificationMeta meta;

    if (dataObj is List) {
      // When data is an empty list or list of notifications
      notifications = dataObj.map((item) => NotificationModel.fromJson(item as Map<String, dynamic>)).toList();

      // Get meta from root level
      final metaObj = json['meta'] as Map<String, dynamic>? ?? {};
      meta = NotificationMeta(
        currentPage: metaObj['current_page'] ?? 1,
        perPage: metaObj['per_page'] ?? 15,
        total: metaObj['total'] ?? 0,
        lastPage: metaObj['last_page'] ?? 1,
        unreadCount: metaObj['unread_count'] ?? notifications.where((n) => !n.isRead).length,
        totalCount: metaObj['total_count'] ?? 0,
      );
    } else if (dataObj is Map<String, dynamic>) {
      // When data is a map with nested data array
      final notificationsData = dataObj['data'] as List? ?? [];
      notifications =
          notificationsData.map((item) => NotificationModel.fromJson(item as Map<String, dynamic>)).toList();

      meta = NotificationMeta(
        currentPage: dataObj['current_page'] ?? 1,
        perPage: dataObj['per_page'] ?? 15,
        total: dataObj['total'] ?? 0,
        lastPage: dataObj['last_page'] ?? 1,
        unreadCount: notifications.where((n) => !n.isRead).length,
        totalCount: dataObj['total'] ?? 0,
      );
    } else {
      // Fallback for unexpected structure
      final metaObj = json['meta'] as Map<String, dynamic>? ?? {};
      meta = NotificationMeta(
        currentPage: metaObj['current_page'] ?? 1,
        perPage: metaObj['per_page'] ?? 15,
        total: metaObj['total'] ?? 0,
        lastPage: metaObj['last_page'] ?? 1,
        unreadCount: metaObj['unread_count'] ?? 0,
        totalCount: metaObj['total_count'] ?? 0,
      );
    }

    return NotificationResponse(
      success: json['success'] ?? false,
      notifications: notifications,
      meta: meta,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': success, // Match API response structure
      'data': {
        'data': notifications.map((n) => n.toJson()).toList(),
        'current_page': meta.currentPage,
        'per_page': meta.perPage,
        'total': meta.total,
        'last_page': meta.lastPage,
      },
    };
  }
}

class NotificationMeta extends Equatable {
  final int currentPage;
  final int perPage;
  final int total;
  final int lastPage;
  final int unreadCount;
  final int totalCount;

  const NotificationMeta({
    required this.currentPage,
    required this.perPage,
    required this.total,
    required this.lastPage,
    required this.unreadCount,
    required this.totalCount,
  });

  factory NotificationMeta.fromJson(Map<String, dynamic> json) {
    return NotificationMeta(
      currentPage: json['current_page'] ?? 1,
      perPage: json['per_page'] ?? 15,
      total: json['total'] ?? 0,
      lastPage: json['last_page'] ?? 1,
      unreadCount: json['unread_count'] ?? 0,
      totalCount: json['total_count'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'current_page': currentPage,
      'per_page': perPage,
      'total': total,
      'last_page': lastPage,
      'unread_count': unreadCount,
      'total_count': totalCount,
    };
  }

  @override
  List<Object?> get props => [
        currentPage,
        perPage,
        total,
        lastPage,
        unreadCount,
        totalCount,
      ];
}
