import 'dart:io';

import 'package:event_app/core/styles/app_colors.dart';
import 'package:event_app/models/vendor_models/products/holder_models/upload_images_model.dart';
import 'package:event_app/vendor/components/services/media_services.dart';
import 'package:event_app/vendor/components/utils/utils.dart';
import 'package:event_app/vendor/components/vendor_text_style.dart';
import 'package:event_app/vendor/vendor_home/vendor_products/vendor_create_product/full_screen_image_view.dart';
import 'package:event_app/vendor/view_models/vendor_products/upload_images/vendor_upload_images_view_model.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as path;
import 'package:provider/provider.dart';

class UploadImagesScreen extends StatefulWidget {
  const UploadImagesScreen({super.key, this.initialImages});
  final List<UploadImagesModel>? initialImages;

  @override
  _UploadImagesScreenState createState() => _UploadImagesScreenState();
}

class _UploadImagesScreenState extends State<UploadImagesScreen> {
  final List<UploadImagesModel> _selectedImages = [];

  bool _isProcessing = false;

  void setProcessing(bool value) {
    setState(() {
      _isProcessing = value;
    });
  }

  Future uploadImages() async {
    try {
      setProcessing(true);
      final provider =
          Provider.of<VendorUploadImagesViewModel>(context, listen: false);
      final results = await provider.uploadAllImages(
          context, _selectedImages.where((file) => file.hasFile).toList());
      if (results.isNotEmpty) {
        print('Result 1 ==> ${results.length} ');
        for (final element in results) {
          if (element != null) {
            final matchedImage = _selectedImages.firstWhere(
              (img) => img.file.path == element.file.path,
              orElse: () => UploadImagesModel(serverID: -1),
            );

            if (matchedImage.serverID != -1) {
              matchedImage.serverFullUrl = element.serverFullUrl;
              matchedImage.serverUrl = element.serverUrl;
              matchedImage.serverID = element.serverID;
              matchedImage.serverName = element.serverName;
              matchedImage.serverBaseName = element.serverBaseName;
            }
          }
        }
      } else {
        print('Result 2 ==> $results');
      }
      setProcessing(false);
    } catch (e) {
      setProcessing(false);
      print('Error: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    if (widget.initialImages != null) {
      _selectedImages.addAll(widget.initialImages!);
    }
  }

  Future<void> _pickImage() async {
    final List<File?>? myFiles =
        await MediaServices().getMultipleFilesFromPicker(
      allowedExtensions: MediaServices().allowedImageExtension,
    );

    final List<UploadImagesModel> uploadImagesList = (myFiles ?? [])
        .where((file) => file != null) // Remove null values
        .map(
          (file) => UploadImagesModel(
            file: file!,
            fileName: path.basename(file.path), // Extract filename from path
            fileExtension:
                path.extension(file.path).toUpperCase().replaceAll('.', ''),
          ),
        )
        .toList();

    print(uploadImagesList);

    if (myFiles != null) {
      setState(() {
        _selectedImages.addAll(uploadImagesList);
      });
      uploadImages();
    }
  }

  void _showFullScreenImage(File imageFile) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => FullScreenImageView(imageFile: imageFile),
      ),
    );
  }

  IconData _getFileIcon(String extension) {
    switch (extension) {
      case 'JPG':
      case 'JPEG':
      case 'PNG':
        return Icons.image;
      default:
        return Icons.insert_drive_file;
    }
  }

  void _returnBack() {
    Navigator.pop(context, _selectedImages);
  }

  @override
  Widget build(BuildContext context) => PopScope(
        canPop: false,
        onPopInvokedWithResult: (bool didPop, Object? result) {
          if (!didPop) {
            _returnBack();
          }
        },
        child: Scaffold(
          appBar: AppBar(
            title: Text('Upload Images', style: vendorName(context)),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: _returnBack,
            ),
          ),
          body: Utils.modelProgressHud(
            processing: _isProcessing,
            child: _selectedImages.isEmpty
                ? const Center(child: Text('No images selected.'))
                : ListView.builder(
                    padding:
                        const EdgeInsets.only(left: 10, right: 10, bottom: 80),
                    itemCount: _selectedImages.length,
                    itemBuilder: (context, index) {
                      String fileName;
                      String fileExtension;
                      print('has file ${_selectedImages[index].hasFile}');

                      if (!_selectedImages[index].hasFile) {
                        final Uri uri =
                            Uri.parse(_selectedImages[index].serverFullUrl);

                        // Ensure there are path segments before accessing the last one
                        fileName = uri.pathSegments.isNotEmpty
                            ? uri.pathSegments.last
                            : '';

                        // Ensure fileName contains '.' before attempting to split
                        fileExtension = fileName.contains('.')
                            ? fileName.split('.').last
                            : 'unknown';
                      } else {
                        fileName = _selectedImages[index].fileName;
                        fileExtension = _selectedImages[index].fileExtension;
                      }

                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        child: ListTile(
                          // leading: Icon(fileIcon, size: 40, color: AppColors.lightCoral),
                          leading: !_selectedImages[index].hasFile
                              ? Image.network(
                                  _selectedImages[index].serverFullUrl,
                                  width: 50,
                                  height: 50,
                                  fit: BoxFit.cover,
                                  errorBuilder: (errorContext, object, error) =>
                                      Image.asset(
                                    'assets/placeholder-100.png',
                                  ),
                                )
                              : Image.file(
                                  _selectedImages[index].file,
                                  width: 50,
                                  height: 50,
                                  fit: BoxFit.cover,
                                  errorBuilder: (errorContext, object, error) =>
                                      Image.asset(
                                    'assets/placeholder-100.png',
                                  ),
                                ),
                          title:
                              Text(fileName, overflow: TextOverflow.ellipsis),
                          subtitle: Text(fileExtension),
                          onTap: () {
                            // _showFullScreenImage(_selectedImages[index].file)
                          },
                          trailing: IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              setState(() {
                                _selectedImages.removeAt(index);
                              });
                            },
                          ),
                        ),
                      );
                    },
                  ),
          ),
          floatingActionButton: Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: FloatingActionButton(
              backgroundColor: AppColors.lightCoral,
              onPressed: _pickImage,
              child: const Icon(Icons.add_a_photo, color: Colors.white),
            ),
          ),
        ),
      );
}
