import '../../../provider/product_package_provider/packages_provider.dart';

class CustomerGetProductReviewsModel {
  CustomerGetProductReviewsModel({
    this.error,
    this.data,
    this.message,
  });

  CustomerGetProductReviewsModel.fromJson(dynamic json) {
    error = json['error'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
    message = json['message'];
  }

  bool? error;
  Data? data;
  dynamic message;
}

class Data {
  Data({
    this.reviews,
    this.products,
  });

  Data.fromJson(dynamic json) {
    reviews =
        json['reviews'] != null ? Reviews.fromJson(json['reviews']) : null;
    if (json['products'] != null) {
      products = [];
      json['products'].forEach((v) {
        products?.add(ProductsAvailableForReview.fromJson(v));
      });
    }
  }

  Reviews? reviews;
  List<ProductsAvailableForReview>? products;
}

class ProductsAvailableForReview {
  ProductsAvailableForReview({
    this.id,
    this.image,
    this.name,
    this.cleanName,
    this.completedAt,
    this.slug,
    this.slugPrefix,
  });

  ProductsAvailableForReview.fromJson(dynamic json) {
    id = json['id'];
    image = json['image'];
    name = json['name'];
    cleanName = json['clean_name'];
    completedAt = json['completed_at'];
    slug = json['slug'];
    slugPrefix = json['slug_prefix'];
  }

  int? id;
  String? image;
  String? name;
  String? cleanName;
  String? completedAt;
  String? slug;
  String? slugPrefix;
}

class Reviews {
  Reviews({
    this.pagination,
    this.records,
  });

  Reviews.fromJson(dynamic json) {
    pagination = json['pagination'] != null
        ? Pagination.fromJson(json['pagination'])
        : null;
    if (json['records'] != null) {
      records = [];
      json['records'].forEach((v) {
        records?.add(ReviewedRecords.fromJson(v));
      });
    }
  }

  Pagination? pagination;
  List<ReviewedRecords>? records;
}

class ReviewedRecords {
  int? id;
  String? image;
  String? name;
  String? cleanName;
  String? slug;
  String? slugPrefix;
  String? type;
  String? sku;
  String? createdAt;
  int? star;
  String? comment;
  String? sortComment;
  String? storeName;
  String? storeSlug;
  bool isDeleting;

  ReviewedRecords({
    this.id,
    this.image,
    this.name,
    this.cleanName,
    this.slug,
    this.slugPrefix,
    this.type,
    this.sku,
    this.createdAt,
    this.star,
    this.comment,
    this.sortComment,
    this.storeName,
    this.storeSlug,
    this.isDeleting = false,
  });

  ReviewedRecords.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        image = json['image'],
        name = json['name'],
        cleanName = json['clean_name'],
        slug = json['slug'],
        slugPrefix = json['slug_prefix'],
        type = json['type'],
        sku = json['sku'],
        createdAt = json['created_at'],
        star = json['star'] != null ? json['star'] as int : null,
        comment = json['comment'],
        sortComment = json['sort_comment'],
        storeName = json['store']?['name'],
        storeSlug = json['store']?['slug'],
        isDeleting = false;

  void setIsDeleting(bool value) {
    isDeleting = value;
  }
}

