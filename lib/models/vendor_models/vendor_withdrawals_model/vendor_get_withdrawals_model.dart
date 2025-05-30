
import 'package:event_app/models/vendor_models/products/VendorGetProductsModel.dart';

class VendorGetWithdrawalsModel {
  bool? error;
  Data? data;
  dynamic? message;

  VendorGetWithdrawalsModel({this.error, this.data, this.message});

  VendorGetWithdrawalsModel.fromJson(Map<String, dynamic> json) {
    error = json['error'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['error'] = this.error;
    data['message'] = this.message;
    return data;
  }
}

class Data {
  Pagination? pagination;
  List<VendorWithdrawalRecords>? records;

  Data({this.pagination, this.records});

  Data.fromJson(Map<String, dynamic> json) {
    pagination = json['pagination'] != null
        ? new Pagination.fromJson(json['pagination'])
        : null;
    if (json['records'] != null) {
      records = <VendorWithdrawalRecords>[];
      json['records'].forEach((v) {
        records!.add(new VendorWithdrawalRecords.fromJson(v));
      });
    }
  }

}


class VendorWithdrawalRecords {
  int? id;
  String? fee;
  String? feeFormat;
  String? amount;
  String? amountFormat;
  Status? status;
  String? currency;
  String? createdAt;

  VendorWithdrawalRecords(
      {this.id,
        this.fee,
        this.feeFormat,
        this.amount,
        this.amountFormat,
        this.status,
        this.currency,
        this.createdAt});

  VendorWithdrawalRecords.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    fee = json['fee'];
    feeFormat = json['fee_format'];
    amount = json['amount'];
    amountFormat = json['amount_format'];
    status =
    json['status'] != null ? new Status.fromJson(json['status']) : null;
    currency = json['currency'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['fee'] = this.fee;
    data['fee_format'] = this.feeFormat;
    data['amount'] = this.amount;
    data['amount_format'] = this.amountFormat;
    if (this.status != null) {
      data['status'] = this.status!.toJson();
    }
    data['currency'] = this.currency;
    data['created_at'] = this.createdAt;
    return data;
  }
}

