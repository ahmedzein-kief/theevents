import 'dart:convert';

import 'package:event_app/core/network/api_endpoints/api_end_point.dart';
import 'package:event_app/provider/api_response_handler.dart';
import 'package:flutter/material.dart';

import '../../models/dashboard/events_bazaar_model/events_bazaar_banner_model.dart';
import '../../models/dashboard/events_bazaar_model/events_bazzar_models.dart';

class EventBazaarProvider with ChangeNotifier {
  final ApiResponseHandler _apiResponseHandler = ApiResponseHandler();

  //   ++++++++++++++++++++++++++++++++++++      All events in  of Events bazaar  +++++++++++++++++++++++++++++++++
  List<EventList> _events = [];
  bool _isLoading = false;

  List<EventList> get events => _events;

  bool get isLoading => _isLoading;

  Future<void> fetchEvents(
    List<String> countries,
    BuildContext context,
  ) async {
    _isLoading = true;
    notifyListeners();
    // final response = await http.get(Uri.parse('https://api.staging.theevents.ae/api/v1/countries/list'));
    const url = ApiEndpoints.eventsBazaarList;

    final response = await _apiResponseHandler.getRequest(
      url,
      context: context,
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final eventsBazaarModels = EventsBazaarModels.fromJson(data);
      _events = eventsBazaarModels.data?.list ?? [];
      _events =
          _events.where((event) => countries.contains(event.value)).toList();
    } else {
      throw Exception('Failed to load ');
    }
    _isLoading = false;
    notifyListeners();
  }

  //   ++++++++++++++++++++++++++++++++++++      Upper Banner in See all of events bazaar  +++++++++++++++++++++++++++++++++

  EventBazaarBanner? _eventBazaarBanner;

  EventBazaarBanner? get eventBazaarBanner => _eventBazaarBanner;

  Future<void> fetchEventBazaarData(
    BuildContext context,
  ) async {
    _isLoading = true;
    notifyListeners();

    const url = ApiEndpoints.eventsBazaarBanner;

    final response = await _apiResponseHandler.getRequest(
      url,
      context: context,
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      _eventBazaarBanner = EventBazaarBanner.fromJson(data);
    } else {
      throw Exception('Failed to load event bazaar data');
    }
    _isLoading = false;
    notifyListeners();
  }
}
