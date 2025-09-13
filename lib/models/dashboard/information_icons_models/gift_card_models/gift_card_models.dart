class GiftCardPage {
  GiftCardPage({required this.error, required this.data, this.message});

  factory GiftCardPage.fromJson(Map<String, dynamic> json) => GiftCardPage(
        error: json['error'],
        data: Data.fromJson(json['data']),
        message: json['message'],
      );
  final bool error;
  final Data data;
  final String? message;
}

class Data {
  Data({
    required this.view,
    required this.name,
    required this.slug,
    required this.image,
    required this.coverImage,
    required this.seoMeta,
    required this.content,
    this.mobileCoverImage,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        view: json['view'],
        name: json['name'],
        slug: json['slug'],
        image: json['image'],
        coverImage: json['cover_image'],
        seoMeta: SeoMeta.fromJson(json['seo_meta']),
        content: json['content'],
        mobileCoverImage: json['cover_image_for_mobile'],
      );
  final String view;
  final String name;
  final String slug;
  final String image;
  final String coverImage;
  final String? mobileCoverImage;
  final SeoMeta seoMeta;
  final String content;
}

class SeoMeta {
  SeoMeta({
    required this.title,
    required this.description,
    required this.image,
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
  final String image;
  final String robots;
}
