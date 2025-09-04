import 'dart:developer';

import 'package:event_app/provider/api_response_handler.dart';
import 'package:flutter/cupertino.dart';

import '../../models/dashboard/home_event_organiser_model.dart';

class VendorByTypesProvider with ChangeNotifier {
  final ApiResponseHandler _apiResponseHandler = ApiResponseHandler();

  bool _isLoading = false;

  bool get isLoading => _isLoading;
  bool _isError = false;

  bool get isError => _isError;
  HomeEventOrganiserModel? _eventOrganiser;

  HomeEventOrganiserModel? get eventOrganiser => _eventOrganiser;
  Map<int, List<Records>> recordsByTypeId = {};

  Future<void> fetchEventOrganiser(
    BuildContext context, {
    required data,
  }) async {
    final typeId = int.tryParse(data['attributes']['type_id'].toString()) ?? 0;
    final limit = data['attributes']['limit'].toString();
    // final baseUrl = Uri.parse('https://apistaging.theevents.ae/api/v1/stores?$typeId');
    final baseUrl = 'https://apistaging.theevents.ae/api/v1/customers-by-type/$typeId';
    final params = {
      'limit': limit,
      'type_id': typeId.toString(),
    };
    final url = baseUrl; // Add query parameters here
    try {
      _isLoading = true;
      _isError = false;
      notifyListeners();

      final response = await _apiResponseHandler.getRequest(
        url,
        queryParams: params,
        context: context,
      );

      if (response.statusCode == 200) {
        log('response=>> ${response.data}');
        _eventOrganiser = HomeEventOrganiserModel.fromJson(response.data);
        _isLoading = false;
        notifyListeners();
      } else {
        _isError = true;
      }
    } catch (error) {
      _isError = true;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
