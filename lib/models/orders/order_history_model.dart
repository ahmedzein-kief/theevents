/// YApi QuickType插件生成，具体参考文档:https://plugins.jetbrains.com/plugin/18847-yapi-quicktype/documentation
library;

import 'dart:convert';

OrderHistoryModel orderHistoryModelFromJson(String str) =>
    OrderHistoryModel.fromJson(json.decode(str));

String orderHistoryModelToJson(OrderHistoryModel data) =>
    json.encode(data.toJson());

class OrderHistoryModel {
  OrderHistoryModel({
    required this.data,
    required this.error,
  });

  factory OrderHistoryModel.fromJson(Map<dynamic, dynamic> json) =>
      OrderHistoryModel(
        data: Data.fromJson(json['data']),
        error: json['error'],
      );

  Data data;
  bool error;

  Map<dynamic, dynamic> toJson() => {
        'data': data.toJson(),
        'error': error,
      };
}

class Data {
  Data({
    required this.pagination,
    required this.records,
  });

  factory Data.fromJson(Map<dynamic, dynamic> json) => Data(
        pagination: Pagination.fromJson(json['pagination']),
        records: List<OrderRecord>.from(
            json['records'].map((x) => OrderRecord.fromJson(x)),),
      );

  Pagination pagination;
  List<OrderRecord> records;

  Map<dynamic, dynamic> toJson() => {
        'pagination': pagination.toJson(),
        'records': List<dynamic>.from(records.map((x) => x.toJson())),
      };
}

class Pagination {
  Pagination({
    required this.perPage,
    required this.total,
    required this.lastPage,
    required this.currentPage,
  });

  factory Pagination.fromJson(Map<dynamic, dynamic> json) => Pagination(
        perPage: json['per_page'],
        total: json['total'],
        lastPage: json['last_page'],
        currentPage: json['current_page'],
      );

  int perPage;
  int total;
  int lastPage;
  int currentPage;

  Map<dynamic, dynamic> toJson() => {
        'per_page': perPage,
        'total': total,
        'last_page': lastPage,
        'current_page': currentPage,
      };
}

class OrderRecord {
  OrderRecord({
    required this.total,
    required this.code,
    required this.price,
    required this.createdAt,
    required this.statusArr,
    required this.id,
    required this.label,
    required this.store,
    required this.status,
    required this.products,
  });

  factory OrderRecord.fromJson(Map<dynamic, dynamic> json) => OrderRecord(
        total: json['total'],
        code: json['code'],
        price: json['price'],
        createdAt: json['created_at'],
        statusArr: StatusArr.fromJson(json['status_arr']),
        id: json['id'],
        label: json['label'],
        store: Store.fromJson(json['store']),
        status: json['status'],
        products: List<OrderProduct>.from(
            json['products'].map((x) => OrderProduct.fromJson(x)),),
      );

  int total;
  String code;
  String price;
  String createdAt;
  StatusArr statusArr;
  int id;
  String label;
  Store store;
  String status;
  List<OrderProduct> products;

  Map<dynamic, dynamic> toJson() => {
        'total': total,
        'code': code,
        'price': price,
        'created_at': createdAt,
        'status_arr': statusArr.toJson(),
        'id': id,
        'label': label,
        'store': store.toJson(),
        'status': status,
        'products': List<dynamic>.from(products.map((x) => x.toJson())),
      };
}

class OrderProduct {
  OrderProduct({
    required this.productSlugPrefix,
    required this.productSlug,
    required this.imageUrl,
    required this.productName,
    required this.imageThumb,
    required this.imageSmall,
    required this.productType,
    required this.productOptions,
    required this.review,
    required this.qty,
    required this.indexNum,
    required this.attributes,
    required this.sku,
    required this.amountFormat,
    required this.totalFormat,
    this.orderRecord,
  });

  factory OrderProduct.fromJson(Map<dynamic, dynamic> json) => OrderProduct(
        productSlugPrefix:
            productSlugPrefixValues.map[json['product_slug_prefix']]!,
        productSlug: json['product_slug'],
        imageUrl: json['image_url'],
        productName: json['product_name'],
        imageThumb: json['image_thumb'],
        imageSmall: json['image_small'],
        productType: productTypeValues.map[json['product_type']]!,
        productOptions: json['product_options'],
        review: Review.fromJson(json['review']),
        qty: json['qty'],
        indexNum: json['index_num'],
        attributes: json['attributes'],
        sku: json['sku'],
        amountFormat: json['amount_format'],
        totalFormat: json['total_format'],
      );

  ProductSlugPrefix productSlugPrefix;
  String productSlug;
  String imageUrl;
  String productName;
  String imageThumb;
  String imageSmall;
  ProductType productType;
  String productOptions;
  Review review;
  int qty;
  int indexNum;
  String attributes;
  String sku;
  String amountFormat;
  String totalFormat;
  OrderRecord? orderRecord;

  Map<dynamic, dynamic> toJson() => {
        'product_slug_prefix':
            productSlugPrefixValues.reverse[productSlugPrefix],
        'product_slug': productSlug,
        'image_url': imageUrl,
        'product_name': productName,
        'image_thumb': imageThumb,
        'image_small': imageSmall,
        'product_type': productTypeValues.reverse[productType],
        'product_options': productOptions,
        'review': review.toJson(),
        'qty': qty,
        'index_num': indexNum,
        'attributes': attributes,
        'sku': sku,
        'amount_format': amountFormat,
        'total_format': totalFormat,
      };
}

enum ProductSlugPrefix { PRODUCTS }

final productSlugPrefixValues =
    EnumValues({'products': ProductSlugPrefix.PRODUCTS});

enum ProductType { PHYSICAL }

final productTypeValues = EnumValues({'physical': ProductType.PHYSICAL});

class Review {
  Review({
    required this.showAvgRating,
    required this.ratingFormated,
  });

  factory Review.fromJson(Map<dynamic, dynamic> json) => Review(
        showAvgRating: json['show_avg_rating'],
        ratingFormated: json['rating_formated'],
      );

  bool showAvgRating;
  String ratingFormated;

  Map<dynamic, dynamic> toJson() => {
        'show_avg_rating': showAvgRating,
        'rating_formated': ratingFormated,
      };
}

class StatusArr {
  StatusArr({
    required this.textClass,
    required this.label,
    required this.type,
  });

  factory StatusArr.fromJson(Map<dynamic, dynamic> json) => StatusArr(
        textClass: json['textClass'],
        label: json['label'],
        type: json['type'],
      );

  String textClass;
  String label;
  String type;

  Map<dynamic, dynamic> toJson() => {
        'textClass': textClass,
        'label': label,
        'type': type,
      };
}

class Store {
  Store({
    required this.thumb,
    required this.name,
    required this.logo,
    required this.slug,
  });

  factory Store.fromJson(Map<dynamic, dynamic> json) => Store(
        thumb: json['thumb'],
        name: json['name'],
        logo: json['logo'],
        slug: json['slug'],
      );

  String thumb;
  String name;
  String logo;
  String slug;

  Map<dynamic, dynamic> toJson() => {
        'thumb': thumb,
        'name': name,
        'logo': logo,
        'slug': slug,
      };
}

class EnumValues<T> {
  EnumValues(this.map);
  Map<String, T> map;
  late Map<T, String> reverseMap;

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
