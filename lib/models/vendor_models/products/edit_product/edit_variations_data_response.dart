/// YApi QuickType插件生成，具体参考文档:https://plugins.jetbrains.com/plugin/18847-yapi-quicktype/documentation
library;

import 'dart:convert';

import 'package:event_app/models/vendor_models/products/edit_product/new_product_view_data_response.dart';

import '../../../../vendor/Components/utils/utils.dart';

EditVariationsDataResponse editVariationsDataResponseFromJson(String str) =>
    EditVariationsDataResponse.fromJson(json.decode(str));

class EditVariationsDataResponse {
  EditVariationsDataResponse({
    required this.data,
    required this.error,
    required this.message,
  });

  factory EditVariationsDataResponse.fromJson(Map<dynamic, dynamic> json) =>
      EditVariationsDataResponse(
        data: json['data'] != null ? Data.fromJson(json['data']) : null,
        error: json['error'],
        message: json['message'],
      );

  Data? data;
  bool error;
  String? message;
}

class Data {
  Data({
    required this.generateLicenseCode,
    required this.productAttributeSets,
    required this.product,
    required this.originalProduct,
    required this.attachments,
    required this.variationImages,
  });

  factory Data.fromJson(Map<dynamic, dynamic> json) => Data(
        generateLicenseCode: json['generate_license_code'],
        productAttributeSets: List<ProductAttributeSet>.from(
            json['productAttributeSets']
                .map((x) => ProductAttributeSet.fromJson(x)),),
        product: VariationProduct.fromJson(json['product']),
        originalProduct: VariationProduct.fromJson(json['originalProduct']),
        attachments: List<Attachment>.from(
            json['attachments'].map((x) => Attachment.fromJson(x)),),
        variationImages: List<VariationImages>.from(
            json['variationImages'].map((x) => VariationImages.fromJson(x)),),
      );

  int? generateLicenseCode;
  List<ProductAttributeSet> productAttributeSets;
  VariationProduct product;
  VariationProduct originalProduct;
  List<Attachment> attachments;
  List<VariationImages> variationImages;
}

class VariationInfo {
  VariationInfo({
    required this.configurableProduct,
    required this.productId,
    required this.id,
    required this.isDefault,
    required this.configurableProductId,
  });

  factory VariationInfo.fromJson(Map<dynamic, dynamic> json) => VariationInfo(
        configurableProduct:
            VariationProduct.fromJson(json['configurable_product']),
        productId: json['product_id'],
        id: json['id'],
        isDefault: json['is_default'],
        configurableProductId: json['configurable_product_id'],
      );

  VariationProduct configurableProduct;
  int productId;
  int id;
  int isDefault;
  int configurableProductId;
}

class VariationImages {
  VariationImages({
    required this.url,
    required this.fullURL,
  });

  factory VariationImages.fromJson(Map<dynamic, dynamic> json) =>
      VariationImages(
        url: json['url'],
        fullURL: json['full_url'],
      );

  String url;
  String fullURL;
}

class VariationProduct {
  VariationProduct({
    required this.endDate,
    required this.generateLicenseCode,
    required this.originalPrice,
    required this.frontSalePrice,
    required this.description,
    required this.allowCheckoutWhenOutOfStock,
    required this.isVariation,
    required this.saleType,
    required this.createdAt,
    required this.content,
    required this.updatedAt,
    required this.price,
    required this.createdByType,
    required this.id,
    required this.sku,
    required this.views,
    required this.order,
    required this.startDate,
    required this.images,
    required this.stockStatus,
    required this.withStorehouseManagement,
    required this.salePrice,
    required this.brandId,
    required this.approvedBy,
    required this.productType,
    required this.barcode,
    this.variationInfo,
    required this.name,
    required this.createdById,
    required this.isFeatured,
    required this.status,
    this.costPerItem,
    this.storeId,
    this.image,
    this.quantity,
  });

  factory VariationProduct.fromJson(Map<dynamic, dynamic> json) =>
      VariationProduct(
        endDate: Utils.formatTimestampToYMDHMS(json['end_date']),
        generateLicenseCode: json['generate_license_code'],
        originalPrice: (json['original_price'] is int)
            ? double.parse(json['original_price'].toString())
            : json['original_price'],
        frontSalePrice: (json['front_sale_price'] is int)
            ? double.parse(json['front_sale_price'].toString())
            : json['front_sale_price'],
        description: json['description'],
        allowCheckoutWhenOutOfStock: json['allow_checkout_when_out_of_stock'],
        isVariation: json['is_variation'],
        saleType: json['sale_type'],
        createdAt: Utils.formatTimestampToYMDHMS(json['created_at']),
        content: json['content'],
        updatedAt: Utils.formatTimestampToYMDHMS(json['updated_at']),
        price: (json['price'] is int)
            ? double.parse(json['price'].toString())
            : json['price'],
        createdByType: json['created_by_type'],
        id: json['id'],
        sku: json['sku'],
        views: json['views'],
        order: json['order'],
        startDate: Utils.formatTimestampToYMDHMS(json['start_date']),
        images: List<String>.from(json['images'].map((x) => x)),
        stockStatus: ProductType.fromJson(json['stock_status']),
        withStorehouseManagement: json['with_storehouse_management'],
        salePrice: (json['sale_price'] is int)
            ? double.parse(json['sale_price'].toString())
            : json['sale_price'],
        brandId: json['brand_id'],
        approvedBy: json['approved_by'],
        productType: ProductType.fromJson(json['product_type']),
        variationInfo: json['variation_info'] == null
            ? null
            : VariationInfo.fromJson(json['variation_info']),
        name: json['name'],
        createdById: json['created_by_id'],
        isFeatured: json['is_featured'],
        status: ProductType.fromJson(json['status']),
        barcode: json['barcode'],
        costPerItem: (json['cost_per_item'] is int)
            ? double.parse(json['cost_per_item'].toString())
            : json['cost_per_item'],
        storeId: json['store_id'],
        image: json['image'],
        quantity: json['quantity'],
      );

  String? endDate;
  int? generateLicenseCode;
  double? originalPrice;
  double? frontSalePrice;
  String? description;
  int? allowCheckoutWhenOutOfStock;
  int? isVariation;
  int? saleType;
  String? createdAt;
  String? content;
  String? updatedAt;
  double? price;
  String? createdByType;
  int? id;
  String? sku;
  int? views;
  int? order;
  String? startDate;
  List<String> images;
  ProductType stockStatus;
  int? withStorehouseManagement;
  double? salePrice;
  int? brandId;
  int? approvedBy;
  ProductType productType;
  VariationInfo? variationInfo;
  String? name;
  int? createdById;
  int? isFeatured;
  ProductType status;
  String? barcode;
  double? costPerItem;
  int? storeId;
  String? image;
  int? quantity;
}

class ProductType {
  ProductType({
    required this.label,
    required this.value,
  });

  factory ProductType.fromJson(Map<dynamic, dynamic> json) => ProductType(
        label: json['label'],
        value: json['value'],
      );

  String? label;
  String? value;
}

class ProductAttributeSet {
  ProductAttributeSet({
    required this.isSearchable,
    required this.createdAt,
    required this.title,
    required this.isUseInProductListing,
    required this.updatedAt,
    required this.displayLayout,
    required this.attributes,
    required this.id,
    required this.useImageFromProductVariation,
    required this.slug,
    required this.isComparable,
    required this.status,
    required this.order,
    required this.selectedId,
  });

  factory ProductAttributeSet.fromJson(Map<dynamic, dynamic> json) =>
      ProductAttributeSet(
        isSearchable: json['is_searchable'],
        createdAt: json['created_at'],
        title: json['title'],
        isUseInProductListing: json['is_use_in_product_listing'],
        updatedAt: json['updated_at'],
        displayLayout: json['display_layout'],
        attributes: List<EditAttributeData>.from(json['attributes']
            .map((x) => EditAttributeData.fromJson(x, json['selected_id'])),),
        id: json['id'],
        useImageFromProductVariation: json['use_image_from_product_variation'],
        slug: json['slug'],
        isComparable: json['is_comparable'],
        status: ProductType.fromJson(json['status']),
        order: json['order'],
        selectedId: json['selected_id'],
      );

  int isSearchable;
  String? createdAt;
  String title;
  int isUseInProductListing;
  String? updatedAt;
  String? displayLayout;
  List<EditAttributeData> attributes;
  int? id;
  int? useImageFromProductVariation;
  String slug;
  int? isComparable;
  ProductType status;
  int? order;
  int? selectedId;
}

class EditAttributeData {
  EditAttributeData({
    required this.attributeSetId,
    this.color,
    required this.updatedAt,
    required this.createdAt,
    required this.id,
    required this.title,
    required this.isDefault,
    required this.slug,
    required this.order,
  });

  factory EditAttributeData.fromJson(
          Map<dynamic, dynamic> json, int? selectedId,) =>
      EditAttributeData(
        attributeSetId: json['attribute_set_id'],
        color: json['color'],
        updatedAt: json['updated_at'],
        createdAt: json['created_at'],
        id: json['id'],
        title: json['title'],
        isDefault: (json['id'] == selectedId) ? 1 : 0,
        slug: json['slug'],
        order: json['order'],
      );

  int? attributeSetId;
  String? color;
  String? updatedAt;
  String? createdAt;
  int? id;
  String? title;
  int? isDefault;
  String? slug;
  int? order;
}

enum Color { THE_333333, RGB_128128128, EMPTY }

final colorValues = EnumValues({
  '': Color.EMPTY,
  'rgb(128, 128, 128)': Color.RGB_128128128,
  '#333333': Color.THE_333333,
});

class EnumValues<T> {
  EnumValues(this.map);
  Map<String, T> map;
  late Map<T, String> reverseMap;

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
