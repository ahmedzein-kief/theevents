import 'package:equatable/equatable.dart';

enum NotificationType { redeem, giftCardRedeem, purchase, deposit, recharge, refundCredit, adminAdjustment }

class NotificationModel extends Equatable {
  final String id;
  final String? title;
  final String message;
  final NotificationType type;
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
    final data = json['data'] != null ? NotificationData.fromJson(json['data']) : null;

    return NotificationModel(
      id: json['id']?.toString() ?? '',
      title: json['title'],
      message: json['message'] ?? '',
      type: _parseNotificationType(json['color'] ?? data?.type ?? json['type']),
      createdAt: _parseDateTime(json['created_at']),
      isRead: json['is_read'] ?? false,
      actionUrl: json['action_url'],
      icon: json['icon'],
      color: json['color'],
      data: data,
      readAt: json['read_at'] != null ? _parseDateTime(json['read_at']) : null,
      createdAtFormatted: json['created_at_formatted'],
      expiresAt: json['expires_at'] != null ? _parseDateTime(json['expires_at']) : null,
      notificationType: json['type'],
    );
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

  static NotificationType _parseNotificationType(dynamic typeValue) {
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

  static DateTime _parseDateTime(dynamic dateValue) {
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
    return NotificationData(
      transactionId: json['transaction_id'],
      type: json['type'],
      direction: json['direction'],
      amount: json['amount'],
      currency: json['currency'],
      runningBalance: json['running_balance'],
      message: json['message'],
      actionUrl: json['action_url'],
      icon: json['icon'],
      color: json['color'],
      timestamp: json['timestamp'] != null ? DateTime.parse(json['timestamp']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'transaction_id': transactionId,
      'type': type,
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
    return NotificationResponse(
      success: json['success'] ?? false,
      notifications: (json['data'] as List? ?? []).map((item) => NotificationModel.fromJson(item)).toList(),
      meta: NotificationMeta.fromJson(json['meta'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'data': notifications.map((n) => n.toJson()).toList(),
      'meta': meta.toJson(),
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
