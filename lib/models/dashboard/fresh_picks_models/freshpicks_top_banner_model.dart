class TagsModel {
  // Use String? instead of Null

  TagsModel({this.error, this.data, this.message});

  TagsModel.fromJson(Map<String, dynamic> json) {
    error = json['error'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
    message = json['message'];
  }
  bool? error;
  Data? data;
  String? message;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['error'] = error;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['message'] = message;
    return data;
  }
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

  Data.fromJson(Map<String, dynamic> json) {
    view = json['view'];
    name = json['name'];
    slug = json['slug'];
    image = json['image'];
    coverImage = json['cover_image'];
    seoMeta =
        json['seo_meta'] != null ? SeoMeta.fromJson(json['seo_meta']) : null;
    content = json['content'];
  }
  String? view;
  String? name;
  String? slug;
  String? image;
  String? coverImage;
  SeoMeta? seoMeta;
  String? content;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['view'] = view;
    data['name'] = name;
    data['slug'] = slug;
    data['image'] = image;
    data['cover_image'] = coverImage;
    if (seoMeta != null) {
      data['seo_meta'] = seoMeta!.toJson();
    }
    data['content'] = content;
    return data;
  }
}

class SeoMeta {
  SeoMeta({
    this.title,
    this.description,
    this.image,
    this.robots,
  });

  SeoMeta.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    description = json['description'];
    image = json['image'];
    robots = json['robots'];
  }
  String? title;
  String? description;
  String? image; // Use String? instead of Null
  String? robots;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['title'] = title;
    data['description'] = description;
    data['image'] = image;
    data['robots'] = robots;
    return data;
  }
}
