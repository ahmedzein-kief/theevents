import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:event_app/core/styles/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionHandler {
  PermissionHandler({required this.context, required this.onPermissionGranted});
  final BuildContext context;
  final Function onPermissionGranted;

  Future<void> requestPermissions() async {
    if (Platform.isAndroid) {
      if ((await DeviceInfoPlugin().androidInfo).version.sdkInt >= 30) {
        final Map<Permission, PermissionStatus> status = await [
          Permission.camera,
          Permission.manageExternalStorage,
        ].request();

        if (status[Permission.camera] == PermissionStatus.granted &&
            status[Permission.manageExternalStorage] ==
                PermissionStatus.granted) {
          onPermissionGranted();
        } else if (status[Permission.camera] ==
                PermissionStatus.permanentlyDenied ||
            status[Permission.manageExternalStorage] ==
                PermissionStatus.permanentlyDenied) {
          _showSettingsDialog();
        } else {
          _showPermissionDialog();
        }
      } else {
        final Map<Permission, PermissionStatus> status =
            await [Permission.camera, Permission.storage].request();

        if (status[Permission.camera] == PermissionStatus.granted &&
            status[Permission.storage] == PermissionStatus.granted) {
          onPermissionGranted();
        } else if (status[Permission.camera] ==
                PermissionStatus.permanentlyDenied ||
            status[Permission.storage] == PermissionStatus.permanentlyDenied) {
          _showSettingsDialog();
        } else {
          _showPermissionDialog();
        }
      }
    } else if (Platform.isIOS) {
      final Map<Permission, PermissionStatus> status = await [
        Permission.camera,
        Permission.photos, // Use Permission.photos for photo library access
      ].request();

      if (status[Permission.camera] == PermissionStatus.granted &&
          status[Permission.photos] == PermissionStatus.granted) {
        onPermissionGranted();
      } else if (status[Permission.camera] ==
              PermissionStatus.permanentlyDenied ||
          status[Permission.photos] == PermissionStatus.permanentlyDenied) {
        _showSettingsDialog();
      } else {
        _showPermissionDialog();
      }
    }
  }

  void _showSettingsDialog() {
    // Show a dialog prompting the user to open app settings
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Permission Required'),
        content: const Text(
            'Please enable the required permissions in app settings.',),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            style: TextButton.styleFrom(
              foregroundColor: AppColors.peachyPink, // Set the text color
              textStyle: const TextStyle(
                fontSize: 16.0, // Optional: Adjust font size
                fontWeight: FontWeight.bold, // Optional: Adjust font weight
              ),
            ),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              openAppSettings(); // Opens the app settings page
              Navigator.pop(context);
            },
            style: TextButton.styleFrom(
              foregroundColor: AppColors.peachyPink, // Set the text color
              textStyle: const TextStyle(
                fontSize: 16.0, // Optional: Adjust font size
                fontWeight: FontWeight.bold, // Optional: Adjust font weight
              ),
            ),
            child: const Text('Open Settings'),
          ),
        ],
      ),
    );
  }

  void _showPermissionDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          'Permission Required',
          style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,), // Use your custom style method
        ),
        actions: [
          GestureDetector(
            onTap: () {
              Navigator.pop(context); // Close dialog
            },
            child: const Text(
              'OK',
              style: TextStyle(color: Colors.blue),
            ), // Use your custom style method
          ),
        ],
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.zero, // Set corners to square
        ),
      ),
    );
  }
}
