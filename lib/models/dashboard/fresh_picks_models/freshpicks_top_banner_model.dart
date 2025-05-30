class TagsModel {
  bool? error;
  Data? data;
  String? message; // Use String? instead of Null

  TagsModel({this.error, this.data, this.message});

  TagsModel.fromJson(Map<String, dynamic> json) {
    error = json['error'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['error'] = this.error;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['message'] = this.message;
    return data;
  }
}

class Data {
  String? view;
  String? name;
  String? slug;
  String? image;
  String? coverImage;
  SeoMeta? seoMeta;
  String? content;

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
    seoMeta = json['seo_meta'] != null ? SeoMeta.fromJson(json['seo_meta']) : null;
    content = json['content'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['view'] = this.view;
    data['name'] = this.name;
    data['slug'] = this.slug;
    data['image'] = this.image;
    data['cover_image'] = this.coverImage;
    if (this.seoMeta != null) {
      data['seo_meta'] = this.seoMeta!.toJson();
    }
    data['content'] = this.content;
    return data;
  }
}

class SeoMeta {
  String? title;
  String? description;
  String? image; // Use String? instead of Null
  String? robots;

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

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['title'] = this.title;
    data['description'] = this.description;
    data['image'] = this.image;
    data['robots'] = this.robots;
    return data;
  }
}
