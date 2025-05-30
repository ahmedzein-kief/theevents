import 'dart:convert';
import 'dart:ffi';

import 'package:event_app/vendor/components/utils/utils.dart';

NewProductViewDataResponse newProductViewDataResponseFromJson(String str) => NewProductViewDataResponse.fromJson(json.decode(str));

class NewProductViewDataResponse {
  NewProductViewDataResponse({
    bool? error,
    Data? data,
    dynamic message,
  }) {
    _error = error;
    _data = data;
    _message = message;
  }

  NewProductViewDataResponse.fromJson(dynamic json) {
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
}

Data dataFromJson(String str) => Data.fromJson(json.decode(str));

class Data {
  int? id;
  String? name;
  String? slug;
  int? slugId;
  String? description;
  String? content;
  Status? status;
  List<Images>? images;
  String? sku;
  double? price;
  String? priceFormat;
  double? salePrice;
  String? salePriceFormat;
  int? quantity;
  int? allowCheckoutWhenOutOfStock;
  int? withStorehouseManagement;
  int? brandId;
  int? isVariation;
  String? startDate;
  String? endDate;
  double? length;
  double? wide;
  double? height;
  double? weight;
  List<int>? taxes;
  int? views;
  Status? stockStatus;
  String? image;
  String? imageUrl;
  ProductType? productType;
  String? barcode;
  double? costPerItem;
  int? storeId;
  String? createdAt;
  String? updatedAt;
  List<int>? categories;
  List<int>? collections;
  List<int>? labels;
  int? totalVariations;
  List<String>? tags;
  List<AttributeSet>? attributeSets;
  List<List<FaqItems>>? faqItems;
  List<String>? selectedExistingFaqs;
  List<RelatedProduct>? relatedProducts;
  List<CrossSaleProduct>? crossSaleProducts;
  String? generateLicenseCode;
  List<Attachment>? attachments;
  List<Option>? options;
  SeoMeta? seoMeta;

  Data({
    this.id,
    this.name,
    this.slug,
    this.slugId,
    this.description,
    this.content,
    this.status,
    this.images,
    this.sku,
    this.price,
    this.priceFormat,
    this.salePrice,
    this.salePriceFormat,
    this.quantity,
    this.allowCheckoutWhenOutOfStock,
    this.withStorehouseManagement,
    this.brandId,
    this.isVariation,
    this.startDate,
    this.endDate,
    this.length,
    this.wide,
    this.height,
    this.weight,
    this.taxes,
    this.views,
    this.stockStatus,
    this.image,
    this.imageUrl,
    this.productType,
    this.barcode,
    this.costPerItem,
    this.storeId,
    this.createdAt,
    this.updatedAt,
    this.categories,
    this.collections,
    this.labels,
    this.totalVariations,
    this.tags,
    this.attributeSets,
    this.faqItems,
    this.selectedExistingFaqs,
    this.relatedProducts,
    this.crossSaleProducts,
    this.generateLicenseCode,
    this.attachments,
    this.options,
    this.seoMeta,
  });

  Data.fromJson(dynamic json) {
    print('wide ==> ${(json['wide'] is int)}');
    id = json['id'];
    name = json['name'];
    slug = json['slug'];
    slugId = json['slug_id'];
    description = json['description'];
    content = json['content'];
    status = json['status'] != null ? Status.fromJson(json['status']) : null;
    if (json['images'] != null) {
      images = [];
      json['images'].forEach((v) {
        images?.add(Images.fromJson(v));
      });
    }
    sku = json['sku'];
    price = (json['price'] is int) ? double.parse(json['price'].toString()) : json['price'];
    priceFormat = json['price_format'];
    salePrice =  (json['sale_price'] is int) ? double.parse(json['sale_price'].toString()) : json['sale_price'];
    salePriceFormat = json['sale_price_format'];
    quantity = json['quantity'] ?? null;
    allowCheckoutWhenOutOfStock = json['allow_checkout_when_out_of_stock'];
    withStorehouseManagement = json['with_storehouse_management'];
    brandId = json['brand_id'];
    isVariation = json['is_variation'];
    startDate = Utils.formatTimestampToYMDHMS(json['start_date']);
    endDate = Utils.formatTimestampToYMDHMS(json['end_date']);
    length = (json['length'] is int) ? double.parse(json['length'].toString()) : json['length'];
    wide = (json['wide'] is int) ? double.parse(json['wide'].toString()) : json['wide'];
    height = (json['height'] is int) ? double.parse(json['height'].toString()) : json['height'];
    weight = (json['weight'] is int) ? double.parse(json['weight'].toString()) : json['weight'];
    taxes = json['taxes'] != null ? json['taxes'].cast<int>() : [];
    views = json['views'];
    stockStatus = json['stock_status'] != null ? Status.fromJson(json['stock_status']) : null;
    image = json['image'];
    imageUrl = json['image_url'];
    productType = json['product_type'] != null ? ProductType.fromJson(json['product_type']) : null;
    barcode = json['barcode'];
    costPerItem = (json['cost_per_item'] is int) ? double.parse(json['cost_per_item'].toString()) : json['cost_per_item'];
    storeId = json['store_id'];
    createdAt = Utils.formatTimestampToYMDHMS(json['created_at']);
    updatedAt = Utils.formatTimestampToYMDHMS(json['updated_at']);
    categories = json['categories'] != null ? json['categories'].cast<int>() : [];
    collections = json['collections'] != null ? json['collections'].cast<int>() : [];
    labels = json['labels'] != null ? json['labels'].cast<int>() : [];
    totalVariations = json['totalVariations'];
    tags = json['tags'] != null ? json['tags'].cast<String>() : [];
    if (json['attributeSets'] != null) {
      attributeSets = [];
      json['attributeSets'].forEach((v) {
        attributeSets?.add(AttributeSet.fromJson(v));
      });
    }

    faqItems = json["faqItems"] is List
        ? List<List<FaqItems>>.from(
            json["faqItems"].map(
              (x) => x is List
                  ? List<FaqItems>.from(
                      x.where((item) => item is Map<String, dynamic>).map(
                            (item) => FaqItems.fromJson(item),
                          ),
                    )
                  : [],
            ),
          )
        : [];

    selectedExistingFaqs = json['selectedExistingFaqs'] != null ? json['selectedExistingFaqs'].cast<String>() : [];

    if (json['relatedProducts'] != null) {
      relatedProducts = [];
      json['relatedProducts'].forEach((v) {
        relatedProducts?.add(RelatedProduct.fromJson(v));
      });
    }
    if (json['crossSaleProducts'] != null) {
      crossSaleProducts = [];
      json['crossSaleProducts'].forEach((v) {
        crossSaleProducts?.add(CrossSaleProduct.fromJson(v));
      });
    }

    if (json['options'] != null) {
      options = [];
      json['options'].forEach((v) {
        options?.add(Option.fromJson(v));
      });
    }
    seoMeta = json['seo_meta'] != null && json['seo_meta'].toString().isNotEmpty ? SeoMeta.fromJson(json['seo_meta']) : null;

    generateLicenseCode = json['generate_license_code']?.toString() ?? '';
    if (json['attachments'] != null) {
      attachments = List<Attachment>.from(json['attachments'].map((v) => Attachment.fromJson(v)));
    }
  }
}

/// faq items
class FaqItems {
  FaqItems({
    this.key,
    this.value,
  });

  String? key;
  String? value;

  factory FaqItems.fromJson(Map<String, dynamic> json) => FaqItems(
        key: json['key'],
        value: json['value'],
      );

  Map<String, dynamic> toJson() => {
        'key': key,
        'value': value,
      };
}

/// status
Status statusFromJson(String str) => Status.fromJson(json.decode(str));

class Status {
  Status({
    this.value,
    this.label,
  });

  Status.fromJson(dynamic json) {
    value = json['value'];
    label = json['label'];
  }

  String? value;
  String? label;
}

ProductType productTypeFromJson(String str) => ProductType.fromJson(json.decode(str));

class ProductType {
  ProductType({
    this.value,
    this.label,
  });

  ProductType.fromJson(dynamic json) {
    value = json['value'];
    label = json['label'];
  }

  String? value;
  String? label;
}

/// Images
Images imagesFromJson(String str) => Images.fromJson(json.decode(str));

class Images {
  Images({
    this.image,
    this.imageUrl,
  });

  Images.fromJson(dynamic json) {
    image = json['image'];
    imageUrl = json['image_url'];
  }

  String? image;
  String? imageUrl;
}

class AttributeSet {
  AttributeSet({
    required this.isSearchable,
    required this.isSelected,
    required this.createdAt,
    required this.title,
    required this.isUseInProductListing,
    required this.updatedAt,
    required this.displayLayout,
    required this.id,
    required this.useImageFromProductVariation,
    required this.slug,
    required this.isComparable,
    required this.status,
    required this.order,
  });

  int isSearchable;
  int? isSelected;
  DateTime createdAt;
  String title;
  int isUseInProductListing;
  DateTime updatedAt;
  String displayLayout;
  int id;
  int useImageFromProductVariation;
  String slug;
  int isComparable;
  Status status;
  int order;

  factory AttributeSet.fromJson(Map<dynamic, dynamic> json) => AttributeSet(
        isSearchable: json["is_searchable"],
        isSelected: json["is_selected"],
        createdAt: DateTime.parse(json["created_at"]),
        title: json["title"],
        isUseInProductListing: json["is_use_in_product_listing"],
        updatedAt: DateTime.parse(json["updated_at"]),
        displayLayout: json["display_layout"],
        id: json["id"],
        useImageFromProductVariation: json["use_image_from_product_variation"],
        slug: json["slug"],
        isComparable: json["is_comparable"],
        status: Status.fromJson(json["status"]),
        order: json["order"],
      );
}

/// Related Products
class RelatedProduct {
  RelatedProduct({
    this.image,
    this.imageUrl,
    this.name,
    this.id,
  });

  String? image;
  String? imageUrl;
  String? name;
  int? id;

  factory RelatedProduct.fromJson(Map<dynamic, dynamic> json) => RelatedProduct(
        image: json["image"],
        imageUrl: json["image_url"],
        name: json["name"],
        id: json["id"],
      );

  Map<dynamic, dynamic> toJson() => {
        "image": image,
        "image_url": imageUrl,
        "name": name,
        "id": id,
      };
}

/// product options
class Option {
  Option({
    this.updatedAt,
    this.optionType,
    this.productId,
    this.values,
    this.name,
    this.createdAt,
    this.id,
    this.required,
    this.order,
  });

  String? updatedAt;
  String? optionType;
  int? productId;
  List<ValueElement>? values;
  String? name;
  String? createdAt;
  int? id;
  int? required;
  int? order;

  factory Option.fromJson(Map<dynamic, dynamic> json) => Option(
        updatedAt: json["updated_at"],
        optionType: json["option_type"],
        productId: json["product_id"],
        values: json["values"] != null ? List<ValueElement>.from(json["values"].map((x) => ValueElement.fromJson(x))) : [],
        name: json["name"],
        createdAt: json["created_at"],
        id: json["id"],
        required: json["required"],
        order: json["order"],
      );

  Map<dynamic, dynamic> toJson() => {
        "updated_at": updatedAt,
        "option_type": optionType,
        "product_id": productId,
        "values": values != null ? List<dynamic>.from(values!.map((x) => x.toJson())) : [],
        "name": name,
        "created_at": createdAt,
        "id": id,
        "required": required,
        "order": order,
      };
}

class ValueElement {
  ValueElement({
    this.optionValue,
    this.updatedAt,
    this.affectType,
    this.createdAt,
    this.optionId,
    this.affectPrice,
    this.id,
    this.order,
  });

  String? optionValue;
  String? updatedAt;
  int? affectType;
  String? createdAt;
  int? optionId;
  int? affectPrice;
  int? id;
  int? order;

  factory ValueElement.fromJson(Map<dynamic, dynamic> json) => ValueElement(
        optionValue: json["option_value"],
        updatedAt: json["updated_at"],
        affectType: json["affect_type"],
        createdAt: json["created_at"],
        optionId: json["option_id"],
        affectPrice: json["affect_price"],
        id: json["id"],
        order: json["order"],
      );

  Map<dynamic, dynamic> toJson() => {
        "option_value": optionValue,
        "updated_at": updatedAt,
        "affect_type": affectType,
        "created_at": createdAt,
        "option_id": optionId,
        "affect_price": affectPrice,
        "id": id,
        "order": order,
      };
}

/// cross selling products
class CrossSaleProduct {
  CrossSaleProduct({
    this.image,
    this.priceFormat,
    this.imageUrl,
    this.crossPrice,
    this.salePrice,
    this.salePriceFormat,
    this.crossPriceType,
    this.applyToAllVariations,
    this.price,
    this.variations,
    this.name,
    this.isVariant,
    this.attributes,
    this.id,
  });

  String? image;
  String? priceFormat;
  String? imageUrl;
  String? crossPrice;
  int? salePrice;
  String? salePriceFormat;
  String? crossPriceType;
  int? applyToAllVariations;
  int? price;
  List<dynamic>? variations;
  String? name;
  int? isVariant;
  List<dynamic>? attributes;
  int? id;

  factory CrossSaleProduct.fromJson(Map<dynamic, dynamic> json) => CrossSaleProduct(
        image: json["image"],
        priceFormat: json["price_format"],
        imageUrl: json["image_url"],
        crossPrice: json["cross_price"],
        salePrice: json["sale_price"],
        salePriceFormat: json["sale_price_format"],
        crossPriceType: json["cross_price_type"],
        applyToAllVariations: json["apply_to_all_variations"],
        price: json["price"],
        variations: json["variations"] != null ? List<dynamic>.from(json["variations"]) : [],
        name: json["name"],
        isVariant: json["is_variant"],
        attributes: json["attributes"] != null ? List<dynamic>.from(json["attributes"]) : [],
        id: json["id"],
      );
}

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}

/// attachments
class Attachment {
  int? id;
  String? name;
  String? externalLink;
  bool? isExternalLink;
  String? size;
  String? createdAt;

  Attachment({
    this.id,
    this.name,
    this.externalLink,
    this.isExternalLink,
    this.size,
    this.createdAt,
  });

  // ✅ Fix: fromJson now correctly expects a Map, not a String
  factory Attachment.fromJson(Map<String, dynamic> json) => Attachment(
        id: json["id"],
        name: json["name"],
        externalLink: json["external_link"],
        isExternalLink: json["is_external_link"],
        size: json["size"],
        createdAt: json["created_at"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "external_link": externalLink,
        "is_external_link": isExternalLink,
        "size": size,
        "created_at": createdAt,
      };
}

/// SEO data
SeoMeta seoMetaFromJson(String str) => SeoMeta.fromJson(json.decode(str));

class SeoMeta {
  String? seoTitle;
  String? seoDescription;
  String? index;
  List<dynamic>? keywords;

  SeoMeta({
    this.seoTitle,
    this.seoDescription,
    this.index,
    this.keywords,
  });

  SeoMeta.fromJson(dynamic json) {
    seoTitle = json['seo_title'];
    seoDescription = json['seo_description'];
    index = json['index'];
    keywords = json['seo_keywords'] != null ? jsonDecode(json['seo_keywords']) : null;
  }

  Map<String, dynamic> toJson() {
    return {
      'seo_title': seoTitle,
      'seo_description': seoDescription,
      'index': index,
      'seo_keywords': jsonEncode(keywords),
    };
  }
}
