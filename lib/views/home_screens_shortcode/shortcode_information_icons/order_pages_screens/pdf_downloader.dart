import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:event_app/core/styles/app_colors.dart';
import 'package:file_picker/file_picker.dart';
import 'package:file_saver/file_saver.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class PDFDownloader {
  // Function to save a file in the Downloads folder
  Future<String?> saveFileInDownloads(
    BuildContext context,
    String content,
    String filename,
  ) async {
    try {
      if (Platform.isAndroid) {
        // Request storage permission on Android
        final bool isPermissionGranted =
            await requestManageExternalStoragePermission(context);
        if (!isPermissionGranted) {
          return 'Permission Denied';
        }
      }

      // Convert string to binary data
      final binaryData = Uint8List.fromList(content.codeUnits);

      String? path;

      if (Platform.isIOS) {
        // Ask user where to save the file
        final String? selectedDirectory =
            await FilePicker.platform.getDirectoryPath();

        if (selectedDirectory == null) {
          return 'User canceled file selection';
        }

        final filePath = '$selectedDirectory/$filename.pdf';
        final file = File(filePath);
        await file.writeAsBytes(binaryData);

        path = filePath;
      } else {
        // Android: Save to Downloads using FileSaver
        path = await FileSaver.instance.saveAs(
          name: filename, // File name
          bytes: binaryData, // File content as Uint8List
          ext: 'pdf', // File extension
          mimeType: MimeType.pdf, // MIME type
        );
      }

      return 'File saved at local storage';
    } catch (e) {
      return 'Error saving file: $e';
    }
  }

  Future<String?> saveFileInDownloadsUint(
    BuildContext context,
    Uint8List? binaryData,
    String filename,
  ) async {
    try {
      if (Platform.isAndroid) {
        // Request storage permission on Android
        final bool isPermissionGranted =
            await requestManageExternalStoragePermission(context);
        if (!isPermissionGranted) {
          return 'Permission Denied';
        }
      }

      String? path;

      if (Platform.isIOS) {
        // Ask user where to save the file
        final String? selectedDirectory =
            await FilePicker.platform.getDirectoryPath();

        if (selectedDirectory == null) {
          return 'User canceled file selection';
        }

        final filePath = '$selectedDirectory/$filename.pdf';
        final file = File(filePath);
        await file.writeAsBytes(binaryData!);

        path = filePath;
      } else {
        // Android: Save to Downloads using FileSaver
        path = await FileSaver.instance.saveAs(
          name: filename,
          bytes: binaryData!,
          ext: 'pdf',
          mimeType: MimeType.pdf,
        );
      }

      return 'File saved at local storage';
    } catch (e) {
      return 'Error saving file: $e';
    }
  }

  Future<bool> requestManageExternalStoragePermission(
    BuildContext context,
  ) async {
    // Check if permission is already granted
    if (await checkAndroidVersion10orGreater()) {
      return true;
    } else {
      if (await Permission.storage.isGranted) {
        return true;
      }

      // Show a dialog explaining why the permission is needed
      final shouldRequest = await showDialog<bool>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const Text('Storage Permission Required'),
          content: const Text(
            'This app requires access to your device\'s external storage to store the invoice. Please grant the permission to proceed.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              style: TextButton.styleFrom(
                foregroundColor:
                    AppColors.lightCoral, // Set text color for "No"
              ), // User declines
              child: const Text(
                'Cancel',
              ),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: TextButton.styleFrom(
                foregroundColor:
                    AppColors.lightCoral, // Set text color for "No"
              ), // User agrees
              child: const Text('Allow'),
            ),
          ],
        ),
      );

      if (shouldRequest == true) {
        // Request the permission
        final status = await Permission.storage.status;

        if (!status.isGranted) {
          final result = await Permission.storage.request();
          return result.isGranted == true;
        }
      }
    }

    return false; // Permission not granted
  }

  Future<bool> checkAndroidVersion10orGreater() async {
    final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    final androidInfo = await deviceInfo.androidInfo;

    if (androidInfo.version.sdkInt >= 29) {
      // API level 29 corresponds to Android 10
      return true;
    } else {
      return false;
    }
  }
}
