Map<String, dynamic> _parseShipping(data) {
  if (data == null || data is List) {
    return {};
  }
  return data as Map<String, dynamic>;
}

class CheckoutResponse {
  final bool error;
  final CheckoutData? data;
  final String? message;

  CheckoutResponse({
    required this.error,
    this.data,
    this.message,
  });

  factory CheckoutResponse.fromJson(Map<String, dynamic> json) {
    return CheckoutResponse(
      error: json['error'] ?? false,
      data: json['data'] != null ? CheckoutData.fromJson(json['data']) : null,
      message: json['message'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'error': error,
      'data': data?.toJson(),
      'message': message,
    };
  }
}

class CheckoutData {
  final String token;
  final Map<String, dynamic> shipping;
  final String defaultShippingMethod;
  final String defaultShippingOption;
  final double subTotal;
  final double tax;
  final double rawTotal;
  final double orderAmount;
  final double shippingAmount;
  final double promotionDiscountAmount;
  final double couponDiscountAmount;
  final FormattedPrices formattedPrices;
  final SessionCheckoutData sessionCheckoutData;
  final bool isShowAddressForm;
  final List<Address> addresses;
  final bool isAvailableAddress;
  final int sessionAddressId;
  final List<dynamic> discounts;

  CheckoutData({
    required this.token,
    required this.shipping,
    required this.defaultShippingMethod,
    required this.defaultShippingOption,
    required this.subTotal,
    required this.tax,
    required this.rawTotal,
    required this.orderAmount,
    required this.shippingAmount,
    required this.promotionDiscountAmount,
    required this.couponDiscountAmount,
    required this.formattedPrices,
    required this.sessionCheckoutData,
    required this.isShowAddressForm,
    required this.addresses,
    required this.isAvailableAddress,
    required this.sessionAddressId,
    required this.discounts,
  });

  factory CheckoutData.fromJson(Map<String, dynamic> json) {
    return CheckoutData(
      token: json['token'] ?? '',
      shipping: _parseShipping(json['shipping']),
      defaultShippingMethod: json['defaultShippingMethod'] ?? '',
      defaultShippingOption: json['defaultShippingOption'] ?? '',
      subTotal: (json['subTotal'] ?? 0).toDouble(),
      tax: (json['tax'] ?? 0).toDouble(),
      rawTotal: (json['rawTotal'] ?? 0).toDouble(),
      orderAmount: (json['orderAmount'] ?? 0).toDouble(),
      shippingAmount: (json['shippingAmount'] ?? 0).toDouble(),
      promotionDiscountAmount: (json['promotionDiscountAmount'] ?? 0).toDouble(),
      couponDiscountAmount: (json['couponDiscountAmount'] ?? 0).toDouble(),
      formattedPrices: FormattedPrices.fromJson(json['formatted_prices'] ?? {}),
      sessionCheckoutData: SessionCheckoutData.fromJson(json['sessionCheckoutData'] ?? {}),
      isShowAddressForm: json['isShowAddressForm'] ?? false,
      addresses: (json['addresses'] as List? ?? []).map((address) => Address.fromJson(address)).toList(),
      isAvailableAddress: json['isAvailableAddress'] ?? false,
      sessionAddressId: json['sessionAddressId'] ?? 0,
      discounts: json['discounts'] ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'token': token,
      'shipping': shipping,
      'defaultShippingMethod': defaultShippingMethod,
      'defaultShippingOption': defaultShippingOption,
      'subTotal': subTotal,
      'tax': tax,
      'rawTotal': rawTotal,
      'orderAmount': orderAmount,
      'shippingAmount': shippingAmount,
      'promotionDiscountAmount': promotionDiscountAmount,
      'couponDiscountAmount': couponDiscountAmount,
      'formatted_prices': formattedPrices.toJson(),
      'sessionCheckoutData': sessionCheckoutData.toJson(),
      'isShowAddressForm': isShowAddressForm,
      'addresses': addresses.map((address) => address.toJson()).toList(),
      'isAvailableAddress': isAvailableAddress,
      'sessionAddressId': sessionAddressId,
      'discounts': discounts,
    };
  }
}

class FormattedPrices {
  final String subTotal;
  final String tax;
  final String rawTotal;
  final String orderAmount;
  final String shippingAmount;
  final String promotionDiscountAmount;
  final String couponDiscountAmount;

  FormattedPrices({
    required this.subTotal,
    required this.tax,
    required this.rawTotal,
    required this.orderAmount,
    required this.shippingAmount,
    required this.promotionDiscountAmount,
    required this.couponDiscountAmount,
  });

  factory FormattedPrices.fromJson(Map<String, dynamic> json) {
    return FormattedPrices(
      subTotal: json['subTotal'] ?? '',
      tax: json['tax'] ?? '',
      rawTotal: json['rawTotal'] ?? '',
      orderAmount: json['orderAmount'] ?? '',
      shippingAmount: json['shippingAmount'] ?? '',
      promotionDiscountAmount: json['promotionDiscountAmount'] ?? '',
      couponDiscountAmount: json['couponDiscountAmount'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'subTotal': subTotal,
      'tax': tax,
      'rawTotal': rawTotal,
      'orderAmount': orderAmount,
      'shippingAmount': shippingAmount,
      'promotionDiscountAmount': promotionDiscountAmount,
      'couponDiscountAmount': couponDiscountAmount,
    };
  }
}

class SessionCheckoutData {
  final int addressId;
  final String name;
  final String phone;
  final String email;
  final String country;
  final String state;
  final String city;
  final String address;
  final bool apiSession;
  final Map<String, MarketplaceData> marketplace;
  final int isAvailableShipping;

  SessionCheckoutData({
    required this.addressId,
    required this.name,
    required this.phone,
    required this.email,
    required this.country,
    required this.state,
    required this.city,
    required this.address,
    required this.apiSession,
    required this.marketplace,
    required this.isAvailableShipping,
  });

  factory SessionCheckoutData.fromJson(Map<String, dynamic> json) {
    final Map<String, MarketplaceData> marketplaceMap = {};
    if (json['marketplace'] != null) {
      (json['marketplace'] as Map<String, dynamic>).forEach((key, value) {
        marketplaceMap[key] = MarketplaceData.fromJson(value);
      });
    }

    return SessionCheckoutData(
      addressId: json['address_id'] ?? 0,
      name: json['name'] ?? '',
      phone: json['phone'] ?? '',
      email: json['email'] ?? '',
      country: json['country'] ?? '',
      state: json['state'] ?? '',
      city: json['city'] ?? '',
      address: json['address'] ?? '',
      apiSession: json['api_session'] ?? false,
      marketplace: marketplaceMap,
      isAvailableShipping: json['is_available_shipping'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> marketplaceMap = {};
    marketplace.forEach((key, value) {
      marketplaceMap[key] = value.toJson();
    });

    return {
      'address_id': addressId,
      'name': name,
      'phone': phone,
      'email': email,
      'country': country,
      'state': state,
      'city': city,
      'address': address,
      'api_session': apiSession,
      'marketplace': marketplaceMap,
      'is_available_shipping': isAvailableShipping,
    };
  }
}

class MarketplaceData {
  final int addressId;
  final String name;
  final String phone;
  final String email;
  final String country;
  final String state;
  final String city;
  final String address;
  final String createdOrder;
  final int createdOrderId;
  final bool isSaveOrderShippingAddress;
  final bool createdOrderAddress;
  final int createdOrderAddressId;
  final String createdOrderProduct;
  final double couponDiscountAmount;
  final String? appliedCouponCode;
  final bool isFreeShipping;
  final double promotionDiscountAmount;
  final String shippingMethod;
  final String shippingOption;
  final String shippingAmount;
  final Map<String, dynamic> shipping;
  final String defaultShippingMethod;
  final String defaultShippingOption;
  final bool isAvailableShipping;

  MarketplaceData({
    required this.addressId,
    required this.name,
    required this.phone,
    required this.email,
    required this.country,
    required this.state,
    required this.city,
    required this.address,
    required this.createdOrder,
    required this.createdOrderId,
    required this.isSaveOrderShippingAddress,
    required this.createdOrderAddress,
    required this.createdOrderAddressId,
    required this.createdOrderProduct,
    required this.couponDiscountAmount,
    this.appliedCouponCode,
    required this.isFreeShipping,
    required this.promotionDiscountAmount,
    required this.shippingMethod,
    required this.shippingOption,
    required this.shippingAmount,
    required this.shipping,
    required this.defaultShippingMethod,
    required this.defaultShippingOption,
    required this.isAvailableShipping,
  });

  factory MarketplaceData.fromJson(Map<String, dynamic> json) {
    return MarketplaceData(
      addressId: json['address_id'] ?? 0,
      name: json['name'] ?? '',
      phone: json['phone'] ?? '',
      email: json['email'] ?? '',
      country: json['country'] ?? '',
      state: json['state'] ?? '',
      city: json['city'] ?? '',
      address: json['address'] ?? '',
      createdOrder: json['created_order'] ?? '',
      createdOrderId: json['created_order_id'] ?? 0,
      isSaveOrderShippingAddress: json['is_save_order_shipping_address'] ?? false,
      createdOrderAddress: json['created_order_address'] ?? false,
      createdOrderAddressId: json['created_order_address_id'] ?? 0,
      createdOrderProduct: json['created_order_product'] ?? '',
      couponDiscountAmount: (json['coupon_discount_amount'] ?? 0).toDouble(),
      appliedCouponCode: json['applied_coupon_code'],
      isFreeShipping: json['is_free_shipping'] ?? false,
      promotionDiscountAmount: (json['promotion_discount_amount'] ?? 0).toDouble(),
      shippingMethod: json['shipping_method'] ?? '',
      shippingOption: json['shipping_option'] ?? '',
      shippingAmount: json['shipping_amount'] ?? '',
      shipping: _parseShipping(json['shipping']),
      defaultShippingMethod: json['default_shipping_method'] ?? '',
      defaultShippingOption: json['default_shipping_option'] ?? '',
      isAvailableShipping: json['is_available_shipping'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'address_id': addressId,
      'name': name,
      'phone': phone,
      'email': email,
      'country': country,
      'state': state,
      'city': city,
      'address': address,
      'created_order': createdOrder,
      'created_order_id': createdOrderId,
      'is_save_order_shipping_address': isSaveOrderShippingAddress,
      'created_order_address': createdOrderAddress,
      'created_order_address_id': createdOrderAddressId,
      'created_order_product': createdOrderProduct,
      'coupon_discount_amount': couponDiscountAmount,
      'applied_coupon_code': appliedCouponCode,
      'is_free_shipping': isFreeShipping,
      'promotion_discount_amount': promotionDiscountAmount,
      'shipping_method': shippingMethod,
      'shipping_option': shippingOption,
      'shipping_amount': shippingAmount,
      'shipping': shipping,
      'default_shipping_method': defaultShippingMethod,
      'default_shipping_option': defaultShippingOption,
      'is_available_shipping': isAvailableShipping,
    };
  }
}

class Address {
  final int id;
  final String name;
  final String email;
  final String phone;
  final String country;
  final String state;
  final String city;
  final String address;
  final int customerId;
  final int isDefault;
  final String createdAt;
  final String updatedAt;
  final LocationCountry locationCountry;
  final LocationState locationState;
  final LocationCity locationCity;

  Address({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.country,
    required this.state,
    required this.city,
    required this.address,
    required this.customerId,
    required this.isDefault,
    required this.createdAt,
    required this.updatedAt,
    required this.locationCountry,
    required this.locationState,
    required this.locationCity,
  });

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      country: json['country'] ?? '',
      state: json['state'] ?? '',
      city: json['city'] ?? '',
      address: json['address'] ?? '',
      customerId: json['customer_id'] ?? 0,
      isDefault: json['is_default'] ?? 0,
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
      locationCountry: _parseLocationCountry(json['location_country']),
      locationState: _parseLocationState(json['location_state']),
      locationCity: _parseLocationCity(json['location_city']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'country': country,
      'state': state,
      'city': city,
      'address': address,
      'customer_id': customerId,
      'is_default': isDefault,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'location_country': locationCountry.toJson(),
      'location_state': locationState.toJson(),
      'location_city': locationCity.toJson(),
    };
  } // Helper methods to handle both empty arrays and objects

  static LocationCountry _parseLocationCountry(data) {
    if (data == null || data is List) {
      // Return empty LocationCountry if data is null or empty array
      return LocationCountry(
        id: 0,
        name: '',
        nationality: '',
        order: 0,
        isDefault: false,
        status: Status(value: '', label: ''),
        createdAt: '',
        updatedAt: '',
        code: '',
      );
    }
    return LocationCountry.fromJson(data as Map<String, dynamic>);
  }

  static LocationState _parseLocationState(data) {
    if (data == null || data is List) {
      // Return empty LocationState if data is null or empty array
      return LocationState(
        id: 0,
        name: '',
        slug: '',
        abbreviation: '',
        countryId: 0,
        order: 0,
        isDefault: false,
        status: Status(value: '', label: ''),
        createdAt: '',
        updatedAt: '',
      );
    }
    return LocationState.fromJson(data as Map<String, dynamic>);
  }

  static LocationCity _parseLocationCity(data) {
    if (data == null || data is List) {
      // Return empty LocationCity if data is null or empty array
      return LocationCity(
        id: 0,
        name: '',
        slug: '',
        stateId: 0,
        countryId: 0,
        order: 0,
        isDefault: false,
        status: Status(value: '', label: ''),
        createdAt: '',
        updatedAt: '',
      );
    }
    return LocationCity.fromJson(data as Map<String, dynamic>);
  }
}

class LocationCountry {
  final int id;
  final String name;
  final String nationality;
  final int order;
  final bool isDefault;
  final Status status;
  final String createdAt;
  final String updatedAt;
  final String code;

  LocationCountry({
    required this.id,
    required this.name,
    required this.nationality,
    required this.order,
    required this.isDefault,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.code,
  });

  factory LocationCountry.fromJson(Map<String, dynamic> json) {
    return LocationCountry(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      nationality: json['nationality'] ?? '',
      order: json['order'] ?? 0,
      isDefault: json['is_default'] ?? false,
      status: Status.fromJson(json['status'] ?? {}),
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
      code: json['code'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'nationality': nationality,
      'order': order,
      'is_default': isDefault,
      'status': status.toJson(),
      'created_at': createdAt,
      'updated_at': updatedAt,
      'code': code,
    };
  }
}

class LocationState {
  final int id;
  final String name;
  final String slug;
  final String abbreviation;
  final int countryId;
  final int order;
  final String? image;
  final bool isDefault;
  final Status status;
  final String createdAt;
  final String updatedAt;

  LocationState({
    required this.id,
    required this.name,
    required this.slug,
    required this.abbreviation,
    required this.countryId,
    required this.order,
    this.image,
    required this.isDefault,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory LocationState.fromJson(Map<String, dynamic> json) {
    return LocationState(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      slug: json['slug'] ?? '',
      abbreviation: json['abbreviation'] ?? '',
      countryId: json['country_id'] ?? 0,
      order: json['order'] ?? 0,
      image: json['image'],
      isDefault: json['is_default'] ?? false,
      status: Status.fromJson(json['status'] ?? {}),
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'slug': slug,
      'abbreviation': abbreviation,
      'country_id': countryId,
      'order': order,
      'image': image,
      'is_default': isDefault,
      'status': status.toJson(),
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}

class LocationCity {
  final int id;
  final String name;
  final String slug;
  final int stateId;
  final int countryId;
  final String? recordId;
  final int order;
  final String? image;
  final bool isDefault;
  final Status status;
  final String createdAt;
  final String updatedAt;

  LocationCity({
    required this.id,
    required this.name,
    required this.slug,
    required this.stateId,
    required this.countryId,
    this.recordId,
    required this.order,
    this.image,
    required this.isDefault,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory LocationCity.fromJson(Map<String, dynamic> json) {
    return LocationCity(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      slug: json['slug'] ?? '',
      stateId: json['state_id'] ?? 0,
      countryId: json['country_id'] ?? 0,
      recordId: json['record_id'],
      order: json['order'] ?? 0,
      image: json['image'],
      isDefault: json['is_default'] ?? false,
      status: Status.fromJson(json['status'] ?? {}),
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'slug': slug,
      'state_id': stateId,
      'country_id': countryId,
      'record_id': recordId,
      'order': order,
      'image': image,
      'is_default': isDefault,
      'status': status.toJson(),
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}

class Status {
  final String value;
  final String label;

  Status({
    required this.value,
    required this.label,
  });

  factory Status.fromJson(Map<String, dynamic> json) {
    return Status(
      value: json['value'] ?? '',
      label: json['label'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'value': value,
      'label': label,
    };
  }
}
