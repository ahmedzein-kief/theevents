import 'dart:convert';

MetaDataResponse metaDataResponseFromJson(String str) =>
    MetaDataResponse.fromJson(json.decode(str));

String metaDataResponseToJson(MetaDataResponse data) =>
    json.encode(data.toJson());

class MetaDataResponse {
  MetaDataResponse({
    required this.data,
    required this.error,
    required this.message,
  });

  factory MetaDataResponse.fromJson(Map<dynamic, dynamic> json) =>
      MetaDataResponse(
        data: Map.from(json['data'])
            .map((k, v) => MapEntry<String, String>(k, v)),
        error: json['error'],
        message: json['message'],
      );

  Map<String, String> data;
  bool error;
  String? message;

  Map<dynamic, dynamic> toJson() => {
        'data': Map.from(data).map((k, v) => MapEntry<String, dynamic>(k, v)),
        'error': error,
        'message': message,
      };
}
