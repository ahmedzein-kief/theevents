class GiftCardPage {
  final bool error;
  final Data data;
  final String? message;

  GiftCardPage({required this.error, required this.data, this.message});

  factory GiftCardPage.fromJson(Map<String, dynamic> json) {
    return GiftCardPage(
      error: json['error'],
      data: Data.fromJson(json['data']),
      message: json['message'],
    );
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
}

class SeoMeta {
  final String title;
  final String description;
  final String image;
  final String robots;

  SeoMeta({
    required this.title,
    required this.description,
    required this.image,
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
}
