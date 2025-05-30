import 'dart:convert';

VendorGetProductGeneralSettingsModel vendorGetProductGeneralSettingsModelFromJson(String str) => VendorGetProductGeneralSettingsModel.fromJson(json.decode(str));

String vendorGetProductGeneralSettingsModelToJson(VendorGetProductGeneralSettingsModel data) => json.encode(data.toJson());

class VendorGetProductGeneralSettingsModel {
  VendorGetProductGeneralSettingsModel({
    bool? error,
    Data? data,
    dynamic message,
  }) {
    _error = error;
    _data = data;
    _message = message;
  }

  VendorGetProductGeneralSettingsModel.fromJson(dynamic json) {
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
    List<ProductAttributeSets>? productAttributeSets,
    String? digitalAllowedMimeTypes,
  }) {
    _stockStatuses = stockStatuses;
    _brands = brands;
    _faqs = faqs;
    _productCollections = productCollections;
    _productLabels = productLabels;
    _productTypes = productTypes;
    _defaultDiscountPercent = defaultDiscountPercent;
    _sku = sku;
    _isTaxEnabled = isTaxEnabled;
    _isEnabledProductOptions = isEnabledProductOptions;
    _taxes = taxes;
    _globalOptions = globalOptions;
    _globalOptionsEnum = globalOptionsEnum;
    _productCategories = productCategories;
    _productAttributeSets = productAttributeSets;
    _digitalAllowedMimeTypes = digitalAllowedMimeTypes;
  }

  Data.fromJson(dynamic json) {
    if (json['stockStatuses'] != null) {
      _stockStatuses = [];
      json['stockStatuses'].forEach((v) {
        _stockStatuses?.add(StockStatuses.fromJson(v));
      });
    }
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
    _productTypes = json['productTypes'] != null ? json['productTypes'].cast<String>() : [];
    _defaultDiscountPercent = json['defaultDiscountPercent'];
    _sku = json['sku'];
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
    _globalOptionsEnum = json['globalOptionsEnum'] != null ? GlobalOptionsEnum.fromJson(json['globalOptionsEnum']) : null;
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

    _digitalAllowedMimeTypes = json["digital_products_allowed_mime_types"];
  }

  List<StockStatuses>? _stockStatuses;
  List<Brands>? _brands;
  List<Faqs>? _faqs;
  List<ProductCollections>? _productCollections;
  List<ProductLabels>? _productLabels;
  List<String>? _productTypes;
  int? _defaultDiscountPercent;
  String? _sku;
  bool? _isTaxEnabled;
  bool? _isEnabledProductOptions;
  List<Taxes>? _taxes;
  List<GlobalOptions>? _globalOptions;
  GlobalOptionsEnum? _globalOptionsEnum;
  List<ProductCategories>? _productCategories;
  List<ProductAttributeSets>? _productAttributeSets;
  String? _digitalAllowedMimeTypes;

  String? get digitalAllowedMimeTypes => _digitalAllowedMimeTypes;

  List<StockStatuses>? get stockStatuses => _stockStatuses;

  List<Brands>? get brands => _brands;

  List<Faqs>? get faqs => _faqs;

  List<ProductCollections>? get productCollections => _productCollections;

  List<ProductLabels>? get productLabels => _productLabels;

  List<String>? get productTypes => _productTypes;

  int? get defaultDiscountPercent => _defaultDiscountPercent;

  String? get sku => _sku;

  bool? get isTaxEnabled => _isTaxEnabled;

  bool? get isEnabledProductOptions => _isEnabledProductOptions;

  List<Taxes>? get taxes => _taxes;

  List<GlobalOptions>? get globalOptions => _globalOptions;

  GlobalOptionsEnum? get globalOptionsEnum => _globalOptionsEnum;

  List<ProductCategories>? get productCategories => _productCategories;

  List<ProductAttributeSets>? get productAttributeSets => _productAttributeSets;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_stockStatuses != null) {
      map['stockStatuses'] = _stockStatuses?.map((v) => v.toJson()).toList();
    }
    if (_brands != null) {
      map['brands'] = _brands?.map((v) => v.toJson()).toList();
    }
    if (_faqs != null) {
      map['faqs'] = _faqs?.map((v) => v.toJson()).toList();
    }
    if (_productCollections != null) {
      map['productCollections'] = _productCollections?.map((v) => v.toJson()).toList();
    }
    if (_productLabels != null) {
      map['productLabels'] = _productLabels?.map((v) => v.toJson()).toList();
    }
    map['productTypes'] = _productTypes;
    map['defaultDiscountPercent'] = _defaultDiscountPercent;
    map['isTaxEnabled'] = _isTaxEnabled;
    map['sku'] = _sku;
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
      map['productCategories'] = _productCategories?.map((v) => v.toJson()).toList();
    }
    if (_productAttributeSets != null) {
      map['productAttributeSets'] = _productAttributeSets?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

ProductAttributeSets productAttributeSetsFromJson(String str) => ProductAttributeSets.fromJson(json.decode(str));

String productAttributeSetsToJson(ProductAttributeSets data) => json.encode(data.toJson());

class ProductAttributeSets {
  ProductAttributeSets({
    int? id,
    String? title,
    String? slug,
    String? displayLayout,
    int? isSearchable,
    int? isComparable,
    int? isUseInProductListing,
    Status? status,
    int? order,
    String? createdAt,
    String? updatedAt,
    int? useImageFromProductVariation,
    List<Attributes>? attributes,
  }) {
    _id = id;
    _title = title;
    _slug = slug;
    _displayLayout = displayLayout;
    _isSearchable = isSearchable;
    _isComparable = isComparable;
    _isUseInProductListing = isUseInProductListing;
    _status = status;
    _order = order;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
    _useImageFromProductVariation = useImageFromProductVariation;
    _attributes = attributes;
  }

  ProductAttributeSets.fromJson(dynamic json) {
    _id = json['id'];
    _title = json['title'];
    _slug = json['slug'];
    _displayLayout = json['display_layout'];
    _isSearchable = json['is_searchable'];
    _isComparable = json['is_comparable'];
    _isUseInProductListing = json['is_use_in_product_listing'];
    _status = json['status'] != null ? Status.fromJson(json['status']) : null;
    _order = json['order'];
    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];
    _useImageFromProductVariation = json['use_image_from_product_variation'];
    if (json['attributes'] != null) {
      _attributes = [];
      json['attributes'].forEach((v) {
        _attributes?.add(Attributes.fromJson(v));
      });
    }
  }

  int? _id;
  String? _title;
  String? _slug;
  String? _displayLayout;
  int? _isSearchable;
  int? _isComparable;
  int? _isUseInProductListing;
  Status? _status;
  int? _order;
  String? _createdAt;
  String? _updatedAt;
  int? _useImageFromProductVariation;
  List<Attributes>? _attributes;

  int? get id => _id;

  String? get title => _title;

  String? get slug => _slug;

  String? get displayLayout => _displayLayout;

  int? get isSearchable => _isSearchable;

  int? get isComparable => _isComparable;

  int? get isUseInProductListing => _isUseInProductListing;

  Status? get status => _status;

  int? get order => _order;

  String? get createdAt => _createdAt;

  String? get updatedAt => _updatedAt;

  int? get useImageFromProductVariation => _useImageFromProductVariation;

  List<Attributes>? get attributes => _attributes;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['title'] = _title;
    map['slug'] = _slug;
    map['display_layout'] = _displayLayout;
    map['is_searchable'] = _isSearchable;
    map['is_comparable'] = _isComparable;
    map['is_use_in_product_listing'] = _isUseInProductListing;
    if (_status != null) {
      map['status'] = _status?.toJson();
    }
    map['order'] = _order;
    map['created_at'] = _createdAt;
    map['updated_at'] = _updatedAt;
    map['use_image_from_product_variation'] = _useImageFromProductVariation;
    if (_attributes != null) {
      map['attributes'] = _attributes?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

Attributes attributesFromJson(String str) => Attributes.fromJson(json.decode(str));

String attributesToJson(Attributes data) => json.encode(data.toJson());

class Attributes {
  Attributes({
    int? id,
    String? slug,
    String? title,
    int? attributeSetId,
  }) {
    _id = id;
    _slug = slug;
    _title = title;
    _attributeSetId = attributeSetId;
  }

  Attributes.fromJson(dynamic json) {
    _id = json['id'];
    _slug = json['slug'];
    _title = json['title'];
    _attributeSetId = json['attribute_set_id'];
  }

  int? _id;
  String? _slug;
  String? _title;
  int? _attributeSetId;

  int? get id => _id;

  String? get slug => _slug;

  String? get title => _title;

  int? get attributeSetId => _attributeSetId;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['slug'] = _slug;
    map['title'] = _title;
    map['attribute_set_id'] = _attributeSetId;
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

ProductCategories productCategoriesFromJson(String str) => ProductCategories.fromJson(json.decode(str));

String productCategoriesToJson(ProductCategories data) => json.encode(data.toJson());

class ProductCategories {
  ProductCategories({
    int? id,
    String? name,
    Status? status,
    int? isFeatured,
    String? image,
    List<dynamic>? activeChildren,
  }) {
    _id = id;
    _name = name;
    _status = status;
    _isFeatured = isFeatured;
    _image = image;
    _activeChildren = activeChildren;
  }

  ProductCategories.fromJson(dynamic json) {
    _id = json['id'];
    _name = json['name'];
    _status = json['status'] != null ? Status.fromJson(json['status']) : null;
    _isFeatured = json['is_featured'];
    _image = json['image'];
    if (json['active_children'] != null) {
      _activeChildren = [];
      json['active_children'].forEach((v) {
        // _activeChildren?.add(Dynamic.fromJson(v)); handle active children
      });
    }
  }

  int? _id;
  String? _name;
  Status? _status;
  int? _isFeatured;
  String? _image;
  List<dynamic>? _activeChildren;

  int? get id => _id;

  String? get name => _name;

  Status? get status => _status;

  int? get isFeatured => _isFeatured;

  String? get image => _image;

  List<dynamic>? get activeChildren => _activeChildren;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['name'] = _name;
    if (_status != null) {
      map['status'] = _status?.toJson();
    }
    map['is_featured'] = _isFeatured;
    map['image'] = _image;
    if (_activeChildren != null) {
      map['active_children'] = _activeChildren?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

GlobalOptionsEnum globalOptionsEnumFromJson(String str) => GlobalOptionsEnum.fromJson(json.decode(str));

String globalOptionsEnumToJson(GlobalOptionsEnum data) => json.encode(data.toJson());

class GlobalOptionsEnum {
  GlobalOptionsEnum({
    String? na,
    TextData? text,
    Select? select,
  }) {
    _na = na;
    _text = text;
    _select = select;
  }

  GlobalOptionsEnum.fromJson(dynamic json) {
    _na = json['N/A'];
    _text = json['Text'] != null ? TextData.fromJson(json['Text']) : null;
    _select = json['Select'] != null ? Select.fromJson(json['Select']) : null;
  }

  String? _na;
  TextData? _text;
  Select? _select;

  String? get na => _na;

  TextData? get text => _text;

  Select? get select => _select;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['N/A'] = _na;
    if (_text != null) {
      map['Text'] = _text?.toJson();
    }
    if (_select != null) {
      map['Select'] = _select?.toJson();
    }
    return map;
  }
}

Select selectFromJson(String str) => Select.fromJson(json.decode(str));

String selectToJson(Select data) => json.encode(data.toJson());

class Select {
  Select({
    String? botbleEcommerceOptionOptionTypeLocation,
    String? botbleEcommerceOptionOptionTypeDatePicker,
  }) {
    _botbleEcommerceOptionOptionTypeLocation = botbleEcommerceOptionOptionTypeLocation;
    _botbleEcommerceOptionOptionTypeDatePicker = botbleEcommerceOptionOptionTypeDatePicker;
  }

  Select.fromJson(dynamic json) {
    _botbleEcommerceOptionOptionTypeLocation = json['Botble\Ecommerce\Option\OptionType\Location'];
    _botbleEcommerceOptionOptionTypeDatePicker = json['Botble\Ecommerce\Option\OptionType\DatePicker'];
  }

  String? _botbleEcommerceOptionOptionTypeLocation;
  String? _botbleEcommerceOptionOptionTypeDatePicker;

  String? get botbleEcommerceOptionOptionTypeLocation => _botbleEcommerceOptionOptionTypeLocation;

  String? get botbleEcommerceOptionOptionTypeDatePicker => _botbleEcommerceOptionOptionTypeDatePicker;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['Botble\Ecommerce\Option\OptionType\Location'] = _botbleEcommerceOptionOptionTypeLocation;
    map['Botble\Ecommerce\Option\OptionType\DatePicker'] = _botbleEcommerceOptionOptionTypeDatePicker;
    return map;
  }
}

TextData textFromJson(String str) => TextData.fromJson(json.decode(str));

String textToJson(TextData data) => json.encode(data.toJson());

class TextData {
  TextData({
    String? botbleEcommerceEnumsTextarea,
  }) {
    _botbleEcommerceEnumsTextarea = botbleEcommerceEnumsTextarea;
  }

  TextData.fromJson(dynamic json) {
    _botbleEcommerceEnumsTextarea = json['Botble\Ecommerce\Enums\Textarea'];
  }

  String? _botbleEcommerceEnumsTextarea;

  String? get botbleEcommerceEnumsTextarea => _botbleEcommerceEnumsTextarea;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['Botble\Ecommerce\Enums\Textarea'] = _botbleEcommerceEnumsTextarea;
    return map;
  }
}

GlobalOptions globalOptionsFromJson(String str) => GlobalOptions.fromJson(json.decode(str));

String globalOptionsToJson(GlobalOptions data) => json.encode(data.toJson());

class GlobalOptions {
  GlobalOptions({
    int? id,
    String? value,
  }) {
    _id = id;
    _value = value;
  }

  GlobalOptions.fromJson(dynamic json) {
    _id = json['id'];
    _value = json['value'];
  }

  int? _id;
  String? _value;

  int? get id => _id;

  String? get value => _value;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['value'] = _value;
    return map;
  }
}

Taxes taxesFromJson(String str) => Taxes.fromJson(json.decode(str));

String taxesToJson(Taxes data) => json.encode(data.toJson());

class Taxes {
  Taxes({
    int? id,
    String? value,
  }) {
    _id = id;
    _value = value;
  }

  Taxes.fromJson(dynamic json) {
    _id = json['id'];
    _value = json['value'];
  }

  int? _id;
  String? _value;

  int? get id => _id;

  String? get value => _value;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['value'] = _value;
    return map;
  }
}

ProductLabels productLabelsFromJson(String str) => ProductLabels.fromJson(json.decode(str));

String productLabelsToJson(ProductLabels data) => json.encode(data.toJson());

class ProductLabels {
  ProductLabels({
    int? id,
    String? value,
  }) {
    _id = id;
    _value = value;
  }

  ProductLabels.fromJson(dynamic json) {
    _id = json['id'];
    _value = json['value'];
  }

  int? _id;
  String? _value;

  int? get id => _id;

  String? get value => _value;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['value'] = _value;
    return map;
  }
}

ProductCollections productCollectionsFromJson(String str) => ProductCollections.fromJson(json.decode(str));

String productCollectionsToJson(ProductCollections data) => json.encode(data.toJson());

class ProductCollections {
  ProductCollections({
    int? id,
    String? value,
  }) {
    _id = id;
    _value = value;
  }

  ProductCollections.fromJson(dynamic json) {
    _id = json['id'];
    _value = json['value'];
  }

  int? _id;
  String? _value;

  int? get id => _id;

  String? get value => _value;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['value'] = _value;
    return map;
  }
}

Faqs faqsFromJson(String str) => Faqs.fromJson(json.decode(str));

String faqsToJson(Faqs data) => json.encode(data.toJson());

class Faqs {
  Faqs({
    int? id,
    String? value,
  }) {
    _id = id;
    _value = value;
  }

  Faqs.fromJson(dynamic json) {
    _id = json['id'];
    _value = json['value'];
  }

  int? _id;
  String? _value;

  int? get id => _id;

  String? get value => _value;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['value'] = _value;
    return map;
  }
}

Brands brandsFromJson(String str) => Brands.fromJson(json.decode(str));

String brandsToJson(Brands data) => json.encode(data.toJson());

class Brands {
  Brands({
    int? id,
    String? value,
  }) {
    _id = id;
    _value = value;
  }

  Brands.fromJson(dynamic json) {
    _id = json['id'];
    _value = json['value'];
  }

  int? _id;
  String? _value;

  int? get id => _id;

  String? get value => _value;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['value'] = _value;
    return map;
  }
}

StockStatuses stockStatusesFromJson(String str) => StockStatuses.fromJson(json.decode(str));

String stockStatusesToJson(StockStatuses data) => json.encode(data.toJson());

class StockStatuses {
  StockStatuses({
    String? label,
    String? value,
    String? myClass,
  }) {
    _label = label;
    _value = value;
    _class = myClass;
  }

  StockStatuses.fromJson(dynamic json) {
    _label = json['label'];
    _value = json['value'];
    _class = json['class'];
  }

  String? _label;
  String? _value;
  String? _class;

  String? get label => _label;

  String? get value => _value;

  String? get myClass => _class;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['label'] = _label;
    map['value'] = _value;
    map['class'] = _class;
    return map;
  }
}
