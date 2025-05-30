// 1234567890-

class VendorTypeBy {
  final bool error;
  final VendorTypeData? data;
  final String? message;

  VendorTypeBy({
    required this.error,
    this.data,
    this.message,
  });

  factory VendorTypeBy.fromJson(Map<String, dynamic> json) {
    return VendorTypeBy(
      error: json['error'] ?? false,
      data: json['data'] != null ? VendorTypeData.fromJson(json['data']) : null,
      message: json['message'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'error': error,
      'data': data?.toJson(),
      'message': message,
    };
  }
}

// class VendorTypeData {
//   final int id;
//   final String name;
//   final String title;
//   final String description;
//   final String slug;
//   final String image;
//   final String thumbnail;  // Renamed from 'thumb' to 'thumbnail'
//   final String coverImage;
//   final SeoMetaManual seoMetaManual;
//
//   VendorTypeData({
//     required this.id,
//     required this.name,
//     required this.title,
//     required this.description,
//     required this.slug,
//     required this.image,
//     required this.thumbnail,
//     required this.coverImage,
//     required this.seoMetaManual,
//   });
//
//   factory VendorTypeData.fromJson(Map<String, dynamic> json) {
//     return VendorTypeData(
//       id: json['id'],
//       name: json['name'] ?? '',
//       title: json['title'] ?? '',
//       description: json['description'] ?? '',
//       slug: json['slug'] ?? '',
//       image: json['image'] ?? '',
//       thumbnail: json['thumb'] ?? '',
//       coverImage: json['cover_image'] ?? '',
//       seoMetaManual: SeoMetaManual.fromJson(json['seo_meta_manual']),
//     );
//   }
//
//   Map<String, dynamic> toJson() {
//     return {
//       'id': id,
//       'name': name,
//       'title': title,
//       'description': description,
//       'slug': slug,
//       'image': image,
//       'thumb': thumbnail,
//       'cover_image': coverImage,
//       'seo_meta_manual': seoMetaManual.toJson(),
//     };
//   }
// }

class VendorTypeData {
  final int? id; // Nullable
  final String? name; // Nullable
  final String? title; // Nullable
  final String? description; // Nullable
  final String? slug; // Nullable
  final String? image; // Nullable
  final String? thumbnail; // Nullable
  final String? coverImage; // Nullable
  final SeoMetaManual? seoMetaManual; // Nullable

  VendorTypeData({
    this.id,
    this.name,
    this.title,
    this.description,
    this.slug,
    this.image,
    this.thumbnail,
    this.coverImage,
    this.seoMetaManual,
  });

  factory VendorTypeData.fromJson(Map<String, dynamic> json) {
    return VendorTypeData(
      id: json['id'] as int?,
      name: json['name'] as String?,
      title: json['title'] as String?,
      description: json['description'] as String?,
      slug: json['slug'] as String?,
      image: json['image'] as String?,
      thumbnail: json['thumb'] as String?,
      coverImage: json['cover_image'] as String?,
      seoMetaManual: json['seo_meta_manual'] != null ? SeoMetaManual.fromJson(json['seo_meta_manual']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'title': title,
      'description': description,
      'slug': slug,
      'image': image,
      'thumb': thumbnail,
      'cover_image': coverImage,
      'seo_meta_manual': seoMetaManual?.toJson(),
    };
  }
}

class SeoMetaManual {
  final String title;
  final String description;
  final String image;
  final String robots;

  SeoMetaManual({
    required this.title,
    required this.description,
    required this.image,
    required this.robots,
  });

  factory SeoMetaManual.fromJson(Map<String, dynamic> json) {
    return SeoMetaManual(
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      image: json['image'] ?? '',
      robots: json['robots'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'image': image,
      'robots': robots,
    };
  }
}

class Records {
  final int id;
  final String name;

  Records({
    required this.id,
    required this.name,
  });

  factory Records.fromJson(Map<String, dynamic> json) {
    return Records(
      id: json['id'],
      name: json['name'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}
