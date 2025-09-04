///  CART UPDATE MODEL CLASS
library;

class UpdateCartResponse {
  UpdateCartResponse(
      {required this.error, required this.data, required this.message,});

  factory UpdateCartResponse.fromJson(Map<String, dynamic> json) =>
      UpdateCartResponse(
        error: json['error'],
        data: json['data'],
        message: json['message'],
      );
  final bool error;
  final dynamic data; // You can specify the type if you have more detailed data
  final String message;
}
