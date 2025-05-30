class HomeBottomBannerModels {
  bool? error;
  Data? data;
  Null message;

  HomeBottomBannerModels({this.error, this.data, this.message});

  HomeBottomBannerModels.fromJson(Map<String, dynamic> json) {
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
  int? id;
  String? name;
  bool? openInNewTab;
  String? imageUrl;
  String? tabletImageUrl;
  String? mobileImageUrl;
  String? randomHash;
  String? key;

  Data({this.id, this.name, this.openInNewTab, this.imageUrl, this.tabletImageUrl, this.mobileImageUrl, this.randomHash, this.key});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    openInNewTab = json['open_in_new_tab'];
    imageUrl = json['image_url'];
    tabletImageUrl = json['tablet_image_url'];
    mobileImageUrl = json['mobile_image_url'];
    randomHash = json['random_hash'];
    key = json['key'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['open_in_new_tab'] = this.openInNewTab;
    data['image_url'] = this.imageUrl;
    data['tablet_image_url'] = this.tabletImageUrl;
    data['mobile_image_url'] = this.mobileImageUrl;
    data['random_hash'] = this.randomHash;
    data['key'] = this.key;
    return data;
  }
}
