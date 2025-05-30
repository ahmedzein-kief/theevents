///  CART UPDATE MODEL CLASS

class UpdateCartResponse {
  final bool error;
  final dynamic data; // You can specify the type if you have more detailed data
  final String message;

  UpdateCartResponse({required this.error, required this.data, required this.message});

  factory UpdateCartResponse.fromJson(Map<String, dynamic> json) {
    return UpdateCartResponse(
      error: json['error'],
      data: json['data'],
      message: json['message'],
    );
  }
}
