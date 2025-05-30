class BrandsResponse {
  final bool error;
  final Data data;
  final String? message;

  BrandsResponse({
    required this.error,
    required this.data,
    this.message,
  });

  factory BrandsResponse.fromJson(Map<String, dynamic> json) {
    return BrandsResponse(
      error: json['error'],
      data: Data.fromJson(json['data']),
      message: json['message'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'error': error,
      'data': data.toJson(),
      'message': message,
    };
  }
}

class Data {
  final String view;
  final String name;
  final String slug;
  final String image;
  final String coverImage;
  final SeoMeta seoMeta;
  final String content;

  Data({
    required this.view,
    required this.name,
    required this.slug,
    required this.image,
    required this.coverImage,
    required this.seoMeta,
    required this.content,
  });

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      view: json['view'],
      name: json['name'],
      slug: json['slug'],
      image: json['image'],
      coverImage: json['cover_image'],
      seoMeta: SeoMeta.fromJson(json['seo_meta']),
      content: json['content'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'view': view,
      'name': name,
      'slug': slug,
      'image': image,
      'cover_image': coverImage,
      'seo_meta': seoMeta.toJson(),
      'content': content,
    };
  }
}

class SeoMeta {
  final String title;
  final String description;
  final String? image;
  final String robots;

  SeoMeta({
    required this.title,
    required this.description,
    this.image,
    required this.robots,
  });

  factory SeoMeta.fromJson(Map<String, dynamic> json) {
    return SeoMeta(
      title: json['title'],
      description: json['description'],
      image: json['image'],
      robots: json['robots'],
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
