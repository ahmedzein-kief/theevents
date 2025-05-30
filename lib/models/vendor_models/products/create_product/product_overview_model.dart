class VendorProductOverviewModel {
  String sku;
  String price;
  String priceSale;
  bool chooseDiscountPeriod;
  String fromDate;
  String toDate;
  String costPerItem;
  String barcode;
  bool withWareHouseManagement;
  String quantity;
  bool allowCustomerCheckoutWhenProductIsOutOfStock;
  String stockStatus;

  VendorProductOverviewModel({
    required this.sku,
    required this.price,
    required this.priceSale,
    required this.chooseDiscountPeriod,
    required this.fromDate,
    required this.toDate,
    required this.costPerItem,
    required this.barcode,
    required this.withWareHouseManagement,
    required this.quantity,
    required this.allowCustomerCheckoutWhenProductIsOutOfStock,
    required this.stockStatus,
  });

  // Convert model to Map<String, dynamic>
  Map<String, dynamic> toMap() {
    return {
      'sku': sku,
      'price': price,
      'priceSale': priceSale,
      'chooseDiscountPeriod': chooseDiscountPeriod ? 1 : 0,
      if (chooseDiscountPeriod) 'fromDate': fromDate,
      if (chooseDiscountPeriod) 'toDate': toDate,
      'costPerItem': costPerItem,
      'barcode': barcode,
      'withWareHouseManagement': withWareHouseManagement ? 1 : 0,
      if (withWareHouseManagement) 'quantity': quantity,
      if (withWareHouseManagement) 'allowCustomerCheckoutWhenProductIsOutOfStock': allowCustomerCheckoutWhenProductIsOutOfStock ? 1 : 0,
      if (!withWareHouseManagement) 'stockStatus': stockStatus,
    };
  }

  // Optionally: Method to create an instance from a map (for parsing)
  factory VendorProductOverviewModel.fromMap(Map<String, dynamic> map) {
    return VendorProductOverviewModel(
      sku: map['sku'] ?? '',
      price: map['price'] ?? '',
      priceSale: map['priceSale'] ?? '',
      chooseDiscountPeriod: map['chooseDiscountPeriod'] ?? false,
      fromDate: map['fromDate'] ?? '',
      toDate: map['toDate'] ?? '',
      costPerItem: map['costPerItem'] ?? '',
      barcode: map['barcode'] ?? '',
      withWareHouseManagement: map['withWareHouseManagement'] ?? false,
      quantity: map['quantity'] ?? '',
      allowCustomerCheckoutWhenProductIsOutOfStock: map['allowCustomerCheckoutWhenProductIsOutOfStock'] ?? false,
      stockStatus: map['stockStatus'] ?? '',
    );
  }
}
