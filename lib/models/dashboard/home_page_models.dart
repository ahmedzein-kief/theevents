class HomePageData {
  HomePageData({
    bool? error,
    Data? data,
    message,
  }) {
    _error = error;
    _data = data;
    _message = message;
  }

  HomePageData.fromJson(json) {
    _error = json['error'];
    _data = json['data'] != null ? Data.fromJson(json['data']) : null;
    _message = json['message'];
  }

  bool? _error;
  Data? _data;
  dynamic _message;

  HomePageData copyWith({
    bool? error,
    Data? data,
    message,
  }) =>
      HomePageData(
        error: error ?? _error,
        data: data ?? _data,
        message: message ?? _message,
      );

  bool? get error => _error;

  Data? get data => _data;

  dynamic get message => _message;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['error'] = _error;
    if (_data != null) {
      map['data'] = _data?.toJson();
    }
    map['message'] = _message;
    return map;
  }
}

/// view : "page"
/// name : "Home"
/// slug : "home"
/// image : ""
/// cover_image : ""
/// seo_meta : {"title":"Home","description":"","image":null,"robots":"index, follow"}
/// content : "<div class=\"home-inner-content rad-content\"><section class=\"hero-section border-topxxx\" id=\"hero\"><shortcode-simple-slider key=\"home-slider\" ads_1=\"IZ6WU8KUALYE\" ads_2=\"IZ6WU8KUALYE\"></shortcode-simple-slider></section><section class=\"bg-white border-top\"><shortcode-featured-categories title=\"Gift by occasion\"></shortcode-featured-categories></section><section class=\"bg-light border-top\"><shortcode-information-icons title1=\"Orders\" link1=\"/customer/orders\" icon1=\"icons/ep-list.png\" title2=\"New Products\" link2=\"/products\" icon2=\"icons/foundation-burst-new-1.png\" title3=\"Gift Card\" link3=\"/customer/gift-cards/create\" icon3=\"icons/ic-round-card-giftcard-1.png\" title4=\"Events Brand\" link4=\"/brands\" icon4=\"icons/simple-icons-e-1.png\" title5=\"Best Sellers\" link5=\"/collections/best-sellers\" icon5=\"icons/solar-stars-bold-1.png\" title6=\"50% Discount\" link6=\"/page/50-discount\" icon6=\"icons/teenyicons-discount-solid-1.png\"></shortcode-information-icons></section><section class=\"bg-white border-top\"><shortcode-events-bazaar title=\"Events Bazaar\" countries=\"SA,OM,QA,KW,BH,AE\"></shortcode-events-bazaar></section><section class=\"custom-style bg-light border-top\"><shortcode-vendors-by-type title=\"Event Organizers\" type_id=\"3\" limit=\"8\"></shortcode-vendors-by-type></section><section class=\"bg-white border-top\"><shortcode-ads key=\"IZ6WU8KUALYE\"></shortcode-ads></section><section class=\"bg-light border-top\"><shortcode-fresh-picks title=\"Fresh Picks\"></shortcode-fresh-picks></section><section class=\"bg-white border-top\"><shortcode-users-by-type title=\"Celebrities\" type_id=\"2\" limit=\"8\"></shortcode-users-by-type></section><section class=\"bg-light border-top\"><shortcode-featured-brands title=\"Top Brands\"></shortcode-featured-brands></section><section class=\"bg-white border-top\"><shortcode-two-tags-blocks-with-ad title=\"Brands\" key=\"home-slider\" slot_1=\"7,8,9,10,11,12,13,14\"></shortcode-two-tags-blocks-with-ad></section><section class=\"bg-light border-top\"><shortcode-users-by-type title=\"Makeup Artist\" type_id=\"1\" limit=\"8\"></shortcode-users-by-type></section></div>"

class Data {
  Data({
    String? view,
    String? name,
    String? slug,
    String? image,
    String? coverImage,
    String? mobileCoverImage,
    SeoMeta? seoMeta,
    String? content,
  }) {
    _view = view;
    _name = name;
    _slug = slug;
    _image = image;
    _coverImage = coverImage;
    _mobileCoverImage = mobileCoverImage;
    _seoMeta = seoMeta;
    _content = content;
  }

  Data.fromJson(json) {
    _view = json['view'];
    _name = json['name'];
    _slug = json['slug'];
    _image = json['image'];
    _coverImage = json['cover_image'];
    _mobileCoverImage = json['cover_image_for_mobile'];
    _seoMeta = json['seo_meta'] != null ? SeoMeta.fromJson(json['seo_meta']) : null;
    _content = json['content'];
  }

  String? _view;
  String? _name;
  String? _slug;
  String? _image;
  String? _coverImage;
  String? _mobileCoverImage;
  SeoMeta? _seoMeta;
  String? _content;

  Data copyWith({
    String? view,
    String? name,
    String? slug,
    String? image,
    String? coverImage,
    String? mobileCoverImage,
    SeoMeta? seoMeta,
    String? content,
  }) =>
      Data(
        view: view ?? _view,
        name: name ?? _name,
        slug: slug ?? _slug,
        image: image ?? _image,
        coverImage: coverImage ?? _coverImage,
        mobileCoverImage: mobileCoverImage ?? _mobileCoverImage,
        seoMeta: seoMeta ?? _seoMeta,
        content: content ?? _content,
      );

  String? get view => _view;

  String? get name => _name;

  String? get slug => _slug;

  String? get image => _image;

  String? get coverImage => _coverImage;

  String? get mobileCoverImage => _mobileCoverImage;

  SeoMeta? get seoMeta => _seoMeta;

  String? get content => _content;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['view'] = _view;
    map['name'] = _name;
    map['slug'] = _slug;
    map['image'] = _image;
    map['cover_image'] = _coverImage;
    map['mobile_cover_image'] = _mobileCoverImage;
    if (_seoMeta != null) {
      map['seo_meta'] = _seoMeta?.toJson();
    }
    map['content'] = _content;
    return map;
  }
}

/// title : "Home"
/// description : ""
/// image : null
/// robots : "index, follow"

class SeoMeta {
  SeoMeta({
    String? title,
    String? description,
    image,
    String? robots,
  }) {
    _title = title;
    _description = description;
    _image = image;
    _robots = robots;
  }

  SeoMeta.fromJson(json) {
    _title = json['title'];
    _description = json['description'];
    _image = json['image'];
    _robots = json['robots'];
  }

  String? _title;
  String? _description;
  dynamic _image;
  String? _robots;

  SeoMeta copyWith({
    String? title,
    String? description,
    image,
    String? robots,
  }) =>
      SeoMeta(
        title: title ?? _title,
        description: description ?? _description,
        image: image ?? _image,
        robots: robots ?? _robots,
      );

  String? get title => _title;

  String? get description => _description;

  dynamic get image => _image;

  String? get robots => _robots;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['title'] = _title;
    map['description'] = _description;
    map['image'] = _image;
    map['robots'] = _robots;
    return map;
  }
}
