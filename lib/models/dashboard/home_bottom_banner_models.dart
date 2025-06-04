class HomeBottomBannerModels {
  HomeBottomBannerModels({this.error, this.data, this.message});

  HomeBottomBannerModels.fromJson(Map<String, dynamic> json) {
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
  Data(
      {this.id,
      this.name,
      this.openInNewTab,
      this.imageUrl,
      this.tabletImageUrl,
      this.mobileImageUrl,
      this.randomHash,
      this.key});

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
  int? id;
  String? name;
  bool? openInNewTab;
  String? imageUrl;
  String? tabletImageUrl;
  String? mobileImageUrl;
  String? randomHash;
  String? key;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['open_in_new_tab'] = openInNewTab;
    data['image_url'] = imageUrl;
    data['tablet_image_url'] = tabletImageUrl;
    data['mobile_image_url'] = mobileImageUrl;
    data['random_hash'] = randomHash;
    data['key'] = key;
    return data;
  }
}
