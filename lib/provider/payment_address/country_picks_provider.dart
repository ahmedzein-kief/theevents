import 'package:event_app/core/network/api_endpoints/api_end_point.dart';
import 'package:event_app/provider/api_response_handler.dart';
import 'package:flutter/material.dart';

class CountryModels {
  CountryModels({this.error, this.data, this.message});

  factory CountryModels.fromJson(Map<String, dynamic> json) {
    return CountryModels(
      error: json['error'],
      data: json['data'] != null
          ? Data.fromApiList(json['data']) // adapt new API shape
          : null,
      message: json['message'],
    );
  }

  bool? error;
  Data? data;
  String? message;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> result = {};
    result['error'] = error;
    if (data != null) {
      result['data'] = data!.toJson();
    }
    result['message'] = message;
    return result;
  }
}

class Data {
  Data({this.list, this.isMulti});

  /// Adapt from new API where "data" is a list of country objects
  factory Data.fromApiList(List<dynamic> apiList) {
    return Data(
      list: apiList.map((json) {
        return CountryList.fromJson(json);
      }).toList(),
    );
  }

  List<CountryList>? list;
  bool? isMulti;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> result = {};
    if (list != null) {
      result['list'] = list!.map((v) => v.toJson()).toList();
    }
    result['is_multi'] = isMulti;
    return result;
  }
}

class CountryList {
  CountryList({this.id, this.name, this.code, this.iso});

  factory CountryList.fromJson(Map<String, dynamic> json) {
    return CountryList(
      id: json['id'] is String && json['id'].toString().isEmpty
          ? null
          : (json['id'] is int
              ? json['id']
              : int.tryParse(json['id'].toString())),
      name: json['name'],
      code: json['code'],
      iso: json['iso'],
    );
  }

  int? id;
  String? name;
  String? code;
  String? iso;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'code': code,
      'iso': iso,
    };
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
    final jsonResponse = response.data;
    return CountryModels.fromJson(jsonResponse);
  } else {
    throw Exception('Failed to load country list');
  }
}
