import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../styles/app_colors.dart';

class ImagePickerHelper {
  final ImagePicker _picker = ImagePicker();

  Future<File?> pickImage(BuildContext context) async => showModalBottomSheet<File?>(
        context: context,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(0),
          ),
        ),
        builder: (BuildContext context) => Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Cancel button at the top-right corner
            Align(
              alignment: Alignment.topRight,
              child: IconButton(
                icon: const Icon(Icons.close, color: Colors.black),
                onPressed: () {
                  Navigator.of(context).pop(); // Close the bottom sheet
                },
              ),
            ),
            // Row for Gallery and Camera options
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Gallery Option
                Column(
                  children: [
                    IconButton(
                      icon: const Icon(
                        CupertinoIcons.photo,
                        size: 20,
                        color: AppColors.peachyPink,
                      ),
                      onPressed: () async {
                        final XFile? image = await _picker.pickImage(
                          source: ImageSource.gallery,
                          imageQuality: 50,
                        );
                        Navigator.of(context).pop(image != null ? File(image.path) : null);
                      },
                    ),
                    const Text('Gallery'),
                  ],
                ),

                Container(
                  color: Colors.grey,
                  height: 50,
                  width: 1,
                ),
                // Camera Option
                Column(
                  children: [
                    IconButton(
                      icon: const Icon(
                        CupertinoIcons.camera,
                        size: 20,
                        color: AppColors.peachyPink,
                      ),
                      onPressed: () async {
                        final XFile? image = await _picker.pickImage(
                          source: ImageSource.camera,
                          imageQuality: 50,
                        );
                        Navigator.of(context).pop(image != null ? File(image.path) : null);
                      },
                    ),
                    const Text('Camera'),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),
            // Optional padding at the bottom of the sheet
          ],
        ),
      );

  /// -----------------------------------  SAVE IMAGE ----------------------------------------------------
  Future<void> saveImageToPreferences(String path) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('profile_image', path);
  }

  Future<String?> getSavedImage() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('profile_image');
  }
}
