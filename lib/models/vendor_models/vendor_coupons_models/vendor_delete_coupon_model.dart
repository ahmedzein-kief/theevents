import 'dart:convert';

/// error : true
/// data : null
/// message : "Invalid coupon."

VendorDeleteCouponModel vendorDeleteCouponModelFromJson(String str) =>
    VendorDeleteCouponModel.fromJson(json.decode(str));

String vendorDeleteCouponModelToJson(VendorDeleteCouponModel data) =>
    json.encode(data.toJson());

class VendorDeleteCouponModel {
  VendorDeleteCouponModel({
    bool? error,
    data,
    String? message,
  }) {
    _error = error;
    _data = data;
    _message = message;
  }

  VendorDeleteCouponModel.fromJson(json) {
    _error = json['error'];
    _data = json['data'];
    _message = json['message'];
  }

  bool? _error;
  dynamic _data;
  String? _message;

  VendorDeleteCouponModel copyWith({
    bool? error,
    data,
    String? message,
  }) =>
      VendorDeleteCouponModel(
        error: error ?? _error,
        data: data ?? _data,
        message: message ?? _message,
      );

  bool? get error => _error;

  dynamic get data => _data;

  String? get message => _message;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['error'] = _error;
    map['data'] = _data;
    map['message'] = _message;
    return map;
  }
}
