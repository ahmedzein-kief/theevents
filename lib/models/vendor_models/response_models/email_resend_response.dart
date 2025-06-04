import 'dart:convert';

EmailResendResponse emailResendResponseFromJson(String str) =>
    EmailResendResponse.fromJson(json.decode(str));

String emailResendResponseToJson(EmailResendResponse data) =>
    json.encode(data.toJson());

class EmailResendResponse {
  EmailResendResponse({
    required this.error,
    required this.message,
  });

  factory EmailResendResponse.fromJson(Map<dynamic, dynamic> json) =>
      EmailResendResponse(
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
