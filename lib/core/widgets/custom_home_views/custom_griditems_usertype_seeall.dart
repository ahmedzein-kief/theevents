import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomGriditemsUsertypeSeeall extends StatelessWidget {
  final String imageUrl;
  final String name;
  final VoidCallback onTap;
  final TextStyle textStyle;

  CustomGriditemsUsertypeSeeall({required this.imageUrl, required this.name, required this.onTap, required this.textStyle});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.max,
      children: [
        GestureDetector(
          onTap: onTap,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.network(
                imageUrl,
                fit: BoxFit.cover,
                height: 100,
                width: double.infinity,
                errorBuilder: (context, builder, _) {
                  return const SizedBox.shrink();
                },
                loadingBuilder: (context, child, loadingProcessor) {
                  if (loadingProcessor == null) return child;
                  return const Center(
                    child: CupertinoActivityIndicator(color: Colors.black, radius: 10, animating: true),
                  );
                },
              ),
              Text(
                name,
                style: textStyle,
                maxLines: 1,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
