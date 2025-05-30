import 'dart:convert';

SubscriptionPackageResponse subscriptionPackageResponseFromJson(String str) => SubscriptionPackageResponse.fromJson(json.decode(str));

String subscriptionPackageResponseToJson(SubscriptionPackageResponse data) => json.encode(data.toJson());

class SubscriptionPackageResponse {
  SubscriptionPackageResponse({
    required this.data,
    required this.error,
  });

  Data data;
  bool error;

  factory SubscriptionPackageResponse.fromJson(Map<dynamic, dynamic> json) => SubscriptionPackageResponse(
        data: Data.fromJson(json["data"]),
        error: json["error"],
      );

  Map<dynamic, dynamic> toJson() => {
        "data": data.toJson(),
        "error": error,
      };
}

class Data {
  Data({
    required this.formatedPrice,
    required this.subHeading2,
    required this.subtime,
    required this.heading,
    required this.subHeading,
    required this.formatedVat,
    required this.price,
    required this.thanksSubHeading,
    required this.storeEmail,
    required this.formatedPriceWithoutVat,
    required this.thanksHeading,
  });

  String formatedPrice;
  String subHeading2;
  String subtime;
  String heading;
  String subHeading;
  String formatedVat;
  String price;
  String thanksSubHeading;
  String storeEmail;
  String formatedPriceWithoutVat;
  String thanksHeading;

  factory Data.fromJson(Map<dynamic, dynamic> json) => Data(
        formatedPrice: json["formated_price"],
        subHeading2: json["sub_heading2"],
        subtime: json["subtime"],
        heading: json["heading"],
        subHeading: json["sub_heading"],
        formatedVat: json["formated_vat"],
        price: json["price"],
        thanksSubHeading: json["thanks_sub_heading"],
        storeEmail: json["store_email"],
        formatedPriceWithoutVat: json["formated_price_without_vat"],
        thanksHeading: json["thanks_heading"],
      );

  Map<dynamic, dynamic> toJson() => {
        "formated_price": formatedPrice,
        "sub_heading2": subHeading2,
        "subtime": subtime,
        "heading": heading,
        "sub_heading": subHeading,
        "formated_vat": formatedVat,
        "price": price,
        "thanks_sub_heading": thanksSubHeading,
        "store_email": storeEmail,
        "formated_price_without_vat": formatedPriceWithoutVat,
        "thanks_heading": thanksHeading,
      };
}
