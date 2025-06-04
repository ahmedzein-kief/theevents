import 'dart:convert';

DashboardDataResponse dashboardDataResponseFromJson(str) =>
    DashboardDataResponse.fromJson(json.decode(str));

class DashboardDataResponse {
  DashboardDataResponse({
    required this.data,
    required this.error,
  });

  factory DashboardDataResponse.fromJson(Map<dynamic, dynamic> json) =>
      DashboardDataResponse(
        data: Data.fromJson(json['data']),
        error: json['error'],
      );

  Data data;
  bool error;
}

class Data {
  Data({
    required this.pendingProducts,
    required this.endDate,
    required this.balanceFormat,
    required this.store,
    required this.livePackages,
    required this.returnOrders,
    required this.liveProducts,
    required this.products,
    required this.revenue,
    required this.balance,
    required this.pendingPackages,
    required this.totalProducts,
    required this.orders,
    required this.totalOrders,
    required this.startDate,
  });

  factory Data.fromJson(Map<dynamic, dynamic> json) => Data(
        pendingProducts: json['pendingProducts'],
        endDate: DateTime.parse(json['endDate']),
        balanceFormat: json['balance_format'],
        store: Store.fromJson(json['store']),
        livePackages: json['livePackages'],
        returnOrders: json['returnOrders'],
        liveProducts: json['liveProducts'],
        products: List<Product>.from(
            json['products'].map((x) => Product.fromJson(x))),
        revenue: Revenue.fromJson(json['revenue']),
        balance: json['balance'],
        pendingPackages: json['pendingPackages'],
        totalProducts: json['totalProducts'],
        orders: List<Order>.from(json['orders'].map((x) => Order.fromJson(x))),
        totalOrders: json['totalOrders'],
        startDate: DateTime.parse(json['startDate']),
      );

  dynamic pendingProducts;
  DateTime endDate;
  dynamic balanceFormat;
  Store store;
  dynamic livePackages;
  dynamic returnOrders;
  dynamic liveProducts;
  List<Product> products;
  Revenue revenue;
  dynamic balance;
  dynamic pendingPackages;
  dynamic totalProducts;
  List<Order> orders;
  dynamic totalOrders;
  DateTime startDate;
}

class Order {
  Order({
    required this.orderCode,
    required this.amount,
    required this.paymentStatus,
    required this.name,
    required this.createdAt,
    required this.id,
    required this.status,
  });

  factory Order.fromJson(Map<dynamic, dynamic> json) => Order(
        orderCode: json['order_code'],
        amount: json['amount'],
        paymentStatus: json['payment_status'],
        name: json['name'],
        createdAt: json['created_at'],
        id: json['id'],
        status: json['status'],
      );

  dynamic orderCode;
  dynamic amount;
  dynamic paymentStatus;
  dynamic name;
  dynamic createdAt;
  dynamic id;
  dynamic status;
}

class Product {
  Product({
    required this.amount,
    required this.name,
    required this.priceInTable,
    required this.createdAt,
    required this.id,
    required this.status,
  });

  factory Product.fromJson(Map<dynamic, dynamic> json) => Product(
        amount: json['amount'],
        name: json['name'],
        priceInTable: json['price_in_table'],
        createdAt: json['created_at'],
        id: json['id'],
        status: json['status'],
      );

  dynamic amount;
  dynamic name;
  dynamic priceInTable;
  dynamic createdAt;
  dynamic id;
  dynamic status;
}

class Revenue {
  Revenue({
    required this.amount,
    required this.withdrawalFormat,
    required this.subAmount,
    required this.fee,
    required this.subAmountFormat,
    required this.feeFormat,
    required this.withdrawal,
    required this.amountFormat,
  });

  factory Revenue.fromJson(Map<dynamic, dynamic> json) => Revenue(
        amount: json['amount'],
        withdrawalFormat: json['withdrawal_format']!,
        subAmount: json['sub_amount'],
        fee: json['fee'],
        subAmountFormat: json['sub_amount_format'],
        feeFormat: json['fee_format']!,
        withdrawal: json['withdrawal'],
        amountFormat: json['amount_format'],
      );

  dynamic amount;
  dynamic withdrawalFormat;
  dynamic subAmount;
  dynamic fee;
  dynamic subAmountFormat;
  dynamic feeFormat;
  dynamic withdrawal;
  dynamic amountFormat;
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

  dynamic name;
  dynamic slug;
}
/*
import 'dart:convert';

DashboardDataResponse? dashboardDataResponseFromJson(dynamic str) =>
    str != null ? DashboardDataResponse.fromJson(json.decode(str)) : null;

class DashboardDataResponse {
  DashboardDataResponse({
    this.data,
    this.error,
  });

  Data? data;
  bool? error;

  factory DashboardDataResponse.fromJson(Map<dynamic, dynamic> json) => DashboardDataResponse(
    data: json["data"] != null ? Data.fromJson(json["data"]) : null,
    error: json["error"],
  );
}

class Data {
  Data({
    this.pendingProducts,
    this.endDate,
    this.balanceFormat,
    this.store,
    this.livePackages,
    this.returnOrders,
    this.liveProducts,
    this.products,
    this.revenue,
    this.balance,
    this.pendingPackages,
    this.totalProducts,
    this.orders,
    this.totalOrders,
    this.startDate,
  });

  dynamic pendingProducts;
  DateTime? endDate;
  dynamic balanceFormat;
  Store? store;
  dynamic livePackages;
  dynamic returnOrders;
  dynamic liveProducts;
  List<Product>? products;
  Revenue? revenue;
  dynamic balance;
  dynamic pendingPackages;
  dynamic totalProducts;
  List<Order>? orders;
  dynamic totalOrders;
  DateTime? startDate;

  factory Data.fromJson(Map<dynamic, dynamic> json) => Data(
    pendingProducts: json["pendingProducts"],
    endDate: json["endDate"] != null ? DateTime.tryParse(json["endDate"]) : null,
    balanceFormat: json["balance_format"],
    store: json["store"] != null ? Store.fromJson(json["store"]) : null,
    livePackages: json["livePackages"],
    returnOrders: json["returnOrders"],
    liveProducts: json["liveProducts"],
    products: json["products"] != null
        ? List<Product>.from(json["products"].map((x) => Product.fromJson(x)))
        : null,
    revenue: json["revenue"] != null ? Revenue.fromJson(json["revenue"]) : null,
    balance: json["balance"],
    pendingPackages: json["pendingPackages"],
    totalProducts: json["totalProducts"],
    orders: json["orders"] != null
        ? List<Order>.from(json["orders"].map((x) => Order.fromJson(x)))
        : null,
    totalOrders: json["totalOrders"],
    startDate: json["startDate"] != null ? DateTime.tryParse(json["startDate"]) : null,
  );
}

class Order {
  Order({
    this.orderCode,
    this.amount,
    this.paymentStatus,
    this.name,
    this.createdAt,
    this.id,
    this.status,
  });

  dynamic orderCode;
  dynamic amount;
  dynamic paymentStatus;
  dynamic name;
  dynamic createdAt;
  dynamic id;
  dynamic status;

  factory Order.fromJson(Map<dynamic, dynamic> json) => Order(
    orderCode: json["order_code"],
    amount: json["amount"],
    paymentStatus: json["payment_status"],
    name: json["name"],
    createdAt: json["created_at"],
    id: json["id"],
    status: json["status"],
  );
}

class Product {
  Product({
    this.amount,
    this.name,
    this.priceInTable,
    this.createdAt,
    this.id,
    this.status,
  });

  dynamic amount;
  dynamic name;
  dynamic priceInTable;
  dynamic createdAt;
  dynamic id;
  dynamic status;

  factory Product.fromJson(Map<dynamic, dynamic> json) => Product(
    amount: json["amount"],
    name: json["name"],
    priceInTable: json["price_in_table"],
    createdAt: json["created_at"],
    id: json["id"],
    status: json["status"],
  );
}

class Revenue {
  Revenue({
    this.amount,
    this.withdrawalFormat,
    this.subAmount,
    this.fee,
    this.subAmountFormat,
    this.feeFormat,
    this.withdrawal,
    this.amountFormat,
  });

  dynamic amount;
  dynamic withdrawalFormat;
  dynamic subAmount;
  dynamic fee;
  dynamic subAmountFormat;
  dynamic feeFormat;
  dynamic withdrawal;
  dynamic amountFormat;

  factory Revenue.fromJson(Map<dynamic, dynamic> json) => Revenue(
    amount: json["amount"],
    withdrawalFormat: json["withdrawal_format"],
    subAmount: json["sub_amount"],
    fee: json["fee"],
    subAmountFormat: json["sub_amount_format"],
    feeFormat: json["fee_format"],
    withdrawal: json["withdrawal"],
    amountFormat: json["amount_format"],
  );
}

class Store {
  Store({
    this.name,
    this.slug,
  });

  dynamic name;
  dynamic slug;

  factory Store.fromJson(Map<dynamic, dynamic> json) => Store(
    name: json["name"],
    slug: json["slug"],
  );
}
*/
