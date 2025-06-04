import 'dart:convert';

CommonPostRequestModel commonPostRequestModelFromJson(String str) =>
    CommonPostRequestModel.fromJson(json.decode(str));

String commonPostRequestModelToJson(CommonPostRequestModel data) =>
    json.encode(data.toJson());

class CommonPostRequestModel {
  CommonPostRequestModel({
    bool? error,
    data,
    String? message,
  }) {
    _error = error;
    _data = data;
    _message = message;
  }

  CommonPostRequestModel.fromJson(json) {
    _error = json['error'];
    _data = json['data'];
    _message = json['message'];
    _errors = json['errors'];
  }

  bool? _error;
  dynamic _data;
  String? _message;
  dynamic _errors;

  bool? get error => _error;

  dynamic get data => _data;

  String? get message => _message;
  dynamic get errors => _errors;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['error'] = _error;
    map['data'] = _data;
    map['message'] = _message;
    map['errors'] = _errors;
    return map;
  }
}
