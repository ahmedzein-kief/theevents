import 'dart:convert';

class CheckoutResponse {
  bool? error;
  CheckoutData? data;
  dynamic message;

  CheckoutResponse({
    this.error,
    this.data,
    this.message,
  });

  factory CheckoutResponse.fromRawJson(String str) => CheckoutResponse.fromJson(json.decode(str));

  factory CheckoutResponse.fromJson(Map<String, dynamic> json) => CheckoutResponse(
        error: json["error"],
        data: json["data"] == null ? null : CheckoutData.fromJson(json["data"]),
        message: json["message"],
      );
}

class CheckoutData {
  String? token;
  Shipping? shipping;
  String? defaultShippingMethod;
  String? defaultShippingOption;
  dynamic subTotal;
  dynamic tax;
  dynamic rawTotal;
  dynamic orderAmount;
  dynamic shippingAmount;
  dynamic promotionDiscountAmount;
  dynamic couponDiscountAmount;
  FormattedPrices? formattedPrices;
  SessionCheckoutData? sessionCheckoutData;
  bool? isShowAddressForm;
  List<Address>? addresses;
  bool? isAvailableAddress;
  dynamic sessionAddressId;
  List<dynamic>? discounts;

  CheckoutData({
    this.token,
    this.shipping,
    this.defaultShippingMethod,
    this.defaultShippingOption,
    this.subTotal,
    this.tax,
    this.rawTotal,
    this.orderAmount,
    this.shippingAmount,
    this.promotionDiscountAmount,
    this.couponDiscountAmount,
    this.formattedPrices,
    this.sessionCheckoutData,
    this.isShowAddressForm,
    this.addresses,
    this.isAvailableAddress,
    this.sessionAddressId,
    this.discounts,
  });

  factory CheckoutData.fromRawJson(String str) => CheckoutData.fromJson(json.decode(str));

  factory CheckoutData.fromJson(Map<String, dynamic> json) => CheckoutData(
        token: json["token"],
        shipping: json["shipping"] == null ? null : Shipping.fromJson(json["shipping"]),
        defaultShippingMethod: json["defaultShippingMethod"],
        defaultShippingOption: json["defaultShippingOption"],
        subTotal: json["subTotal"],
        tax: json["tax"],
        rawTotal: json["rawTotal"],
        orderAmount: json["orderAmount"] is double ? json["orderAmount"].toStringAsFixed(2) : json["orderAmount"],
        shippingAmount: json["shippingAmount"],
        promotionDiscountAmount: json["promotionDiscountAmount"],
        couponDiscountAmount: json["couponDiscountAmount"],
        formattedPrices: json["formatted_prices"] == null ? null : FormattedPrices.fromJson(json["formatted_prices"]),
        sessionCheckoutData: json["sessionCheckoutData"] == null ? null : SessionCheckoutData.fromJson(json["sessionCheckoutData"]),
        isShowAddressForm: json["isShowAddressForm"],
        addresses: json["addresses"] == null ? [] : List<Address>.from(json["addresses"]!.map((x) => Address.fromJson(x))),
        isAvailableAddress: json["isAvailableAddress"],
        sessionAddressId: json["sessionAddressId"],
        discounts: json["discounts"] == null ? [] : List<dynamic>.from(json["discounts"]!.map((x) => x)),
      );
}

class Shipping {
  Map<String, Default>? shippingDefault;

  Shipping({
    this.shippingDefault,
  });

  factory Shipping.fromRawJson(String str) => Shipping.fromJson(json.decode(str));

  factory Shipping.fromJson(Map<String, dynamic> json) => Shipping(
        shippingDefault: Map.from(json["default"]!).map((k, v) => MapEntry<String, Default>(k, Default.fromJson(v))),
      );
}

class Default {
  dynamic name;
  dynamic price;

  Default({
    this.name,
    this.price,
  });

  factory Default.fromRawJson(String str) => Default.fromJson(json.decode(str));

  factory Default.fromJson(Map<String, dynamic> json) => Default(
        name: json["name"],
        price: json["price"],
      );
}

class Address {
  dynamic id;
  String? name;
  String? email;
  String? phone;
  String? country;
  dynamic state;
  String? city;
  String? address;
  dynamic customerId;
  dynamic isDefault;
  DateTime? createdAt;
  DateTime? updatedAt;
  dynamic zipCode;
  List<dynamic>? locationCountry;
  List<dynamic>? locationState;
  List<dynamic>? locationCity;

  Address({
    this.id,
    this.name,
    this.email,
    this.phone,
    this.country,
    this.state,
    this.city,
    this.address,
    this.customerId,
    this.isDefault,
    this.createdAt,
    this.updatedAt,
    this.zipCode,
    this.locationCountry,
    this.locationState,
    this.locationCity,
  });

  factory Address.fromRawJson(String str) => Address.fromJson(json.decode(str));

  factory Address.fromJson(Map<String, dynamic> json) => Address(
        id: json["id"],
        name: json["name"],
        email: json["email"],
        phone: json["phone"],
        country: json["country"],
        state: json["state"],
        city: json["city"],
        address: json["address"],
        customerId: json["customer_id"],
        isDefault: json["is_default"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
        zipCode: json["zip_code"],
        locationCountry: json["location_country"] == null ? [] : List<dynamic>.from(json["location_country"]!.map((x) => x)),
        locationState: json["location_state"] == null ? [] : List<dynamic>.from(json["location_state"]!.map((x) => x)),
        locationCity: json["location_city"] == null ? [] : List<dynamic>.from(json["location_city"]!.map((x) => x)),
      );
}

class FormattedPrices {
  String? subTotal;
  String? tax;
  String? rawTotal;
  String? orderAmount;
  String? shippingAmount;
  String? promotionDiscountAmount;
  String? couponDiscountAmount;

  FormattedPrices({
    this.subTotal,
    this.tax,
    this.rawTotal,
    this.orderAmount,
    this.shippingAmount,
    this.promotionDiscountAmount,
    this.couponDiscountAmount,
  });

  factory FormattedPrices.fromRawJson(String str) => FormattedPrices.fromJson(json.decode(str));

  factory FormattedPrices.fromJson(Map<String, dynamic> json) => FormattedPrices(
        subTotal: json["subTotal"],
        tax: json["tax"],
        rawTotal: json["rawTotal"],
        orderAmount: json["orderAmount"],
        shippingAmount: json["shippingAmount"],
        promotionDiscountAmount: json["promotionDiscountAmount"],
        couponDiscountAmount: json["couponDiscountAmount"],
      );
}

class SessionCheckoutData {
  dynamic addressId;
  String? name;
  String? phone;
  String? email;
  String? country;
  dynamic state;
  String? city;
  String? address;
  dynamic zipCode;
  bool? apiSession;
  Marketplace? marketplace;
  List<ShippingDetails>? listShippingDetails;
  int? isAvailableShipping;

  SessionCheckoutData({
    this.addressId,
    this.name,
    this.phone,
    this.email,
    this.country,
    this.state,
    this.city,
    this.address,
    this.zipCode,
    this.apiSession,
    this.marketplace,
    this.isAvailableShipping,
  });

  factory SessionCheckoutData.fromRawJson(String str) => SessionCheckoutData.fromJson(json.decode(str));

  factory SessionCheckoutData.fromJson(Map<String, dynamic> json) => SessionCheckoutData(
        addressId: json["address_id"],
        name: json["name"],
        phone: json["phone"],
        email: json["email"],
        country: json["country"],
        state: json["state"],
        city: json["city"],
        address: json["address"],
        zipCode: json["zip_code"],
        apiSession: json["api_session"],
        marketplace: (json["marketplace"] is Map)
            ? Marketplace.fromJson(json["marketplace"])
            : (json["marketplace"] is List && json["marketplace"].isNotEmpty)
                ? Marketplace.fromJson({"0": json["marketplace"].first}) // Convert List to Map
                : null,
        isAvailableShipping: json["is_available_shipping"],
      );
}

class Marketplace {
  Map<String, ShippingDetails>? data;

  Marketplace({
    this.data,
  });

  factory Marketplace.fromJson(Map<String, dynamic> json) => Marketplace(
        data: json.map(
          (key, value) => MapEntry(
            key,
            ShippingDetails.fromJson(value),
          ),
        ),
      );
}

class ShippingDetails {
  dynamic addressId;
  String? name;
  String? phone;
  String? email;
  String? country;
  dynamic state;
  String? city;
  String? address;
  dynamic zipCode;
  DateTime? createdOrder;
  int? createdOrderId;
  bool? isSaveOrderShippingAddress;
  bool? createdOrderAddress;
  dynamic createdOrderAddressId;
  DateTime? createdOrderProduct;
  int? couponDiscountAmount;
  dynamic appliedCouponCode;
  bool? isFreeShipping;
  int? promotionDiscountAmount;
  String? shippingMethod;
  String? shippingOption;
  String? shippingAmount;
  Shipping? shipping;
  String? defaultShippingMethod;
  String? defaultShippingOption;
  bool? isAvailableShipping;

  ShippingDetails({
    this.addressId,
    this.name,
    this.phone,
    this.email,
    this.country,
    this.state,
    this.city,
    this.address,
    this.zipCode,
    this.createdOrder,
    this.createdOrderId,
    this.isSaveOrderShippingAddress,
    this.createdOrderAddress,
    this.createdOrderAddressId,
    this.createdOrderProduct,
    this.couponDiscountAmount,
    this.appliedCouponCode,
    this.isFreeShipping,
    this.promotionDiscountAmount,
    this.shippingMethod,
    this.shippingOption,
    this.shippingAmount,
    this.shipping,
    this.defaultShippingMethod,
    this.defaultShippingOption,
    this.isAvailableShipping,
  });

  factory ShippingDetails.fromRawJson(String str) => ShippingDetails.fromJson(json.decode(str));

  factory ShippingDetails.fromJson(Map<String, dynamic> json) => ShippingDetails(
        addressId: json["address_id"],
        name: json["name"],
        phone: json["phone"],
        email: json["email"],
        country: json["country"],
        state: json["state"],
        city: json["city"],
        address: json["address"],
        zipCode: json["zip_code"],
        createdOrder: json["created_order"] == null ? null : DateTime.parse(json["created_order"]),
        createdOrderId: json["created_order_id"],
        isSaveOrderShippingAddress: json["is_save_order_shipping_address"],
        createdOrderAddress: json["created_order_address"],
        createdOrderAddressId: json["created_order_address_id"],
        createdOrderProduct: json["created_order_product"] == null ? null : DateTime.parse(json["created_order_product"]),
        couponDiscountAmount: json["coupon_discount_amount"],
        appliedCouponCode: json["applied_coupon_code"],
        isFreeShipping: json["is_free_shipping"],
        promotionDiscountAmount: json["promotion_discount_amount"],
        shippingMethod: json["shipping_method"],
        shippingOption: json["shipping_option"],
        shippingAmount: json["shipping_amount"],
        shipping: json["shipping"] == null ? null : Shipping.fromJson(json["shipping"]),
        defaultShippingMethod: json["default_shipping_method"],
        defaultShippingOption: json["default_shipping_option"],
        isAvailableShipping: json["is_available_shipping"],
      );
}
