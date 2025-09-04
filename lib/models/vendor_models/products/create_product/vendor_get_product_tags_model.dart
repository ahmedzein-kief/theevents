import 'dart:convert';

VendorGetProductTagsModel vendorGetProductTagsModelFromJson(String str) =>
    VendorGetProductTagsModel.fromJson(json.decode(str));

String vendorGetProductTagsModelToJson(
        VendorGetProductTagsModel vendorProductTags,) =>
    json.encode(vendorProductTags.toJson());

class VendorGetProductTagsModel {
  VendorGetProductTagsModel({
    bool? error,
    List<String>? vendorProductTags,
    message,
  }) {
    _error = error;
    _vendorProductTags = vendorProductTags;
    _message = message;
  }

  VendorGetProductTagsModel.fromJson(json) {
    _error = json['error'];
    _vendorProductTags =
        json['data'] != null ? json['data'].cast<String>() : [];
    _message = json['message'];
  }

  bool? _error;
  List<String>? _vendorProductTags;
  dynamic _message;

  bool? get error => _error;

  List<String>? get vendorProductTags => _vendorProductTags;

  dynamic get message => _message;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['error'] = _error;
    map['data'] = _vendorProductTags;
    map['message'] = _message;
    return map;
  }
}
