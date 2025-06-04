class FeaturedBrand {
  FeaturedBrand({
    required this.id,
    required this.name,
    this.title,
    this.description,
    required this.slug,
    required this.image,
    required this.thumb,
    required this.coverImage,
    required this.items,
    this.website,
    required this.isFeatured,
    required this.seoMeta,
  });

  factory FeaturedBrand.fromJson(Map<String, dynamic> json) => FeaturedBrand(
        id: json['id'] ?? 0,
        name: json['name'] ?? '',
        title: json['title'],
        description: json['description'],
        slug: json['slug'] ?? '',
        image: json['image'] ?? '',
        thumb: json['thumb'] ?? '',
        coverImage: json['cover_image'] ?? '',
        items: json['items'] ?? 0,
        website: json['website'],
        isFeatured: json['is_featured'] ?? 0,
        seoMeta: SeoMeta.fromJson(json['seo_meta'] ?? {}),
      );
  final int id;
  final String name;
  final String? title;
  final String? description;
  final String slug;
  final String image;
  final String thumb;
  final dynamic coverImage;
  final int items;
  final String? website;
  final int isFeatured;
  final SeoMeta seoMeta;
}

class SeoMeta {
  SeoMeta({
    required this.title,
    required this.description,
    required this.image,
    required this.robots,
  });

  factory SeoMeta.fromJson(Map<String, dynamic> json) => SeoMeta(
        title: json['title'] ?? '',
        description: json['description'] ?? '',
        image: json['image'] ?? '',
        robots: json['robots'] ?? '',
      );
  final String title;
  final String description;
  final String image;
  final String robots;
}
