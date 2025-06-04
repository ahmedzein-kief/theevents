import 'dart:convert';

VendorType vendorTypeFromJson(String str) =>
    VendorType.fromJson(json.decode(str));

String vendorTypeToJson(VendorType data) => json.encode(data.toJson());

class VendorType {
  VendorType({
    required this.error,
    required this.data,
    required this.message,
  });

  factory VendorType.fromJson(Map<String, dynamic> json) => VendorType(
        error: json['error'],
        data: Data.fromJson(json['data']),
        message: json['message'],
      );
  final bool error;
  final Data data;
  final dynamic message;

  Map<String, dynamic> toJson() => {
        'error': error,
        'data': data.toJson(),
        'message': message,
      };
}

class Data {
  Data({
    required this.pagination,
    required this.records,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        pagination: Pagination.fromJson(json['pagination']),
        records:
            List<Record>.from(json['records'].map((x) => Record.fromJson(x))),
      );
  final Pagination pagination;
  final List<Record> records;

  Map<String, dynamic> toJson() => {
        'pagination': pagination.toJson(),
        'records': List<dynamic>.from(records.map((x) => x.toJson())),
      };
}

class Pagination {
  Pagination({
    required this.total,
    required this.lastPage,
    required this.currentPage,
    required this.perPage,
  });

  factory Pagination.fromJson(Map<String, dynamic> json) => Pagination(
        total: json['total'],
        lastPage: json['last_page'],
        currentPage: json['current_page'],
        perPage: json['per_page'],
      );
  final int total;
  final int lastPage;
  final int currentPage;
  final int perPage;

  Map<String, dynamic> toJson() => {
        'total': total,
        'last_page': lastPage,
        'current_page': currentPage,
        'per_page': perPage,
      };
}

class Record {
  Record({
    required this.id,
    required this.name,
    required this.title,
    required this.description,
    required this.slug,
    required this.image,
    required this.thumb,
    required this.coverImage,
  });

  factory Record.fromJson(Map<String, dynamic> json) => Record(
        id: json['id'],
        name: json['name'],
        title: json['title'],
        description: json['description'],
        slug: json['slug'],
        image: json['image'],
        thumb: json['thumb'],
        coverImage: json['cover_image'],
      );
  final int id;
  final String name;
  final String title;
  final String description;
  final String slug;
  final String image;
  final String thumb;
  final String coverImage;

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'title': title,
        'description': description,
        'slug': slug,
        'image': image,
        'thumb': thumb,
        'cover_image': coverImage,
      };
}
