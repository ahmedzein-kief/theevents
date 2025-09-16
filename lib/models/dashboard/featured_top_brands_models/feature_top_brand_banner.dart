class BrandsResponse {
  BrandsResponse({
    required this.error,
    required this.data,
    this.message,
  });

  factory BrandsResponse.fromJson(Map<String, dynamic> json) => BrandsResponse(
        error: json['error'],
        data: Data.fromJson(json['data']),
        message: json['message'],
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
    required this.view,
    required this.name,
    required this.slug,
    required this.image,
    required this.coverImage,
    this.coverImageForMobile,
    required this.seoMeta,
    required this.content,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        view: json['view'],
        name: json['name'],
        slug: json['slug'],
        image: json['image'],
        coverImage: json['cover_image_for_mobile'],
        coverImageForMobile: json['cover_image'],
        seoMeta: SeoMeta.fromJson(json['seo_meta']),
        content: json['content'],
      );
  final String view;
  final String name;
  final String slug;
  final String image;
  final String coverImage;
  final String? coverImageForMobile;
  final SeoMeta seoMeta;
  final String content;

  Map<String, dynamic> toJson() => {
        'view': view,
        'name': name,
        'slug': slug,
        'image': image,
        'cover_image': coverImage,
        'cover_image_for_mobile': coverImageForMobile,
        'seo_meta': seoMeta.toJson(),
        'content': content,
      };
}

class SeoMeta {
  SeoMeta({
    required this.title,
    required this.description,
    this.image,
    required this.robots,
  });

  factory SeoMeta.fromJson(Map<String, dynamic> json) => SeoMeta(
        title: json['title'],
        description: json['description'],
        image: json['image'],
        robots: json['robots'],
      );
  final String title;
  final String description;
  final String? image;
  final String robots;

  Map<String, dynamic> toJson() => {
        'title': title,
        'description': description,
        'image': image,
        'robots': robots,
      };
}
