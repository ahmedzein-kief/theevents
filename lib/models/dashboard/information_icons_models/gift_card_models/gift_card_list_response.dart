class GiftCardListResponse {
  final bool error;
  final GiftCardListData? data;
  final String? message;

  GiftCardListResponse({
    required this.error,
    this.data,
    this.message,
  });

  factory GiftCardListResponse.fromJson(Map<String, dynamic> json) {
    return GiftCardListResponse(
      error: json['error'] ?? false,
      data: json['data'] != null ? GiftCardListData.fromJson(json['data']) : null,
      message: json['message'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'error': error,
      'data': data?.toJson(),
      'message': message,
    };
  }
}

class GiftCardListData {
  final Pagination? pagination;
  final List<GiftCardItem>? records;

  GiftCardListData({
    this.pagination,
    this.records,
  });

  factory GiftCardListData.fromJson(Map<String, dynamic> json) {
    return GiftCardListData(
      pagination: json['pagination'] != null ? Pagination.fromJson(json['pagination']) : null,
      records: json['records'] != null ? (json['records'] as List).map((x) => GiftCardItem.fromJson(x)).toList() : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'pagination': pagination?.toJson(),
      'records': records?.map((x) => x.toJson()).toList(),
    };
  }
}

class Pagination {
  final int? total;
  final int? lastPage;
  final int? currentPage;
  final int? perPage;

  Pagination({
    this.total,
    this.lastPage,
    this.currentPage,
    this.perPage,
  });

  factory Pagination.fromJson(Map<String, dynamic> json) {
    return Pagination(
      total: json['total'],
      lastPage: json['last_page'],
      currentPage: json['current_page'],
      perPage: json['per_page'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'total': total,
      'last_page': lastPage,
      'current_page': currentPage,
      'per_page': perPage,
    };
  }
}

class GiftCardItem {
  final int? id;
  final String? recipientName;
  final String? recipientEmail;
  final String? sku;
  final String? additionalNotes;
  final String? code;
  final int? totalUsed;
  final String? price;

  GiftCardItem({
    this.id,
    this.recipientName,
    this.recipientEmail,
    this.sku,
    this.additionalNotes,
    this.code,
    this.totalUsed,
    this.price,
  });

  factory GiftCardItem.fromJson(Map<String, dynamic> json) {
    return GiftCardItem(
      id: json['id'],
      recipientName: json['recipient_name'],
      recipientEmail: json['recipient_email'],
      sku: json['sku'],
      additionalNotes: json['additional_notes'],
      code: json['code'],
      totalUsed: json['total_used'],
      price: json['price'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'recipient_name': recipientName,
      'recipient_email': recipientEmail,
      'sku': sku,
      'additional_notes': additionalNotes,
      'code': code,
      'total_used': totalUsed,
      'price': price,
    };
  }
}
