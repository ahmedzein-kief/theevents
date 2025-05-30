import 'dart:convert';

ReviewsDataResponse reviewsDataResponseFromJson(String str) => ReviewsDataResponse.fromJson(json.decode(str));

class ReviewsDataResponse {
  ReviewsDataResponse({
    required this.data,
    required this.error,
  });

  Data? data;
  bool error;

  factory ReviewsDataResponse.fromJson(Map<dynamic, dynamic> json) => ReviewsDataResponse(
        data: Data.fromJson(json["data"]),
        error: json["error"],
      );
}

class Data {
  Data({
    required this.pagination,
    required this.records,
  });

  Pagination? pagination;
  List<ReviewRecord> records;

  factory Data.fromJson(Map<dynamic, dynamic> json) => Data(
        pagination: Pagination.fromJson(json["pagination"]),
        records: List<ReviewRecord>.from(json["records"].map((x) => ReviewRecord.fromJson(x))),
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

class ReviewRecord {
  ReviewRecord({
    required this.images,
    required this.star,
    required this.productId,
    required this.createdAt,
    required this.comment,
    required this.id,
    required this.customerName,
    required this.customerId,
    required this.productName,
  });

  List<dynamic> images;
  int star;
  int productId;
  DateTime createdAt;
  String comment;
  int id;
  String customerName;
  int customerId;
  String productName;

  factory ReviewRecord.fromJson(Map<dynamic, dynamic> json) => ReviewRecord(
        images: List<dynamic>.from(json["images"].map((x) => x)),
        star: json["star"],
        productId: json["product_id"],
        createdAt: DateTime.parse(json["created_at"]),
        comment: json["comment"],
        id: json["id"],
        customerName: json["customer_name"],
        customerId: json["customer_id"],
        productName: json["product_name"],
      );
}
