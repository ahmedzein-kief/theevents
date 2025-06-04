import 'dart:convert';

import '../products/vendor_get_product_general_settings_model.dart';

VendorGetPackageGeneralSettingsModel
    vendorGetPackageGeneralSettingsModelFromJson(String str) =>
        VendorGetPackageGeneralSettingsModel.fromJson(json.decode(str));
String vendorGetPackageGeneralSettingsModelToJson(
        VendorGetPackageGeneralSettingsModel data) =>
    json.encode(data.toJson());

class VendorGetPackageGeneralSettingsModel {
  VendorGetPackageGeneralSettingsModel({
    bool? error,
    Data? data,
    message,
  }) {
    _error = error;
    _data = data;
    _message = message;
  }

  VendorGetPackageGeneralSettingsModel.fromJson(json) {
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
    List<StockStatuses>? stockStatuses,
    String? sku,
    List<Brands>? brands,
    List<Faqs>? faqs,
    List<ProductCollections>? productCollections,
    List<ProductLabels>? productLabels,
    List<String>? productTypes,
    int? defaultDiscountPercent,
    bool? isTaxEnabled,
    bool? isEnabledProductOptions,
    List<Taxes>? taxes,
    List<GlobalOptions>? globalOptions,
    GlobalOptionsEnum? globalOptionsEnum,
    List<ProductCategories>? productCategories,
    List<dynamic>? productAttributeSets,
  }) {
    _stockStatuses = stockStatuses;
    _sku = sku;
    _brands = brands;
    _faqs = faqs;
    _productCollections = productCollections;
    _productLabels = productLabels;
    _productTypes = productTypes;
    _defaultDiscountPercent = defaultDiscountPercent;
    _isTaxEnabled = isTaxEnabled;
    _isEnabledProductOptions = isEnabledProductOptions;
    _taxes = taxes;
    _globalOptions = globalOptions;
    _globalOptionsEnum = globalOptionsEnum;
    _productCategories = productCategories;
    _productAttributeSets = productAttributeSets;
  }

  Data.fromJson(json) {
    if (json['stockStatuses'] != null) {
      _stockStatuses = [];
      json['stockStatuses'].forEach((v) {
        _stockStatuses?.add(StockStatuses.fromJson(v));
      });
    }
    _sku = json['sku'];
    if (json['brands'] != null) {
      _brands = [];
      json['brands'].forEach((v) {
        _brands?.add(Brands.fromJson(v));
      });
    }
    if (json['faqs'] != null) {
      _faqs = [];
      json['faqs'].forEach((v) {
        _faqs?.add(Faqs.fromJson(v));
      });
    }
    if (json['productCollections'] != null) {
      _productCollections = [];
      json['productCollections'].forEach((v) {
        _productCollections?.add(ProductCollections.fromJson(v));
      });
    }
    if (json['productLabels'] != null) {
      _productLabels = [];
      json['productLabels'].forEach((v) {
        _productLabels?.add(ProductLabels.fromJson(v));
      });
    }
    _productTypes =
        json['productTypes'] != null ? json['productTypes'].cast<String>() : [];
    _defaultDiscountPercent = json['defaultDiscountPercent'];
    _isTaxEnabled = json['isTaxEnabled'];
    _isEnabledProductOptions = json['isEnabledProductOptions'];
    if (json['taxes'] != null) {
      _taxes = [];
      json['taxes'].forEach((v) {
        _taxes?.add(Taxes.fromJson(v));
      });
    }
    if (json['globalOptions'] != null) {
      _globalOptions = [];
      json['globalOptions'].forEach((v) {
        _globalOptions?.add(GlobalOptions.fromJson(v));
      });
    }
    _globalOptionsEnum = json['globalOptionsEnum'] != null
        ? GlobalOptionsEnum.fromJson(json['globalOptionsEnum'])
        : null;
    if (json['productCategories'] != null) {
      _productCategories = [];
      json['productCategories'].forEach((v) {
        _productCategories?.add(ProductCategories.fromJson(v));
      });
    }
    if (json['productAttributeSets'] != null) {
      _productAttributeSets = [];
      json['productAttributeSets'].forEach((v) {
        _productAttributeSets?.add(ProductAttributeSets.fromJson(v));
      });
    }
  }
  List<StockStatuses>? _stockStatuses;
  String? _sku;
  List<Brands>? _brands;
  List<Faqs>? _faqs;
  List<ProductCollections>? _productCollections;
  List<ProductLabels>? _productLabels;
  List<String>? _productTypes;
  int? _defaultDiscountPercent;
  bool? _isTaxEnabled;
  bool? _isEnabledProductOptions;
  List<Taxes>? _taxes;
  List<GlobalOptions>? _globalOptions;
  GlobalOptionsEnum? _globalOptionsEnum;
  List<ProductCategories>? _productCategories;
  List<dynamic>? _productAttributeSets;

  List<StockStatuses>? get stockStatuses => _stockStatuses;
  String? get sku => _sku;
  List<Brands>? get brands => _brands;
  List<Faqs>? get faqs => _faqs;
  List<ProductCollections>? get productCollections => _productCollections;
  List<ProductLabels>? get productLabels => _productLabels;
  List<String>? get productTypes => _productTypes;
  int? get defaultDiscountPercent => _defaultDiscountPercent;
  bool? get isTaxEnabled => _isTaxEnabled;
  bool? get isEnabledProductOptions => _isEnabledProductOptions;
  List<Taxes>? get taxes => _taxes;
  List<GlobalOptions>? get globalOptions => _globalOptions;
  GlobalOptionsEnum? get globalOptionsEnum => _globalOptionsEnum;
  List<ProductCategories>? get productCategories => _productCategories;
  List<dynamic>? get productAttributeSets => _productAttributeSets;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_stockStatuses != null) {
      map['stockStatuses'] = _stockStatuses?.map((v) => v.toJson()).toList();
    }
    map['sku'] = _sku;
    if (_brands != null) {
      map['brands'] = _brands?.map((v) => v.toJson()).toList();
    }
    if (_faqs != null) {
      map['faqs'] = _faqs?.map((v) => v.toJson()).toList();
    }
    if (_productCollections != null) {
      map['productCollections'] =
          _productCollections?.map((v) => v.toJson()).toList();
    }
    if (_productLabels != null) {
      map['productLabels'] = _productLabels?.map((v) => v.toJson()).toList();
    }
    map['productTypes'] = _productTypes;
    map['defaultDiscountPercent'] = _defaultDiscountPercent;
    map['isTaxEnabled'] = _isTaxEnabled;
    map['isEnabledProductOptions'] = _isEnabledProductOptions;
    if (_taxes != null) {
      map['taxes'] = _taxes?.map((v) => v.toJson()).toList();
    }
    if (_globalOptions != null) {
      map['globalOptions'] = _globalOptions?.map((v) => v.toJson()).toList();
    }
    if (_globalOptionsEnum != null) {
      map['globalOptionsEnum'] = _globalOptionsEnum?.toJson();
    }
    if (_productCategories != null) {
      map['productCategories'] =
          _productCategories?.map((v) => v.toJson()).toList();
    }
    if (_productAttributeSets != null) {
      map['productAttributeSets'] =
          _productAttributeSets?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}
