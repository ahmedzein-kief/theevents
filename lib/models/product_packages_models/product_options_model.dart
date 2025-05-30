import 'dart:convert';

ProductOptionsModel productOptionsModelFromJson(String str) => ProductOptionsModel.fromJson(json.decode(str));

String productOptionsModelToJson(ProductOptionsModel data) => json.encode(data.toJson());

class ProductOptionsModel {
  ProductOptionsModel({
    required this.optionType,
    required this.productId,
    required this.values,
    required this.name,
    required this.id,
    required this.required,
    required this.order,
    required this.isError,
  });

  String optionType;
  int productId;
  List<OptionValuesModel> values;
  String name;
  int id;
  int required;
  int order;
  bool isError;

  factory ProductOptionsModel.fromJson(Map<dynamic, dynamic> json) => ProductOptionsModel(
        optionType: json["option_type"],
        productId: json["product_id"],
        values: List<OptionValuesModel>.from(json["values"].map((x) => OptionValuesModel.fromJson(x))),
        name: json["name"],
        id: json["id"],
        required: json["required"],
        order: json["order"],
        isError: false,
      );

  Map<dynamic, dynamic> toJson() => {
        "option_type": optionType,
        "product_id": productId,
        "values": List<dynamic>.from(values.map((x) => x.toJson())),
        "name": name,
        "id": id,
        "required": required,
        "order": order,
      };
}

class OptionValuesModel {
  OptionValuesModel({
    required this.optionValue,
    required this.price,
    required this.formatPrice,
    required this.optionId,
    required this.id,
    required this.order,
  });

  String optionValue;
  int price;
  String formatPrice;
  int optionId;
  int id;
  int order;

  factory OptionValuesModel.fromJson(Map<dynamic, dynamic> json) => OptionValuesModel(
        optionValue: json["option_value"],
        price: json["price"],
        formatPrice: json["format_price"],
        optionId: json["option_id"],
        id: json["id"],
        order: json["order"],
      );

  Map<dynamic, dynamic> toJson() => {
        "option_value": optionValue,
        "price": price,
        "format_price": formatPrice,
        "option_id": optionId,
        "id": id,
        "order": order,
      };
}
