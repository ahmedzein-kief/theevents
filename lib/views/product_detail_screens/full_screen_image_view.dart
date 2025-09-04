import 'package:event_app/core/helper/extensions/app_localizations_extension.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

import '../../core/constants/app_strings.dart';

class FullScreenImageView extends StatelessWidget {
  const FullScreenImageView({super.key, required this.imageUrl});

  final String? imageUrl;

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
          leading: IconButton(
            icon: const Icon(CupertinoIcons.chevron_left_circle,
                color: Colors.white,),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ),
        body: Center(
          child: PhotoView(
            imageProvider: NetworkImage(imageUrl ?? ''),
            loadingBuilder: (context, event) => const Center(
              child: CupertinoActivityIndicator(
                color: Colors.white,
                radius: 15,
                animating: true,
              ),
            ),
            errorBuilder: (context, error, stackTrace) => Center(
              child: Text(
                AppStrings.failedToLoadImage.tr,
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ),
        ),
      );
}
