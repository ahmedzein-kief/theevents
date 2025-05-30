import 'dart:convert';

CreateProductDataResponse createProductDataResponseFromJson(String str) => CreateProductDataResponse.fromJson(json.decode(str));

class CreateProductDataResponse {
  CreateProductDataResponse({
    required this.data,
    required this.error,
    required this.message,
  });

  CreateProductData data;
  bool error;
  String message;

  factory CreateProductDataResponse.fromJson(Map<dynamic, dynamic> json) => CreateProductDataResponse(
        data: CreateProductData.fromJson(json["data"]),
        error: json["error"],
        message: json["message"],
      );
}

class CreateProductData {
  CreateProductData({
    required this.id,
  });

  int id;

  factory CreateProductData.fromJson(Map<dynamic, dynamic> json) => CreateProductData(
        id: json["id"],
      );
}
