import 'dart:convert';

import 'package:event_app/provider/api_response_handler.dart';
import 'package:event_app/utils/apiendpoints/api_end_point.dart';
import 'package:event_app/utils/storage/shared_preferences_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../core/utils/custom_toast.dart';
import '../../utils/apiStatus/api_status.dart';

class CustomerAddressModels {
  bool? error;
  Data? data;
  Null message;

  CustomerAddressModels({this.error, this.data, this.message});

  CustomerAddressModels.fromJson(Map<String, dynamic> json) {
    error = json['error'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['error'] = this.error;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['message'] = this.message;
    return data;
  }
}

class Data {
  AddressPagination? pagination;
  List<CustomerRecords>? records;

  Data({this.pagination, this.records});

  Data.fromJson(Map<String, dynamic> json) {
    pagination = json['pagination'] != null ? new AddressPagination.fromJson(json['pagination']) : null;
    if (json['records'] != null) {
      records = <CustomerRecords>[];
      json['records'].forEach((v) {
        records!.add(new CustomerRecords.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.pagination != null) {
      data['pagination'] = this.pagination!.toJson();
    }
    if (this.records != null) {
      data['records'] = this.records!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class AddressPagination {
  int? total;
  int? lastPage;
  int? currentPage;
  int? perPage;

  AddressPagination({this.total, this.lastPage, this.currentPage, this.perPage});

  AddressPagination.fromJson(Map<String, dynamic> json) {
    total = json['total'];
    lastPage = json['last_page'];
    currentPage = json['current_page'];
    perPage = json['per_page'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['total'] = this.total;
    data['last_page'] = this.lastPage;
    data['current_page'] = this.currentPage;
    data['per_page'] = this.perPage;
    return data;
  }
}

class CustomerRecords {
  int? id;
  String? name;
  int? isDefault;
  String? fullAddress;
  String? email;
  String? zip_code;
  String? phone;
  String? country;
  String? city;
  String? address;
  String? state;

  CustomerRecords({this.id, this.name, this.isDefault, this.fullAddress, this.phone, this.email, this.country, this.city, this.address, this.zip_code, this.state});

  CustomerRecords.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    isDefault = json['is_default'];
    fullAddress = json['full_address'];
    phone = json['phone'];
    country = json['country'];
    city = json['city'];
    address = json['address'];
    state = json['state'];
    zip_code = json['zip_code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['email'] = this.email;
    data['is_default'] = this.isDefault;
    data['full_address'] = this.fullAddress;
    data['phone'] = this.phone;
    data['country'] = this.country;
    data['country'] = this.city;
    data['country'] = this.address;
    return data;
  }
}

class CustomerAddressProvider with ChangeNotifier {
  final ApiResponseHandler _apiResponseHandler = ApiResponseHandler();

  ApiStatus _status = ApiStatus.completed;

  ApiStatus get status => _status;

  void setStatus(ApiStatus status) {
    _status = status;
    notifyListeners();
  }

  List<CustomerRecords> _addresses = [];
  AddressPagination? _addressPagination;
  bool _isLoadingAddresses = false;

  bool get isLoadingAddresses => _isLoadingAddresses;
  bool _isLoading = false;
  String? _errorMessage;

  AddressPagination? get addressPagination => _addressPagination;

  List<CustomerRecords> get addresses => _addresses;

  bool get isLoading => _isLoading;

  String? get errorMessage => _errorMessage;

  Future<CustomerAddressModels?> fetchCustomerAddresses(String token, BuildContext context, {int perPage = 12, page = 1}) async {
    setStatus(ApiStatus.loading);
    if (page == 1) {
      _addresses.clear();
      _isLoadingAddresses = true;
    }

    notifyListeners();

    try {
      final url = '${ApiEndpoints.customerAddressList}?per-page=$perPage&page=$page';
      final headers = {
        'Authorization': 'Bearer $token',
      };

      final response = await _apiResponseHandler.getRequest(
        url,
        headers: headers,
        context: context,
      );

      if (response.statusCode == 200) {
        setStatus(ApiStatus.completed);
        CustomerAddressModels customerAddressModels = CustomerAddressModels.fromJson(json.decode(response.body));

        if (page == 1) {
          _addresses = customerAddressModels.data?.records ?? [];
          _addressPagination = customerAddressModels.data?.pagination;
        } else {
          _addresses.addAll(customerAddressModels.data?.records ?? []);
        }

        _isLoadingAddresses = false;
        notifyListeners();
        return customerAddressModels;
      } else {
        _errorMessage = 'Failed to load addresses';
        _isLoadingAddresses = false;
        setStatus(ApiStatus.error);
        notifyListeners();
        return null;
      }
    } catch (error) {
      _errorMessage = error.toString();
      return null;
    } finally {
      _isLoadingAddresses = false;
      setStatus(ApiStatus.error);
      notifyListeners();
    }
  }

  ///  TODO :  DELETE THE ADDRESS OF USER

  bool _isLoadingDelete = false;

  String? errorMessageDelete;

  bool get isLoadingDelete => _isLoadingDelete;

  // Method to delete an address
  Future<void> deleteAddress(int addressId, BuildContext context) async {
    try {
      _isLoadingDelete = true;
      notifyListeners();

      final token = await SecurePreferencesUtil.getToken();
      final url = '${ApiEndpoints.customerAddressDelete}$addressId';
      final headers = {'Authorization': token ?? ''};

      final response = await _apiResponseHandler.deleteRequest(url, headers: headers);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['error'] == false) {
          CustomSnackbar.showSuccess(context, "Address Delete successfully!");

          addresses.removeWhere((address) => address.id == addressId);
        } else {
          errorMessageDelete = data['message'] ?? 'Failed to delete address';
          CustomSnackbar.showError(context, "Failed to delete address!");
        }
      } else {
        errorMessageDelete = "Failed to delete address";
      }
    } catch (error) {
      errorMessageDelete = "An error occurred: $error";
    } finally {
      _isLoadingDelete = false;
      notifyListeners();
    }
  }
}
