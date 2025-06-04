import 'dart:convert';

VendorGetSeoKeywordsModel vendorGetSeoKeywordsModelFromJson(String str) =>
    VendorGetSeoKeywordsModel.fromJson(json.decode(str));

String vendorGetSeoKeywordsModelToJson(VendorGetSeoKeywordsModel data) =>
    json.encode(data.toJson());

class VendorGetSeoKeywordsModel {
  VendorGetSeoKeywordsModel({
    bool? error,
    List<String>? data,
    message,
  }) {
    _error = error;
    _data = data;
    _message = message;
  }

  VendorGetSeoKeywordsModel.fromJson(json) {
    _error = json['error'];
    _data = json['data'] != null ? json['data'].cast<String>() : [];
    _message = json['message'];
  }

  bool? _error;
  List<String>? _data;
  dynamic _message;

  bool? get error => _error;

  List<String>? get data => _data;

  dynamic get message => _message;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['error'] = _error;
    map['data'] = _data;
    map['message'] = _message;
    return map;
  }
}
