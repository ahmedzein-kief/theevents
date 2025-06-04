/// YApi QuickType插件生成，具体参考文档:https://plugins.jetbrains.com/plugin/18847-yapi-quicktype/documentation
library;

import 'dart:convert';

OrderDetailModel orderDetailModelFromJson(String str) =>
    OrderDetailModel.fromJson(json.decode(str));

String orderDetailModelToJson(OrderDetailModel data) =>
    json.encode(data.toJson());

class OrderDetailModel {
  OrderDetailModel({
    required this.data,
    required this.error,
  });

  factory OrderDetailModel.fromJson(Map<dynamic, dynamic> json) =>
      OrderDetailModel(
        data: OrderDetailData.fromJson(json['data']),
        error: json['error'],
      );

  OrderDetailData data;
  bool error;

  Map<dynamic, dynamic> toJson() => {
        'data': data.toJson(),
        'error': error,
      };
}

class OrderDetailData {
  OrderDetailData({
    required this.isInvoiceAvailable,
    required this.taxAmount,
    required this.code,
    required this.discountAmount,
    required this.createdAt,
    required this.fullAddress,
    required this.products,
    required this.shipping,
    required this.price,
    required this.isCanceled,
    required this.proofFile,
    required this.canBeCanceled,
    required this.invoiceId,
    required this.id,
    required this.coupon,
    required this.canBeReturned,
    required this.paymentStatus,
    required this.shippingAmount,
    required this.isTaxEnabled,
    required this.paymentChannel,
    required this.phone,
    required this.totalAmount,
    required this.name,
    required this.status,
  });

  factory OrderDetailData.fromJson(Map<dynamic, dynamic> json) =>
      OrderDetailData(
        isInvoiceAvailable: json['is_invoice_available'],
        taxAmount: json['tax_amount'],
        code: json['code'],
        discountAmount: json['discount_amount'],
        createdAt: json['created_at'],
        fullAddress: json['full_address'],
        products: List<OrderDetailProduct>.from(
            json['products'].map((x) => OrderDetailProduct.fromJson(x))),
        shipping: Shipping.fromJson(json['shipping']),
        price: json['price'],
        isCanceled: json['is_canceled'],
        proofFile: json['proof_file'],
        canBeCanceled: json['can_be_canceled'],
        invoiceId: json['invoice_id'],
        id: json['id'],
        coupon: json['coupon'],
        canBeReturned: json['can_be_returned'],
        paymentStatus: json['payment_status'],
        shippingAmount: json['shipping_amount'],
        isTaxEnabled: json['is_tax_enabled'],
        paymentChannel: json['payment_channel'],
        phone: json['phone'],
        totalAmount: json['total_amount'],
        name: json['name'],
        status: json['status'],
      );

  bool isInvoiceAvailable;
  String taxAmount;
  String code;
  String discountAmount;
  String createdAt;
  String fullAddress;
  List<OrderDetailProduct> products;
  Shipping shipping;
  String price;
  bool isCanceled;
  String? proofFile;
  bool canBeCanceled;
  int invoiceId;
  int id;
  String coupon;
  bool canBeReturned;
  String paymentStatus;
  String shippingAmount;
  bool isTaxEnabled;
  String paymentChannel;
  String phone;
  String totalAmount;
  String name;
  String status;

  bool get hasUploadedProof => proofFile != null;

  Map<dynamic, dynamic> toJson() => {
        'is_invoice_available': isInvoiceAvailable,
        'tax_amount': taxAmount,
        'code': code,
        'discount_amount': discountAmount,
        'created_at': createdAt,
        'full_address': fullAddress,
        'products': List<dynamic>.from(products.map((x) => x.toJson())),
        'shipping': shipping.toJson(),
        'price': price,
        'is_canceled': isCanceled,
        'can_be_canceled': canBeCanceled,
        'invoice_id': invoiceId,
        'id': id,
        'coupon': coupon,
        'can_be_returned': canBeReturned,
        'payment_status': paymentStatus,
        'shipping_amount': shippingAmount,
        'is_tax_enabled': isTaxEnabled,
        'payment_channel': paymentChannel,
        'phone': phone,
        'total_amount': totalAmount,
        'name': name,
        'status': status,
      };
}

class OrderDetailProduct {
  OrderDetailProduct({
    required this.productSlugPrefix,
    required this.productSlug,
    required this.imageUrl,
    required this.store,
    required this.productName,
    required this.productType,
    required this.productOptions,
    required this.qty,
    required this.indexNum,
    required this.attributes,
    required this.sku,
    required this.amountFormat,
    required this.totalFormat,
  });

  factory OrderDetailProduct.fromJson(Map<dynamic, dynamic> json) =>
      OrderDetailProduct(
        productSlugPrefix: json['product_slug_prefix'],
        productSlug: json['product_slug'],
        imageUrl: json['image_url'],
        store: Store.fromJson(json['store']),
        productName: json['product_name'],
        productType: json['product_type'],
        productOptions: json['product_options'],
        qty: json['qty'],
        indexNum: json['index_num'],
        attributes: json['attributes'],
        sku: json['sku'],
        amountFormat: json['amount_format'],
        totalFormat: json['total_format'],
      );

  String productSlugPrefix;
  String productSlug;
  String imageUrl;
  Store store;
  String productName;
  String productType;
  String productOptions;
  int qty;
  int indexNum;
  String attributes;
  String sku;
  String amountFormat;
  String totalFormat;

  Map<dynamic, dynamic> toJson() => {
        'product_slug_prefix': productSlugPrefix,
        'product_slug': productSlug,
        'image_url': imageUrl,
        'store': store.toJson(),
        'product_name': productName,
        'product_type': productType,
        'product_options': productOptions,
        'qty': qty,
        'index_num': indexNum,
        'attributes': attributes,
        'sku': sku,
        'amount_format': amountFormat,
        'total_format': totalFormat,
      };
}

class Store {
  Store({
    required this.name,
    required this.slug,
  });

  factory Store.fromJson(Map<dynamic, dynamic> json) => Store(
        name: json['name'],
        slug: json['slug'],
      );

  String name;
  String slug;

  Map<dynamic, dynamic> toJson() => {
        'name': name,
        'slug': slug,
      };
}

class Shipping {
  Shipping({
    required this.note,
    required this.dateShipped,
    required this.companyName,
    required this.estimateDateShipped,
    required this.id,
    required this.trackingId,
    required this.trackingLink,
    required this.status,
  });

  factory Shipping.fromJson(Map<dynamic, dynamic> json) => Shipping(
        note: json['note'],
        dateShipped: json['date_shipped'],
        companyName: json['company_name'],
        estimateDateShipped: json['estimate_date_shipped'],
        id: json['id'],
        trackingId: json['tracking_id'],
        trackingLink: json['tracking_link'],
        status: json['status'],
      );

  String note;
  String dateShipped;
  String companyName;
  String estimateDateShipped;
  int id;
  String trackingId;
  String trackingLink;
  String status;

  Map<dynamic, dynamic> toJson() => {
        'note': note,
        'date_shipped': dateShipped,
        'company_name': companyName,
        'estimate_date_shipped': estimateDateShipped,
        'id': id,
        'tracking_id': trackingId,
        'tracking_link': trackingLink,
        'status': status,
      };
}
