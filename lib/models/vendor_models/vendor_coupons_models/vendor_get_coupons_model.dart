import 'dart:convert';

/// error : false
/// data : {"pagination":{"total":2,"last_page":1,"current_page":1,"per_page":10},"records":[{"id":15,"title":"Test Coupon 2","code":"MBYCD5K33VHP","full_start_date":"2025-01-26T20:00:00.000000Z","start_date":"2025-01-27","start_time":"00:00","full_end_date":null,"end_date":null,"end_time":null,"quantity":null,"total_used":0,"value":100,"type":"coupon","can_use_with_promotion":false,"discount_on":null,"product_quantity":null,"type_option":"shipping","target":"all-orders","min_order_price":null,"display_at_checkout":true,"description":null,"updated_at":"2025-01-27 16:19:55","created_at":"2025-01-27 16:19:55","is_expired":false},{"id":14,"title":"Hi Abhay","code":"RDGP7V9HGOLU","full_start_date":"2025-01-26T20:00:00.000000Z","start_date":"2025-01-27","start_time":"00:00","full_end_date":null,"end_date":null,"end_time":null,"quantity":100,"total_used":0,"value":10,"type":"coupon","can_use_with_promotion":false,"discount_on":null,"product_quantity":null,"type_option":"amount","target":"all-orders","min_order_price":null,"display_at_checkout":true,"description":null,"updated_at":"2025-01-27 16:19:31","created_at":"2025-01-27 16:19:31","is_expired":false}]}
/// message : null

VendorGetCouponsModel vendorGetCouponsModelFromJson(String str) =>
    VendorGetCouponsModel.fromJson(json.decode(str));

String vendorGetCouponsModelToJson(VendorGetCouponsModel data) =>
    json.encode(data.toJson());

class VendorGetCouponsModel {
  VendorGetCouponsModel({
    bool? error,
    Data? data,
    message,
  }) {
    _error = error;
    _data = data;
    _message = message;
  }

  VendorGetCouponsModel.fromJson(json) {
    _error = json['error'];
    _data = json['data'] != null ? Data.fromJson(json['data']) : null;
    _message = json['message'];
  }

  bool? _error;
  Data? _data;
  dynamic _message;

  VendorGetCouponsModel copyWith({
    bool? error,
    Data? data,
    message,
  }) =>
      VendorGetCouponsModel(
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
/// records : [{"id":15,"title":"Test Coupon 2","code":"MBYCD5K33VHP","full_start_date":"2025-01-26T20:00:00.000000Z","start_date":"2025-01-27","start_time":"00:00","full_end_date":null,"end_date":null,"end_time":null,"quantity":null,"total_used":0,"value":100,"type":"coupon","can_use_with_promotion":false,"discount_on":null,"product_quantity":null,"type_option":"shipping","target":"all-orders","min_order_price":null,"display_at_checkout":true,"description":null,"updated_at":"2025-01-27 16:19:55","created_at":"2025-01-27 16:19:55","is_expired":false},{"id":14,"title":"Hi Abhay","code":"RDGP7V9HGOLU","full_start_date":"2025-01-26T20:00:00.000000Z","start_date":"2025-01-27","start_time":"00:00","full_end_date":null,"end_date":null,"end_time":null,"quantity":100,"total_used":0,"value":10,"type":"coupon","can_use_with_promotion":false,"discount_on":null,"product_quantity":null,"type_option":"amount","target":"all-orders","min_order_price":null,"display_at_checkout":true,"description":null,"updated_at":"2025-01-27 16:19:31","created_at":"2025-01-27 16:19:31","is_expired":false}]

Data dataFromJson(String str) => Data.fromJson(json.decode(str));

String dataToJson(Data data) => json.encode(data.toJson());

class Data {
  Data({
    Pagination? pagination,
    List<CouponRecords>? records,
  }) {
    _pagination = pagination;
    _records = records;
  }

  Data.fromJson(json) {
    _pagination = json['pagination'] != null
        ? Pagination.fromJson(json['pagination'])
        : null;
    if (json['records'] != null) {
      _records = [];
      json['records'].forEach((v) {
        _records?.add(CouponRecords.fromJson(v));
      });
    }
  }

  Pagination? _pagination;
  List<CouponRecords>? _records;

  Data copyWith({
    Pagination? pagination,
    List<CouponRecords>? records,
  }) =>
      Data(
        pagination: pagination ?? _pagination,
        records: records ?? _records,
      );

  Pagination? get pagination => _pagination;

  List<CouponRecords>? get records => _records;

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

/// id : 15
/// title : "Test Coupon 2"
/// code : "MBYCD5K33VHP"
/// full_start_date : "2025-01-26T20:00:00.000000Z"
/// start_date : "2025-01-27"
/// start_time : "00:00"
/// full_end_date : null
/// end_date : null
/// end_time : null
/// quantity : null
/// total_used : 0
/// value : 100
/// type : "coupon"
/// can_use_with_promotion : false
/// discount_on : null
/// product_quantity : null
/// type_option : "shipping"
/// target : "all-orders"
/// min_order_price : null
/// display_at_checkout : true
/// description : null
/// updated_at : "2025-01-27 16:19:55"
/// created_at : "2025-01-27 16:19:55"
/// is_expired : false

CouponRecords recordsFromJson(String str) =>
    CouponRecords.fromJson(json.decode(str));

String recordsToJson(CouponRecords data) => json.encode(data.toJson());

class CouponRecords {
  CouponRecords({
    id,
    String? title,
    String? code,
    String? fullStartDate,
    String? startDate,
    String? startTime,
    fullEndDate,
    endDate,
    endTime,
    quantity,
    totalUsed,
    value,
    String? type,
    bool? canUseWithPromotion,
    discountOn,
    productQuantity,
    String? typeOption,
    String? target,
    minOrderPrice,
    bool? displayAtCheckout,
    description,
    String? updatedAt,
    String? createdAt,
    bool? isExpired,
  }) {
    _id = id;
    _title = title;
    _code = code;
    _fullStartDate = fullStartDate;
    _startDate = startDate;
    _startTime = startTime;
    _fullEndDate = fullEndDate;
    _endDate = endDate;
    _endTime = endTime;
    _quantity = quantity;
    _totalUsed = totalUsed;
    _value = value;
    _type = type;
    _canUseWithPromotion = canUseWithPromotion;
    _discountOn = discountOn;
    _productQuantity = productQuantity;
    _typeOption = typeOption;
    _target = target;
    _minOrderPrice = minOrderPrice;
    _displayAtCheckout = displayAtCheckout;
    _description = description;
    _updatedAt = updatedAt;
    _createdAt = createdAt;
    _isExpired = isExpired;
    _isDeleting = false;
  }

  CouponRecords.fromJson(json) {
    _id = json['id'];
    _title = json['title'];
    _code = json['code'];
    _fullStartDate = json['full_start_date'];
    _startDate = json['start_date'];
    _startTime = json['start_time'];
    _fullEndDate = json['full_end_date'];
    _endDate = json['end_date'];
    _endTime = json['end_time'];
    _quantity = json['quantity'];
    _totalUsed = json['total_used'];
    _value = json['value'];
    _type = json['type'];
    _canUseWithPromotion = json['can_use_with_promotion'];
    _discountOn = json['discount_on'];
    _productQuantity = json['product_quantity'];
    _typeOption = json['type_option'];
    _target = json['target'];
    _minOrderPrice = json['min_order_price'];
    _displayAtCheckout = json['display_at_checkout'];
    _description = json['description'];
    _updatedAt = json['updated_at'];
    _createdAt = json['created_at'];
    _isExpired = json['is_expired'];
    _isDeleting = false;
  }

  dynamic _id;
  String? _title;
  String? _code;
  String? _fullStartDate;
  String? _startDate;
  String? _startTime;
  dynamic _fullEndDate;
  dynamic _endDate;
  dynamic _endTime;
  dynamic _quantity;
  dynamic _totalUsed;
  dynamic _value;
  String? _type;
  bool? _canUseWithPromotion;
  dynamic _discountOn;
  dynamic _productQuantity;
  String? _typeOption;
  String? _target;
  dynamic _minOrderPrice;
  bool? _displayAtCheckout;
  dynamic _description;
  String? _updatedAt;
  String? _createdAt;
  bool? _isExpired;
  bool _isDeleting = false;

  void setIsDeleting(bool deleting) {
    _isDeleting = deleting;
  }

  CouponRecords copyWith({
    id,
    String? title,
    String? code,
    String? fullStartDate,
    String? startDate,
    String? startTime,
    fullEndDate,
    endDate,
    endTime,
    quantity,
    totalUsed,
    value,
    String? type,
    bool? canUseWithPromotion,
    discountOn,
    productQuantity,
    String? typeOption,
    String? target,
    minOrderPrice,
    bool? displayAtCheckout,
    description,
    String? updatedAt,
    String? createdAt,
    bool? isExpired,
  }) =>
      CouponRecords(
        id: id ?? _id,
        title: title ?? _title,
        code: code ?? _code,
        fullStartDate: fullStartDate ?? _fullStartDate,
        startDate: startDate ?? _startDate,
        startTime: startTime ?? _startTime,
        fullEndDate: fullEndDate ?? _fullEndDate,
        endDate: endDate ?? _endDate,
        endTime: endTime ?? _endTime,
        quantity: quantity ?? _quantity,
        totalUsed: totalUsed ?? _totalUsed,
        value: value ?? _value,
        type: type ?? _type,
        canUseWithPromotion: canUseWithPromotion ?? _canUseWithPromotion,
        discountOn: discountOn ?? _discountOn,
        productQuantity: productQuantity ?? _productQuantity,
        typeOption: typeOption ?? _typeOption,
        target: target ?? _target,
        minOrderPrice: minOrderPrice ?? _minOrderPrice,
        displayAtCheckout: displayAtCheckout ?? _displayAtCheckout,
        description: description ?? _description,
        updatedAt: updatedAt ?? _updatedAt,
        createdAt: createdAt ?? _createdAt,
        isExpired: isExpired ?? _isExpired,
      );

  dynamic get id => _id;

  String? get title => _title;

  String? get code => _code;

  String? get fullStartDate => _fullStartDate;

  String? get startDate => _startDate;

  String? get startTime => _startTime;

  dynamic get fullEndDate => _fullEndDate;

  dynamic get endDate => _endDate;

  dynamic get endTime => _endTime;

  dynamic get quantity => _quantity;

  dynamic get totalUsed => _totalUsed;

  dynamic get value => _value;

  String? get type => _type;

  bool? get canUseWithPromotion => _canUseWithPromotion;

  dynamic get discountOn => _discountOn;

  dynamic get productQuantity => _productQuantity;

  String? get typeOption => _typeOption;

  String? get target => _target;

  dynamic get minOrderPrice => _minOrderPrice;

  bool? get displayAtCheckout => _displayAtCheckout;

  dynamic get description => _description;

  String? get updatedAt => _updatedAt;

  String? get createdAt => _createdAt;

  bool? get isExpired => _isExpired;

  bool get isDeleting => _isDeleting;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['title'] = _title;
    map['code'] = _code;
    map['full_start_date'] = _fullStartDate;
    map['start_date'] = _startDate;
    map['start_time'] = _startTime;
    map['full_end_date'] = _fullEndDate;
    map['end_date'] = _endDate;
    map['end_time'] = _endTime;
    map['quantity'] = _quantity;
    map['total_used'] = _totalUsed;
    map['value'] = _value;
    map['type'] = _type;
    map['can_use_with_promotion'] = _canUseWithPromotion;
    map['discount_on'] = _discountOn;
    map['product_quantity'] = _productQuantity;
    map['type_option'] = _typeOption;
    map['target'] = _target;
    map['min_order_price'] = _minOrderPrice;
    map['display_at_checkout'] = _displayAtCheckout;
    map['description'] = _description;
    map['updated_at'] = _updatedAt;
    map['created_at'] = _createdAt;
    map['is_expired'] = _isExpired;
    return map;
  }
}

/// total : 2
/// last_page : 1
/// current_page : 1
/// per_page : 10

Pagination paginationFromJson(String str) =>
    Pagination.fromJson(json.decode(str));

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
