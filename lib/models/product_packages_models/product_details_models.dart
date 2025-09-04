import 'package:event_app/models/product_packages_models/customer_reviews_data_response.dart';
import 'package:event_app/models/product_packages_models/product_attributes_model.dart';
import 'package:event_app/models/product_packages_models/product_models.dart';
import 'package:event_app/models/product_packages_models/product_options_model.dart';

class ProductDetailsModels {
  ProductDetailsModels({required this.error, this.data});

  factory ProductDetailsModels.fromJson(Map<String, dynamic> json) =>
      ProductDetailsModels(
        error: json['error'] ?? false,
        data: json['data'] != null ? Data.fromJson(json['data']) : null,
      );
  final bool error;
  final Data? data;
}

class Data {
  Data({required this.breadcrumb, this.record});

  factory Data.fromJson(Map<String, dynamic> json) {
    final list = json['breadcrumb'] as List? ?? [];
    final List<Breadcrumb> breadcrumbList =
        list.map((i) => Breadcrumb.fromJson(i)).toList();

    return Data(
      breadcrumb: breadcrumbList,
      record:
          json['record'] != null ? ItemRecord.fromJson(json['record']) : null,
    );
  }
  final List<Breadcrumb> breadcrumb;
  final ItemRecord? record;
}

class Breadcrumb {
  Breadcrumb({required this.name, required this.slug});

  factory Breadcrumb.fromJson(Map<String, dynamic> json) => Breadcrumb(
        name: json['name'] ?? '',
        slug: json['slug'] ?? '',
      );
  final String name;
  final String slug;
}

class ItemRecord {
  ItemRecord({
    this.id,
    required this.name,
    required this.description,
    required this.content,
    required this.sku,
    required this.slug,
    required this.slugPrefix,
    this.isFeatured,
    required this.productType,
    required this.images,
    required this.outOfStock,
    required this.cartEnabled,
    required this.wishEnabled,
    required this.compareEnabled,
    required this.reviewEnabled,
    required this.quickbuyEnabled,
    this.isVariation,
    this.variationsCount,
    this.review,
    this.prices,
    this.store,
    this.brand,
    required this.labels,
    required this.flashSale,
    this.variations,
    this.defaultVariation,
    required this.productCollections,
    required this.tags,
    required this.categories,
    required this.options,
    required this.crossSales,
    required this.metadata,
    required this.reviews,
    this.brandDetail,
    this.attributes,
    required this.relatedProducts,
    required this.inWishList,
    required this.inCart,
  });

  factory ItemRecord.fromJson(Map<String, dynamic> json) {
    print('wishlist data ==> ${json['in_wishlist']}');

    final listImages = json['images'] as List? ?? [];
    final List<Images> imagesList =
        listImages.map((i) => Images.fromJson(i)).toList();

    final listLabels = json['labels'] as List? ?? [];
    final List<Label> labelsList =
        listLabels.map((i) => Label.fromJson(i)).toList();

    final listCategories = json['categories'] as List? ?? [];
    final List<Category> categoriesList =
        listCategories.map((i) => Category.fromJson(i)).toList();

    final listMetadata = json['metadata'] as List? ?? [];
    final List<Metadata> metadataList =
        listMetadata.map((i) => Metadata.fromJson(i)).toList();

    final listAttributes = json['attributes'] as List? ?? [];
    final List<ProductAttributesModel> attributes =
        listAttributes.map((i) => ProductAttributesModel.fromJson(i)).toList();

    final listOptions = json['options'] as List? ?? [];
    final List<ProductOptionsModel> options =
        listOptions.map((i) => ProductOptionsModel.fromJson(i)).toList();

    final listRelatedProducts = json['related_products'] as List? ?? [];
    final List<RecordProduct> relatedProducts =
        listRelatedProducts.map((i) => RecordProduct.fromJson(i)).toList();

    return ItemRecord(
      id: json['id'],
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      content: json['content'] ?? '',
      sku: json['sku'] ?? '',
      slug: json['slug'] ?? '',
      slugPrefix: json['slug_prefix'] ?? '',
      isFeatured: json['is_featured'],
      productType: json['product_type'] ?? '',
      images: imagesList,
      outOfStock: json['out_of_stock'] ?? false,
      cartEnabled: json['cart_enabled'] ?? false,
      wishEnabled: json['wish_enabled'] ?? false,
      compareEnabled: json['compare_enabled'] ?? false,
      reviewEnabled: json['review_enabled'] ?? false,
      quickbuyEnabled: json['quickbuy_enabled'] ?? false,
      isVariation: json['is_variation'],
      variationsCount: json['variations_count'],
      review: json['review'] != null ? Review.fromJson(json['review']) : null,
      prices: json['prices'] != null ? Prices.fromJson(json['prices']) : null,
      store: (json['store'] != null && json['store'] is Map<String, dynamic>)
          ? Store.fromJson(json['store'])
          : null,
      brand: (json['brand'] != null && json['brand'] is Map<String, dynamic>)
          ? Brand.fromJson(json['brand'])
          : null,
      labels: labelsList,
      flashSale: json['flashSale'] ?? [],
      variations: json['variations'] != null
          ? Variations.fromJson(json['variations'])
          : null,
      defaultVariation: json['default_variation'] != null
          ? DefaultVariation.fromJson(json['default_variation'])
          : null,
      productCollections: json['product_collections'] ?? [],
      tags: json['tags'] ?? [],
      categories: categoriesList,
      options: options,
      crossSales: json['cross_sales'] ?? [],
      metadata: metadataList,
      reviews:
          (json['reviews'] != null && json['reviews'] is Map<String, dynamic>)
              ? json['reviews']
                  .map((i) => CustomerReviewRecord.fromJson(i))
                  .toList()
              : [],
      brandDetail:
          (json['brand'] != null && json['brand'] is Map<String, dynamic>)
              ? Brand.fromJson(json['brand'])
              : null,
      attributes: attributes,
      relatedProducts: relatedProducts,
      inWishList: json['in_wishlist'] ?? false,
      inCart: json['in_cart'] ?? false,
    );
  }
  final dynamic id;
  final String name;
  final String description;
  final String content;
  final String sku;
  final String slug;
  final String slugPrefix;
  final int? isFeatured;
  final String productType;
  final List<Images> images;
  final bool outOfStock;
  final bool cartEnabled;
  final bool wishEnabled;
  final bool compareEnabled;
  final bool reviewEnabled;
  final bool quickbuyEnabled;
  final int? isVariation;
  final int? variationsCount;
  final Review? review;
  final Prices? prices;
  final Store? store;
  final Brand? brand;
  final List<Label> labels;
  final List<dynamic> flashSale;
  final Variations? variations;
  final DefaultVariation? defaultVariation;
  final List<dynamic> productCollections;
  final List<dynamic> tags;
  final List<Category> categories;
  final List<ProductOptionsModel> options;
  final List<dynamic> crossSales;
  final List<Metadata> metadata;
  final List<CustomerReviewRecord> reviews;
  final Brand? brandDetail;
  final List<ProductAttributesModel>? attributes;
  final List<RecordProduct> relatedProducts;
  bool inWishList;
  final bool inCart;
}

class Images {
  Images({required this.large, required this.small, required this.thumb});

  factory Images.fromJson(Map<String, dynamic> json) => Images(
        large: json['large'] ?? '',
        small: json['small'] ?? '',
        thumb: json['thumb'] ?? '',
      );
  final String large;
  final String small;
  final String thumb;
}

class Review {
  Review({
    required this.showAvgRating,
    this.rating,
    required this.ratingFormatted,
    required this.reviewsCount,
    required this.averageCountArray,
    required this.imagesCount,
    required this.reviewImages,
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    final listAverageCountArray = json['average_count_array'] as List? ?? [];
    final List<AverageCountArray> averageCountArrayList = listAverageCountArray
        .map((i) => AverageCountArray.fromJson(i))
        .toList();

    return Review(
      showAvgRating: json['show_avg_rating'] ?? false,
      rating: json['rating'],
      ratingFormatted: json['rating_formated'] ?? '',
      reviewsCount: json['reviews_count'] ?? 0,
      averageCountArray: averageCountArrayList,
      imagesCount: json['images_count'] ?? '',
      reviewImages: json['review_images'] ?? [],
    );
  }
  final bool showAvgRating;
  final dynamic rating;
  final String ratingFormatted;
  final int reviewsCount;
  final List<AverageCountArray> averageCountArray;
  final String imagesCount;
  final List<dynamic> reviewImages;
}

class AverageCountArray {
  AverageCountArray(
      {required this.star, required this.count, required this.percent,});

  factory AverageCountArray.fromJson(Map<String, dynamic> json) =>
      AverageCountArray(
        star: json['star'] ?? 0,
        count: json['count'] ?? 0,
        percent: json['percent'] ?? 0,
      );
  final int star;
  final int count;
  final int percent;
}

class Prices {
  Prices({
    this.frontSalePrice,
    this.price,
    required this.frontSalePriceWithTaxes,
    required this.priceWithTaxes,
  });

  factory Prices.fromJson(Map<String, dynamic> json) => Prices(
        frontSalePrice: json['front_sale_price'],
        price: json['price'],
        frontSalePriceWithTaxes: json['front_sale_price_with_taxes'] ?? '',
        priceWithTaxes: json['price_with_taxes'] ?? '',
      );
  final int? frontSalePrice;
  final int? price;
  final String frontSalePriceWithTaxes;
  final String priceWithTaxes;
}

class Store {
  Store({
    required this.name,
    required this.email,
    required this.phone,
    required this.address,
    required this.country,
    required this.state,
    required this.city,
    required this.slug,
    required this.description,
    required this.content,
    required this.logo,
    required this.coverImage,
  });

  factory Store.fromJson(Map<String, dynamic> json) => Store(
        name: json['name'] ?? '',
        email: json['email'] ?? '',
        phone: json['phone'] ?? '',
        address: json['address'] ?? '',
        country: json['country'] ?? '',
        state: json['state'] ?? '',
        city: json['city'] ?? '',
        slug: json['slug'] ?? '',
        description: json['description'] ?? '',
        content: json['content'] ?? '',
        logo: json['logo'] ?? '',
        coverImage: json['cover_image'] ?? '',
      );
  final String name;
  final String email;
  final String phone;
  final String address;
  final String country;
  final String state;
  final String city;
  final String slug;
  final String description;
  final String content;
  final String logo;
  final String coverImage;
}

class Brand {
  Brand({required this.name, required this.slug});

  factory Brand.fromJson(Map<String, dynamic> json) => Brand(
        name: json['name'] ?? '',
        slug: json['slug'] ?? '',
      );
  final String name;
  final String slug;
}

class Label {
  Label({required this.name});

  factory Label.fromJson(Map<String, dynamic> json) => Label(
        name: json['name'] ?? '',
      );
  final String name;
}

class Variations {
  Variations({required this.variations, required this.count});

  factory Variations.fromJson(Map<String, dynamic> json) {
    final listVariations = json['variations'] as List? ?? [];
    return Variations(
      variations: listVariations,
      count: json['count'] ?? 0,
    );
  }
  final List<dynamic> variations;
  final int count;
}

class DefaultVariation {
  DefaultVariation({
    required this.id,
    required this.name,
    required this.price,
    required this.salePrice,
  });

  factory DefaultVariation.fromJson(Map<String, dynamic> json) =>
      DefaultVariation(
        id: json['id'] ?? 0,
        name: json['name'] ?? '',
        price: json['price'] ?? '',
        salePrice: json['sale_price'] ?? '',
      );
  final int id;
  final String name;
  final String price;
  final String salePrice;
}

class Category {
  Category({required this.name, required this.slug});

  factory Category.fromJson(Map<String, dynamic> json) => Category(
        name: json['name'] ?? '',
        slug: json['slug'] ?? '',
      );
  final String name;
  final String slug;
}

class Metadata {
  Metadata({required this.name, required this.value});

  factory Metadata.fromJson(Map<String, dynamic> json) => Metadata(
        name: json['name'] ?? '',
        value: json['value'] ?? '',
      );
  final String name;
  final String value;
}
