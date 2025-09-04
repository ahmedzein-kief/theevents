import 'dart:developer';

import 'package:flutter/material.dart';

import '../../core/network/api_endpoints/api_end_point.dart';
import '../../provider/api_response_handler.dart';

class StateModels {
  final bool? error;
  final String? message;
  final List<StateRecord>? data;

  StateModels({this.error, this.message, this.data});

  factory StateModels.fromJson(Map<String, dynamic> json) {
    return StateModels(
      error: json['error'],
      message: json['message'],
      data: json['data'] != null
          ? List<StateRecord>.from(
              json['data'].map((x) => StateRecord.fromJson(x)),
            )
          : null,
    );
  }
}

class StateRecord {
  final int? id;
  final String? name;

  StateRecord({this.id, this.name});

  factory StateRecord.fromJson(Map<String, dynamic> json) {
    return StateRecord(
      id: json['id'],
      name: json['name'],
    );
  }
}

class CityModels {
  final bool? error;
  final String? message;
  final List<CityRecord>? data;

  CityModels({this.error, this.message, this.data});

  factory CityModels.fromJson(Map<String, dynamic> json) {
    return CityModels(
      error: json['error'],
      message: json['message'],
      data: json['data'] != null
          ? List<CityRecord>.from(
              json['data'].map((x) => CityRecord.fromJson(x)),
            )
          : null,
    );
  }
}

class CityRecord {
  final int? id;
  final String? name;

  CityRecord({this.id, this.name});

  factory CityRecord.fromJson(Map<String, dynamic> json) {
    return CityRecord(
      id: json['id'],
      name: json['name'],
    );
  }
}

Future<StateModels?> fetchStates(BuildContext context, int countryId) async {
  final ApiResponseHandler apiResponseHandler = ApiResponseHandler();
  final url = '${ApiEndpoints.stateList}?country_id=$countryId';

  final response = await apiResponseHandler.getRequest(
    url,
    context: context,
  );

  if (response.statusCode == 200) {
    final jsonResponse = response.data;
    return StateModels.fromJson(jsonResponse);
  } else {
    throw Exception('Failed to load state list');
  }
}

Future<CityModels?> fetchCities(
  BuildContext context,
  int stateId,
  int countryId,
) async {
  final ApiResponseHandler apiResponseHandler = ApiResponseHandler();
  final url = '${ApiEndpoints.cityList}?state_id=$stateId&country_id=$countryId';

  final response = await apiResponseHandler.getRequest(
    url,
    context: context,
  );
  log('fetchCities $response $url');
  if (response.statusCode == 200) {
    final jsonResponse = response.data;
    return CityModels.fromJson(jsonResponse);
  } else {
    throw Exception('Failed to load city list');
  }
}
