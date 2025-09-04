import '../../../vendor_models/products/VendorGetProductsModel.dart';

class VendorGetProductVariationsModel {
  VendorGetProductVariationsModel(
      {bool? error, ProductVariationsData? data, String? message,})
      : _error = error,
        _data = data,
        _message = message;

  factory VendorGetProductVariationsModel.fromJson(Map<String, dynamic> json) =>
      VendorGetProductVariationsModel(
        error: json['error'] as bool?,
        data: json['data'] != null
            ? ProductVariationsData.fromJson(json['data'])
            : null,
        message: json['message'] as String?,
      );
  bool? _error;
  ProductVariationsData? _data;
  String? _message;

  Map<String, dynamic> toJson() => {
        'error': _error,
        'data': _data?.toJson(),
        'message': _message,
      };

  // Getters
  bool? get error => _error;

  ProductVariationsData? get data => _data;

  String? get message => _message;

  // Setters
  set error(bool? value) => _error = value;

  set data(ProductVariationsData? value) => _data = value;

  set message(String? value) => _message = value;
}

class ProductVariationsData {
  ProductVariationsData(
      {Pagination? pagination, List<ProductVariationRecord>? records,})
      : _pagination = pagination,
        _records = records;

  factory ProductVariationsData.fromJson(Map<String, dynamic> json) =>
      ProductVariationsData(
        pagination: json['pagination'] != null
            ? Pagination.fromJson(json['pagination'])
            : null,
        records: (json['records'] as List?)
            ?.map((record) => ProductVariationRecord.fromJson(record))
            .toList(),
      );
  Pagination? _pagination;
  List<ProductVariationRecord>? _records;

  Map<String, dynamic> toJson() => {
        'pagination': _pagination?.toJson(),
        'records': _records?.map((record) => record.toJson()).toList(),
      };

  // Getters
  Pagination? get pagination => _pagination;

  List<ProductVariationRecord>? get records => _records;

  // Setters
  set pagination(Pagination? value) => _pagination = value;

  set records(List<ProductVariationRecord>? value) => _records = value;
}

class ProductVariationRecord {
  ProductVariationRecord({
    String? id,
    int? productId,
    int? originalProductId,
    bool? isDefault,
    double? price,
    String? priceFormat,
    double? salePrice,
    String? salePriceFormat,
    String? imagePath,
    String? quantity,
    int? fileExternalCount,
    int? fileInternalCount,
    Map<String, String?>? selectedAttributeSets,
    bool? isDeleting,
  })  : _id = id,
        _productId = productId,
        _originalProductId = originalProductId,
        _isDefault = isDefault,
        _price = price,
        _priceFormat = priceFormat,
        _salePrice = salePrice,
        _salePriceFormat = salePriceFormat,
        _imagePath = imagePath,
        _quantity = quantity,
        _fileInternalCount = fileInternalCount,
        _fileExternalCount = fileExternalCount,
        _selectedAttributeSets = selectedAttributeSets,
        _isDeleting = isDeleting;

  factory ProductVariationRecord.fromJson(Map<String, dynamic> json) =>
      ProductVariationRecord(
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
        selectedAttributeSets:
            (json['selected_attribute_sets'] as Map<String, dynamic>?)
                ?.map((key, value) => MapEntry(key, value as String?)),
      );
  String? _id;
  int? _productId;
  int? _originalProductId;
  bool? _isDefault;
  double? _price;
  String? _priceFormat;
  double? _salePrice;
  String? _salePriceFormat;
  String? _imagePath;
  String? _quantity;
  int? _fileExternalCount;
  int? _fileInternalCount;
  Map<String, String?>? _selectedAttributeSets;
  bool? _isDeleting;

  Map<String, dynamic> toJson() => {
        'id': _id,
        'product_id': _productId,
        'original_product_id': _originalProductId,
        'is_default': _isDefault,
        'price': _price,
        'price_format': _priceFormat,
        'sale_price': _salePrice,
        'sale_price_format': _salePriceFormat,
        'image_path': _imagePath,
        'quantity': _quantity,
        'selected_attribute_sets': _selectedAttributeSets,
      };

  // Getters
  String? get id => _id;

  int? get productId => _productId;

  int? get originalProductId => _originalProductId;

  bool? get isDefault => _isDefault;

  double? get price => _price;

  String? get priceFormat => _priceFormat;

  double? get salePrice => _salePrice;

  String? get salePriceFormat => _salePriceFormat;

  String? get imagePath => _imagePath;

  String? get quantity => _quantity;

  int? get fileExternalCount => _fileExternalCount;

  int? get fileInternalCount => _fileInternalCount;

  Map<String, String?>? get selectedAttributeSets => _selectedAttributeSets;

  bool? get isDeleting => _isDeleting;

  // Setters
  set id(String? value) => _id = value;

  set productId(int? value) => _productId = value;

  set originalProductId(int? value) => _originalProductId = value;

  set isDefault(bool? value) => _isDefault = value;

  set price(double? value) => _price = value;

  set priceFormat(String? value) => _priceFormat = value;

  set salePrice(double? value) => _salePrice = value;

  set salePriceFormat(String? value) => _salePriceFormat = value;

  set imagePath(String? value) => _imagePath = value;

  set quantity(String? value) => _quantity = value;

  set selectedAttributeSets(Map<String, String?>? value) =>
      _selectedAttributeSets = value;

  set isDeleting(bool? value) => _isDeleting = value;
}
