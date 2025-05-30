class PaymentPostData {
  bool? cardForm;
  int? cardAmount;
  Map<String, String>? paymentMethod;

  // Convert object to List<MapEntry<String, String>>
  List<MapEntry<String, String>> toMapEntries() {
    return {
      "meta_type": "payment",
      "card_form": "0",
      "payment_method": paymentMethod?["payment_method"] ?? "",
      "card_amount": cardAmount.toString(),
      // "${paymentMethod?["sub_option_key"]}": paymentMethod?["sub_option_value"] ?? "",
    }.entries.map((entry) => MapEntry(entry.key, entry.value ?? "")).toList();
  }

  @override
  String toString() {
    return '''
Payment Data:
  Card Form: $cardForm
  Payment Method: $paymentMethod
  Card Amount: $cardAmount
  ''';
  }
}
