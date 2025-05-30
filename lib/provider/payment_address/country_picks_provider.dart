import 'dart:convert';

import 'package:event_app/provider/api_response_handler.dart';
import 'package:event_app/utils/apiendpoints/api_end_point.dart';
import 'package:flutter/material.dart';

class CountryModels {
  bool? error;
  Data? data;
  String? message; // Change Null? to String?

  CountryModels({this.error, this.data, this.message});

  CountryModels.fromJson(Map<String, dynamic> json) {
    error = json['error'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
    message = json['message']; // Assume message is of type String
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['error'] = this.error;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['message'] = this.message;
    return data;
  }
}

class Data {
  List<CountryList>? list;
  bool? isMulti;

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

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (this.list != null) {
      data['list'] = this.list!.map((v) => v.toJson()).toList();
    }
    data['is_multi'] = this.isMulti;
    return data;
  }
}

class CountryList {
  String? label;
  String? value;
  String? title;

  CountryList({this.label, this.value, this.title});

  CountryList.fromJson(Map<String, dynamic> json) {
    label = json['label'];
    value = json['value'];
    title = json['title'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['label'] = this.label;
    data['value'] = this.value;
    data['title'] = this.title;
    return data;
  }
}

Future<CountryModels?> fetchCountries(BuildContext context) async {
  final ApiResponseHandler _apiResponseHandler = ApiResponseHandler();

  final url = ApiEndpoints.countryList;

  final response = await _apiResponseHandler.getRequest(
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
