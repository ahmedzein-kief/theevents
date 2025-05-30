import 'package:flutter/material.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class CustomSnackbar {
  static void showSuccess(BuildContext context, String message, {Color backgroundColor = Colors.white}) {
    OverlayState overlayState = Overlay.of(context);
    showTopSnackBar(
      overlayState,
      _buildSnackbar(context, message, backgroundColor),
      reverseAnimationDuration: const Duration(milliseconds: 300),
    );
  }

  static Widget _buildSnackbar(BuildContext context, String message, Color backgroundColor) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: Colors.white,
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
                decoration: TextDecoration.none, // Remove underline
                color: Colors.black87,
                fontSize: 16.0,
              ),
            ),
          ),
        ],
      ),
    );
  }

  //   custom snack bar for the error messages
  static void showError(BuildContext context, String message, {Color backgroundColor = Colors.red}) {
    OverlayState overlayState = Overlay.of(context);
    showTopSnackBar(
      overlayState,
      _buildErrorSnackBar(context, message, backgroundColor),
      reverseAnimationDuration: const Duration(milliseconds: 300),
      // CustomSnackBar.error(
      //     message: message,
      //     textStyle: const TextStyle(color: Colors.white),
      //   backgroundColor: Colors.red,
      //   textAlign: TextAlign.center,
      //   icon: const Icon(Icons.error_outline,
      //     color: Colors.red, // Ensure the icon color is set
      //   ),
      //   borderRadius: BorderRadius.circular(2),
      //
      // ),
    );
  }

  static Widget _buildErrorSnackBar(BuildContext context, String message, Color backgroundColor) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: Colors.red,
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
              style:  TextStyle(
                decoration: TextDecoration.none, // Remove underline
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
}
