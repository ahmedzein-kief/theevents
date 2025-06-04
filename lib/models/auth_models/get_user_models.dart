// user_model.dart
class UserModel {
  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.avatar,
    required this.token,
    required this.phone,
    required this.isVendor,
    required this.isApproved,
    required this.isVerified,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        id: json['id'],
        name: json['name'],
        email: json['email'],
        avatar: json['avatar'],
        token: json['token'],
        phone: json['phone'],
        isVendor: json['is_vendor'],
        isApproved: json['is_approved'],
        isVerified: json['is_verified'],
      );
  final int id;
  final String name;
  final String email;
  final String avatar;
  final String token;
  final String? phone;
  final int? isVendor;
  final bool? isApproved;
  final bool? isVerified;
}
