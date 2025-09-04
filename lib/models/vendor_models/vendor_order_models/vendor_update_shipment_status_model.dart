import 'dart:convert';

VendorUpdateShipmentStatusModel vendorUpdateShipmentStatusModelFromJson(
        String str,) =>
    VendorUpdateShipmentStatusModel.fromJson(json.decode(str));

String vendorUpdateShipmentStatusModelToJson(
        VendorUpdateShipmentStatusModel data,) =>
    json.encode(data.toJson());

class VendorUpdateShipmentStatusModel {
  VendorUpdateShipmentStatusModel({
    bool? error,
    data,
    String? message,
  }) {
    _error = error;
    _data = data;
    _message = message;
  }

  VendorUpdateShipmentStatusModel.fromJson(json) {
    _error = json['error'];
    _data = json['data'];
    _message = json['message'];
  }

  bool? _error;
  dynamic _data;
  String? _message;

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
