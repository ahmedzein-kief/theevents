import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class FullScreenImageView extends StatelessWidget {
  final String? imageUrl;

  FullScreenImageView({required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: Icon(CupertinoIcons.chevron_left_circle, color: Colors.white),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Center(
        child: PhotoView(
          imageProvider: NetworkImage(imageUrl ?? ""),
          loadingBuilder: (context, event) => Center(
            child: CupertinoActivityIndicator(
              color: Colors.white,
              radius: 15,
              animating: true,
            ),
          ),
          errorBuilder: (context, error, stackTrace) => Center(
            child: Text(
              'Failed to load image',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }
}
