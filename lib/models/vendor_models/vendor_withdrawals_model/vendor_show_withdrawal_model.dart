
import 'package:event_app/models/vendor_models/products/VendorGetProductsModel.dart';

class VendorShowWithdrawalModel {
  VendorShowWithdrawalModel({
      this.error, 
      this.data, 
      this.message,});

  VendorShowWithdrawalModel.fromJson(dynamic json) {
    error = json['error'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
    message = json['message'];
  }
  bool? error;
  Data? data;
  dynamic message;

}

class Data {
  Data({
      this.id, 
      this.fee, 
      this.feeFormat, 
      this.amount, 
      this.amountFormat, 
      this.currentBalance, 
      this.currentBalanceFormat, 
      this.currency, 
      this.description, 
      this.bankInfo, 
      this.paymentChannel, 
      this.status, 
      this.transactionId, 
      this.images, 
      this.createdAt, 
      this.updatedAt,});

  Data.fromJson(dynamic json) {
    id = json['id'];
    fee = json['fee'];
    feeFormat = json['fee_format'];
    amount = json['amount'];
    amountFormat = json['amount_format'];
    currentBalance = json['current_balance'];
    currentBalanceFormat = json['current_balance_format'];
    currency = json['currency'];
    description = json['description'];
    bankInfo = json['bank_info'] != null ? BankInfo.fromJson(json['bank_info']) : null;
    paymentChannel = json['payment_channel'];
    status = json['status'] != null ? Status.fromJson(json['status']) : null;
    transactionId = json['transaction_id'];
    if (json['images'] != null) {
      images = [];
      json['images'].forEach((v) {
        images?.add(v);
      });
    }
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }
  int? id;
  String? fee;
  String? feeFormat;
  String? amount;
  String? amountFormat;
  String? currentBalance;
  String? currentBalanceFormat;
  String? currency;
  String? description;
  BankInfo? bankInfo;
  String? paymentChannel;
  Status? status;
  dynamic transactionId;
  List<dynamic>? images;
  String? createdAt;
  String? updatedAt;


}


class BankInfo {
  BankInfo({
      this.name, 
      this.code, 
      this.fullName, 
      this.number, 
      this.paypalId, 
      this.upiId, 
      this.description,});

  BankInfo.fromJson(dynamic json) {
    name = json['name'];
    code = json['code'];
    fullName = json['full_name'];
    number = json['number'];
    paypalId = json['paypal_id'];
    upiId = json['upi_id'];
    description = json['description'];
  }
  dynamic name;
  dynamic code;
  dynamic fullName;
  dynamic number;
  dynamic paypalId;
  dynamic upiId;
  dynamic description;

}