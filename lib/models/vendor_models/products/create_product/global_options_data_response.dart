import 'dart:convert';

import 'package:flutter/cupertino.dart';

GlobalOptionsDataResponse globalOptionsDataResponseFromJson(String str) =>
    GlobalOptionsDataResponse.fromJson(json.decode(str));

class GlobalOptionsDataResponse {
  GlobalOptionsDataResponse({
    required this.data,
    required this.error,
    required this.message,
  });

  factory GlobalOptionsDataResponse.fromJson(Map<dynamic, dynamic> json) =>
      GlobalOptionsDataResponse(
        data: json['data'] != null
            ? GlobalOptionsData.fromJson(json['data'])
            : null,
        error: json['error'],
        message: json['message'],
      );

  GlobalOptionsData? data;
  bool error;
  String? message;
}

class GlobalOptionsData {
  GlobalOptionsData({
    required this.updatedAt,
    required this.optionType,
    required this.values,
    required this.name,
    required this.createdAt,
    required this.id,
    required this.required,
    required this.nameController,
    required this.optionTypeController,
  });

  factory GlobalOptionsData.fromJson(Map<dynamic, dynamic> json) =>
      GlobalOptionsData(
        updatedAt: json['updated_at'],
        optionType: json['option_type'],
        values: List<GlobalOptionsValues>.from(
            json['values'].map((x) => GlobalOptionsValues.fromJson(x)),),
        name: json['name'],
        createdAt: json['created_at'],
        id: json['id'],
        required: json['required'],
        nameController: TextEditingController(),
        optionTypeController: TextEditingController(),
      );

  String updatedAt;
  String optionType;
  List<GlobalOptionsValues> values;
  String name;
  String createdAt;
  int id;
  int required;
  TextEditingController nameController;
  TextEditingController optionTypeController;

  String getType() {
    String result;
    switch (true) {
      case var _
          when optionType.contains('Botble\\Ecommerce\\Option\\OptionType\\'):
        result = optionType.replaceAll(
            'Botble\\Ecommerce\\Option\\OptionType\\', '',);
        break;
      case var _ when optionType.contains('Botble\\Ecommerce\\Enums\\'):
        result = optionType.replaceAll('Botble\\Ecommerce\\Enums\\', '');
        break;
      default:
        result = optionType;
    }
    return result;
  }
}

class GlobalOptionsValues {
  GlobalOptionsValues({
    required this.updatedAt,
    required this.affectType,
    required this.createdAt,
    required this.optionId,
    required this.optionValue,
    required this.affectPrice,
    required this.id,
    required this.order,
    required this.priceController,
    required this.optionValueController,
  });

  factory GlobalOptionsValues.fromJson(Map<dynamic, dynamic> json) =>
      GlobalOptionsValues(
        updatedAt: json['updated_at'],
        affectType: json['affect_type'],
        createdAt: json['created_at'],
        optionId: json['option_id'],
        optionValue: json['option_value'],
        affectPrice: json['affect_price'],
        id: json['id'],
        order: json['order'],
        priceController: TextEditingController(text: '0'),
        optionValueController: TextEditingController(),
      );

  factory GlobalOptionsValues.defaultData() => GlobalOptionsValues(
        updatedAt: '',
        affectType: 0,
        createdAt: '',
        optionId: 0,
        optionValue: '',
        affectPrice: 0,
        id: 0,
        order: 0,
        priceController: TextEditingController(),
        optionValueController: TextEditingController(),
      );

  String updatedAt;
  int affectType;
  String createdAt;
  int optionId;
  String? optionValue;
  int affectPrice;
  int id;
  int order;
  TextEditingController priceController;
  TextEditingController optionValueController;
}
