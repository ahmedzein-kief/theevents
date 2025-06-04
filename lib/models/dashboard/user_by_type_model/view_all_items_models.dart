class Vendor {
  Vendor({
    required this.id,
    required this.name,
    required this.email,
    required this.avatar,
    required this.storeName,
    required this.storeLogo,
    required this.coverImage,
  });

  factory Vendor.fromJson(Map<String, dynamic> json) => Vendor(
        id: json['id'],
        name: json['name'],
        email: json['email'],
        avatar: json['avatar'],
        storeName: json['store_name'],
        storeLogo: json['store_logo'],
        coverImage: json['cover_image'],
      );
  final int id;
  final String name;
  final String email;
  final String avatar;
  final String storeName;
  final String storeLogo;
  final String coverImage;

  static List<Vendor> fromJsonList(List<dynamic> jsonList) =>
      jsonList.map((json) => Vendor.fromJson(json)).toList();
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
}

class VendorResponse {
  VendorResponse({
    required this.pagination,
    required this.records,
  });

  factory VendorResponse.fromJson(Map<String, dynamic> json) => VendorResponse(
        pagination: Pagination.fromJson(json['pagination']),
        records: Vendor.fromJsonList(json['records']),
      );
  final Pagination pagination;
  final List<Vendor> records;
}
