import 'dart:convert';

VendorGetOrderDetailsModel vendorGetOrderDetailsModelFromJson(String str) => VendorGetOrderDetailsModel.fromJson(json.decode(str));

String vendorGetOrderDetailsModelToJson(VendorGetOrderDetailsModel data) => json.encode(data.toJson());

class VendorGetOrderDetailsModel {
  VendorGetOrderDetailsModel({
    bool? error,
    Data? data,
    dynamic message,
  }) {
    _error = error;
    _data = data;
    _message = message;
  }

  VendorGetOrderDetailsModel.fromJson(dynamic json) {
    _error = json['error'];
    _data = json['data'] != null ? Data.fromJson(json['data']) : null;
    _message = json['message'];
  }

  bool? _error;
  Data? _data;
  dynamic _message;

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

Data dataFromJson(String str) => Data.fromJson(json.decode(str));

String dataToJson(Data data) => json.encode(data.toJson());

class Data {
  Data({
    dynamic? id,
    String? code,
    dynamic? digitalProductsCount,
    bool? orderCompleted,
    OrderStatus? orderStatus,
    String? subTotal,
    String? subTotalFormat,
    dynamic discountDescription,
    String? discountAmount,
    String? discountAmountFormat,
    String? shippingMethodName,
    String? weight,
    String? shippingAmount,
    String? shippingAmountFormat,
    String? taxAmount,
    String? taxAmountFormat,
    String? paymentChannel,
    String? amount,
    String? amountFormat,
    PaymentStatus? paymentStatus,
    dynamic description,
    List<Items>? items,
    bool? isConfirmed,
    bool? isCanceled,
    bool? cancelEnabled,
    bool? shippingEnabled,
    Shipping? shipping,
    dynamic billing,
    Customer? customer,
    Shipment? shipment,
    List<History>? history,
    List<ShippingStatuses>? shippingStatuses,
    String? createdAt,
  }) {
    _id = id;
    _code = code;
    _digitalProductsCount = digitalProductsCount;
    _orderCompleted = orderCompleted;
    _orderStatus = orderStatus;
    _subTotal = subTotal;
    _subTotalFormat = subTotalFormat;
    _discountDescription = discountDescription;
    _discountAmount = discountAmount;
    _discountAmountFormat = discountAmountFormat;
    _shippingMethodName = shippingMethodName;
    _weight = weight;
    _shippingAmount = shippingAmount;
    _shippingAmountFormat = shippingAmountFormat;
    _taxAmount = taxAmount;
    _taxAmountFormat = taxAmountFormat;
    _paymentChannel = paymentChannel;
    _amount = amount;
    _amountFormat = amountFormat;
    _paymentStatus = paymentStatus;
    _description = description;
    _items = items;
    _isConfirmed = isConfirmed;
    _isCanceled = isCanceled;
    _shippingEnabled = shippingEnabled;
    _cancelEnabled = cancelEnabled;
    _shipping = shipping;
    _billing = billing;
    _customer = customer;
    _shipment = shipment;
    _history = history;
    _shippingStatuses = shippingStatuses;
    _createdAt = createdAt;
  }

  Data.fromJson(dynamic json) {
    _id = json['id'];
    _code = json['code'];
    _digitalProductsCount = json['digital_products_count'];
    _orderCompleted = json['order_completed'];
    _orderStatus = json['order_status'] != null ? OrderStatus.fromJson(json['order_status']) : null;
    _subTotal = json['sub_total'];
    _subTotalFormat = json['sub_total_format'];
    _discountDescription = json['discount_description'];
    _discountAmount = json['discount_amount'];
    _discountAmountFormat = json['discount_amount_format'];
    _shippingMethodName = json['shipping_method_name'];
    _weight = json['weight'];
    _shippingAmount = json['shipping_amount'];
    _shippingAmountFormat = json['shipping_amount_format'];
    _taxAmount = json['tax_amount'];
    _taxAmountFormat = json['tax_amount_format'];
    _paymentChannel = json['payment_channel'];
    _amount = json['amount'];
    _amountFormat = json['amount_format'];
    _paymentStatus = json['payment_status'] != null ? PaymentStatus.fromJson(json['payment_status']) : null;
    _description = json['description'];
    if (json['items'] != null) {
      _items = [];
      json['items'].forEach((v) {
        _items?.add(Items.fromJson(v));
      });
    }
    _isConfirmed = json['is_confirmed'];
    _isCanceled = json['is_canceled'];
    _shippingEnabled = json['shipping_enabled'];
    _cancelEnabled = json['cancel_enabled'];
    _shipping = json['shipping'] != null ? Shipping.fromJson(json['shipping']) : null;
    _billing = json['billing'];
    _customer = json['customer'] != null ? Customer.fromJson(json['customer']) : null;
    _shipment = json['shipment'] != null ? Shipment.fromJson(json['shipment']) : null;
    if (json['history'] != null) {
      _history = [];
      json['history'].forEach((v) {
        _history?.add(History.fromJson(v));
      });
    }
    if (json['shipping_statuses'] != null) {
      _shippingStatuses = [];
      json['shipping_statuses'].forEach((v) {
        _shippingStatuses?.add(ShippingStatuses.fromJson(v));
      });
    }
    _createdAt = json['created_at'];
  }

  dynamic? _id;
  String? _code;
  dynamic? _digitalProductsCount;
  bool? _orderCompleted;
  OrderStatus? _orderStatus;
  String? _subTotal;
  String? _subTotalFormat;
  dynamic _discountDescription;
  String? _discountAmount;
  String? _discountAmountFormat;
  String? _shippingMethodName;
  String? _weight;
  String? _shippingAmount;
  String? _shippingAmountFormat;
  String? _taxAmount;
  String? _taxAmountFormat;
  String? _paymentChannel;
  String? _amount;
  String? _amountFormat;
  PaymentStatus? _paymentStatus;
  dynamic _description;
  List<Items>? _items;
  bool? _isConfirmed;
  bool? _isCanceled;
  bool? _shippingEnabled;
  bool? _cancelEnabled;
  Shipping? _shipping;
  dynamic _billing;
  Customer? _customer;
  Shipment? _shipment;
  List<History>? _history;
  List<ShippingStatuses>? _shippingStatuses;
  String? _createdAt;

  dynamic? get id => _id;

  String? get code => _code;

  dynamic? get digitalProductsCount => _digitalProductsCount;

  bool? get orderCompleted => _orderCompleted;

  OrderStatus? get orderStatus => _orderStatus;

  String? get subTotal => _subTotal;

  String? get subTotalFormat => _subTotalFormat;

  dynamic get discountDescription => _discountDescription;

  String? get discountAmount => _discountAmount;

  String? get discountAmountFormat => _discountAmountFormat;

  String? get shippingMethodName => _shippingMethodName;

  String? get weight => _weight;

  String? get shippingAmount => _shippingAmount;

  String? get shippingAmountFormat => _shippingAmountFormat;

  String? get taxAmount => _taxAmount;

  String? get taxAmountFormat => _taxAmountFormat;

  String? get paymentChannel => _paymentChannel;

  String? get amount => _amount;

  String? get amountFormat => _amountFormat;

  PaymentStatus? get paymentStatus => _paymentStatus;

  dynamic get description => _description;

  List<Items>? get items => _items;

  bool? get isConfirmed => _isConfirmed;

  bool? get isCanceled => _isCanceled;

  bool? get shippingEnabled => _shippingEnabled;

  bool? get cancelEnabled => _cancelEnabled;

  Shipping? get shipping => _shipping;

  dynamic get billing => _billing;

  Customer? get customer => _customer;

  Shipment? get shipment => _shipment;

  List<History>? get history => _history;

  List<ShippingStatuses>? get shippingStatuses => _shippingStatuses;

  String? get createdAt => _createdAt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['code'] = _code;
    map['digital_products_count'] = _digitalProductsCount;
    map['order_completed'] = _orderCompleted;
    if (_orderStatus != null) {
      map['order_status'] = _orderStatus?.toJson();
    }
    map['sub_total'] = _subTotal;
    map['sub_total_format'] = _subTotalFormat;
    map['discount_description'] = _discountDescription;
    map['discount_amount'] = _discountAmount;
    map['discount_amount_format'] = _discountAmountFormat;
    map['shipping_method_name'] = _shippingMethodName;
    map['weight'] = _weight;
    map['shipping_amount'] = _shippingAmount;
    map['shipping_amount_format'] = _shippingAmountFormat;
    map['tax_amount'] = _taxAmount;
    map['tax_amount_format'] = _taxAmountFormat;
    map['payment_channel'] = _paymentChannel;
    map['amount'] = _amount;
    map['amount_format'] = _amountFormat;
    if (_paymentStatus != null) {
      map['payment_status'] = _paymentStatus?.toJson();
    }
    map['description'] = _description;
    if (_items != null) {
      map['items'] = _items?.map((v) => v.toJson()).toList();
    }
    map['is_confirmed'] = _isConfirmed;
    map['is_canceled'] = _isCanceled;
    map['cancel_enabled'] = _cancelEnabled;
    if (_shipping != null) {
      map['shipping'] = _shipping?.toJson();
    }
    map['billing'] = _billing;
    if (_customer != null) {
      map['customer'] = _customer?.toJson();
    }
    if (_shipment != null) {
      map['shipment'] = _shipment?.toJson();
    }
    if (_history != null) {
      map['history'] = _history?.map((v) => v.toJson()).toList();
    }
    if (_shippingStatuses != null) {
      map['shipping_statuses'] = _shippingStatuses?.map((v) => v.toJson()).toList();
    }
    map['created_at'] = _createdAt;
    return map;
  }
}

ShippingStatuses shippingStatusesFromJson(String str) => ShippingStatuses.fromJson(json.decode(str));

String shippingStatusesToJson(ShippingStatuses data) => json.encode(data.toJson());

class ShippingStatuses {
  ShippingStatuses({
    String? label,
    String? value,
    String? statusClass,
  }) {
    _label = label;
    _value = value;
    _class = statusClass;
  }

  ShippingStatuses.fromJson(dynamic json) {
    _label = json['label'];
    _value = json['value'];
    _class = json['class'];
  }

  String? _label;
  String? _value;
  String? _class;

  String? get label => _label;

  String? get value => _value;

  String? get statusClass => _class;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['label'] = _label;
    map['value'] = _value;
    map['class'] = _class;
    return map;
  }
}

History historyFromJson(String str) => History.fromJson(json.decode(str));

String historyToJson(History data) => json.encode(data.toJson());

class History {
  History({
    dynamic? id,
    String? action,
    String? historyVariables,
    String? createdAt,
  }) {
    _id = id;
    _action = action;
    _historyVariables = historyVariables;
    _createdAt = createdAt;
  }

  History.fromJson(dynamic json) {
    _id = json['id'];
    _action = json['action'];
    _historyVariables = json['history_variables'];
    _createdAt = json['created_at'];
  }

  dynamic? _id;
  String? _action;
  String? _historyVariables;
  String? _createdAt;

  dynamic? get id => _id;

  String? get action => _action;

  String? get historyVariables => _historyVariables;

  String? get createdAt => _createdAt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['action'] = _action;
    map['history_variables'] = _historyVariables;
    map['created_at'] = _createdAt;
    return map;
  }
}

Shipment shipmentFromJson(String str) => Shipment.fromJson(json.decode(str));

String shipmentToJson(Shipment data) => json.encode(data.toJson());

class Shipment {
  Shipment({
    dynamic? id,
    String? name,
    Status? status,
    String? shippingMethodName,
    String? weight,
    String? updatedAt,
    dynamic codAmount,
    dynamic codAmountFormat,
    dynamic deliveryNote,
  }) {
    _id = id;
    _name = name;
    _status = status;
    _shippingMethodName = shippingMethodName;
    _weight = weight;
    _updatedAt = updatedAt;
    _codAmount = codAmount;
    _codAmountFormat = codAmountFormat;
    _deliveryNote = deliveryNote;
  }

  Shipment.fromJson(dynamic json) {
    _id = json['id'];
    _name = json['name'];
    _status = json['status'] != null ? Status.fromJson(json['status']) : null;
    _shippingMethodName = json['shipping_method_name'];
    _weight = json['weight'];
    _updatedAt = json['updated_at'];
    _codAmount = json['cod_amount'];
    _codAmountFormat = json['cod_amount_format'];
    _deliveryNote = json['delivery_note'];
  }

  dynamic? _id;
  String? _name;
  Status? _status;
  String? _shippingMethodName;
  String? _weight;
  String? _updatedAt;
  dynamic _codAmount;
  dynamic _codAmountFormat;
  dynamic _deliveryNote;

  dynamic? get id => _id;

  String? get name => _name;

  Status? get status => _status;

  String? get shippingMethodName => _shippingMethodName;

  String? get weight => _weight;

  String? get updatedAt => _updatedAt;

  dynamic get codAmount => _codAmount;

  dynamic get codAmountFormat => _codAmountFormat;

  dynamic get deliveryNote => _deliveryNote;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['name'] = _name;
    if (_status != null) {
      map['status'] = _status?.toJson();
    }
    map['shipping_method_name'] = _shippingMethodName;
    map['weight'] = _weight;
    map['updated_at'] = _updatedAt;
    map['cod_amount'] = _codAmount;
    map['cod_amount_format'] = _codAmountFormat;
    map['delivery_note'] = _deliveryNote;
    return map;
  }
}

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

  Status.fromJson(dynamic json) {
    _value = json['value'];
    _label = json['label'];
  }

  String? _value;
  String? _label;

  String? get value => _value;

  String? get label => _label;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['value'] = _value;
    map['label'] = _label;
    return map;
  }
}

Customer customerFromJson(String str) => Customer.fromJson(json.decode(str));

String customerToJson(Customer data) => json.encode(data.toJson());

class Customer {
  Customer({
    String? name,
    String? email,
    dynamic? totalOrders,
    String? avatarUrl,
    String? haveAccountMessage,
  }) {
    _name = name;
    _email = email;
    _totalOrders = totalOrders;
    _avatarUrl = avatarUrl;
    _haveAccountMessage = haveAccountMessage;
  }

  Customer.fromJson(dynamic json) {
    _name = json['name'];
    _email = json['email'];
    _totalOrders = json['total_orders'];
    _avatarUrl = json['avatar_url'];
    _haveAccountMessage = json['have_account_message'];
  }

  String? _name;
  String? _email;
  dynamic? _totalOrders;
  String? _avatarUrl;
  String? _haveAccountMessage;

  String? get name => _name;

  String? get email => _email;

  dynamic? get totalOrders => _totalOrders;

  String? get avatarUrl => _avatarUrl;

  String? get haveAccountMessage => _haveAccountMessage;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['name'] = _name;
    map['email'] = _email;
    map['total_orders'] = _totalOrders;
    map['avatar_url'] = _avatarUrl;
    map['have_account_message'] = _haveAccountMessage;
    return map;
  }
}

Shipping shippingFromJson(String str) => Shipping.fromJson(json.decode(str));

String shippingToJson(Shipping data) => json.encode(data.toJson());

class Shipping {
  Shipping({
    dynamic? id,
    String? name,
    String? email,
    String? phone,
    String? address,
    String? cityName,
    String? stateName,
    String? countryName,
    dynamic zipCode,
  }) {
    _id = id;
    _name = name;
    _email = email;
    _phone = phone;
    _address = address;
    _cityName = cityName;
    _stateName = stateName;
    _countryName = countryName;
    _zipCode = zipCode;
  }

  Shipping.fromJson(dynamic json) {
    _id = json['id'];
    _name = json['name'];
    _email = json['email'];
    _phone = json['phone'];
    _address = json['address'];
    _cityName = json['city_name'];
    _stateName = json['state_name'];
    _countryName = json['country_name'];
    _zipCode = json['zip_code'];
  }

  dynamic? _id;
  String? _name;
  String? _email;
  String? _phone;
  String? _address;
  String? _cityName;
  String? _stateName;
  String? _countryName;
  dynamic _zipCode;

  dynamic? get id => _id;

  String? get name => _name;

  String? get email => _email;

  String? get phone => _phone;

  String? get address => _address;

  String? get cityName => _cityName;

  String? get stateName => _stateName;

  String? get countryName => _countryName;

  dynamic get zipCode => _zipCode;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['name'] = _name;
    map['email'] = _email;
    map['phone'] = _phone;
    map['address'] = _address;
    map['city_name'] = _cityName;
    map['state_name'] = _stateName;
    map['country_name'] = _countryName;
    map['zip_code'] = _zipCode;
    return map;
  }
}

Items itemsFromJson(String str) => Items.fromJson(json.decode(str));

String itemsToJson(Items data) => json.encode(data.toJson());

class Items {
  Items({
    dynamic? id,
    String? name,
    String? image,
    String? sku,
    String? attributes,
    String? shippingMethodName,
    dynamic? qty,
    dynamic? price,
    String? priceFormat,
    dynamic? totalAmount,
    String? totalAmountFormat,
  }) {
    _id = id;
    _name = name;
    _image = image;
    _sku = sku;
    _attributes = attributes;
    _shippingMethodName = shippingMethodName;
    _qty = qty;
    _price = price;
    _priceFormat = priceFormat;
    _totalAmount = totalAmount;
    _totalAmountFormat = totalAmountFormat;
  }

  Items.fromJson(dynamic json) {
    _id = json['id'];
    _name = json['name'];
    _image = json['image'];
    _sku = json['sku'];
    _attributes = json['attributes'];
    _shippingMethodName = json['shipping_method_name'];
    _qty = json['qty'];
    _price = json['price'];
    _priceFormat = json['price_format'];
    _totalAmount = json['total_amount'];
    _totalAmountFormat = json['total_amount_format'];
  }

  dynamic? _id;
  String? _name;
  String? _image;
  String? _sku;
  String? _attributes;
  String? _shippingMethodName;
  dynamic? _qty;
  dynamic? _price;
  String? _priceFormat;
  dynamic? _totalAmount;
  String? _totalAmountFormat;

  dynamic? get id => _id;

  String? get name => _name;

  String? get image => _image;

  String? get sku => _sku;

  String? get attributes => _attributes;

  String? get shippingMethodName => _shippingMethodName;

  dynamic? get qty => _qty;

  dynamic? get price => _price;

  String? get priceFormat => _priceFormat;

  dynamic? get totalAmount => _totalAmount;

  String? get totalAmountFormat => _totalAmountFormat;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['name'] = _name;
    map['image'] = _image;
    map['sku'] = _sku;
    map['attributes'] = _attributes;
    map['shipping_method_name'] = _shippingMethodName;
    map['qty'] = _qty;
    map['price'] = _price;
    map['price_format'] = _priceFormat;
    map['total_amount'] = _totalAmount;
    map['total_amount_format'] = _totalAmountFormat;
    return map;
  }
}

PaymentStatus paymentStatusFromJson(String str) => PaymentStatus.fromJson(json.decode(str));

String paymentStatusToJson(PaymentStatus data) => json.encode(data.toJson());

class PaymentStatus {
  PaymentStatus({
    String? value,
    String? label,
  }) {
    _value = value;
    _label = label;
  }

  PaymentStatus.fromJson(dynamic json) {
    _value = json['value'];
    _label = json['label'];
  }

  String? _value;
  String? _label;

  String? get value => _value;

  String? get label => _label;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['value'] = _value;
    map['label'] = _label;
    return map;
  }
}

OrderStatus orderStatusFromJson(String str) => OrderStatus.fromJson(json.decode(str));

String orderStatusToJson(OrderStatus data) => json.encode(data.toJson());

class OrderStatus {
  OrderStatus({
    String? value,
    String? label,
  }) {
    _value = value;
    _label = label;
  }

  OrderStatus.fromJson(dynamic json) {
    _value = json['value'];
    _label = json['label'];
  }

  String? _value;
  String? _label;

  String? get value => _value;

  String? get label => _label;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['value'] = _value;
    map['label'] = _label;
    return map;
  }
}
