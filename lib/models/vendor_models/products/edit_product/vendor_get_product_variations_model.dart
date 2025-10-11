import '../../../vendor_models/products/vendor_get_products_model.dart';

class VendorGetProductVariationsModel {
  VendorGetProductVariationsModel({
    this.error,
    this.data,
    this.message,
  });

  factory VendorGetProductVariationsModel.fromJson(Map<String, dynamic> json) => VendorGetProductVariationsModel(
        error: json['error'] as bool?,
        data: json['data'] != null ? ProductVariationsData.fromJson(json['data']) : null,
        message: json['message'] as String?,
      );
  bool? error;
  ProductVariationsData? data;
  String? message;

  Map<String, dynamic> toJson() => {
        'error': error,
        'data': data?.toJson(),
        'message': message,
      };
}

class ProductVariationsData {
  ProductVariationsData({
    this.pagination,
    this.records,
  });

  factory ProductVariationsData.fromJson(Map<String, dynamic> json) => ProductVariationsData(
        pagination: json['pagination'] != null ? Pagination.fromJson(json['pagination']) : null,
        records: (json['records'] as List?)?.map((record) => ProductVariationRecord.fromJson(record)).toList(),
      );
  Pagination? pagination;
  List<ProductVariationRecord>? records;

  Map<String, dynamic> toJson() => {
        'pagination': pagination?.toJson(),
        'records': records?.map((record) => record.toJson()).toList(),
      };
}

class ProductVariationRecord {
  ProductVariationRecord({
    this.id,
    this.productId,
    this.originalProductId,
    this.isDefault,
    this.price,
    this.priceFormat,
    this.salePrice,
    this.salePriceFormat,
    this.imagePath,
    this.quantity,
    this.fileExternalCount,
    this.fileInternalCount,
    this.selectedAttributeSets,
    this.isDeleting,
  });

  factory ProductVariationRecord.fromJson(Map<String, dynamic> json) => ProductVariationRecord(
        id: json['id'] as String?,
        productId: json['product_id'] as int?,
        originalProductId: json['original_product_id'] as int?,
        isDefault: json['is_default'] as bool?,
        price: (json['price'] as num?)?.toDouble(),
        priceFormat: json['price_format'] as String?,
        salePrice: (json['sale_price'] as num?)?.toDouble(),
        salePriceFormat: json['sale_price_format'] as String?,
        imagePath: json['image_path'] as String?,
        quantity: json['quantity'].toString() as String?,
        fileInternalCount: json['file_internal_count'] as int?,
        fileExternalCount: json['file_external_count'] as int?,
        selectedAttributeSets: (json['selected_attribute_sets'] as Map<String, dynamic>?)
            ?.map((key, value) => MapEntry(key, value as String?)),
      );
  String? id;
  int? productId;
  int? originalProductId;
  bool? isDefault;
  double? price;
  String? priceFormat;
  double? salePrice;
  String? salePriceFormat;
  String? imagePath;
  String? quantity;
  int? fileExternalCount;
  int? fileInternalCount;
  Map<String, String?>? selectedAttributeSets;
  bool? isDeleting;

  Map<String, dynamic> toJson() => {
        'id': id,
        'product_id': productId,
        'original_product_id': originalProductId,
        'is_default': isDefault,
        'price': price,
        'price_format': priceFormat,
        'sale_price': salePrice,
        'sale_price_format': salePriceFormat,
        'image_path': imagePath,
        'quantity': quantity,
        'selected_attribute_sets': selectedAttributeSets,
      };
}
