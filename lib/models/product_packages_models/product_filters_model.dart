import 'dart:convert';

ProductFiltersModel productFiltersModelFromJson(String str) => ProductFiltersModel.fromJson(json.decode(str));

String productFiltersModelToJson(ProductFiltersModel data) => json.encode(data.toJson());

class ProductFiltersModel {
  ProductFiltersModel({
    required this.rand,
    required this.categoryRequest,
    required this.brands,
    required this.maxPrice,
    required this.categoryId,
    required this.categories,
    required this.tags,
    required this.attributesSet,
  });

  factory ProductFiltersModel.fromJson(Map<dynamic, dynamic> json) => ProductFiltersModel(
        rand: json['rand'] ?? 0,
        categoryRequest:
            json['categoryRequest'] != null ? List<dynamic>.from(json['categoryRequest'].map((x) => x)) : [],
        brands: json['brands'] != null
            ? List<FilterBrand>.from(
                json['brands'].map((x) => FilterBrand.fromJson(x)),
              )
            : [],
        maxPrice: json['max_price'] ?? 0,
        categoryId: json['category_id'] ?? 0,
        categories: json['categories'] != null
            ? List<ProductFiltersModelCategory>.from(
                json['categories'].map((x) => ProductFiltersModelCategory.fromJson(x)),
              )
            : [],
        tags: json['tags'] != null ? List<Tag>.from(json['tags'].map((x) => Tag.fromJson(x))) : [],
        attributesSet: json['attributeSets'] != null
            ? List<AttributeSet>.from(
                json['attributeSets'].map((x) => AttributeSet.fromJson(x)),
              )
            : [],
      );

  int rand;
  List<dynamic> categoryRequest;
  List<FilterBrand> brands;
  int maxPrice;
  int categoryId;
  List<ProductFiltersModelCategory> categories;
  List<Tag> tags;
  List<AttributeSet> attributesSet;

  // Method to combine lists into a map
  Map<String, dynamic> toCombinedMap() => {
        'categories': categories, // Return the full list of categories
        'brands': brands, // Return the full list of brands
        'tags': tags, // Return the full list of tags
      };

  Map<dynamic, dynamic> toJson() => {
        'rand': rand,
        'categoryRequest': List<dynamic>.from(categoryRequest.map((x) => x)),
        'brands': List<dynamic>.from(brands.map((x) => x.toJson())),
        'max_price': maxPrice,
        'category_id': categoryId,
        'categories': List<dynamic>.from(categories.map((x) => x.toJson())),
        'tags': List<dynamic>.from(tags.map((x) => x.toJson())),
        'attributeSets': List<dynamic>.from(attributesSet.map((x) => x.toJson())),
      };
}

class AttributeSet {
  AttributeSet({
    required this.id,
    required this.title,
    required this.slug,
    required this.displayLayout,
    required this.isSearchable,
    required this.isComparable,
    required this.isUseInProductListing,
    required this.order,
    required this.createdAt,
    required this.updatedAt,
    required this.useImageFromProductVariation,
    required this.attributes,
    required this.categories,
  });

  factory AttributeSet.fromJson(Map<String, dynamic> json) => AttributeSet(
        id: json['id'],
        title: json['title'] ?? '',
        slug: json['slug'],
        displayLayout: json['display_layout'],
        isSearchable: json['is_searchable'] == 1,
        isComparable: json['is_comparable'] == 1,
        isUseInProductListing: json['is_use_in_product_listing'] == 1,
        order: json['order'],
        createdAt: DateTime.parse(json['created_at']),
        updatedAt: DateTime.parse(json['updated_at']),
        useImageFromProductVariation: json['use_image_from_product_variation'] == 1,
        attributes: (json['attributes'] as List).map((item) => Attribute.fromJson(item)).toList(),
        categories: List<dynamic>.from(json['categories']),
      );
  final int id;
  final String? title;
  final String slug;
  final String displayLayout;
  final bool isSearchable;
  final bool isComparable;
  final bool isUseInProductListing;
  final int order;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool useImageFromProductVariation;
  final List<Attribute> attributes;
  final List<dynamic> categories;

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'slug': slug,
        'display_layout': displayLayout,
        'is_searchable': isSearchable ? 1 : 0,
        'is_comparable': isComparable ? 1 : 0,
        'is_use_in_product_listing': isUseInProductListing ? 1 : 0,
        'order': order,
        'created_at': createdAt.toIso8601String(),
        'updated_at': updatedAt.toIso8601String(),
        'use_image_from_product_variation': useImageFromProductVariation ? 1 : 0,
        'attributes': attributes.map((item) => item.toJson()).toList(), // Assuming Attribute class has a toJson method.
        'categories': categories,
      };
}

class Attribute {
  Attribute({
    required this.id,
    required this.attributeSetId,
    required this.title,
    required this.slug,
    required this.color,
    this.image,
    required this.isDefault,
    required this.order,
    required this.createdAt,
    required this.updatedAt,
    required this.translations,
  });

  factory Attribute.fromJson(Map<String, dynamic> json) => Attribute(
        id: json['id'],
        attributeSetId: json['attribute_set_id'],
        title: json['title'] ?? '',
        slug: json['slug'],
        color: json['color'] ?? '',
        image: json['image'],
        isDefault: json['is_default'] == 1,
        order: json['order'],
        createdAt: DateTime.parse(json['created_at']),
        updatedAt: DateTime.parse(json['updated_at']),
        translations: List<dynamic>.from(json['translations']),
      );
  final int id;
  final int attributeSetId;
  final String? title;
  final String slug;
  final String? color;
  final String? image;
  final bool isDefault;
  final int order;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<dynamic> translations;

  Map<String, dynamic> toJson() => {
        'id': id,
        'attribute_set_id': attributeSetId,
        'title': title,
        'slug': slug,
        'color': color,
        'image': image,
        'is_default': isDefault ? 1 : 0, // Converting boolean to 1/0
        'order': order,
        'created_at': createdAt.toIso8601String(),
        'updated_at': updatedAt.toIso8601String(),
        'translations': translations,
      };
}

class FilterBrand {
  FilterBrand({
    this.description,
    required this.createdAt,
    required this.productsCount,
    this.title,
    required this.slugable,
    required this.updatedAt,
    required this.name,
    required this.logo,
    required this.id,
    required this.coverImage,
    required this.categories,
    required this.isFeatured,
    required this.status,
    required this.order,
    this.selected = false,
  });

  factory FilterBrand.fromJson(Map<dynamic, dynamic> json) => FilterBrand(
        description: json['description'] ?? '',
        createdAt: DateTime.parse(json['created_at']),
        productsCount: json['products_count'],
        title: json['title'] ?? '',
        slugable: Slugable.fromJson(json['slugable']),
        updatedAt: DateTime.parse(json['updated_at']),
        name: json['name'],
        logo: json['logo'],
        id: json['id'],
        coverImage: json['cover_image'],
        categories: List<BrandCategory>.from(
          json['categories'].map((x) => BrandCategory.fromJson(x)),
        ),
        isFeatured: json['is_featured'],
        status: Status.fromJson(json['status']),
        order: json['order'],
      );

  String? description;
  DateTime createdAt;
  int productsCount;
  String? title;
  Slugable slugable;
  DateTime updatedAt;
  String name;
  String logo;
  int id;
  String coverImage;
  List<BrandCategory> categories;
  int isFeatured;
  Status status;
  int order;
  bool selected;

  Map<dynamic, dynamic> toJson() => {
        'description': description,
        'created_at': createdAt.toIso8601String(),
        'products_count': productsCount,
        'title': title,
        'slugable': slugable.toJson(),
        'updated_at': updatedAt.toIso8601String(),
        'name': name,
        'logo': logo,
        'id': id,
        'cover_image': coverImage,
        'categories': List<dynamic>.from(categories.map((x) => x.toJson())),
        'is_featured': isFeatured,
        'status': status,
        'order': order,
      };
}

class BrandCategory {
  BrandCategory({
    required this.image,
    this.icon,
    required this.iconImage,
    required this.createdAt,
    required this.updatedAt,
    required this.parentId,
    required this.name,
    required this.pivot,
    required this.id,
    required this.isFeatured,
    required this.status,
    required this.order,
  });

  factory BrandCategory.fromJson(Map<dynamic, dynamic> json) => BrandCategory(
        image: json['image'],
        icon: json['icon'],
        iconImage: json['icon_image'],
        createdAt: DateTime.parse(json['created_at']),
        updatedAt: DateTime.parse(json['updated_at']),
        parentId: json['parent_id'],
        name: json['name'],
        pivot: Pivot.fromJson(json['pivot']),
        id: json['id'],
        isFeatured: json['is_featured'],
        status: Status.fromJson(json['status']),
        order: json['order'],
      );

  String image;
  String? icon;
  String iconImage;
  DateTime createdAt;
  DateTime updatedAt;
  int parentId;
  String name;
  Pivot pivot;
  int id;
  int isFeatured;
  Status status;
  int order;

  Map<dynamic, dynamic> toJson() => {
        'image': image,
        'icon': icon,
        'icon_image': iconImage,
        'created_at': createdAt.toIso8601String(),
        'updated_at': updatedAt.toIso8601String(),
        'parent_id': parentId,
        'name': name,
        'pivot': pivot.toJson(),
        'id': id,
        'is_featured': isFeatured,
        'status': status,
        'order': order,
      };
}

class Pivot {
  Pivot({
    required this.referenceId,
    required this.categoryId,
    required this.referenceType,
  });

  factory Pivot.fromJson(Map<dynamic, dynamic> json) => Pivot(
        referenceId: json['reference_id'],
        categoryId: json['category_id'],
        referenceType: referenceTypeValues.map[json['reference_type']]!,
      );

  int referenceId;
  int categoryId;
  ReferenceType referenceType;

  Map<dynamic, dynamic> toJson() => {
        'reference_id': referenceId,
        'category_id': categoryId,
        'reference_type': referenceTypeValues.reverse[referenceType],
      };
}

enum ReferenceType { BOTBLE_ECOMMERCE_MODELS_BRAND, BOTBLE_ECOMMERCE_MODELS_PRODUCT_TAG }

final referenceTypeValues = EnumValues(
  {
    'Botble\\Ecommerce\\Models\\Brand': ReferenceType.BOTBLE_ECOMMERCE_MODELS_BRAND,
    'Botble\\Ecommerce\\Models\\ProductTag': ReferenceType.BOTBLE_ECOMMERCE_MODELS_PRODUCT_TAG,
  },
);

class Status {
  Status({
    required this.label,
    required this.value,
  });

  factory Status.fromJson(Map<dynamic, dynamic> json) => Status(
        label: json['label'],
        value: json['value'],
      );

  String? label;
  String? value;
}

class Slugable {
  Slugable({
    required this.referenceId,
    required this.prefix,
    required this.id,
    required this.key,
    required this.referenceType,
  });

  factory Slugable.fromJson(Map<dynamic, dynamic> json) => Slugable(
        referenceId: json['reference_id'],
        prefix: prefixValues.map[json['prefix']]!,
        id: json['id'],
        key: json['key'],
        referenceType: referenceTypeValues.map[json['reference_type']]!,
      );

  int referenceId;
  Prefix prefix;
  int id;
  String key;
  ReferenceType referenceType;

  Map<dynamic, dynamic> toJson() => {
        'reference_id': referenceId,
        'prefix': prefixValues.reverse[prefix],
        'id': id,
        'key': key,
        'reference_type': referenceTypeValues.reverse[referenceType],
      };
}

enum Prefix { BRANDS, PRODUCT_TAGS }

final prefixValues = EnumValues({'brands': Prefix.BRANDS, 'product-tags': Prefix.PRODUCT_TAGS});

class ProductFiltersModelCategory {
  ProductFiltersModelCategory({
    required this.image,
    this.mobileCoverImage,
    required this.parentId,
    required this.name,
    required this.iconImage,
    required this.id,
    required this.url,
    this.icon,
    this.selected = false,
  });

  factory ProductFiltersModelCategory.fromJson(Map<dynamic, dynamic> json) => ProductFiltersModelCategory(
        image: json['image'],
        mobileCoverImage: json['cover_image_for_mobile'],
        parentId: json['parent_id'],
        name: json['name'],
        iconImage: json['icon_image'],
        id: json['id'],
        url: json['url'],
        icon: json['icon'],
      );

  String? image;
  String? mobileCoverImage;
  int parentId;
  String name;
  String iconImage;
  int id;
  String url;
  String? icon;
  bool selected;

  Map<dynamic, dynamic> toJson() => {
        'image': image,
        'cover_image_for_mobile': mobileCoverImage,
        'parent_id': parentId,
        'name': name,
        'icon_image': iconImage,
        'id': id,
        'url': url,
        'icon': icon,
      };
}

class Tag {
  Tag({
    required this.image,
    required this.updatedAt,
    required this.name,
    required this.description,
    required this.createdAt,
    required this.productsCount,
    required this.id,
    required this.coverImage,
    required this.slugable,
    required this.status,
    this.selected = false,
  });

  factory Tag.fromJson(Map<dynamic, dynamic> json) => Tag(
        image: json['image'] ?? '',
        updatedAt: DateTime.parse(json['updated_at']),
        name: json['name'],
        description: json['description'] ?? '',
        createdAt: DateTime.parse(json['created_at']),
        productsCount: json['products_count'],
        id: json['id'],
        coverImage: json['cover_image'],
        slugable: Slugable.fromJson(json['slugable']),
        status: Status.fromJson(json['status']),
      );

  String? image;
  DateTime updatedAt;
  String name;
  String? description;
  DateTime createdAt;
  int productsCount;
  int id;
  String coverImage;
  Slugable slugable;
  Status status;
  bool selected;

  Map<dynamic, dynamic> toJson() => {
        'image': image,
        'updated_at': updatedAt.toIso8601String(),
        'name': name,
        'description': description,
        'created_at': createdAt.toIso8601String(),
        'products_count': productsCount,
        'id': id,
        'cover_image': coverImage,
        'slugable': slugable.toJson(),
        'status': status,
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
