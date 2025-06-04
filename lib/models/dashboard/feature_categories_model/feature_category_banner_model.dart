/// +++++++++++++++++++++   FEATURED CATEGORY BANNER MODELS  ----------------------------------
library;

class PageData {
  PageData({
    this.view,
    this.name,
    this.slug,
    this.image,
    this.coverImage,
    this.seoMeta,
    this.content,
  });

  factory PageData.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>?;

    return PageData(
      view: data?['view'] as String?,
      name: data?['name'] as String?,
      slug: data?['slug'] as String?,
      image: data?['image'] as String?,
      coverImage: data?['cover_image'] as String?,
      seoMeta: data?['seo_meta'] != null
          ? SeoMeta.fromJson(data!['seo_meta'])
          : null,
      content: data?['content'] as String?,
    );
  }
  final String? view;
  final String? name;
  final String? slug;
  final String? image;
  final String? coverImage;
  final SeoMeta? seoMeta;
  final String? content;
}

class SeoMeta {
  SeoMeta({
    this.title,
    this.description,
    this.image,
    this.robots,
  });

  factory SeoMeta.fromJson(Map<String, dynamic> json) => SeoMeta(
        title: json['title'] as String?,
        description: json['description'] as String?,
        image: json['image'] as String?,
        robots: json['robots'] as String?,
      );
  final String? title;
  final String? description;
  final String? image;
  final String? robots;
}
