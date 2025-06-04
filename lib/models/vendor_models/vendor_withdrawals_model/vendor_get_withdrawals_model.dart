import 'package:event_app/models/vendor_models/products/VendorGetProductsModel.dart';

class VendorGetWithdrawalsModel {
  VendorGetWithdrawalsModel({this.error, this.data, this.message});

  VendorGetWithdrawalsModel.fromJson(Map<String, dynamic> json) {
    error = json['error'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
    message = json['message'];
  }
  bool? error;
  Data? data;
  dynamic message;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['error'] = error;
    data['message'] = message;
    return data;
  }
}

class Data {
  Data({this.pagination, this.records});

  Data.fromJson(Map<String, dynamic> json) {
    pagination = json['pagination'] != null
        ? Pagination.fromJson(json['pagination'])
        : null;
    if (json['records'] != null) {
      records = <VendorWithdrawalRecords>[];
      json['records'].forEach((v) {
        records!.add(VendorWithdrawalRecords.fromJson(v));
      });
    }
  }
  Pagination? pagination;
  List<VendorWithdrawalRecords>? records;
}

class VendorWithdrawalRecords {
  VendorWithdrawalRecords({
    this.id,
    this.fee,
    this.feeFormat,
    this.amount,
    this.amountFormat,
    this.status,
    this.currency,
    this.createdAt,
  });

  VendorWithdrawalRecords.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    fee = json['fee'];
    feeFormat = json['fee_format'];
    amount = json['amount'];
    amountFormat = json['amount_format'];
    status = json['status'] != null ? Status.fromJson(json['status']) : null;
    currency = json['currency'];
    createdAt = json['created_at'];
  }
  int? id;
  String? fee;
  String? feeFormat;
  String? amount;
  String? amountFormat;
  Status? status;
  String? currency;
  String? createdAt;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['fee'] = fee;
    data['fee_format'] = feeFormat;
    data['amount'] = amount;
    data['amount_format'] = amountFormat;
    if (status != null) {
      data['status'] = status!.toJson();
    }
    data['currency'] = currency;
    data['created_at'] = createdAt;
    return data;
  }
}
