import 'dart:convert';

ProductAttributesModel productAttributesModelFromJson(String str) => ProductAttributesModel.fromJson(json.decode(str));

String productAttributesModelToJson(ProductAttributesModel data) => json.encode(data.toJson());

class ProductAttributesModel {
  ProductAttributesModel({
    required this.keyName,
    required this.isSearchable,
    required this.isUseInProductListing,
    required this.children,
    required this.displayLayout,
    required this.id,
    required this.title,
    required this.key,
    required this.slug,
    required this.isComparable,
  });

  String keyName;
  int isSearchable;
  int isUseInProductListing;
  List<Child> children;
  String displayLayout;
  int id;
  String title;
  int key;
  String slug;
  int isComparable;

  factory ProductAttributesModel.fromJson(Map<dynamic, dynamic> json) => ProductAttributesModel(
        keyName: json["key_name"],
        isSearchable: json["is_searchable"],
        isUseInProductListing: json["is_use_in_product_listing"],
        children: List<Child>.from(json["children"].map((x) => Child.fromJson(x))),
        displayLayout: json["display_layout"],
        id: json["id"],
        title: json["title"],
        key: json["key"],
        slug: json["slug"],
        isComparable: json["is_comparable"],
      );

  Map<dynamic, dynamic> toJson() => {
        "key_name": keyName,
        "is_searchable": isSearchable,
        "is_use_in_product_listing": isUseInProductListing,
        "children": List<dynamic>.from(children.map((x) => x.toJson())),
        "display_layout": displayLayout,
        "id": id,
        "title": title,
        "key": key,
        "slug": slug,
        "is_comparable": isComparable,
      };
}

class Child {
  Child({
    required this.attributeSetId,
    required this.available,
    required this.id,
    required this.title,
    required this.isDefault,
    required this.slug,
    required this.selected,
    required this.order,
  });

  int attributeSetId;
  int available;
  int id;
  String title;
  int isDefault;
  String slug;
  bool selected;
  int order;

  factory Child.fromJson(Map<dynamic, dynamic> json) => Child(
        attributeSetId: json["attribute_set_id"],
        available: json["available"],
        id: json["id"],
        title: json["title"],
        isDefault: json["is_default"],
        slug: json["slug"],
        selected: json["selected"],
        order: json["order"],
      );

  factory Child.defaultData() => Child(
        attributeSetId: -1,
        available: -1,
        id: -1,
        title: "",
        isDefault: -1,
        slug: "",
        selected: false,
        order: -1,
      );

  Map<dynamic, dynamic> toJson() => {
        "attribute_set_id": attributeSetId,
        "available": available,
        "id": id,
        "title": title,
        "is_default": isDefault,
        "slug": slug,
        "selected": selected,
        "order": order,
      };
}
