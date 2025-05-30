import 'dart:convert';

BankDetailsResponse bankDetailsResponseFromJson(String str) => BankDetailsResponse.fromJson(json.decode(str));

String bankDetailsResponseToJson(BankDetailsResponse data) => json.encode(data.toJson());

class BankDetailsResponse {
  BankDetailsResponse({
    required this.error,
    required this.message,
  });

  bool error;
  String message;

  factory BankDetailsResponse.fromJson(Map<dynamic, dynamic> json) => BankDetailsResponse(
        error: json["error"],
        message: json["message"],
      );

  Map<dynamic, dynamic> toJson() => {
        "error": error,
        "message": message,
      };
}
