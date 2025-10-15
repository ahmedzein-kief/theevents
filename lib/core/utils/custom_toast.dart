import 'package:flutter/material.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class CustomSnackbar {
  /// Shows a success snackbar with proper safety checks
  static void showSuccess(
    BuildContext context,
    String message, {
    Color backgroundColor = Colors.white,
  }) {
    _showSnackbarSafely(
      context,
      () => _buildSnackbar(context, message, backgroundColor),
      const Duration(milliseconds: 300),
      null,
    );
  }

  /// Shows an error snackbar with proper safety checks
  static void showError(
    BuildContext context,
    String message, {
    Color backgroundColor = Colors.red,
    Duration? displayDuration,
  }) {
    _showSnackbarSafely(
      context,
      () => _buildErrorSnackBar(context, message, backgroundColor),
      const Duration(milliseconds: 300),
      displayDuration ?? const Duration(seconds: 2),
    );
  }

  /// Core method that safely shows snackbars with all necessary checks
  static void _showSnackbarSafely(
    BuildContext context,
    Widget Function() snackbarBuilder,
    Duration reverseAnimationDuration,
    Duration? displayDuration,
  ) {
    // First check if context is still mounted and valid
    if (!_isContextValid(context)) {
      return;
    }

    try {
      // Try to get the overlay state with additional safety checks
      final OverlayState? overlayState = _getOverlayStateSafely(context);

      if (overlayState == null) {
        return;
      }

      // Build the snackbar widget
      final Widget snackbarWidget = snackbarBuilder();

      // Show the snackbar
      showTopSnackBar(
        overlayState,
        snackbarWidget,
        reverseAnimationDuration: reverseAnimationDuration,
        displayDuration: displayDuration ?? const Duration(seconds: 2),
      );
    } catch (e) {
      // Log the error but don't crash the app
    }
  }

  /// Safely attempts to get the OverlayState with multiple fallback strategies
  static OverlayState? _getOverlayStateSafely(BuildContext context) {
    try {
      // First check if context is still valid
      if (!_isContextValid(context)) return null;

      // Try to get overlay state using maybeOf (safer)
      final OverlayState? overlayState = Overlay.maybeOf(context);
      if (overlayState != null) {
        return overlayState;
      }

      // If maybeOf fails, try with rootOverlay
      return Overlay.maybeOf(context, rootOverlay: true);
    } catch (e) {
      return null;
    }
  }

  /// Comprehensive context validation
  static bool _isContextValid(BuildContext context) {
    try {
      // Check if the context is mounted (available in newer Flutter versions)
      if (context is Element) {
        final element = context;
        // Check if element is still active in the tree
        if (!element.mounted) return false;
      }

      // Try to access the widget to see if context is still valid
      // This will throw if context is deactivated
      context.widget;

      return true;
    } catch (e) {
      return false;
    }
  }

  /// Success snackbar widget builder
  static Widget _buildSnackbar(
    BuildContext context,
    String message,
    Color backgroundColor,
  ) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(5),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 6.0,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              message,
              style: const TextStyle(
                decoration: TextDecoration.none,
                color: Colors.black87,
                fontSize: 16.0,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Error snackbar widget builder
  static Widget _buildErrorSnackBar(
    BuildContext context,
    String message,
    Color backgroundColor,
  ) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(5),
        boxShadow: const [
          BoxShadow(
            color: Colors.white,
            blurRadius: 6.0,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              message,
              style: const TextStyle(
                decoration: TextDecoration.none,
                color: Colors.white,
                fontSize: 14.0,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Alternative method for showing snackbars when you have stored OverlayState
  static void showWithOverlay(
    OverlayState overlayState,
    Widget snackbarWidget, {
    Duration reverseAnimationDuration = const Duration(milliseconds: 300),
    Duration? displayDuration,
  }) {
    try {
      showTopSnackBar(
        overlayState,
        snackbarWidget,
        reverseAnimationDuration: reverseAnimationDuration,
        displayDuration: displayDuration ?? const Duration(seconds: 2),
      );
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  /// Utility method to pre-validate context before use
  static bool canShowSnackbar(BuildContext context) {
    return _isContextValid(context) && _getOverlayStateSafely(context) != null;
  }
}
