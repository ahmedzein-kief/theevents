import 'package:event_app/core/helper/extensions/app_localizations_extension.dart';
import 'package:event_app/core/network/api_endpoints/api_end_point.dart';
import 'package:event_app/core/services/shared_preferences_helper.dart';
import 'package:event_app/provider/api_response_handler.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../core/constants/app_strings.dart';
import '../../core/network/api_endpoints/api_contsants.dart';
import '../../core/network/api_status/api_status.dart';
import '../../core/utils/app_utils.dart';

class CustomerAddressModels {
  CustomerAddressModels({this.error, this.data, this.message});

  CustomerAddressModels.fromJson(Map<String, dynamic> json) {
    error = json['error'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
    message = json['message'];
  }

  bool? error;
  Data? data;
  Null message;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['error'] = error;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['message'] = message;
    return data;
  }
}

class Data {
  Data({this.pagination, this.records});

  Data.fromJson(Map<String, dynamic> json) {
    pagination = json['pagination'] != null ? AddressPagination.fromJson(json['pagination']) : null;
    if (json['records'] != null) {
      records = <CustomerRecords>[];
      json['records'].forEach((v) {
        records!.add(CustomerRecords.fromJson(v));
      });
    }
  }

  AddressPagination? pagination;
  List<CustomerRecords>? records;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (pagination != null) {
      data['pagination'] = pagination!.toJson();
    }
    if (records != null) {
      data['records'] = records!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class AddressPagination {
  AddressPagination({
    this.total,
    this.lastPage,
    this.currentPage,
    this.perPage,
  });

  AddressPagination.fromJson(Map<String, dynamic> json) {
    total = json['total'];
    lastPage = json['last_page'];
    currentPage = json['current_page'];
    perPage = json['per_page'];
  }

  int? total;
  int? lastPage;
  int? currentPage;
  int? perPage;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['total'] = total;
    data['last_page'] = lastPage;
    data['current_page'] = currentPage;
    data['per_page'] = perPage;
    return data;
  }
}

class CustomerRecords {
  CustomerRecords({
    this.id,
    this.name,
    this.isDefault,
    this.fullAddress,
    this.phone,
    this.email,
    this.country,
    this.city,
    this.address,
    this.zipCode,
    this.state,
    this.countryId, // Added
    this.stateId, // Added
    this.cityId, // Added
    this.phoneCountryCode, // Added from API response
  });

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
    zipCode = json['zip_code'];
    countryId = json['country_id']; // Added
    stateId = json['state_id']; // Added
    cityId = json['city_id']; // Added
    phoneCountryCode = json['phone_country_code']; // Added
  }

  int? id;
  String? name;
  int? isDefault;
  String? fullAddress;
  String? email;
  String? zipCode; // Fixed naming convention
  String? phone;
  String? country;
  String? city;
  String? address;
  String? state;
  String? countryId; // Added
  String? stateId; // Added
  String? cityId; // Added
  String? phoneCountryCode; // Added

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['email'] = email;
    data['is_default'] = isDefault;
    data['full_address'] = fullAddress;
    data['phone'] = phone;
    data['country'] = country;
    data['city'] = city;
    data['address'] = address;
    data['state'] = state;
    data['zip_code'] = zipCode;
    data['country_id'] = countryId; // Added
    data['state_id'] = stateId; // Added
    data['city_id'] = cityId; // Added
    data['phone_country_code'] = phoneCountryCode; // Added
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
  final bool _isLoading = false;
  String? _errorMessage;

  AddressPagination? get addressPagination => _addressPagination;

  List<CustomerRecords> get addresses => _addresses;

  bool get isLoading => _isLoading;

  String? get errorMessage => _errorMessage;

  Future<CustomerAddressModels?> fetchCustomerAddresses({
    int perPage = 12,
    page = 1,
  }) async {
    if (page == 1) {
      _addresses.clear();
    }

    _isLoadingAddresses = true;
    notifyListeners();

    try {
      final url = '${ApiEndpoints.customerAddressList}?per-page=$perPage&page=$page';
      final response = await _apiResponseHandler.getRequest(url, extra: {ApiConstants.requireAuthKey: true});

      if (response.statusCode == 200) {
        final CustomerAddressModels customerAddressModels = CustomerAddressModels.fromJson(response.data);

        if (page == 1) {
          _addresses = customerAddressModels.data?.records ?? [];
          _addressPagination = customerAddressModels.data?.pagination;
        } else {
          _addresses.addAll(customerAddressModels.data?.records ?? []);
        }

        _errorMessage = null;
        return customerAddressModels;
      } else {
        _errorMessage = AppStrings.failedToLoadAddresses.tr;
        return null;
      }
    } catch (error) {
      _errorMessage = error.toString();
      return null;
    } finally {
      _isLoadingAddresses = false;
      notifyListeners();
    }
  }

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
        final data = response.data;
        if (data['error'] == false) {
          AppUtils.showToast(AppStrings.addressDeleteSuccess.tr, isSuccess: true);

          addresses.removeWhere((address) => address.id == addressId);
        } else {
          errorMessageDelete = data['message'] ?? AppStrings.failedToDeleteAddress.tr;
          AppUtils.showToast(AppStrings.failedToDeleteAddress.tr);
        }
      } else {
        errorMessageDelete = AppStrings.failedToDeleteAddress.tr;
      }
    } catch (error) {
      errorMessageDelete = AppStrings.anErrorOccurred.tr;
    } finally {
      _isLoadingDelete = false;
      notifyListeners();
    }
  }
}
