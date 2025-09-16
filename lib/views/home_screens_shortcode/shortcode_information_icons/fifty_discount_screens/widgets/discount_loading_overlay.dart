import 'package:flutter/material.dart';

import '../../../../../core/styles/app_colors.dart';

class DiscountLoadingOverlay extends StatelessWidget {
  final bool isVisible;

  const DiscountLoadingOverlay({
    super.key,
    required this.isVisible,
  });

  @override
  Widget build(BuildContext context) {
    if (!isVisible) {
      return const SizedBox.shrink();
    }

    return Container(
      color: Colors.black.withAlpha((0.5 * 255).toInt()),
      child: const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(AppColors.peachyPink),
        ),
      ),
    );
  }
}
