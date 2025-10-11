import 'dart:async';

import 'package:flutter/material.dart';

Timer? _debounce;

void debouncedSearch<T>({
  required BuildContext context,
  required String? value,
  required T Function(BuildContext) providerGetter,
  required Future<void> Function() refreshFunction, // Callback function
  Duration debounceDuration = const Duration(milliseconds: 500),
}) {
  // final provider = providerGetter(context);
  // final apiResponse = (provider as dynamic).apiResponse;

  // Cancel any existing debounce timer
  _debounce?.cancel();

  // Start a new debounce timer
  _debounce = Timer(debounceDuration, () async {
    if (value == null || value.isEmpty) {
      await refreshFunction(); // Call the provided refresh function
      return;
    }

    if (value.isNotEmpty == true) {
      await refreshFunction(); // Call the provided refresh function
    }
  });
}
