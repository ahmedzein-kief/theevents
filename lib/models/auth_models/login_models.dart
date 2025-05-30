class UserLoginModel {
  bool? error;
  UserAuthData? data;
  String? message;

  UserLoginModel({this.error, this.data, this.message});

  UserLoginModel.fromJson(Map<String, dynamic> json) {
    error = json['error'];
    data = json['data'] != null ? UserAuthData.fromJson(json['data']) : null;
    message = json['message'] != null ? json['message'] : null;
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

class UserAuthData {
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

  UserAuthData(
      {this.id,
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
      this.gender});

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

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['email'] = this.email;
    data['avatar'] = this.avatar;
    data['phone'] = this.phone;
    data['company'] = this.company;
    data['is_vendor'] = this.isVendor;
    data['is_approved'] = this.isApproved;
    data['is_verified'] = this.isVerified;
    data['title'] = this.title;
    data['token'] = this.token;
    data['token_type'] = this.tokenType;
    data['expires_in'] = this.expiresIn;
    data['step'] = this.step;
    data['gender'] = this.gender;
    return data;
  }
}
