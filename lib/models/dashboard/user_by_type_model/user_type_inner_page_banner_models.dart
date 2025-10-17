class UserModel {
  UserModel({required this.error, required this.data, this.message});

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        error: json['error'],
        data: UserData.fromJson(json['data']),
        message: json['message'],
      );
  final bool error;
  final UserData data;
  final String? message;
}

class UserData {
  UserData({
    required this.id,
    required this.name,
    required this.email,
    required this.avatar,
    required this.avatarThumb,
    required this.coverImage,
    this.coverImageForMobile,
    required this.storeId,
    required this.storeName,
    required this.storeSlug,
    required this.storeLogo,
    required this.storeLogoThumb,
    required this.storeCoverImage,
    this.storeTitle,
    this.storeDescription,
    required this.items,
    required this.type,
    required this.listingType,
    required this.seoMeta,
  });

  factory UserData.fromJson(Map<String, dynamic> json) => UserData(
        id: json['id'],
        name: json['name'],
        email: json['email'],
        avatar: json['avatar'],
        avatarThumb: json['avatar_thumb'],
        coverImage: json['cover_image'],
        coverImageForMobile: json['cover_image_for_mobile'],
        storeId: json['store_id'],
        storeName: json['store_name'],
        storeSlug: json['store_slug'],
        storeLogo: json['store_logo'],
        storeLogoThumb: json['store_logo_thumb'],
        storeCoverImage: json['store_cover_image'],
        storeTitle: json['store_title'],
        storeDescription: json['store_description'],
        items: json['items'],
        type: json['type'],
        listingType: json['listing_type'],
        seoMeta: SeoMeta.fromJson(json['seo_meta']),
      );
  final int id;
  final String name;
  final String email;
  final String avatar;
  final String avatarThumb;
  final String coverImage;
  final String? coverImageForMobile;
  final int storeId;
  final String storeName;
  final String storeSlug;
  final String storeLogo;
  final String storeLogoThumb;
  final String storeCoverImage;
  final String? storeTitle;
  final String? storeDescription;
  final int items;
  final String type;
  final String listingType;
  final SeoMeta seoMeta;
}

class SeoMeta {
  SeoMeta({
    required this.title,
    this.description,
    required this.image,
    required this.robots,
  });

  factory SeoMeta.fromJson(Map<String, dynamic> json) => SeoMeta(
        title: json['title'],
        description: json['description'],
        image: json['image'],
        robots: json['robots'],
      );
  final String title;
  final String? description;
  final String image;
  final String robots;
}
