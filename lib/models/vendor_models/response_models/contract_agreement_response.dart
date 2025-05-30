import 'dart:convert';

ContractAgreementResponse companyInfoResponseFromJson(String str) => ContractAgreementResponse.fromJson(json.decode(str));

String contractAgreementResponseToJson(ContractAgreementResponse data) => json.encode(data.toJson());

class ContractAgreementResponse {
  ContractAgreementResponse({
    required this.error,
    required this.message,
  });

  bool error;
  String message;

  factory ContractAgreementResponse.fromJson(Map<dynamic, dynamic> json) => ContractAgreementResponse(
        error: json["error"],
        message: json["message"],
      );

  Map<dynamic, dynamic> toJson() => {
        "error": error,
        "message": message,
      };
}
