import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PaddedNetworkBanner extends StatelessWidget {
  const PaddedNetworkBanner({
    super.key,
    required this.imageUrl,
    this.height = 160,
    this.width,
    this.padding,
    this.borderRadius = 8,
    this.fit = BoxFit.cover,
    this.gradientColors = const [Colors.grey, Colors.black],
    this.cacheKey,
    this.alignment = Alignment.center,
  });

  final String imageUrl;
  final double height;
  final double? width;
  final EdgeInsetsGeometry? padding;
  final double borderRadius;
  final BoxFit fit;
  final List<Color> gradientColors;
  final String? cacheKey;
  final Alignment alignment;

  bool get _isNetworkUrl => imageUrl.startsWith('http://') || imageUrl.startsWith('https://');

  bool get _isAssetPath => imageUrl.startsWith('assets/');

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.sizeOf(context).width;

    final double resolvedWidth = width ?? screenWidth;

    Widget buildPlaceholder() => Container(
          height: height,
          width: resolvedWidth,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: gradientColors,
            ),
          ),
          child: const CupertinoActivityIndicator(
            color: Colors.black,
            radius: 10,
            animating: true,
          ),
        );

    Widget child;
    if (_isNetworkUrl) {
      child = CachedNetworkImage(
        imageUrl: imageUrl,
        cacheKey: cacheKey,
        fit: fit,
        alignment: alignment,
        height: height,
        width: resolvedWidth,
        errorWidget: (context, object, error) => buildPlaceholder(),
        placeholder: (BuildContext context, String url) => buildPlaceholder(),
      );
    } else if (_isAssetPath) {
      child = Image.asset(
        imageUrl,
        fit: fit,
        alignment: alignment,
        height: height,
        width: resolvedWidth,
      );
    } else {
      // Fallback to CachedNetworkImage; if it fails, show placeholder
      child = CachedNetworkImage(
        imageUrl: imageUrl,
        cacheKey: cacheKey,
        fit: fit,
        alignment: alignment,
        height: height,
        width: resolvedWidth,
        errorWidget: (context, object, error) => buildPlaceholder(),
        placeholder: (BuildContext context, String url) => buildPlaceholder(),
      );
    }

    return Padding(
      padding: padding ?? EdgeInsets.zero,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: child,
      ),
    );
  }
}
