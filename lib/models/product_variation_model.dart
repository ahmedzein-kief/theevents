import 'dart:convert';

ProductVariationModel productVariationModelFromJson(String str) =>
    ProductVariationModel.fromJson(json.decode(str));

class ProductVariationModel {
  ProductVariationModel({
    required this.data,
    required this.error,
  });

  factory ProductVariationModel.fromJson(Map<dynamic, dynamic> json) =>
      ProductVariationModel(
        data: Data.fromJson(json['data']),
        error: json['error'],
      );

  Data data;
  bool error;
}

class Data {
  Data({
    required this.originalPrice,
    required this.description,
    required this.isOutOfStock,
    required this.price,
    required this.id,
    required this.displaySalePrice,
    required this.sku,
    required this.slug,
    required this.height,
    required this.imageWithSizes,
    required this.quantity,
    required this.displayPrice,
    required this.wide,
    required this.unavailableAttributeIds,
    required this.length,
    required this.weight,
    required this.withStorehouseManagement,
    required this.salePrice,
    required this.salePercentage,
    required this.selectedAttributes,
    required this.stockStatusLabel,
    required this.stockStatusHtml,
    required this.successMessage,
    required this.errorMessage,
    required this.name,
  });

  factory Data.fromJson(Map<dynamic, dynamic> json) => Data(
        originalPrice: json['original_price'],
        description: json['description'],
        isOutOfStock: json['is_out_of_stock'],
        price: json['price'],
        id: json['id'],
        displaySalePrice: json['display_sale_price'],
        sku: json['sku'],
        slug: json['slug'],
        height: json['height'],
        imageWithSizes: ImageWithSizes.fromJson(json['image_with_sizes']),
        quantity: json['quantity'],
        displayPrice: json['display_price'],
        wide: json['wide'],
        unavailableAttributeIds:
            List<dynamic>.from(json['unavailable_attribute_ids'].map((x) => x)),
        length: json['length'],
        weight: json['weight'],
        withStorehouseManagement: json['with_storehouse_management'],
        salePrice: json['sale_price'],
        salePercentage: json['sale_percentage'],
        selectedAttributes: List<SelectedAttribute>.from(
            json['selected_attributes']
                .map((x) => SelectedAttribute.fromJson(x))),
        stockStatusLabel: json['stock_status_label'],
        stockStatusHtml: json['stock_status_html'],
        successMessage: json['success_message'],
        errorMessage: json['error_message'],
        name: json['name'],
      );

  int originalPrice;
  String description;
  bool isOutOfStock;
  int price;
  int id;
  String displaySalePrice;
  String? sku;
  String slug;
  int height;
  ImageWithSizes imageWithSizes;
  int? quantity;
  String displayPrice;
  int wide;
  List<dynamic> unavailableAttributeIds;
  int length;
  int weight;
  int withStorehouseManagement;
  int salePrice;
  String salePercentage;
  List<SelectedAttribute> selectedAttributes;
  String stockStatusLabel;
  String stockStatusHtml;
  String? successMessage;
  String? errorMessage;
  String name;
}

class ImageWithSizes {
  ImageWithSizes({
    required this.thumb,
    required this.origin,
  });

  factory ImageWithSizes.fromJson(Map<dynamic, dynamic> json) => ImageWithSizes(
        thumb: List<String>.from(json['thumb'].map((x) => x)),
        origin: List<String>.from(json['origin'].map((x) => x)),
      );

  List<String> thumb;
  List<String> origin;

  Map<dynamic, dynamic> toJson() => {
        'thumb': List<dynamic>.from(thumb.map((x) => x)),
        'origin': List<dynamic>.from(origin.map((x) => x)),
      };
}

class SelectedAttribute {
  SelectedAttribute({
    required this.setSlug,
    required this.setId,
    required this.id,
    required this.slug,
  });

  factory SelectedAttribute.fromJson(Map<dynamic, dynamic> json) =>
      SelectedAttribute(
        setSlug: json['set_slug'],
        setId: json['set_id'],
        id: json['id'],
        slug: json['slug'],
      );

  String setSlug;
  int setId;
  int id;
  String slug;
}
