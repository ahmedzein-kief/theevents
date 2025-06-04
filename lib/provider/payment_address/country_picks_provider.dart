import 'dart:convert';

import 'package:event_app/core/network/api_endpoints/api_end_point.dart';
import 'package:event_app/provider/api_response_handler.dart';
import 'package:flutter/material.dart';

class CountryModels {
  // Change Null? to String?

  CountryModels({this.error, this.data, this.message});

  CountryModels.fromJson(Map<String, dynamic> json) {
    error = json['error'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
    message = json['message']; // Assume message is of type String
  }
  bool? error;
  Data? data;
  String? message;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['error'] = error;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['message'] = message;
    return data;
  }
}

class Data {
  Data({this.list, this.isMulti});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['list'] != null) {
      list = <CountryList>[];
      json['list'].forEach((v) {
        list!.add(CountryList.fromJson(v));
      });
    }
    isMulti = json['is_multi'];
  }
  List<CountryList>? list;
  bool? isMulti;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (list != null) {
      data['list'] = list!.map((v) => v.toJson()).toList();
    }
    data['is_multi'] = isMulti;
    return data;
  }
}

class CountryList {
  CountryList({this.label, this.value, this.title});

  CountryList.fromJson(Map<String, dynamic> json) {
    label = json['label'];
    value = json['value'];
    title = json['title'];
  }
  String? label;
  String? value;
  String? title;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['label'] = label;
    data['value'] = value;
    data['title'] = title;
    return data;
  }
}

Future<CountryModels?> fetchCountries(BuildContext context) async {
  final ApiResponseHandler apiResponseHandler = ApiResponseHandler();

  const url = ApiEndpoints.countryList;

  final response = await apiResponseHandler.getRequest(
    url,
    context: context,
  );

  if (response.statusCode == 200) {
    final jsonResponse = json.decode(response.body);
    return CountryModels.fromJson(jsonResponse);
  } else {
    throw Exception('Failed to load country list');
  }
}
