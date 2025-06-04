import 'dart:convert';

PaymentMethodsResponse paymentMethodsResponseFromJson(String str) =>
    PaymentMethodsResponse.fromJson(json.decode(str));

String paymentMethodsResponseToJson(PaymentMethodsResponse data) =>
    json.encode(data.toJson());

class PaymentMethodsResponse {
  PaymentMethodsResponse({
    required this.data,
    required this.error,
  });

  factory PaymentMethodsResponse.fromJson(Map<dynamic, dynamic> json) =>
      PaymentMethodsResponse(
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
    required this.paymentMethods,
    required this.dataDefault,
    required this.currency,
    required this.selecting,
  });

  factory Data.fromJson(Map<dynamic, dynamic> json) => Data(
        paymentMethods: List<PaymentMethod>.from(
            json['payment_methods'].map((x) => PaymentMethod.fromJson(x))),
        dataDefault: json['default'],
        currency: json['currency'],
        selecting: json['selecting'],
      );

  List<PaymentMethod> paymentMethods;
  String dataDefault;
  String currency;
  String selecting;

  Map<dynamic, dynamic> toJson() => {
        'payment_methods':
            List<dynamic>.from(paymentMethods.map((x) => x.toJson())),
        'default': dataDefault,
        'currency': currency,
        'selecting': selecting,
      };
}

class PaymentMethod {
  PaymentMethod({
    required this.image,
    required this.code,
    required this.imgWidth,
    required this.imgWidth1,
    required this.name,
    required this.description,
    required this.subOptions,
    required this.label,
    required this.image1,
  });

  factory PaymentMethod.fromJson(Map<dynamic, dynamic> json) => PaymentMethod(
        image: json['image'],
        code: json['code'],
        imgWidth: json['img_width'],
        imgWidth1: json['img_width1'],
        name: json['name'],
        description: json['description'],
        subOptions: List<SubOption>.from(
            json['sub_options'].map((x) => SubOption.fromJson(x))),
        label: json['label'],
        image1: json['image1'],
      );

  String image;
  String code;
  int imgWidth;
  int imgWidth1;
  String name;
  String description;
  List<SubOption> subOptions;
  String label;
  String image1;

  Map<dynamic, dynamic> toJson() => {
        'image': image,
        'code': code,
        'img_width': imgWidth,
        'img_width1': imgWidth1,
        'name': name,
        'description': description,
        'sub_options': List<dynamic>.from(subOptions.map((x) => x.toJson())),
        'label': label,
        'image1': image1,
      };
}

class SubOption {
  SubOption({
    required this.value,
    required this.key,
  });

  factory SubOption.fromJson(Map<dynamic, dynamic> json) => SubOption(
        value: List<Value>.from(json['value'].map((x) => Value.fromJson(x))),
        key: json['key'],
      );

  List<Value> value;
  String key;

  Map<dynamic, dynamic> toJson() => {
        'value': List<dynamic>.from(value.map((x) => x.toJson())),
        'key': key,
      };
}

class Value {
  Value({
    required this.id,
    required this.title,
    this.isDefault,
    required this.value,
  });

  factory Value.fromJson(Map<dynamic, dynamic> json) => Value(
        id: json['id'],
        title: json['title'],
        isDefault: json['is_default'],
        value: json['value'],
      );

  String id;
  String title;
  bool? isDefault;
  String value;

  Map<dynamic, dynamic> toJson() => {
        'id': id,
        'title': title,
        'is_default': isDefault,
        'value': value,
      };
}
