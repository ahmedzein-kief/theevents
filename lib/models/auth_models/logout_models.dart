class UserLogoutModel {
  UserLogoutModel({this.error, this.data, this.message});

  UserLogoutModel.fromJson(Map<String, dynamic> json) {
    error = json['error'];
    data = json['data'];
    message = json['message'];
  }
  dynamic error;
  dynamic data;
  dynamic message;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['error'] = error;
    data['data'] = this.data;
    data['message'] = message;
    return data;
  }
}
