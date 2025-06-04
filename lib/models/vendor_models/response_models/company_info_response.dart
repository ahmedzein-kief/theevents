import 'dart:convert';

CompanyInfoResponse companyInfoResponseFromJson(String str) =>
    CompanyInfoResponse.fromJson(json.decode(str));

String companyInfoResponseToJson(CompanyInfoResponse data) =>
    json.encode(data.toJson());

class CompanyInfoResponse {
  CompanyInfoResponse({
    required this.error,
    required this.message,
  });

  factory CompanyInfoResponse.fromJson(Map<dynamic, dynamic> json) =>
      CompanyInfoResponse(
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
