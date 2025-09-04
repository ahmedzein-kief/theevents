class EcomTagsResponse {
  EcomTagsResponse({
    required this.error,
    required this.data,
    this.message,
  });

  factory EcomTagsResponse.fromJson(Map<String, dynamic> json) =>
      EcomTagsResponse(
        error: json['error'] as bool,
        data: Data.fromJson(json['data'] as Map<String, dynamic>),
        message: json['message'] as String?,
      );
  final bool error;
  final Data data;
  final String? message;

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
        pagination: PaginationEComTag.fromJson(
            json['pagination'] as Map<String, dynamic>,),
        records: (json['records'] as List<dynamic>)
            .map((item) => Record.fromJson(item as Map<String, dynamic>))
            .toList(),
      );
  final PaginationEComTag pagination;
  final List<Record> records;

  Map<String, dynamic> toJson() => {
        'pagination': pagination.toJson(),
        'records': records.map((record) => record.toJson()).toList(),
      };
}

class PaginationEComTag {
  PaginationEComTag({
    required this.total,
    required this.lastPage,
    required this.currentPage,
    required this.perPage,
  });

  factory PaginationEComTag.fromJson(Map<String, dynamic> json) =>
      PaginationEComTag(
        total: json['total'] as int,
        lastPage: json['last_page'] as int,
        currentPage: json['current_page'] as int,
        perPage: json['per_page'] as int,
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
    this.title,
    required this.description,
    required this.slug,
    required this.items,
    required this.image,
    required this.thumb,
    required this.coverImage,
  });

  factory Record.fromJson(Map<String, dynamic> json) => Record(
        id: json['id'] as int,
        name: json['name'] as String,
        title: json['title'] as String?,
        description: json['description'] as String,
        slug: json['slug'] as String,
        items: json['items'] as int,
        image: json['image'] as String,
        thumb: json['thumb'] as String,
        coverImage: json['cover_image'] as String,
      );
  final int id;
  final String name;
  final String? title;
  final String description;
  final String slug;
  final int items;
  final String image;
  final String thumb;
  final String coverImage;

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'title': title,
        'description': description,
        'slug': slug,
        'items': items,
        'image': image,
        'thumb': thumb,
        'cover_image': coverImage,
      };
}
