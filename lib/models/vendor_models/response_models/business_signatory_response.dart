import 'dart:convert';

BusinessSignatoryResponse businessSignatoryResponseFromJson(String str) =>
    BusinessSignatoryResponse.fromJson(json.decode(str));

String businessSignatoryResponseToJson(BusinessSignatoryResponse data) =>
    json.encode(data.toJson());

class BusinessSignatoryResponse {
  BusinessSignatoryResponse({
    required this.error,
    required this.message,
  });

  factory BusinessSignatoryResponse.fromJson(Map<dynamic, dynamic> json) =>
      BusinessSignatoryResponse(
        error: json['error'],
        message: json['message'],
      );

  bool error;
  String message;

  Map<dynamic, dynamic> toJson() => {
        'error': error,
        'message': message,
      };
}
