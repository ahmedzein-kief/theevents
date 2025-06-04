//     +----------------------------------------------------------------   Events Bazaar Banner - +++++++++++++++++++++++++++++++++

class EventBazaarBanner {
  // Changed from Null to String?

  EventBazaarBanner({this.error, this.data, this.message});

  factory EventBazaarBanner.fromJson(Map<String, dynamic> json) =>
      EventBazaarBanner(
        error: json['error'],
        data: json['data'] != null ? Data.fromJson(json['data']) : null,
        message: json['message'],
      );
  bool? error;
  Data? data;
  String? message;

  Map<String, dynamic> toJson() => {
        'error': error,
        'data': data?.toJson(),
        'message': message,
      };
}

class Data {
  Data({
    this.view,
    this.name,
    this.slug,
    this.image,
    this.coverImage,
    this.seoMeta,
    this.content,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        view: json['view'],
        name: json['name'],
        slug: json['slug'],
        image: json['image'],
        coverImage: json['cover_image'],
        seoMeta: json['seo_meta'] != null
            ? SeoMeta.fromJson(json['seo_meta'])
            : null,
        content: json['content'],
      );
  String? view;
  String? name;
  String? slug;
  String? image;
  String? coverImage;
  SeoMeta? seoMeta;
  String? content;

  Map<String, dynamic> toJson() => {
        'view': view,
        'name': name,
        'slug': slug,
        'image': image,
        'cover_image': coverImage,
        'seo_meta': seoMeta?.toJson(),
        'content': content,
      };
}

class SeoMeta {
  SeoMeta({this.title, this.description, this.image, this.robots});

  factory SeoMeta.fromJson(Map<String, dynamic> json) => SeoMeta(
        title: json['title'],
        description: json['description'],
        image: json['image'],
        robots: json['robots'],
      );
  String? title;
  String? description;
  String? image;
  String? robots;

  Map<String, dynamic> toJson() => {
        'title': title,
        'description': description,
        'image': image,
        'robots': robots,
      };
}
