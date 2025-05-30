class UserLogoutModel {
  dynamic error;
  dynamic data;
  dynamic message;

  UserLogoutModel({this.error, this.data, this.message});

  UserLogoutModel.fromJson(Map<String, dynamic> json) {
    error = json['error'];
    data = json['data'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['error'] = this.error;
    data['data'] = this.data;
    data['message'] = this.message;
    return data;
  }
}
