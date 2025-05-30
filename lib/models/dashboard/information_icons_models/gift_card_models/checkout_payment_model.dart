class CheckoutPaymentModel {
  final bool error;
  final Data data;
  final String? message;

  CheckoutPaymentModel({required this.error, required this.data, this.message});

  factory CheckoutPaymentModel.fromJson(Map<String, dynamic> json) {
    return CheckoutPaymentModel(
      error: json['error'],
      data: Data.fromJson(json['data']),
      message: json['message'],
    );
  }
}

class Data {
  final String checkoutUrl;

  Data({
    required this.checkoutUrl,
  });

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      checkoutUrl: json['checkoutUrl'],
    );
  }
}
