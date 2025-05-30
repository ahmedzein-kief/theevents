class CustomerUploadProfilePicModel {
  CustomerUploadProfilePicModel({
      this.error, 
      this.data, 
      this.message,});

  CustomerUploadProfilePicModel.fromJson(dynamic json) {
    error = json['error'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
    message = json['message'];
  }
  bool? error;
  Data? data;
  String? message;



}

class Data {
  Data({this.url,});

  Data.fromJson(dynamic json) {
    url = json['url'];
  }
  String? url;

}