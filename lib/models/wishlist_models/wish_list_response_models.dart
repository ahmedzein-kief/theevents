class WishlistResponseModels {
  final bool? error; // Dynamic type
  final WishlistData? data; // Dynamic type
  final String? message; // Dynamic type

  WishlistResponseModels({
    this.error,
    this.data,
    this.message,
  });

  factory WishlistResponseModels.fromJson(Map<String, dynamic> json) {
    return WishlistResponseModels(
      error: json['error'] ?? false,
      data: json['data'] != null ? WishlistData.fromJson(json['data']) : null,
      message: json['message'] ?? null,
    );
  }
}

class WishlistData {
  final int? count; // Dynamic type
  final dynamic ids; // Dynamic type
  final bool added; // Dynamic type
  final String? message; // Dynamic type

  WishlistData({
    this.count,
    this.ids,
    required this.added,
    this.message,
  });

  factory WishlistData.fromJson(Map<String, dynamic> json) {
    return WishlistData(
      count: json['count'] ?? null,
      ids: json['ids'] ?? null,
      added: json['added'] ?? false,
      message: json['message'] ?? '',
    );
  }
}
