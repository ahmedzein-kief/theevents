import 'login_models.dart';

// class SignUpResponse {
//   bool? error;
//   UserAuthData? data;
//   Map<String, List<String>>? errors;
//   String? message;
//
//   SignUpResponse({
//     this.error,
//     this.data,
//     this.errors,
//     this.message,
//   });
//
//   SignUpResponse.fromJson(Map<String, dynamic> json) {
//     error = json['error'] ?? false;
//     data = json['data'] != null ? UserAuthData.fromJson(json['data']) : null;
//     errors = json['errors'] != null ? Map<String, List<String>>.from(json['errors']) : null;
//     message = json['message'] != null ? json['message'] : null;
//   }
// }
class SignUpResponse {
  bool? error;
  UserAuthData? data;
  Map<String, List<String>>? errors;
  String? message;

  SignUpResponse({
    this.error,
    this.data,
    this.errors,
    this.message,
  });

  factory SignUpResponse.fromJson(Map<String, dynamic>? json) {
    if (json == null) return SignUpResponse(); // Handle null JSON input safely

    return SignUpResponse(
      error: json['error'] as bool?,
      data: json['data'] != null ? UserAuthData.fromJson(json['data']) : null,
      errors: json['errors'] != null
          ? (json['errors'] as Map?)?.map((key, value) => MapEntry(
          key.toString(), (value as List?)?.map((e) => e.toString()).toList() ?? []))
          : null,
      message: json['message'] as String?,
    );
  }
}

extension SignUpResponseExtension on SignUpResponse {
  String get formattedErrors {
    if (errors == null || errors!.isEmpty) return "";
    return errors!.values.map((list) => list.first).join("\n");
  }
}

