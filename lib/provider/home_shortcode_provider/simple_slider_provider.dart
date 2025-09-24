import 'package:event_app/core/network/api_endpoints/api_end_point.dart';
import 'package:event_app/provider/api_response_handler.dart';
import 'package:flutter/material.dart';

import '../../models/dashboard/home_banner_model.dart';

class TopSliderProvider with ChangeNotifier {
  final ApiResponseHandler _apiResponseHandler = ApiResponseHandler();

  HomeBannerModels? _homeBanner;
  bool _isLoading = false;
  String? _errorMessage;

  HomeBannerModels? get homeBanner => _homeBanner;

  bool get isLoading => _isLoading;

  String? get errorMessage => _errorMessage;

  // [log] TopSliderProvider fetchSliders home-slider
  // [log] BottomSliderProvider fetchSliders home-brand-slider

  Future<void> fetchSliders(BuildContext context, {required data}) async {
    _isLoading = true;
    notifyListeners();

    // const baseUrl = 'https://newapistaging.theevents.ae/api/v1/simple-slider'; // Replace with your API endpoint
    const baseUrl = ApiEndpoints.homeSlider; // Replace with your API endpoint
    final url = '$baseUrl?key=${data['attributes']['key']}'; // Add query parameters here

    try {
      final response = await _apiResponseHandler.getRequest(
        url,
        context: context,
      );

      if (response.statusCode == 200) {
        final data = response.data;
        _homeBanner = HomeBannerModels.fromJson(data);
        _errorMessage = null; // Clear any previous error message
      } else {
        _errorMessage = 'CHECK YOUR INTERNET CONNECTION';
      }
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}

class BottomSliderProvider with ChangeNotifier {
  final ApiResponseHandler _apiResponseHandler = ApiResponseHandler();

  HomeBannerModels? _homeBanner;
  bool _isLoading = false;
  String? _errorMessage;

  HomeBannerModels? get homeBanner => _homeBanner;

  bool get isLoading => _isLoading;

  String? get errorMessage => _errorMessage;

  Future<void> fetchSliders(BuildContext context, {required data}) async {
    _isLoading = true;
    notifyListeners();

    // const baseUrl = 'https://newapistaging.theevents.ae/api/v1/simple-slider'; // Replace with your API endpoint
    const baseUrl = ApiEndpoints.homeSlider; // Replace with your API endpoint
    final url = '$baseUrl?key=${data['attributes']['key']}'; // Add query parameters here

    try {
      final response = await _apiResponseHandler.getRequest(
        url,
        context: context,
      );

      if (response.statusCode == 200) {
        final data = response.data;
        _homeBanner = HomeBannerModels.fromJson(data);
        _errorMessage = null; // Clear any previous error message
      } else {
        _errorMessage = 'CHECK YOUR INTERNET CONNECTION';
      }
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
