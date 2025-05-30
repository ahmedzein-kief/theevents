class HomeBannerModels {
  bool? error;
  Data? data;
  String? message;

  HomeBannerModels({this.error, this.data, this.message});

  HomeBannerModels.fromJson(Map<String, dynamic> json) {
    error = json['error'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
    message = json['message'];
  }

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
  String? name;
  String? description;
  List<Slides>? slides;

  Data({this.name, this.description, this.slides});

  Data.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    description = json['description'];
    if (json['slides'] != null) {
      slides = <Slides>[];
      json['slides'].forEach((v) {
        slides!.add(Slides.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['description'] = description;
    if (slides != null) {
      data['slides'] = slides!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Slides {
  int? id;
  String? title;
  dynamic image;
  String? tabletImage;
  String? mobileImage;
  String? link;
  String? description;
  int? order;

  Slides({
    this.id,
    this.title,
    this.image,
    this.tabletImage,
    this.mobileImage,
    this.link,
    this.description,
    this.order,
  });

  Slides.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    image = json['image'];
    tabletImage = json['tablet_image'];
    mobileImage = json['mobile_image'];
    link = json['link'];
    description = json['description'];
    order = json['order'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['image'] = image;
    data['tablet_image'] = tabletImage;
    data['mobile_image'] = mobileImage;
    data['link'] = link;
    data['description'] = description;
    data['order'] = order;
    return data;
  }
}
