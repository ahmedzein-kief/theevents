class HomeTopBrandsModels {
  bool? error;
  List<Data>? data;
  Null message;

  HomeTopBrandsModels({this.error, this.data, this.message});

  HomeTopBrandsModels.fromJson(Map<String, dynamic> json) {
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
  int? id;
  String? name;
  String? slug;
  String? logo;
  String? thumb;
  int? items;

  Data({this.id, this.name, this.slug, this.logo, this.thumb, this.items});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    slug = json['slug'];
    logo = json['logo'];
    thumb = json['thumb'];
    items = json['items'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['slug'] = this.slug;
    data['logo'] = this.logo;
    data['thumb'] = this.thumb;
    data['items'] = this.items;
    return data;
  }
}
