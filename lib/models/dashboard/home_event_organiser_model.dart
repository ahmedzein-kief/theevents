class HomeEventOrganiserModel {
  bool? error;
  Data? data;
  Null message;

  HomeEventOrganiserModel({this.error, this.data, this.message});

  HomeEventOrganiserModel.fromJson(Map<String, dynamic> json) {
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
  String? email;
  String? avatar;
  String? avatarThumb;
  String? storeName;
  String? storeSlug;
  String? storeLogo;
  String? storeLogoThumb;
  String? coverImage;
  int? items;

  Records({this.id, this.name, this.email, this.avatar, this.avatarThumb, this.storeName, this.storeSlug, this.storeLogo, this.storeLogoThumb, this.coverImage, this.items});

  Records.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    avatar = json['avatar'];
    avatarThumb = json['avatar_thumb'];
    storeName = json['store_name'];
    storeSlug = json['store_slug'];
    storeLogo = json['store_logo'];
    storeLogoThumb = json['store_logo_thumb'];
    coverImage = json['cover_image'];
    items = json['items'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['email'] = this.email;
    data['avatar'] = this.avatar;
    data['avatar_thumb'] = this.avatarThumb;
    data['store_name'] = this.storeName;
    data['store_slug'] = this.storeSlug;
    data['store_logo'] = this.storeLogo;
    data['store_logo_thumb'] = this.storeLogoThumb;
    data['cover_image'] = this.coverImage;
    data['items'] = this.items;
    return data;
  }
}
