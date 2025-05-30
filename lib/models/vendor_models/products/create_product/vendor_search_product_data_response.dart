// import 'dart:convert';
//
// import 'package:flutter/cupertino.dart';
//
// VendorSearchProductDataResponse searchProductDataResponseFromJson(String str) => VendorSearchProductDataResponse.fromJson(json.decode(str));
//
// class VendorSearchProductDataResponse {
//   VendorSearchProductDataResponse({
//     required this.data,
//     required this.error,
//     required this.message,
//   });
//
//   Data? data;
//   bool error;
//   String? message;
//
//   factory VendorSearchProductDataResponse.fromJson(Map<dynamic, dynamic> json) => VendorSearchProductDataResponse(
//         data: json["data"] != null ? Data.fromJson(json["data"]) : null,
//         error: json["error"],
//         message: json["message"],
//       );
// }
//
// class Data {
//   Data({
//     required this.pagination,
//     required this.records,
//   });
//
//   Pagination pagination;
//   List<SearchProductRecord> records;
//
//   factory Data.fromJson(Map<dynamic, dynamic> json) => Data(
//         pagination: Pagination.fromJson(json["pagination"]),
//         records: json["records"] != null ? List<SearchProductRecord>.from(json["records"].map((x) => SearchProductRecord.fromJson(x))) : [],
//       );
// }
//
// class Pagination {
//   Pagination({
//     required this.perPage,
//     required this.total,
//     required this.lastPage,
//     required this.currentPage,
//   });
//
//   int perPage;
//   int total;
//   int lastPage;
//   int currentPage;
//
//   factory Pagination.fromJson(Map<dynamic, dynamic> json) => Pagination(
//         perPage: json["per_page"],
//         total: json["total"],
//         lastPage: json["last_page"],
//         currentPage: json["current_page"],
//       );
// }
//
// class SearchProductRecord {
//   String? image;
//   String? priceFormat;
//   dynamic? originalPrice;
//   String? salePriceFormat;
//   dynamic? price;
//   String? name;
//   String? originalPriceFormat;
//   int? id;
//   dynamic? salePrice;
//   String? priceType;
//   TextEditingController controller;
//
//   SearchProductRecord({
//     this.image,
//     this.priceFormat,
//     this.originalPrice,
//     this.salePriceFormat,
//     this.price,
//     this.name,
//     this.originalPriceFormat,
//     this.id,
//     this.salePrice,
//     this.priceType,
//     required this.controller,
//   });
//
//   factory SearchProductRecord.fromJson(Map<dynamic, dynamic> json) => SearchProductRecord(
//         image: json["image"],
//         priceFormat: json["price_format"],
//         originalPrice: json["original_price"],
//         salePriceFormat: json["sale_price_format"],
//         price: json["price"],
//         name: json["name"],
//         originalPriceFormat: json["original_price_format"],
//         id: json["id"],
//         salePrice: json["sale_price"],
//         priceType: "fixed",
//         controller: TextEditingController(),
//       );
//
//   static String? capitalize(String? text) {
//     if (text == null || text.isEmpty) return text;
//     return text[0].toUpperCase() + text.substring(1);
//   }
//
// }
//
import 'dart:convert';
import 'package:flutter/cupertino.dart';

VendorSearchProductDataResponse searchProductDataResponseFromJson(String str) =>
    VendorSearchProductDataResponse.fromJson(json.decode(str));

class VendorSearchProductDataResponse {
  VendorSearchProductDataResponse({
    this.data,
    this.error,
    this.message,
  });

  Data? data;
  bool? error;
  String? message;

  factory VendorSearchProductDataResponse.fromJson(Map<dynamic, dynamic> json) =>
      VendorSearchProductDataResponse(
        data: json["data"] != null ? Data.fromJson(json["data"]) : null,
        error: json["error"],
        message: json["message"],
      );
}

class Data {
  Data({
    this.pagination,
    this.records,
  });

  Pagination? pagination;
  List<SearchProductRecord>? records;

  factory Data.fromJson(Map<dynamic, dynamic> json) => Data(
    pagination: json["pagination"] != null ? Pagination.fromJson(json["pagination"]) : null,
    records: json["records"] != null
        ? List<SearchProductRecord>.from(
        json["records"].map((x) => SearchProductRecord.fromJson(x)))
        : [],
  );
}

class Pagination {
  Pagination({
    this.perPage,
    this.total,
    this.lastPage,
    this.currentPage,
  });

  int? perPage;
  int? total;
  int? lastPage;
  int? currentPage;

  factory Pagination.fromJson(Map<dynamic, dynamic> json) => Pagination(
    perPage: json["per_page"],
    total: json["total"],
    lastPage: json["last_page"],
    currentPage: json["current_page"],
  );
}

class SearchProductRecord {
  String? image;
  String? priceFormat;
  dynamic originalPrice;
  String? salePriceFormat;
  dynamic? price;
  String? name;
  String? originalPriceFormat;
  int? id;
  dynamic? salePrice;
  String? priceType;
  TextEditingController controller;

  SearchProductRecord({
    this.image,
    this.priceFormat,
    this.originalPrice,
    this.salePriceFormat,
    this.price,
    this.name,
    this.originalPriceFormat,
    this.id,
    this.salePrice,
    this.priceType,
    TextEditingController? controller, // Making this nullable
  }) : controller = controller ?? TextEditingController();

  factory SearchProductRecord.fromJson(Map<dynamic, dynamic> json) =>
      SearchProductRecord(
        image: json["image"],
        priceFormat: json["price_format"],
        originalPrice: json["original_price"],
        salePriceFormat: json["sale_price_format"],
        price: json["price"],
        name: json["name"],
        originalPriceFormat: json["original_price_format"],
        id: json["id"],
        salePrice: json["sale_price"],
        priceType: json["price_type"] ?? "fixed",
        controller: TextEditingController(),
      );

  static String? capitalize(String? text) {
    if (text == null || text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1);
  }
}
