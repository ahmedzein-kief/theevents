class ApiResponse {
  ApiResponse({required this.error, required this.data, this.message});

  factory ApiResponse.fromJson(Map<String, dynamic> json) => ApiResponse(
        error: json['error'],
        data: Data.fromJson(json['data']),
        message: json['message'],
      );
  final bool error;
  final Data data;
  final String? message;
}

class Data {
  Data({required this.pagination, required this.records});

  factory Data.fromJson(Map<String, dynamic> json) {
    final list = json['records'] as List;
    final List<Brand> recordsList = list.map((i) => Brand.fromJson(i)).toList();

    return Data(
      pagination: PaginationBrands.fromJson(json['pagination']),
      records: recordsList,
    );
  }
  final PaginationBrands pagination;
  final List<Brand> records;
}

class PaginationBrands {
  PaginationBrands({
    required this.total,
    required this.lastPage,
    required this.currentPage,
    required this.perPage,
  });

  factory PaginationBrands.fromJson(Map<String, dynamic> json) =>
      PaginationBrands(
        total: json['total'],
        lastPage: json['last_page'],
        currentPage: json['current_page'],
        perPage: json['per_page'],
      );
  final int total;
  final int lastPage;
  final int currentPage;
  final int perPage;
}

class Brand {
  Brand({
    required this.id,
    required this.name,
    this.title,
    this.description,
    this.website,
    required this.slug,
    required this.image,
    required this.thumb,
    required this.coverImage,
    required this.isFeatured,
    required this.items,
  });

  factory Brand.fromJson(Map<String, dynamic> json) => Brand(
        id: json['id'],
        name: json['name'],
        title: json['title'],
        description: json['description'],
        website: json['website'],
        slug: json['slug'],
        image: json['image'],
        thumb: json['thumb'],
        coverImage: json['cover_image'],
        isFeatured: json['is_featured'],
        items: json['items'],
      );
  final int id;
  final String name;
  final String? title;
  final String? description;
  final String? website;
  final String slug;
  final String image;
  final String thumb;
  final String coverImage;
  final int isFeatured;
  final int items;
}
