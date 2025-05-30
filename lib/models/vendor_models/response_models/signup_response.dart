import 'dart:convert';

SignUpResponse vendorSignupResponseFromJson(String str) => SignUpResponse.fromJson(json.decode(str));

class SignUpResponse {
  SignUpResponse({
    required this.data,
    required this.error,
    required this.message,
  });

  Data? data;
  bool error;
  String message;

  factory SignUpResponse.fromJson(Map<dynamic, dynamic> json) => SignUpResponse(
        data: json["data"] != null ? Data.fromJson(json["data"]) : null,
        error: json["error"],
        message: json["message"],
      );
}

class Data {
  Data({
    required this.avatar,
    required this.title,
    required this.tokenType,
    required this.isVerified,
    required this.token,
    required this.name,
    required this.isApproved,
    required this.company,
    required this.isVendor,
    required this.step,
    required this.id,
    required this.email,
  });

  String avatar;
  String title;
  String tokenType;
  bool isVerified;
  String token;
  String name;
  bool isApproved;
  String company;
  bool isVendor;
  int step;
  int id;
  String email;

  factory Data.fromJson(Map<dynamic, dynamic> json) => Data(
        avatar: json["avatar"],
        title: json["title"],
        tokenType: json["token_type"],
        isVerified: json["is_verified"],
        token: json["token"],
        name: json["name"],
        isApproved: json["is_approved"],
        company: json["company"],
        isVendor: json["is_vendor"],
        step: json["step"],
        id: json["id"],
        email: json["email"],
      );

  Map<dynamic, dynamic> toJson() => {
        "avatar": avatar,
        "title": title,
        "token_type": tokenType,
        "is_verified": isVerified,
        "token": token,
        "name": name,
        "is_approved": isApproved,
        "company": company,
        "is_vendor": isVendor,
        "step": step,
        "id": id,
        "email": email,
      };
}
