class WishlistResponseModels {
  // Dynamic type

  WishlistResponseModels({
    this.error,
    this.data,
    this.message,
  });

  factory WishlistResponseModels.fromJson(Map<String, dynamic> json) =>
      WishlistResponseModels(
        error: json['error'] ?? false,
        data: json['data'] != null ? WishlistData.fromJson(json['data']) : null,
        message: json['message'],
      );
  final bool? error; // Dynamic type
  final WishlistData? data; // Dynamic type
  final String? message;
}

class WishlistData {
  // Dynamic type

  WishlistData({
    this.count,
    this.ids,
    required this.added,
    this.message,
  });

  factory WishlistData.fromJson(Map<String, dynamic> json) => WishlistData(
        count: json['count'],
        ids: json['ids'],
        added: json['added'] ?? false,
        message: json['message'] ?? '',
      );
  final int? count; // Dynamic type
  final dynamic ids; // Dynamic type
  final bool added; // Dynamic type
  final String? message;
}
