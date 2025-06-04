import 'dart:convert';

/// error : false
/// data : "RZPMMMBFUVJS"
/// message : null

VendorGenerateCouponCodeModel vendorGenerateCouponCodeModelFromJson(
        String str) =>
    VendorGenerateCouponCodeModel.fromJson(json.decode(str));

String vendorGenerateCouponCodeModelToJson(
        VendorGenerateCouponCodeModel data) =>
    json.encode(data.toJson());

class VendorGenerateCouponCodeModel {
  VendorGenerateCouponCodeModel({
    bool? error,
    String? data,
    message,
  }) {
    _error = error;
    _data = data;
    _message = message;
  }

  VendorGenerateCouponCodeModel.fromJson(json) {
    _error = json['error'];
    _data = json['data'];
    _message = json['message'];
  }

  bool? _error;
  String? _data;
  dynamic _message;

  VendorGenerateCouponCodeModel copyWith({
    bool? error,
    String? data,
    message,
  }) =>
      VendorGenerateCouponCodeModel(
        error: error ?? _error,
        data: data ?? _data,
        message: message ?? _message,
      );

  bool? get error => _error;

  String? get data => _data;

  dynamic get message => _message;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['error'] = _error;
    map['data'] = _data;
    map['message'] = _message;
    return map;
  }
}
