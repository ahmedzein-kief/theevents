import 'dart:convert';

/// Response model for vendor products API
/// Returns paginated product records with metadata
VendorGetProductsModel vendorGetProductsModelFromJson(String str) => VendorGetProductsModel.fromJson(json.decode(str));

String vendorGetProductsModelToJson(VendorGetProductsModel data) => json.encode(data.toJson());

class VendorGetProductsModel {
  final bool error;
  final Data? data;
  final dynamic message;

  VendorGetProductsModel({
    required this.error,
    this.data,
    this.message,
  });

  factory VendorGetProductsModel.fromJson(Map<String, dynamic> json) {
    return VendorGetProductsModel(
      error: json['error'] ?? false,
      data: json['data'] != null ? Data.fromJson(json['data']) : null,
      message: json['message'],
    );
  }

  VendorGetProductsModel copyWith({
    bool? error,
    Data? data,
    String? message,
  }) {
    return VendorGetProductsModel(
      error: error ?? this.error,
      data: data ?? this.data,
      message: message ?? this.message,
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

class Data {
  final Pagination? pagination;
  final List<GetProductRecords> records;

  Data({
    this.pagination,
    this.records = const [],
  });

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      pagination: json['pagination'] != null ? Pagination.fromJson(json['pagination']) : null,
      records:
          json['records'] != null ? (json['records'] as List).map((v) => GetProductRecords.fromJson(v)).toList() : [],
    );
  }

  Data copyWith({
    Pagination? pagination,
    List<GetProductRecords>? records,
  }) {
    return Data(
      pagination: pagination ?? this.pagination,
      records: records ?? this.records,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'pagination': pagination?.toJson(),
      'records': records.map((v) => v.toJson()).toList(),
    };
  }
}

class GetProductRecords {
  final int id;
  final String name;
  final int order;
  final Status? status;
  final String sku;
  final String image;
  final num price;
  final String priceFormat;
  final num salePrice;
  final String salePriceFormat;
  final String? startDate;
  final String? endDate;
  final int? quantity;
  final bool withStorehouseManagement;
  final String createdAt;

  // Mutable state flags
  bool isDeleting;
  bool isDefault;

  GetProductRecords({
    required this.id,
    required this.name,
    required this.order,
    this.status,
    required this.sku,
    required this.image,
    required this.price,
    required this.priceFormat,
    required this.salePrice,
    required this.salePriceFormat,
    this.startDate,
    this.endDate,
    this.quantity,
    required this.withStorehouseManagement,
    required this.createdAt,
    this.isDeleting = false,
    this.isDefault = false,
  });

  factory GetProductRecords.fromJson(Map<String, dynamic> json) {
    return GetProductRecords(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      order: json['order'] ?? 0,
      status: json['status'] != null ? Status.fromJson(json['status']) : null,
      sku: json['sku'] ?? '',
      image: json['image'] ?? '',
      price: json['price'] ?? 0,
      priceFormat: json['price_format'] ?? '',
      salePrice: json['sale_price'] ?? 0,
      salePriceFormat: json['sale_price_format'] ?? '',
      startDate: json['start_date'],
      endDate: json['end_date'],
      quantity: json['quantity'],
      withStorehouseManagement: json['with_storehouse_management'] ?? false,
      createdAt: json['created_at'] ?? '',
      isDeleting: false,
      isDefault: false,
    );
  }

  GetProductRecords copyWith({
    int? id,
    String? name,
    int? order,
    Status? status,
    String? sku,
    String? image,
    num? price,
    String? priceFormat,
    num? salePrice,
    String? salePriceFormat,
    String? startDate,
    String? endDate,
    int? quantity,
    bool? withStorehouseManagement,
    String? createdAt,
    bool? isDeleting,
    bool? isDefault,
  }) {
    return GetProductRecords(
      id: id ?? this.id,
      name: name ?? this.name,
      order: order ?? this.order,
      status: status ?? this.status,
      sku: sku ?? this.sku,
      image: image ?? this.image,
      price: price ?? this.price,
      priceFormat: priceFormat ?? this.priceFormat,
      salePrice: salePrice ?? this.salePrice,
      salePriceFormat: salePriceFormat ?? this.salePriceFormat,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      quantity: quantity ?? this.quantity,
      withStorehouseManagement: withStorehouseManagement ?? this.withStorehouseManagement,
      createdAt: createdAt ?? this.createdAt,
      isDeleting: isDeleting ?? this.isDeleting,
      isDefault: isDefault ?? this.isDefault,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'order': order,
      'status': status?.toJson(),
      'sku': sku,
      'image': image,
      'price': price,
      'price_format': priceFormat,
      'sale_price': salePrice,
      'sale_price_format': salePriceFormat,
      'start_date': startDate,
      'end_date': endDate,
      'quantity': quantity,
      'with_storehouse_management': withStorehouseManagement,
      'created_at': createdAt,
    };
  }
}

class Status {
  final String value;
  final String label;

  Status({
    required this.value,
    required this.label,
  });

  factory Status.fromJson(Map<String, dynamic> json) {
    return Status(
      value: json['value'] ?? '',
      label: json['label'] ?? '',
    );
  }

  Status copyWith({
    String? value,
    String? label,
  }) {
    return Status(
      value: value ?? this.value,
      label: label ?? this.label,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'value': value,
      'label': label,
    };
  }
}

class Pagination {
  final int total;
  final int lastPage;
  final int currentPage;
  final int perPage;

  Pagination({
    required this.total,
    required this.lastPage,
    required this.currentPage,
    required this.perPage,
  });

  factory Pagination.fromJson(Map<String, dynamic> json) {
    return Pagination(
      total: json['total'] ?? 0,
      lastPage: json['last_page'] ?? 0,
      currentPage: json['current_page'] ?? 0,
      perPage: json['per_page'] ?? 0,
    );
  }

  Pagination copyWith({
    int? total,
    int? lastPage,
    int? currentPage,
    int? perPage,
  }) {
    return Pagination(
      total: total ?? this.total,
      lastPage: lastPage ?? this.lastPage,
      currentPage: currentPage ?? this.currentPage,
      perPage: perPage ?? this.perPage,
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
