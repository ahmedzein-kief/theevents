import 'dart:convert';

RevenueDataResponse revenueDataResponseFromJson(String str) =>
    RevenueDataResponse.fromJson(json.decode(str));

class RevenueDataResponse {
  RevenueDataResponse({
    required this.data,
    required this.error,
  });

  factory RevenueDataResponse.fromJson(Map<dynamic, dynamic> json) =>
      RevenueDataResponse(
        data: Data.fromJson(json['data']),
        error: json['error'],
      );

  Data? data;
  bool error;
}

class Data {
  Data({
    required this.pagination,
    required this.records,
  });

  factory Data.fromJson(Map<dynamic, dynamic> json) => Data(
        pagination: Pagination.fromJson(json['pagination']),
        records: List<RevenueRecord>.from(
            json['records'].map((x) => RevenueRecord.fromJson(x))),
      );

  Pagination? pagination;
  List<RevenueRecord> records;
}

class Pagination {
  Pagination({
    required this.perPage,
    required this.total,
    required this.lastPage,
    required this.currentPage,
  });

  factory Pagination.fromJson(Map<dynamic, dynamic> json) => Pagination(
        perPage: json['per_page'],
        total: json['total'],
        lastPage: json['last_page'],
        currentPage: json['current_page'],
      );

  int perPage;
  int total;
  int lastPage;
  int currentPage;
}

class RevenueRecord {
  RevenueRecord({
    required this.orderCode,
    required this.amount,
    required this.subAmount,
    required this.subAmountFormat,
    required this.fee,
    required this.feeFormat,
    required this.createdAt,
    required this.id,
    required this.type,
    required this.amountFormat,
    required this.orderId,
  });

  factory RevenueRecord.fromJson(Map<dynamic, dynamic> json) => RevenueRecord(
        orderCode: json['order_code'],
        amount: json['amount'],
        subAmount: json['sub_amount'],
        subAmountFormat: json['sub_amount_format'],
        fee: json['fee'],
        feeFormat: json['fee_format'],
        createdAt: DateTime.parse(json['created_at']),
        id: json['id'],
        type: json['type'],
        amountFormat: json['amount_format'],
        orderId: json['order_id'],
      );

  String orderCode;
  String amount;
  String subAmount;
  String subAmountFormat;
  String fee;
  String feeFormat;
  DateTime createdAt;
  int id;
  String type;
  String amountFormat;
  int orderId;
}
