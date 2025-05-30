import 'dart:convert';

import 'package:event_app/provider/api_response_handler.dart';
import 'package:event_app/utils/apiendpoints/api_end_point.dart';
import 'package:flutter/cupertino.dart';

class PaymentMethodsResponse {
  bool error;
  PaymentMethodsData data;
  String? message;

  PaymentMethodsResponse({
    required this.error,
    required this.data,
    this.message,
  });

  factory PaymentMethodsResponse.fromJson(Map<String, dynamic> json) {
    return PaymentMethodsResponse(
      error: json['error'],
      data: PaymentMethodsData.fromJson(json['data']),
      message: json['message'],
    );
  }
}

class PaymentMethodsData {
  List<PaymentMethod> paymentMethods;
  String currency;
  String? selectedMethod;
  String defaultMethod;
  String selecting;

  PaymentMethodsData({
    required this.paymentMethods,
    required this.currency,
    this.selectedMethod,
    required this.defaultMethod,
    required this.selecting,
  });

  factory PaymentMethodsData.fromJson(Map<String, dynamic> json) {
    return PaymentMethodsData(
      paymentMethods: List<PaymentMethod>.from(json['payment_methods'].map((x) => PaymentMethod.fromJson(x))),
      currency: json['currency'],
      selectedMethod: json['selected_method'],
      defaultMethod: json['default'],
      selecting: json['selecting'],
    );
  }
}

class PaymentMethod {
  String label;
  String name;
  String code;
  String description;
  String image;
  String image1;
  int imgWidth;
  int imgWidth1;
  List<SubOption> subOptions;

  PaymentMethod({
    required this.label,
    required this.name,
    required this.code,
    required this.description,
    required this.image,
    required this.image1,
    required this.imgWidth,
    required this.imgWidth1,
    required this.subOptions,
  });

  factory PaymentMethod.fromJson(Map<String, dynamic> json) {
    return PaymentMethod(
      label: json['label'],
      name: json['name'],
      code: json['code'],
      description: json['description'],
      image: json['image'],
      image1: json['image1'],
      imgWidth: json['img_width'],
      imgWidth1: json['img_width1'],
      subOptions: List<SubOption>.from(json['sub_options'].map((x) => SubOption.fromJson(x))),
    );
  }
}

class SubOption {
  String key;
  List<PaymentType> value;

  SubOption({
    required this.key,
    required this.value,
  });

  factory SubOption.fromJson(Map<String, dynamic> json) {
    return SubOption(
      key: json['key'],
      value: List<PaymentType>.from(json['value'].map((x) => PaymentType.fromJson(x))),
    );
  }
}

class PaymentType {
  String title;
  String value;
  String id;
  bool isDefault;

  PaymentType({
    required this.title,
    required this.value,
    required this.id,
    required this.isDefault,
  });

  factory PaymentType.fromJson(Map<String, dynamic> json) {
    return PaymentType(
      title: json['title'],
      value: json['value'],
      id: json['id'],
      isDefault: json['is_default'] ?? false,
    );
  }
}

class PaymentMethodProviderGiftCard with ChangeNotifier {
  final ApiResponseHandler _apiResponseHandler = ApiResponseHandler();

  List<PaymentMethod> _paymentMethods = [];
  String? selectedMethod;
  bool isLoading = true;
  bool hasError = false;

  List<PaymentMethod> get paymentMethods => _paymentMethods;

  Future<void> fetchPaymentMethods(BuildContext context) async {
    final url = ApiEndpoints.paymentMethods;
    try {
      final response = await _apiResponseHandler.getRequest(
        url,
        context: context,
      );

      if (response.statusCode == 200) {
        final decodedData = json.decode(response.body);
        PaymentMethodsResponse result = PaymentMethodsResponse.fromJson(decodedData);

        _paymentMethods = result.data.paymentMethods; // Access the list properly
        selectedMethod = result.data.selectedMethod ?? result.data.paymentMethods[0].name;
        hasError = false;
      } else {
        hasError = true;
      }
    } catch (error) {
      hasError = true;
    }
    isLoading = false;
    notifyListeners();
  }

  void setSelectedMethod(String method) {
    selectedMethod = method;
    notifyListeners();
  }
}
