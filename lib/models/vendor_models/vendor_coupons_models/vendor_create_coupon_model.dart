import 'dart:convert';

/// error : false
/// data : null
/// message : "Created successfully"

VendorCreateCouponModel vendorCreateCouponModelFromJson(String str) => VendorCreateCouponModel.fromJson(json.decode(str));

String vendorCreateCouponModelToJson(VendorCreateCouponModel data) => json.encode(data.toJson());

class VendorCreateCouponModel {
  VendorCreateCouponModel({
    bool? error,
    dynamic data,
    String? message,
  }) {
    _error = error;
    _data = data;
    _message = message;
  }

  VendorCreateCouponModel.fromJson(dynamic json) {
    _error = json['error'];
    _data = json['data'];
    _message = json['message'];
  }

  bool? _error;
  dynamic _data;
  String? _message;

  VendorCreateCouponModel copyWith({
    bool? error,
    dynamic data,
    String? message,
  }) =>
      VendorCreateCouponModel(
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
