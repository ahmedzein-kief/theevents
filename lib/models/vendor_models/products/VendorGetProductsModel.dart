import 'dart:convert';

/// error : false
/// data : {"pagination":{"total":2,"last_page":1,"current_page":1,"per_page":10},"records":[{"id":3113,"name":"Test Product 2","order":0,"status":{"value":"pending","label":"Pending"},"sku":"MF-2443-XLVBV","image":"https://newapistaging.theevents.ae/storage/stores/apple/1024-1024-image-1-250x250.jpg","price":100,"price_format":"AED100.00","sale_price":100,"sale_price_format":"AED100.00","start_date":null,"end_date":null,"quantity":null,"with_storehouse_management":false,"created_at":"2025-01-24 09:28:53"},{"id":3112,"name":"Test Product","order":0,"status":{"value":"published","label":"Published"},"sku":"MF-2443-JXODU","image":"https://newapistaging.theevents.ae/vendor/core/core/base/images/placeholder.png","price":10,"price_format":"AED10.00","sale_price":10,"sale_price_format":"AED10.00","start_date":null,"end_date":null,"quantity":1000,"with_storehouse_management":true,"created_at":"2025-01-24 09:24:38"}]}
/// message : null

VendorGetProductsModel vendorGetProductsModelFromJson(String str) => VendorGetProductsModel.fromJson(json.decode(str));

String vendorGetProductsModelToJson(VendorGetProductsModel data) => json.encode(data.toJson());

class VendorGetProductsModel {
  VendorGetProductsModel({
    bool? error,
    Data? data,
    message,
  }) {
    _error = error;
    _data = data;
    _message = message;
  }

  VendorGetProductsModel.fromJson(json) {
    _error = json['error'];
    _data = json['data'] != null ? Data.fromJson(json['data']) : null;
    _message = json['message'];
  }

  bool? _error;
  Data? _data;
  dynamic _message;

  VendorGetProductsModel copyWith({
    bool? error,
    Data? data,
    message,
  }) =>
      VendorGetProductsModel(
        error: error ?? _error,
        data: data ?? _data,
        message: message ?? _message,
      );

  bool? get error => _error;

  Data? get data => _data;

  dynamic get message => _message;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['error'] = _error;
    if (_data != null) {
      map['data'] = _data?.toJson();
    }
    map['message'] = _message;
    return map;
  }
}

/// pagination : {"total":2,"last_page":1,"current_page":1,"per_page":10}
/// records : [{"id":3113,"name":"Test Product 2","order":0,"status":{"value":"pending","label":"Pending"},"sku":"MF-2443-XLVBV","image":"https://newapistaging.theevents.ae/storage/stores/apple/1024-1024-image-1-250x250.jpg","price":100,"price_format":"AED100.00","sale_price":100,"sale_price_format":"AED100.00","start_date":null,"end_date":null,"quantity":null,"with_storehouse_management":false,"created_at":"2025-01-24 09:28:53"},{"id":3112,"name":"Test Product","order":0,"status":{"value":"published","label":"Published"},"sku":"MF-2443-JXODU","image":"https://newapistaging.theevents.ae/vendor/core/core/base/images/placeholder.png","price":10,"price_format":"AED10.00","sale_price":10,"sale_price_format":"AED10.00","start_date":null,"end_date":null,"quantity":1000,"with_storehouse_management":true,"created_at":"2025-01-24 09:24:38"}]

Data dataFromJson(String str) => Data.fromJson(json.decode(str));

String dataToJson(Data data) => json.encode(data.toJson());

class Data {
  Data({
    Pagination? pagination,
    List<GetProductRecords>? records,
  }) {
    _pagination = pagination;
    _records = records;
  }

  Data.fromJson(json) {
    _pagination = json['pagination'] != null ? Pagination.fromJson(json['pagination']) : null;
    if (json['records'] != null) {
      _records = [];
      json['records'].forEach((v) {
        _records?.add(GetProductRecords.fromJson(v));
      });
    }
  }

  Pagination? _pagination;
  List<GetProductRecords>? _records;

  Data copyWith({
    Pagination? pagination,
    List<GetProductRecords>? records,
  }) =>
      Data(
        pagination: pagination ?? _pagination,
        records: records ?? _records,
      );

  Pagination? get pagination => _pagination;

  List<GetProductRecords>? get records => _records;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_pagination != null) {
      map['pagination'] = _pagination?.toJson();
    }
    if (_records != null) {
      map['records'] = _records?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

GetProductRecords recordsFromJson(String str) => GetProductRecords.fromJson(json.decode(str));

String recordsToJson(GetProductRecords data) => json.encode(data.toJson());

class GetProductRecords {
  GetProductRecords({
    id,
    String? name,
    order,
    Status? status,
    String? sku,
    String? image,
    price,
    String? priceFormat,
    salePrice,
    String? salePriceFormat,
    startDate,
    endDate,
    quantity,
    bool? withStorehouseManagement,
    String? createdAt,
    bool isDefault = false,
  }) {
    _id = id;
    _name = name;
    _order = order;
    _status = status;
    _sku = sku;
    _image = image;
    _price = price;
    _priceFormat = priceFormat;
    _salePrice = salePrice;
    _salePriceFormat = salePriceFormat;
    _startDate = startDate;
    _endDate = endDate;
    _quantity = quantity;
    _withStorehouseManagement = withStorehouseManagement;
    _createdAt = createdAt;
    _isDefault = isDefault;
  }

  GetProductRecords.fromJson(json) {
    _id = json['id'];
    _name = json['name'];
    _order = json['order'];
    _status = json['status'] != null ? Status.fromJson(json['status']) : null;
    _sku = json['sku'];
    _image = json['image'];
    _price = json['price'];
    _priceFormat = json['price_format'];
    _salePrice = json['sale_price'];
    _salePriceFormat = json['sale_price_format'];
    _startDate = json['start_date'];
    _endDate = json['end_date'];
    _quantity = json['quantity'];
    _withStorehouseManagement = json['with_storehouse_management'];
    _createdAt = json['created_at'];
    _isDeleting = false;
    _isDefault = false;
  }

  dynamic _id;
  String? _name;
  dynamic _order;
  Status? _status;
  String? _sku;
  String? _image;
  dynamic _price;
  String? _priceFormat;
  dynamic _salePrice;
  String? _salePriceFormat;
  dynamic _startDate;
  dynamic _endDate;
  dynamic _quantity;
  bool? _withStorehouseManagement;
  String? _createdAt;
  bool _isDeleting = false;
  bool _isDefault = false;

  GetProductRecords copyWith({
    id,
    String? name,
    order,
    Status? status,
    String? sku,
    String? image,
    price,
    String? priceFormat,
    salePrice,
    String? salePriceFormat,
    startDate,
    endDate,
    quantity,
    bool? withStorehouseManagement,
    String? createdAt,
  }) =>
      GetProductRecords(
        id: id ?? _id,
        name: name ?? _name,
        order: order ?? _order,
        status: status ?? _status,
        sku: sku ?? _sku,
        image: image ?? _image,
        price: price ?? _price,
        priceFormat: priceFormat ?? _priceFormat,
        salePrice: salePrice ?? _salePrice,
        salePriceFormat: salePriceFormat ?? _salePriceFormat,
        startDate: startDate ?? _startDate,
        endDate: endDate ?? _endDate,
        quantity: quantity ?? _quantity,
        withStorehouseManagement: withStorehouseManagement ?? _withStorehouseManagement,
        createdAt: createdAt ?? _createdAt,
      );

  dynamic get id => _id;

  String? get name => _name;

  dynamic get order => _order;

  Status? get status => _status;

  String? get sku => _sku;

  String? get image => _image;

  dynamic get price => _price;

  String? get priceFormat => _priceFormat;

  dynamic get salePrice => _salePrice;

  String? get salePriceFormat => _salePriceFormat;

  dynamic get startDate => _startDate;

  dynamic get endDate => _endDate;

  dynamic get quantity => _quantity;

  bool? get withStorehouseManagement => _withStorehouseManagement;

  String? get createdAt => _createdAt;

  bool get isDeleting => _isDeleting;

  bool get isDefault => _isDefault;

  set isDeleting(bool value) {
    _isDeleting = value;
  }

  set isDefault(bool value) {
    _isDefault = value;
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['name'] = _name;
    map['order'] = _order;
    if (_status != null) {
      map['status'] = _status?.toJson();
    }
    map['sku'] = _sku;
    map['image'] = _image;
    map['price'] = _price;
    map['price_format'] = _priceFormat;
    map['sale_price'] = _salePrice;
    map['sale_price_format'] = _salePriceFormat;
    map['start_date'] = _startDate;
    map['end_date'] = _endDate;
    map['quantity'] = _quantity;
    map['with_storehouse_management'] = _withStorehouseManagement;
    map['created_at'] = _createdAt;
    return map;
  }
}

/// value : "pending"
/// label : "Pending"

Status statusFromJson(String str) => Status.fromJson(json.decode(str));

String statusToJson(Status data) => json.encode(data.toJson());

class Status {
  Status({
    String? value,
    String? label,
  }) {
    _value = value;
    _label = label;
  }

  Status.fromJson(json) {
    _value = json['value'];
    _label = json['label'];
  }

  String? _value;
  String? _label;

  Status copyWith({
    String? value,
    String? label,
  }) =>
      Status(
        value: value ?? _value,
        label: label ?? _label,
      );

  String? get value => _value;

  String? get label => _label;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['value'] = _value;
    map['label'] = _label;
    return map;
  }
}

/// total : 2
/// last_page : 1
/// current_page : 1
/// per_page : 10

Pagination paginationFromJson(String str) => Pagination.fromJson(json.decode(str));

String paginationToJson(Pagination data) => json.encode(data.toJson());

class Pagination {
  Pagination({
    total,
    lastPage,
    currentPage,
    perPage,
  }) {
    _total = total;
    _lastPage = lastPage;
    _currentPage = currentPage;
    _perPage = perPage;
  }

  Pagination.fromJson(json) {
    _total = json['total'];
    _lastPage = json['last_page'];
    _currentPage = json['current_page'];
    _perPage = json['per_page'];
  }

  dynamic _total;
  dynamic _lastPage;
  dynamic _currentPage;
  dynamic _perPage;

  Pagination copyWith({
    total,
    lastPage,
    currentPage,
    perPage,
  }) =>
      Pagination(
        total: total ?? _total,
        lastPage: lastPage ?? _lastPage,
        currentPage: currentPage ?? _currentPage,
        perPage: perPage ?? _perPage,
      );

  dynamic get total => _total;

  dynamic get lastPage => _lastPage;

  dynamic get currentPage => _currentPage;

  dynamic get perPage => _perPage;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['total'] = _total;
    map['last_page'] = _lastPage;
    map['current_page'] = _currentPage;
    map['per_page'] = _perPage;
    return map;
  }
}
