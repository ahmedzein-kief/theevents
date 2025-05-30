class HomeBrandsTypesModels {
  bool? error;
  Data? data;
  Null message;

  HomeBrandsTypesModels({this.error, this.data, this.message});

  HomeBrandsTypesModels.fromJson(Map<String, dynamic> json) {
    error = json['error'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['error'] = this.error;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['message'] = this.message;
    return data;
  }
}

class Data {
  Pagination? pagination;
  List<Records>? records;

  Data({this.pagination, this.records});

  Data.fromJson(Map<String, dynamic> json) {
    pagination = json['pagination'] != null ? new Pagination.fromJson(json['pagination']) : null;
    if (json['records'] != null) {
      records = <Records>[];
      json['records'].forEach((v) {
        records!.add(new Records.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.pagination != null) {
      data['pagination'] = this.pagination!.toJson();
    }
    if (this.records != null) {
      data['records'] = this.records!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Pagination {
  int? total;
  int? lastPage;
  int? currentPage;
  int? perPage;

  Pagination({this.total, this.lastPage, this.currentPage, this.perPage});

  Pagination.fromJson(Map<String, dynamic> json) {
    total = json['total'];
    lastPage = json['last_page'];
    currentPage = json['current_page'];
    perPage = json['per_page'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['total'] = this.total;
    data['last_page'] = this.lastPage;
    data['current_page'] = this.currentPage;
    data['per_page'] = this.perPage;
    return data;
  }
}

class Records {
  int? id;
  String? name;
  Null title;
  String? description;
  String? slug;
  int? items;
  String? image;
  String? thumb;
  String? coverImage;

  Records({this.id, this.name, this.title, this.description, this.slug, this.items, this.image, this.thumb, this.coverImage});

  Records.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    title = json['title'];
    description = json['description'];
    slug = json['slug'];
    items = json['items'];
    image = json['image'];
    thumb = json['thumb'];
    coverImage = json['cover_image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['title'] = this.title;
    data['description'] = this.description;
    data['slug'] = this.slug;
    data['items'] = this.items;
    data['image'] = this.image;
    data['thumb'] = this.thumb;
    data['cover_image'] = this.coverImage;
    return data;
  }
}
