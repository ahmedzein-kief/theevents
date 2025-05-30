import 'dart:convert';

CustomerReviewsDataResponse customerReviewsDataResponseFromJson(String str) => CustomerReviewsDataResponse.fromJson(json.decode(str));

class CustomerReviewsDataResponse {
  CustomerReviewsDataResponse({
    required this.data,
    required this.error,
    required this.message,
  });

  Data? data;
  bool error;
  String? message;

  factory CustomerReviewsDataResponse.fromJson(Map<dynamic, dynamic> json) => CustomerReviewsDataResponse(
        data: json["data"] != null ? Data.fromJson(json["data"]) : null,
        error: json["error"],
        message: json["message"],
      );
}

class Data {
  Data({
    required this.pagination,
    required this.star,
    required this.records,
    required this.productName,
  });

  Pagination pagination;
  int star;
  List<CustomerReviewRecord> records;
  String productName;

  factory Data.fromJson(Map<dynamic, dynamic> json) => Data(
        pagination: Pagination.fromJson(json["pagination"]),
        star: json["star"],
        records: List<CustomerReviewRecord>.from(json["records"].map((x) => CustomerReviewRecord.fromJson(x))),
        productName: json["product_name"],
      );
}

class Pagination {
  Pagination({
    required this.perPage,
    required this.total,
    required this.lastPage,
    required this.currentPage,
  });

  int perPage;
  int total;
  int lastPage;
  int currentPage;

  factory Pagination.fromJson(Map<dynamic, dynamic> json) => Pagination(
        perPage: json["per_page"],
        total: json["total"],
        lastPage: json["last_page"],
        currentPage: json["current_page"],
      );
}

class CustomerReviewRecord {
  CustomerReviewRecord({
    required this.images,
    required this.avatarUrl,
    required this.star,
    required this.name,
    required this.isApproved,
    required this.createdAt,
    required this.createdAtDiffer,
    required this.comment,
    required this.customerId,
    required this.reply,
    required this.orderCreatedAt,
  });

  List<dynamic> images;
  String avatarUrl;
  int star;
  String name;
  bool isApproved;
  DateTime createdAt;
  String createdAtDiffer;
  String comment;
  int customerId;
  List<dynamic> reply;
  String orderCreatedAt;

  factory CustomerReviewRecord.fromJson(Map<dynamic, dynamic> json) => CustomerReviewRecord(
        images: List<dynamic>.from(json["images"].map((x) => x)),
        avatarUrl: json["avatar_url"],
        star: json["star"],
        name: json["name"],
        isApproved: json["is_approved"],
        createdAt: DateTime.parse(json["created_at"]),
        createdAtDiffer: json["created_at_differ"],
        comment: json["comment"],
        customerId: json["customer_id"],
        reply: List<dynamic>.from(json["reply"].map((x) => x)),
        orderCreatedAt: json["order_created_at"],
      );
}
