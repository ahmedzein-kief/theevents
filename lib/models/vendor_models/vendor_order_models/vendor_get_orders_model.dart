import 'dart:convert';

/// error : false
/// data : {"pagination":{"total":5,"last_page":1,"current_page":1,"per_page":10},"records":[{"id":1919,"code":"#10001919","tax_amount":"0.00","tax_amount_format":"AED0.00","amount":"329.00","amount_format":"AED329.00","shipping_amount":"39.00","shipping_amount_format":"AED39.00","status":{"value":"completed","label":"Completed"},"payment_status":{"value":"completed","label":"Completed"},"payment_method":{"value":"telr","label":"Telr"},"customer_name":null,"created_at":"2025-01-16 13:34:30"},{"id":1673,"code":"#10001673","tax_amount":"13.25","tax_amount_format":"AED13.25","amount":"317.25","amount_format":"AED317.25","shipping_amount":"39.00","shipping_amount_format":"AED39.00","status":{"value":"completed","label":"Completed"},"payment_status":{"value":null,"label":""},"payment_method":{"value":null,"label":""},"customer_name":"Mohammed Lamdy","created_at":"2024-12-07 13:30:21"},{"id":1299,"code":"#10001299","tax_amount":"14.50","tax_amount_format":"AED14.50","amount":"343.50","amount_format":"AED343.50","shipping_amount":"39.00","shipping_amount_format":"AED39.00","status":{"value":"pending","label":"Pending"},"payment_status":{"value":null,"label":""},"payment_method":{"value":null,"label":""},"customer_name":"Dikshit sharma","created_at":"2024-11-24 16:05:27"},{"id":1298,"code":"#10001298","tax_amount":"23.90","tax_amount_format":"AED23.90","amount":"540.90","amount_format":"AED540.90","shipping_amount":"39.00","shipping_amount_format":"AED39.00","status":{"value":"pending","label":"Pending"},"payment_status":{"value":null,"label":""},"payment_method":{"value":null,"label":""},"customer_name":"Dikshit sharma","created_at":"2024-11-24 16:00:47"},{"id":1296,"code":"#10001296","tax_amount":"30.25","tax_amount_format":"AED30.25","amount":"674.25","amount_format":"AED674.25","shipping_amount":"39.00","shipping_amount_format":"AED39.00","status":{"value":"pending","label":"Pending"},"payment_status":{"value":null,"label":""},"payment_method":{"value":null,"label":""},"customer_name":"Dikshit sharma","created_at":"2024-11-24 15:52:05"}]}
/// message : null

VendorGetOrdersModel vendorGetOrdersModelFromJson(String str) =>
    VendorGetOrdersModel.fromJson(json.decode(str));

String vendorGetOrdersModelToJson(VendorGetOrdersModel data) =>
    json.encode(data.toJson());

class VendorGetOrdersModel {
  VendorGetOrdersModel({
    bool? error,
    Data? data,
    message,
  }) {
    _error = error;
    _data = data;
    _message = message;
  }

  VendorGetOrdersModel.fromJson(json) {
    _error = json['error'];
    _data = json['data'] != null ? Data.fromJson(json['data']) : null;
    _message = json['message'];
  }

  bool? _error;
  Data? _data;
  dynamic _message;

  VendorGetOrdersModel copyWith({
    bool? error,
    Data? data,
    message,
  }) =>
      VendorGetOrdersModel(
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

/// pagination : {"total":5,"last_page":1,"current_page":1,"per_page":10}
/// records : [{"id":1919,"code":"#10001919","tax_amount":"0.00","tax_amount_format":"AED0.00","amount":"329.00","amount_format":"AED329.00","shipping_amount":"39.00","shipping_amount_format":"AED39.00","status":{"value":"completed","label":"Completed"},"payment_status":{"value":"completed","label":"Completed"},"payment_method":{"value":"telr","label":"Telr"},"customer_name":null,"created_at":"2025-01-16 13:34:30"},{"id":1673,"code":"#10001673","tax_amount":"13.25","tax_amount_format":"AED13.25","amount":"317.25","amount_format":"AED317.25","shipping_amount":"39.00","shipping_amount_format":"AED39.00","status":{"value":"completed","label":"Completed"},"payment_status":{"value":null,"label":""},"payment_method":{"value":null,"label":""},"customer_name":"Mohammed Lamdy","created_at":"2024-12-07 13:30:21"},{"id":1299,"code":"#10001299","tax_amount":"14.50","tax_amount_format":"AED14.50","amount":"343.50","amount_format":"AED343.50","shipping_amount":"39.00","shipping_amount_format":"AED39.00","status":{"value":"pending","label":"Pending"},"payment_status":{"value":null,"label":""},"payment_method":{"value":null,"label":""},"customer_name":"Dikshit sharma","created_at":"2024-11-24 16:05:27"},{"id":1298,"code":"#10001298","tax_amount":"23.90","tax_amount_format":"AED23.90","amount":"540.90","amount_format":"AED540.90","shipping_amount":"39.00","shipping_amount_format":"AED39.00","status":{"value":"pending","label":"Pending"},"payment_status":{"value":null,"label":""},"payment_method":{"value":null,"label":""},"customer_name":"Dikshit sharma","created_at":"2024-11-24 16:00:47"},{"id":1296,"code":"#10001296","tax_amount":"30.25","tax_amount_format":"AED30.25","amount":"674.25","amount_format":"AED674.25","shipping_amount":"39.00","shipping_amount_format":"AED39.00","status":{"value":"pending","label":"Pending"},"payment_status":{"value":null,"label":""},"payment_method":{"value":null,"label":""},"customer_name":"Dikshit sharma","created_at":"2024-11-24 15:52:05"}]

Data dataFromJson(String str) => Data.fromJson(json.decode(str));

String dataToJson(Data data) => json.encode(data.toJson());

class Data {
  Data({
    Pagination? pagination,
    List<OrderRecords>? records,
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
        _records?.add(OrderRecords.fromJson(v));
      });
    }
  }

  Pagination? _pagination;
  List<OrderRecords>? _records;

  Data copyWith({
    Pagination? pagination,
    List<OrderRecords>? records,
  }) =>
      Data(
        pagination: pagination ?? _pagination,
        records: records ?? _records,
      );

  Pagination? get pagination => _pagination;

  List<OrderRecords>? get records => _records;

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

/// id : 1919
/// code : "#10001919"
/// tax_amount : "0.00"
/// tax_amount_format : "AED0.00"
/// amount : "329.00"
/// amount_format : "AED329.00"
/// shipping_amount : "39.00"
/// shipping_amount_format : "AED39.00"
/// status : {"value":"completed","label":"Completed"}
/// payment_status : {"value":"completed","label":"Completed"}
/// payment_method : {"value":"telr","label":"Telr"}
/// customer_name : null
/// created_at : "2025-01-16 13:34:30"

OrderRecords recordsFromJson(String str) =>
    OrderRecords.fromJson(json.decode(str));

String recordsToJson(OrderRecords data) => json.encode(data.toJson());

class OrderRecords {
  OrderRecords({
    id,
    String? code,
    String? taxAmount,
    String? taxAmountFormat,
    String? amount,
    String? amountFormat,
    String? shippingAmount,
    String? shippingAmountFormat,
    Status? status,
    PaymentStatus? paymentStatus,
    PaymentMethod? paymentMethod,
    customerName,
    String? createdAt,
  }) {
    _id = id;
    _code = code;
    _taxAmount = taxAmount;
    _taxAmountFormat = taxAmountFormat;
    _amount = amount;
    _amountFormat = amountFormat;
    _shippingAmount = shippingAmount;
    _shippingAmountFormat = shippingAmountFormat;
    _status = status;
    _paymentStatus = paymentStatus;
    _paymentMethod = paymentMethod;
    _customerName = customerName;
    _createdAt = createdAt;
    isDeleting = false;
  }

  OrderRecords.fromJson(json) {
    _id = json['id'];
    _code = json['code'];
    _taxAmount = json['tax_amount'];
    _taxAmountFormat = json['tax_amount_format'];
    _amount = json['amount'];
    _amountFormat = json['amount_format'];
    _shippingAmount = json['shipping_amount'];
    _shippingAmountFormat = json['shipping_amount_format'];
    _status = json['status'] != null ? Status.fromJson(json['status']) : null;
    _paymentStatus = json['payment_status'] != null
        ? PaymentStatus.fromJson(json['payment_status'])
        : null;
    _paymentMethod = json['payment_method'] != null
        ? PaymentMethod.fromJson(json['payment_method'])
        : null;
    _customerName = json['customer_name'];
    _createdAt = json['created_at'];
    isDeleting = false;
  }

  dynamic _id;
  String? _code;
  String? _taxAmount;
  String? _taxAmountFormat;
  String? _amount;
  String? _amountFormat;
  String? _shippingAmount;
  String? _shippingAmountFormat;
  Status? _status;
  PaymentStatus? _paymentStatus;
  PaymentMethod? _paymentMethod;
  dynamic _customerName;
  String? _createdAt;
  bool isDeleting = false;

  OrderRecords copyWith({
    id,
    String? code,
    String? taxAmount,
    String? taxAmountFormat,
    String? amount,
    String? amountFormat,
    String? shippingAmount,
    String? shippingAmountFormat,
    Status? status,
    PaymentStatus? paymentStatus,
    PaymentMethod? paymentMethod,
    customerName,
    String? createdAt,
  }) =>
      OrderRecords(
        id: id ?? _id,
        code: code ?? _code,
        taxAmount: taxAmount ?? _taxAmount,
        taxAmountFormat: taxAmountFormat ?? _taxAmountFormat,
        amount: amount ?? _amount,
        amountFormat: amountFormat ?? _amountFormat,
        shippingAmount: shippingAmount ?? _shippingAmount,
        shippingAmountFormat: shippingAmountFormat ?? _shippingAmountFormat,
        status: status ?? _status,
        paymentStatus: paymentStatus ?? _paymentStatus,
        paymentMethod: paymentMethod ?? _paymentMethod,
        customerName: customerName ?? _customerName,
        createdAt: createdAt ?? _createdAt,
      );

  dynamic get id => _id;

  String? get code => _code;

  String? get taxAmount => _taxAmount;

  String? get taxAmountFormat => _taxAmountFormat;

  String? get amount => _amount;

  String? get amountFormat => _amountFormat;

  String? get shippingAmount => _shippingAmount;

  String? get shippingAmountFormat => _shippingAmountFormat;

  Status? get status => _status;

  PaymentStatus? get paymentStatus => _paymentStatus;

  PaymentMethod? get paymentMethod => _paymentMethod;

  dynamic get customerName => _customerName;

  String? get createdAt => _createdAt;


  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['code'] = _code;
    map['tax_amount'] = _taxAmount;
    map['tax_amount_format'] = _taxAmountFormat;
    map['amount'] = _amount;
    map['amount_format'] = _amountFormat;
    map['shipping_amount'] = _shippingAmount;
    map['shipping_amount_format'] = _shippingAmountFormat;
    if (_status != null) {
      map['status'] = _status?.toJson();
    }
    if (_paymentStatus != null) {
      map['payment_status'] = _paymentStatus?.toJson();
    }
    if (_paymentMethod != null) {
      map['payment_method'] = _paymentMethod?.toJson();
    }
    map['customer_name'] = _customerName;
    map['created_at'] = _createdAt;
    return map;
  }
}

/// value : "telr"
/// label : "Telr"

PaymentMethod paymentMethodFromJson(String str) =>
    PaymentMethod.fromJson(json.decode(str));

String paymentMethodToJson(PaymentMethod data) => json.encode(data.toJson());

class PaymentMethod {
  PaymentMethod({
    String? value,
    String? label,
  }) {
    _value = value;
    _label = label;
  }

  PaymentMethod.fromJson(json) {
    _value = json['value'];
    _label = json['label'];
  }

  String? _value;
  String? _label;

  PaymentMethod copyWith({
    String? value,
    String? label,
  }) =>
      PaymentMethod(
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

/// value : "completed"
/// label : "Completed"

PaymentStatus paymentStatusFromJson(String str) =>
    PaymentStatus.fromJson(json.decode(str));

String paymentStatusToJson(PaymentStatus data) => json.encode(data.toJson());

class PaymentStatus {
  PaymentStatus({
    String? value,
    String? label,
  }) {
    _value = value;
    _label = label;
  }

  PaymentStatus.fromJson(json) {
    _value = json['value'];
    _label = json['label'];
  }

  String? _value;
  String? _label;

  PaymentStatus copyWith({
    String? value,
    String? label,
  }) =>
      PaymentStatus(
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

/// value : "completed"
/// label : "Completed"

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

/// total : 5
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
