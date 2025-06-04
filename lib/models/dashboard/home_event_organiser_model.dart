class HomeEventOrganiserModel {
  HomeEventOrganiserModel({this.error, this.data, this.message});

  HomeEventOrganiserModel.fromJson(Map<String, dynamic> json) {
    error = json['error'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
    message = json['message'];
  }
  bool? error;
  Data? data;
  Null message;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['error'] = error;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['message'] = message;
    return data;
  }
}

class Data {
  Data({this.pagination, this.records});

  Data.fromJson(Map<String, dynamic> json) {
    pagination = json['pagination'] != null
        ? Pagination.fromJson(json['pagination'])
        : null;
    if (json['records'] != null) {
      records = <Records>[];
      json['records'].forEach((v) {
        records!.add(Records.fromJson(v));
      });
    }
  }
  Pagination? pagination;
  List<Records>? records;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (pagination != null) {
      data['pagination'] = pagination!.toJson();
    }
    if (records != null) {
      data['records'] = records!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Pagination {
  Pagination({this.total, this.lastPage, this.currentPage, this.perPage});

  Pagination.fromJson(Map<String, dynamic> json) {
    total = json['total'];
    lastPage = json['last_page'];
    currentPage = json['current_page'];
    perPage = json['per_page'];
  }
  int? total;
  int? lastPage;
  int? currentPage;
  int? perPage;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['total'] = total;
    data['last_page'] = lastPage;
    data['current_page'] = currentPage;
    data['per_page'] = perPage;
    return data;
  }
}

class Records {
  Records(
      {this.id,
      this.name,
      this.email,
      this.avatar,
      this.avatarThumb,
      this.storeName,
      this.storeSlug,
      this.storeLogo,
      this.storeLogoThumb,
      this.coverImage,
      this.items});

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

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['email'] = email;
    data['avatar'] = avatar;
    data['avatar_thumb'] = avatarThumb;
    data['store_name'] = storeName;
    data['store_slug'] = storeSlug;
    data['store_logo'] = storeLogo;
    data['store_logo_thumb'] = storeLogoThumb;
    data['cover_image'] = coverImage;
    data['items'] = items;
    return data;
  }
}
