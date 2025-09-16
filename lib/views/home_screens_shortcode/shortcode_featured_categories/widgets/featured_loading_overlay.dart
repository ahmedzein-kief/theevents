import 'package:flutter/material.dart';

import '../../../../core/styles/app_colors.dart';

class FeaturedLoadingOverlay extends StatelessWidget {
  const FeaturedLoadingOverlay({
    super.key,
    required this.isLoading,
  });

  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    if (!isLoading) return const SizedBox.shrink();

    return Container(
      color: Colors.black.withAlpha((0.5 * 255).toInt()), // Semi-transparent background
      child: const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(AppColors.peachyPink),
        ),
      ),
    );
  }
}
