import 'dart:convert';

/// data : "null"
/// message : "The email field is required. (and 2 more errors)"
/// errors : {"email":["The email field is required."],"phone":["The phone field is required."],"country":["The country field is required."]}

VendorSettingsModel vendorSettingsModelFromJson(String str) => VendorSettingsModel.fromJson(json.decode(str));

String vendorSettingsModelToJson(VendorSettingsModel data) => json.encode(data.toJson());

class VendorSettingsModel {
  VendorSettingsModel({
    String? data,
    String? message,
    Errors? errors,
  }) {
    _data = data;
    _message = message;
    _errors = errors;
  }

  VendorSettingsModel.fromJson(dynamic json) {
    _data = json['data'];
    _message = json['message'];
    _errors = json['errors'] != null ? Errors.fromJson(json['errors']) : null;
  }

  String? _data;
  String? _message;
  Errors? _errors;

  VendorSettingsModel copyWith({
    String? data,
    String? message,
    Errors? errors,
  }) =>
      VendorSettingsModel(
        data: data ?? _data,
        message: message ?? _message,
        errors: errors ?? _errors,
      );

  String? get data => _data;

  String? get message => _message;

  Errors? get errors => _errors;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['data'] = _data;
    map['message'] = _message;
    if (_errors != null) {
      map['errors'] = _errors?.toJson();
    }
    return map;
  }
}

/// email : ["The email field is required."]
/// phone : ["The phone field is required."]
/// country : ["The country field is required."]

Errors errorsFromJson(String str) => Errors.fromJson(json.decode(str));

String errorsToJson(Errors data) => json.encode(data.toJson());

class Errors {
  Errors({
    List<String>? email,
    List<String>? phone,
    List<String>? country,
  }) {
    _email = email;
    _phone = phone;
    _country = country;
  }

  Errors.fromJson(dynamic json) {
    _email = json['email'] != null ? json['email'].cast<String>() : [];
    _phone = json['phone'] != null ? json['phone'].cast<String>() : [];
    _country = json['country'] != null ? json['country'].cast<String>() : [];
  }

  List<String>? _email;
  List<String>? _phone;
  List<String>? _country;

  Errors copyWith({
    List<String>? email,
    List<String>? phone,
    List<String>? country,
  }) =>
      Errors(
        email: email ?? _email,
        phone: phone ?? _phone,
        country: country ?? _country,
      );

  List<String>? get email => _email;

  List<String>? get phone => _phone;

  List<String>? get country => _country;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['email'] = _email;
    map['phone'] = _phone;
    map['country'] = _country;
    return map;
  }
}
