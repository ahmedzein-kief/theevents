import 'dart:io';

import 'package:flutter/material.dart';

class FullScreenImageView extends StatelessWidget {
  final File imageFile;

  const FullScreenImageView({required this.imageFile});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Center(child: Image.file(imageFile, fit: BoxFit.contain)),
          Positioned(
            top: 40,
            right: 20,
            child: IconButton(
              icon: Icon(Icons.close, color: Colors.white, size: 30),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
        ],
      ),
    );
  }
}
