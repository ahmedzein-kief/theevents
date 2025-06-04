import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

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
                color: Colors.white),
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
            errorBuilder: (context, error, stackTrace) => const Center(
              child: Text(
                'Failed to load image',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ),
      );
}
