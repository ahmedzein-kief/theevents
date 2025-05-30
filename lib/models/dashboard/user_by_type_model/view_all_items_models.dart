class Vendor {
  final int id;
  final String name;
  final String email;
  final String avatar;
  final String storeName;
  final String storeLogo;
  final String coverImage;

  Vendor({
    required this.id,
    required this.name,
    required this.email,
    required this.avatar,
    required this.storeName,
    required this.storeLogo,
    required this.coverImage,
  });

  factory Vendor.fromJson(Map<String, dynamic> json) {
    return Vendor(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      avatar: json['avatar'],
      storeName: json['store_name'],
      storeLogo: json['store_logo'],
      coverImage: json['cover_image'],
    );
  }

  static List<Vendor> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => Vendor.fromJson(json)).toList();
  }
}

class Pagination {
  final int total;
  final int lastPage;
  final int currentPage;
  final int perPage;

  Pagination({
    required this.total,
    required this.lastPage,
    required this.currentPage,
    required this.perPage,
  });

  factory Pagination.fromJson(Map<String, dynamic> json) {
    return Pagination(
      total: json['total'],
      lastPage: json['last_page'],
      currentPage: json['current_page'],
      perPage: json['per_page'],
    );
  }
}

class VendorResponse {
  final Pagination pagination;
  final List<Vendor> records;

  VendorResponse({
    required this.pagination,
    required this.records,
  });

  factory VendorResponse.fromJson(Map<String, dynamic> json) {
    return VendorResponse(
      pagination: Pagination.fromJson(json['pagination']),
      records: Vendor.fromJsonList(json['records']),
    );
  }
}
