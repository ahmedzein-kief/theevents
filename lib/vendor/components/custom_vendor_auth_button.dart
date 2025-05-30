import 'package:event_app/core/styles/app_colors.dart';
import 'package:flutter/material.dart';

class CustomVendorAuthButton extends StatelessWidget {
  final String title;
  final bool isLoading;
  final Function() onPressed;

  CustomVendorAuthButton({required this.title, this.isLoading = false, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: MediaQuery.sizeOf(context).width * 0.02,
        right: MediaQuery.sizeOf(context).width * 0.02,
        top: MediaQuery.sizeOf(context).height * 0.02,
        bottom: MediaQuery.sizeOf(context).height * 0.010,
      ),
      child: GestureDetector(
          onTap: isLoading ? null : onPressed,
          child: Container(
              width: double.infinity,
              height: 45,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
                color: AppColors.darkGrey,
              ),
              child: isLoading
                  ? SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Theme.of(context).colorScheme.onPrimary,
                        ),
                        strokeWidth: 2.0,
                      ),
                    )
                  : Text(
                      title,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ))),
    );
  }
}
