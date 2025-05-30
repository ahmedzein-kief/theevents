import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:event_app/utils/mixins_and_constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ChooseFileCard extends StatefulWidget {
  final File? file;
  final String? imageLink;
  final VoidCallback? onChoose;
  final VoidCallback? onClose;
  double? width;
  double? height;

   ChooseFileCard({
    super.key,
    this.file,
    this.onChoose,
    required this.onClose,
    this.imageLink,
    this.width,
    this.height,
  });

  @override
  State<ChooseFileCard> createState() => _ChooseFileCardState();
}

class _ChooseFileCardState extends State<ChooseFileCard> {
  static  double width =  130;
  static  double height = 123;
  static const double padding = 0;
  static const double closeIconSize = 15;

  @override
  void initState() {
    if(widget.width != null){
      width = widget.width!;
    }
    if(widget.height != null){
      height = widget.height!;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 0.5,
      shadowColor: Colors.grey,
      borderRadius: BorderRadius.circular(kFileCardRadius),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(kFileCardRadius),
        ),
        child: Stack(
          children: [
            GestureDetector(
              onTap: widget.onChoose,
              child: ClipRRect(borderRadius: BorderRadius.circular(kFileCardRadius), child: _buildImageContent()),
            ),
            if (widget.file != null || widget.imageLink != null) _buildCloseButton(),
          ],
        ),
      ),
    );
  }

  /// Builds the main image or placeholder content
  Widget _buildImageContent() {
    return ConstrainedBox(
      constraints:  BoxConstraints(
        maxWidth: width,
        maxHeight: height,
        minWidth: width,
        minHeight: height,
      ),
      child: Padding(
        padding: const EdgeInsets.all(padding),
        child: widget.file != null
            ? _buildFileImage()
            : widget.imageLink != null && widget.imageLink!.isNotEmpty
                ? _buildNetworkImage()
                : _buildPlaceholder(),
      ),
    );
  }

  /// Builds an image from a File
  Widget _buildFileImage() {
    try {
      return Image.file(
        File(widget.file!.path),
        fit: BoxFit.fill,
        errorBuilder: (context, error, stackTrace) => _buildPlaceholder(),
      );
    } catch (e) {
      return _buildPlaceholder();
    }
  }

  /// Builds an image from a Network URL
  Widget _buildNetworkImage() {
    return CachedNetworkImage(
      imageUrl: widget.imageLink ?? '',
      fit: BoxFit.fill,
      errorWidget: (context, error, stackTrace) => _buildPlaceholder(),
    );
  }

  /// Builds the default placeholder (when no image or file is available)
  Widget _buildPlaceholder() {
    return Padding(
      padding: EdgeInsets.all(kLargePadding),
      child: SvgPicture.asset(
        'assets/vendor_assets/settings/choose_Image.svg',
      ),
    );
  }

  /// Builds the close button to remove the image
  Widget _buildCloseButton() {
    return Positioned(
      top: 2,
      right: 2,
      child: GestureDetector(
        onTap: widget.onClose,
        child: SvgPicture.asset(
          'assets/vendor_assets/settings/remove_highlight_outlined.svg',
          height: closeIconSize,
          width: closeIconSize,
        ),
      ),
    );
  }
}
