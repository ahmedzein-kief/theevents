class FeaturedCategoriesModels {
  bool? error;
  List<Data>? data;
  Null message;

  FeaturedCategoriesModels({this.error, this.data, this.message});

  FeaturedCategoriesModels.fromJson(Map<String, dynamic> json) {
    error = json['error'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['error'] = this.error;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['message'] = this.message;
    return data;
  }
}

class Data {
  String? name;
  String? slug;
  String? image;
  int? items;

  Data({this.name, this.slug, this.image, this.items});

  Data.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    slug = json['slug'];
    image = json['image'];
    items = json['items'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['slug'] = this.slug;
    data['image'] = this.image;
    data['items'] = this.items;
    return data;
  }
}
