import 'dart:convert';

/// error : false
/// data : {"payment_method_options":{"bank_transfer":"Bank Transfer","paypal":"PayPal"},"store":{"name":"Abhay Kumar","slug":"wwwshopurlcom","email":"abhay.kumar@gmail.com","phone":"98980446928","address":"vpo lahar","country":"IN","state":"Himachal Pradesh","city":"Hamirpur","title":"Master Company","description":"Description for master company.","content":"<p><strong>Test Content.</strong></p><p><i><u>Hi Abhay</u></i></p><p><span style=\"color:hsl(30,75%,60%);\">How are you?</span></p>","company":"Ampersand","logo":"https://apistaging.theevents.ae/storage/stores/asfsfsfsasfsf/1024-1024-image-3.jpg","cover_image":null},"payment_method":"bank_transfer","bank_info":{"name":"State Bank Of India","code":"111111111","full_name":"111111111","number":"111111111","paypal_id":"hkjhakjhsf","upi_id":"upi@ok","description":"description for payout Info."},"tax_info":{"business_name":"Master Business Kom","tax_id":"123456786543","address":"Vpo lahar"}}
/// message : null

VendorGetSettingsModel vendorGetSettingsModelFromJson(String str) => VendorGetSettingsModel.fromJson(json.decode(str));

String vendorGetSettingsModelToJson(VendorGetSettingsModel data) => json.encode(data.toJson());

class VendorGetSettingsModel {
  VendorGetSettingsModel({
    bool? error,
    Data? data,
    message,
  }) {
    _error = error;
    _data = data;
    _message = message;
  }

  VendorGetSettingsModel.fromJson(json) {
    _error = json['error'];
    _data = json['data'] != null ? Data.fromJson(json['data']) : null;
    _message = json['message'];
  }

  bool? _error;
  Data? _data;
  dynamic _message;

  VendorGetSettingsModel copyWith({
    bool? error,
    Data? data,
    message,
  }) =>
      VendorGetSettingsModel(
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

/// payment_method_options : {"bank_transfer":"Bank Transfer","paypal":"PayPal"}
/// store : {"name":"Abhay Kumar","slug":"wwwshopurlcom","email":"abhay.kumar@gmail.com","phone":"98980446928","address":"vpo lahar","country":"IN","state":"Himachal Pradesh","city":"Hamirpur","title":"Master Company","description":"Description for master company.","content":"<p><strong>Test Content.</strong></p><p><i><u>Hi Abhay</u></i></p><p><span style=\"color:hsl(30,75%,60%);\">How are you?</span></p>","company":"Ampersand","logo":"https://apistaging.theevents.ae/storage/stores/asfsfsfsasfsf/1024-1024-image-3.jpg","cover_image":null}
/// payment_method : "bank_transfer"
/// bank_info : {"name":"State Bank Of India","code":"111111111","full_name":"111111111","number":"111111111","paypal_id":"hkjhakjhsf","upi_id":"upi@ok","description":"description for payout Info."}
/// tax_info : {"business_name":"Master Business Kom","tax_id":"123456786543","address":"Vpo lahar"}

Data dataFromJson(String str) => Data.fromJson(json.decode(str));

String dataToJson(Data data) => json.encode(data.toJson());

class Data {
  Data({
    PaymentMethodOptions? paymentMethodOptions,
    Store? store,
    String? paymentMethod,
    BankInfo? bankInfo,
    TaxInfo? taxInfo,
  }) {
    _paymentMethodOptions = paymentMethodOptions;
    _store = store;
    _paymentMethod = paymentMethod;
    _bankInfo = bankInfo;
    _taxInfo = taxInfo;
  }

  Data.fromJson(json) {
    _paymentMethodOptions =
        json['payment_method_options'] != null ? PaymentMethodOptions.fromJson(json['payment_method_options']) : null;
    _store = (json['store'] != null && json['store'] is Map) ? Store.fromJson(json['store']) : null;
    _paymentMethod = json['payment_method'];
    _bankInfo = json['bank_info'] != null ? BankInfo.fromJson(json['bank_info']) : null;
    _taxInfo = json['tax_info'] != null ? TaxInfo.fromJson(json['tax_info']) : null;
  }

  PaymentMethodOptions? _paymentMethodOptions;
  Store? _store;
  String? _paymentMethod;
  BankInfo? _bankInfo;
  TaxInfo? _taxInfo;

  Data copyWith({
    PaymentMethodOptions? paymentMethodOptions,
    Store? store,
    String? paymentMethod,
    BankInfo? bankInfo,
    TaxInfo? taxInfo,
  }) =>
      Data(
        paymentMethodOptions: paymentMethodOptions ?? _paymentMethodOptions,
        store: store ?? _store,
        paymentMethod: paymentMethod ?? _paymentMethod,
        bankInfo: bankInfo ?? _bankInfo,
        taxInfo: taxInfo ?? _taxInfo,
      );

  PaymentMethodOptions? get paymentMethodOptions => _paymentMethodOptions;

  Store? get store => _store;

  String? get paymentMethod => _paymentMethod;

  BankInfo? get bankInfo => _bankInfo;

  TaxInfo? get taxInfo => _taxInfo;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_paymentMethodOptions != null) {
      map['payment_method_options'] = _paymentMethodOptions?.toJson();
    }
    if (_store != null) {
      map['store'] = _store?.toJson();
    }
    map['payment_method'] = _paymentMethod;
    if (_bankInfo != null) {
      map['bank_info'] = _bankInfo?.toJson();
    }
    if (_taxInfo != null) {
      map['tax_info'] = _taxInfo?.toJson();
    }
    return map;
  }
}

/// business_name : "Master Business Kom"
/// tax_id : "123456786543"
/// address : "Vpo lahar"

TaxInfo taxInfoFromJson(String str) => TaxInfo.fromJson(json.decode(str));

String taxInfoToJson(TaxInfo data) => json.encode(data.toJson());

class TaxInfo {
  TaxInfo({
    String? businessName,
    String? taxId,
    String? address,
  }) {
    _businessName = businessName;
    _taxId = taxId;
    _address = address;
  }

  TaxInfo.fromJson(json) {
    _businessName = json['business_name'];
    _taxId = json['tax_id'];
    _address = json['address'];
  }

  String? _businessName;
  String? _taxId;
  String? _address;

  TaxInfo copyWith({
    String? businessName,
    String? taxId,
    String? address,
  }) =>
      TaxInfo(
        businessName: businessName ?? _businessName,
        taxId: taxId ?? _taxId,
        address: address ?? _address,
      );

  String? get businessName => _businessName;

  String? get taxId => _taxId;

  String? get address => _address;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['business_name'] = _businessName;
    map['tax_id'] = _taxId;
    map['address'] = _address;
    return map;
  }
}

/// name : "State Bank Of India"
/// code : "111111111"
/// full_name : "111111111"
/// number : "111111111"
/// paypal_id : "hkjhakjhsf"
/// upi_id : "upi@ok"
/// description : "description for payout Info."

BankInfo bankInfoFromJson(String str) => BankInfo.fromJson(json.decode(str));

String bankInfoToJson(BankInfo data) => json.encode(data.toJson());

class BankInfo {
  BankInfo({
    String? name,
    String? code,
    String? fullName,
    String? number,
    String? paypalId,
    String? upiId,
    String? description,
  }) {
    _name = name;
    _code = code;
    _fullName = fullName;
    _number = number;
    _paypalId = paypalId;
    _upiId = upiId;
    _description = description;
  }

  BankInfo.fromJson(json) {
    _name = json['name'];
    _code = json['code'];
    _fullName = json['full_name'];
    _number = json['number'];
    _paypalId = json['paypal_id'];
    _upiId = json['upi_id'];
    _description = json['description'];
  }

  String? _name;
  String? _code;
  String? _fullName;
  String? _number;
  String? _paypalId;
  String? _upiId;
  String? _description;

  BankInfo copyWith({
    String? name,
    String? code,
    String? fullName,
    String? number,
    String? paypalId,
    String? upiId,
    String? description,
  }) =>
      BankInfo(
        name: name ?? _name,
        code: code ?? _code,
        fullName: fullName ?? _fullName,
        number: number ?? _number,
        paypalId: paypalId ?? _paypalId,
        upiId: upiId ?? _upiId,
        description: description ?? _description,
      );

  String? get name => _name;

  String? get code => _code;

  String? get fullName => _fullName;

  String? get number => _number;

  String? get paypalId => _paypalId;

  String? get upiId => _upiId;

  String? get description => _description;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['name'] = _name;
    map['code'] = _code;
    map['full_name'] = _fullName;
    map['number'] = _number;
    map['paypal_id'] = _paypalId;
    map['upi_id'] = _upiId;
    map['description'] = _description;
    return map;
  }
}

/// name : "Abhay Kumar"
/// slug : "wwwshopurlcom"
/// email : "abhay.kumar@gmail.com"
/// phone : "98980446928"
/// address : "vpo lahar"
/// country : "IN"
/// state : "Himachal Pradesh"
/// city : "Hamirpur"
/// title : "Master Company"
/// description : "Description for master company."
/// content : "<p><strong>Test Content.</strong></p><p><i><u>Hi Abhay</u></i></p><p><span style=\"color:hsl(30,75%,60%);\">How are you?</span></p>"
/// company : "Ampersand"
/// logo : "https://apistaging.theevents.ae/storage/stores/asfsfsfsasfsf/1024-1024-image-3.jpg"
/// cover_image : null

Store storeFromJson(String str) => Store.fromJson(json.decode(str));

String storeToJson(Store data) => json.encode(data.toJson());

class Store {
  Store({
    String? name,
    String? slug,
    String? email,
    String? phone,
    String? address,
    String? country,
    String? state,
    String? city,
    String? title,
    String? description,
    String? content,
    String? company,
    String? logo,
    coverImage,
  }) {
    _name = name;
    _slug = slug;
    _email = email;
    _phone = phone;
    _address = address;
    _country = country;
    _state = state;
    _city = city;
    _title = title;
    _description = description;
    _content = content;
    _company = company;
    _logo = logo;
    _coverImage = coverImage;
  }

  Store.fromJson(dynamic json) {
    if (json == null || json is List) {
      _name = '';
      _slug = '';
      _email = '';
      _phone = '';
      _address = '';
      _country = '';
      _state = '';
      _city = '';
      _title = '';
      _description = '';
      _content = '';
      _company = '';
      _logo = '';
      _coverImage = null;
      return;
    }
    _name = json['name'];
    _slug = json['slug'];
    _email = json['email'];
    _phone = json['phone'];
    _address = json['address'];
    _country = json['country'];
    _state = json['state'];
    _city = json['city'];
    _title = json['title'];
    _description = json['description'];
    _content = json['content'];
    _company = json['company'];
    _logo = json['logo'];
    _coverImage = json['cover_image'];
  }

  String? _name;
  String? _slug;
  String? _email;
  String? _phone;
  String? _address;
  String? _country;
  String? _state;
  String? _city;
  String? _title;
  String? _description;
  String? _content;
  String? _company;
  String? _logo;
  dynamic _coverImage;

  Store copyWith({
    String? name,
    String? slug,
    String? email,
    String? phone,
    String? address,
    String? country,
    String? state,
    String? city,
    String? title,
    String? description,
    String? content,
    String? company,
    String? logo,
    coverImage,
  }) =>
      Store(
        name: name ?? _name,
        slug: slug ?? _slug,
        email: email ?? _email,
        phone: phone ?? _phone,
        address: address ?? _address,
        country: country ?? _country,
        state: state ?? _state,
        city: city ?? _city,
        title: title ?? _title,
        description: description ?? _description,
        content: content ?? _content,
        company: company ?? _company,
        logo: logo ?? _logo,
        coverImage: coverImage ?? _coverImage,
      );

  String? get name => _name;

  String? get slug => _slug;

  String? get email => _email;

  String? get phone => _phone;

  String? get address => _address;

  String? get country => _country;

  String? get state => _state;

  String? get city => _city;

  String? get title => _title;

  String? get description => _description;

  String? get content => _content;

  String? get company => _company;

  String? get logo => _logo;

  dynamic get coverImage => _coverImage;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['name'] = _name;
    map['slug'] = _slug;
    map['email'] = _email;
    map['phone'] = _phone;
    map['address'] = _address;
    map['country'] = _country;
    map['state'] = _state;
    map['city'] = _city;
    map['title'] = _title;
    map['description'] = _description;
    map['content'] = _content;
    map['company'] = _company;
    map['logo'] = _logo;
    map['cover_image'] = _coverImage;
    return map;
  }
}

/// bank_transfer : "Bank Transfer"
/// paypal : "PayPal"

PaymentMethodOptions paymentMethodOptionsFromJson(String str) => PaymentMethodOptions.fromJson(json.decode(str));

String paymentMethodOptionsToJson(PaymentMethodOptions data) => json.encode(data.toJson());

class PaymentMethodOptions {
  PaymentMethodOptions({
    String? bankTransfer,
    String? paypal,
  }) {
    _bankTransfer = bankTransfer;
    _paypal = paypal;
  }

  PaymentMethodOptions.fromJson(json) {
    _bankTransfer = json['bank_transfer'];
    _paypal = json['paypal'];
  }

  String? _bankTransfer;
  String? _paypal;

  PaymentMethodOptions copyWith({
    String? bankTransfer,
    String? paypal,
  }) =>
      PaymentMethodOptions(
        bankTransfer: bankTransfer ?? _bankTransfer,
        paypal: paypal ?? _paypal,
      );

  String? get bankTransfer => _bankTransfer;

  String? get paypal => _paypal;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['bank_transfer'] = _bankTransfer;
    map['paypal'] = _paypal;
    return map;
  }
}
