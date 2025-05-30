import 'dart:convert';

CommonDataResponse commonDataResponseFromJson(String str) => CommonDataResponse.fromJson(json.decode(str));

class CommonDataResponse {
    CommonDataResponse({
        required this.error,
        required this.message,
    });

    bool? error;
    String? message;

    factory CommonDataResponse.fromJson(Map<dynamic, dynamic> json) => CommonDataResponse(
        error: json["error"],
        message: json["message"],
    );
}
