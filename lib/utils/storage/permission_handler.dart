import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:event_app/core/styles/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionHandler {
  final BuildContext context;
  final Function onPermissionGranted;

  PermissionHandler({required this.context, required this.onPermissionGranted});

  Future<void> requestPermissions() async {
    if (Platform.isAndroid) {
      if ((await DeviceInfoPlugin().androidInfo).version.sdkInt >= 30) {
        Map<Permission, PermissionStatus> status = await [Permission.camera, Permission.manageExternalStorage].request();

        if (status[Permission.camera] == PermissionStatus.granted && status[Permission.manageExternalStorage] == PermissionStatus.granted) {
          onPermissionGranted();
        } else if (status[Permission.camera] == PermissionStatus.permanentlyDenied || status[Permission.manageExternalStorage] == PermissionStatus.permanentlyDenied) {
          _showSettingsDialog();
        } else {
          _showPermissionDialog();
        }
      } else {
        Map<Permission, PermissionStatus> status = await [Permission.camera, Permission.storage].request();

        if (status[Permission.camera] == PermissionStatus.granted && status[Permission.storage] == PermissionStatus.granted) {
          onPermissionGranted();
        } else if (status[Permission.camera] == PermissionStatus.permanentlyDenied || status[Permission.storage] == PermissionStatus.permanentlyDenied) {
         _showSettingsDialog();
        } else {
          _showPermissionDialog();
        }
      }
    } else if (Platform.isIOS) {
      Map<Permission, PermissionStatus> status = await [
        Permission.camera,
        Permission.photos, // Use Permission.photos for photo library access
      ].request();

      if (status[Permission.camera] == PermissionStatus.granted && status[Permission.photos] == PermissionStatus.granted) {
        onPermissionGranted();
      } else if (status[Permission.camera] == PermissionStatus.permanentlyDenied || status[Permission.photos] == PermissionStatus.permanentlyDenied) {
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
        title: Text("Permission Required"),
        content: Text("Please enable the required permissions in app settings."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancel"),
            style: TextButton.styleFrom(
              foregroundColor: AppColors.peachyPink, // Set the text color
              textStyle: TextStyle(
                fontSize: 16.0, // Optional: Adjust font size
                fontWeight: FontWeight.bold, // Optional: Adjust font weight
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              openAppSettings(); // Opens the app settings page
              Navigator.pop(context);
            },
            child: Text("Open Settings"),
            style: TextButton.styleFrom(
              foregroundColor: AppColors.peachyPink, // Set the text color
              textStyle: TextStyle(
                fontSize: 16.0, // Optional: Adjust font size
                fontWeight: FontWeight.bold, // Optional: Adjust font weight
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showPermissionDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Permission Required',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold), // Use your custom style method
        ),
        actions: [
          GestureDetector(
            onTap: () {
              Navigator.pop(context); // Close dialog
            },
            child: Text(
              "OK",
              style: TextStyle(color: Colors.blue),
            ), // Use your custom style method
          ),
        ],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.zero, // Set corners to square
        ),
      ),
    );
  }
}
