import 'dart:convert';

ProductOptionsPostModel productOptionsPostModelFromJson(String str) => ProductOptionsPostModel.fromJson(json.decode(str));

Map<String, dynamic> productOptionsPostModelToJson(ProductOptionsPostModel data) => data.toJson();

class ProductOptionsPostModel {
  ProductOptionsPostModel({
    required this.options,
  });

  List<ProductOption> options;

  factory ProductOptionsPostModel.fromJson(Map<dynamic, dynamic> json) => ProductOptionsPostModel(
        options: List<ProductOption>.from(json["options"].map((x) => ProductOption.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "options": options.map((x) => x.toJson()).toList(),
      };
}

class ProductOption {
  ProductOption({
    required this.optionType,
    required this.values,
    required this.name,
    required this.id,
    required this.required,
    required this.order,
  });

  String optionType;
  List<OptionValues> values;
  String name;
  String id;
  String required;
  String order;

  factory ProductOption.fromJson(Map<dynamic, dynamic> json) => ProductOption(
        optionType: json["option_type"],
        values: List<OptionValues>.from(json["values"].map((x) => OptionValues.fromJson(x))),
        name: json["name"],
        id: json["id"],
        required: json["required"],
        order: json["order"],
      );

  Map<String, dynamic> toJson() => {
        "option_type": optionType,
        "values": values.map((x) => x.toJson()).toList(),
        "name": name,
        "id": id,
        "required": required,
        "order": order,
      };
}

class OptionValues {
  OptionValues({
    required this.optionValue,
    required this.affectType,
    required this.affectPrice,
    required this.id,
    required this.order,
  });

  String optionValue;
  String affectType;
  String affectPrice;
  String id;
  String order;

  factory OptionValues.fromJson(Map<dynamic, dynamic> json) => OptionValues(
        optionValue: json["option_value"],
        affectType: json["affect_type"],
        affectPrice: json["affect_price"],
        id: json["id"],
        order: json["order"],
      );

  Map<String, dynamic> toJson() => {
        "option_value": optionValue,
        "affect_type": affectType,
        "affect_price": affectPrice,
        "id": id,
        "order": order,
      };
}
