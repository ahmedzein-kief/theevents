class ApiResponse {
  final bool error;
  final Data data;
  final String? message;

  ApiResponse({required this.error, required this.data, this.message});

  factory ApiResponse.fromJson(Map<String, dynamic> json) {
    return ApiResponse(
      error: json['error'],
      data: Data.fromJson(json['data']),
      message: json['message'],
    );
  }
}

class Data {
  final PaginationBrands pagination;
  final List<Brand> records;

  Data({required this.pagination, required this.records});

  factory Data.fromJson(Map<String, dynamic> json) {
    var list = json['records'] as List;
    List<Brand> recordsList = list.map((i) => Brand.fromJson(i)).toList();

    return Data(
      pagination: PaginationBrands.fromJson(json['pagination']),
      records: recordsList,
    );
  }
}

class PaginationBrands {
  final int total;
  final int lastPage;
  final int currentPage;
  final int perPage;

  PaginationBrands({
    required this.total,
    required this.lastPage,
    required this.currentPage,
    required this.perPage,
  });

  factory PaginationBrands.fromJson(Map<String, dynamic> json) {
    return PaginationBrands(
      total: json['total'],
      lastPage: json['last_page'],
      currentPage: json['current_page'],
      perPage: json['per_page'],
    );
  }
}

class Brand {
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

  factory Brand.fromJson(Map<String, dynamic> json) {
    return Brand(
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
  }
}
