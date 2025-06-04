class CategoryResponse {
  CategoryResponse({required this.error, required this.data, this.message});

  factory CategoryResponse.fromJson(Map<String, dynamic> json) =>
      CategoryResponse(
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
    final List<Category> recordsList =
        list.map((i) => Category.fromJson(i)).toList();

    return Data(
      pagination: Pagination.fromJson(json['pagination']),
      records: recordsList,
    );
  }
  final Pagination pagination;
  final List<Category> records;
}

class Pagination {
  Pagination(
      {required this.total,
      required this.lastPage,
      required this.currentPage,
      required this.perPage});

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
}

class Category {
  Category({
    required this.id,
    required this.name,
    required this.slug,
    required this.image,
    required this.thumb,
    required this.coverImage,
    required this.items,
  });

  factory Category.fromJson(Map<String, dynamic> json) => Category(
        id: json['id'],
        name: json['name'],
        slug: json['slug'],
        image: json['image'],
        thumb: json['thumb'],
        coverImage: json['cover_image'],
        items: json['items'],
      );
  final int id;
  final String name;
  final String slug;
  final String image;
  final String thumb;
  final String coverImage;
  final int items;
}
