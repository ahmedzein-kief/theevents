class UserLoginModel {
  UserLoginModel({this.error, this.data, this.message});

  UserLoginModel.fromJson(Map<String, dynamic> json) {
    error = json['error'];
    data = json['data'] != null ? UserAuthData.fromJson(json['data']) : null;
    message = json['message'];
  }
  bool? error;
  UserAuthData? data;
  String? message;

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

class UserAuthData {
  UserAuthData({
    this.id,
    this.name,
    this.email,
    this.avatar,
    this.phone,
    this.company,
    this.isVendor,
    this.isApproved,
    this.isVerified,
    this.title,
    this.token,
    this.tokenType,
    this.expiresIn,
    this.step,
    this.gender,
  });

  UserAuthData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    avatar = json['avatar'];
    phone = json['phone'];
    company = json['company'];
    isVendor = json['is_vendor'];
    isApproved = json['is_approved'];
    isVerified = json['is_verified'];
    title = json['title'];
    token = json['token'];
    tokenType = json['token_type'];
    expiresIn = json['expires_in'];
    step = json['step'];
    gender = json['gender'];
  }
  int? id;
  String? name;
  String? email;
  String? avatar;
  String? phone;
  String? company;
  int? isVendor;
  bool? isApproved;
  bool? isVerified;
  String? title;
  String? token;
  String? tokenType;
  dynamic expiresIn;
  dynamic step;
  dynamic gender;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['email'] = email;
    data['avatar'] = avatar;
    data['phone'] = phone;
    data['company'] = company;
    data['is_vendor'] = isVendor;
    data['is_approved'] = isApproved;
    data['is_verified'] = isVerified;
    data['title'] = title;
    data['token'] = token;
    data['token_type'] = tokenType;
    data['expires_in'] = expiresIn;
    data['step'] = step;
    data['gender'] = gender;
    return data;
  }
}
