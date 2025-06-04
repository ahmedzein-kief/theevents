import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../styles/app_colors.dart';

class CustomToast {
  CustomToast(BuildContext context) {
    fToast = FToast();
    fToast.init(context);
  }
  FToast fToast = FToast();

  void showToast({
    required String textHint,
    required VoidCallback onDismiss,
    required BuildContext context,
  }) {
    final Widget toast = Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(0),
        color: AppColors.peachyPink,
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    textAlign: TextAlign.start,
                    textHint,
                    style: GoogleFonts.inter(
                      fontSize: 15,
                      fontWeight: FontWeight.w300,
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                  ),
                ),
              ),
              // SizedBox(width: 35),
              GestureDetector(
                onTap: onDismiss,
                child: Icon(
                  size: 20,
                  CupertinoIcons.clear_thick,
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
              ),
            ],
          ),
        ],
      ),
    );

    fToast.showToast(
      child: toast,
      gravity: ToastGravity.TOP,
      toastDuration: const Duration(seconds: 5),
    );
  }

  void removeToast() {
    fToast.removeCustomToast();
  }
}
