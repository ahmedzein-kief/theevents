import 'dart:convert';

UploadImagesDataResponse uploadImagesDataResponseFromJson(String str) =>
    UploadImagesDataResponse.fromJson(json.decode(str));

class UploadImagesDataResponse {
  UploadImagesDataResponse({
    required this.data,
    required this.error,
    required this.message,
  });

  factory UploadImagesDataResponse.fromJson(Map<dynamic, dynamic> json) =>
      UploadImagesDataResponse(
          data: json['data'] != null ? Data.fromJson(json['data']) : null,
          error: json['error'],
          message: json['message'],);

  Data? data;
  bool error;
  String? message;
}

class Data {
  Data({
    required this.fullUrl,
    required this.thumb,
    required this.icon,
    required this.alt,
    required this.createdAt,
    required this.type,
    required this.url,
    required this.basename,
    required this.size,
    required this.updatedAt,
    required this.mimeType,
    required this.previewUrl,
    required this.name,
    required this.options,
    required this.id,
    required this.folderId,
  });

  factory Data.fromJson(Map<dynamic, dynamic> json) => Data(
        fullUrl: json['full_url'],
        thumb: json['thumb'],
        icon: json['icon'],
        alt: json['alt'],
        createdAt: DateTime.parse(json['created_at']),
        type: json['type'],
        url: json['url'],
        basename: json['basename'],
        size: json['size'],
        updatedAt: DateTime.parse(json['updated_at']),
        mimeType: json['mime_type'],
        previewUrl: json['preview_url'],
        name: json['name'],
        options: List<dynamic>.from(json['options'].map((x) => x)),
        id: json['id'],
        folderId: json['folder_id'],
      );

  String fullUrl;
  String thumb;
  String icon;
  String alt;
  DateTime createdAt;
  String type;
  String url;
  String basename;
  String size;
  DateTime updatedAt;
  String mimeType;
  String previewUrl;
  String name;
  List<dynamic> options;
  int id;
  int folderId;
}
