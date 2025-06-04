class HomeTopBrandsModels {
  HomeTopBrandsModels({this.error, this.data, this.message});

  HomeTopBrandsModels.fromJson(Map<String, dynamic> json) {
    error = json['error'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(Data.fromJson(v));
      });
    }
    message = json['message'];
  }
  bool? error;
  List<Data>? data;
  Null message;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['error'] = error;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['message'] = message;
    return data;
  }
}

class Data {
  Data({this.id, this.name, this.slug, this.logo, this.thumb, this.items});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    slug = json['slug'];
    logo = json['logo'];
    thumb = json['thumb'];
    items = json['items'];
  }
  int? id;
  String? name;
  String? slug;
  String? logo;
  String? thumb;
  int? items;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['slug'] = slug;
    data['logo'] = logo;
    data['thumb'] = thumb;
    data['items'] = items;
    return data;
  }
}
