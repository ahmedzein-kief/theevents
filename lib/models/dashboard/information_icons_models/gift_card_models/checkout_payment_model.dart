class CheckoutPaymentModel {
  CheckoutPaymentModel({required this.error, required this.data, this.message});

  factory CheckoutPaymentModel.fromJson(Map<String, dynamic> json) =>
      CheckoutPaymentModel(
        error: json['error'],
        data: Data.fromJson(json['data']),
        message: json['message'],
      );
  final bool error;
  final Data data;
  final String? message;
}

class Data {
  Data({
    required this.checkoutUrl,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        checkoutUrl: json['checkoutUrl'],
      );
  final String checkoutUrl;
}
