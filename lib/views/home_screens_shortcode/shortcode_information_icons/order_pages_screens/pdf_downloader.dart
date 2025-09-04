import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:event_app/core/constants/app_strings.dart'; // Import AppStrings
import 'package:event_app/core/helper/extensions/app_localizations_extension.dart';
import 'package:event_app/core/styles/app_colors.dart';
import 'package:file_picker/file_picker.dart';
import 'package:file_saver/file_saver.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class PDFDownloader {
  Future<String?> saveFileInDownloads(
    BuildContext context,
    String content,
    String filename,
  ) async {
    try {
      if (Platform.isAndroid) {
        final bool isPermissionGranted =
            await requestManageExternalStoragePermission(context);
        if (!isPermissionGranted) {
          return AppStrings.permissionDenied.tr;
        }
      }

      final binaryData = Uint8List.fromList(content.codeUnits);
      String? path;

      if (Platform.isIOS) {
        final String? selectedDirectory =
            await FilePicker.platform.getDirectoryPath();
        if (selectedDirectory == null) {
          return AppStrings.userCancelled.tr;
        }

        final filePath = '$selectedDirectory/$filename.pdf';
        final file = File(filePath);
        await file.writeAsBytes(binaryData);
        path = filePath;
      } else {
        path = await FileSaver.instance.saveAs(
          name: filename,
          bytes: binaryData,
          ext: 'pdf',
          mimeType: MimeType.pdf,
        );
      }

      return AppStrings.fileSavedSuccess.tr;
    } catch (e) {
      return '${AppStrings.fileSaveError.tr} $e';
    }
  }

  Future<String?> saveFileInDownloadsUint(
    BuildContext context,
    Uint8List? binaryData,
    String filename,
  ) async {
    try {
      if (Platform.isAndroid) {
        final bool isPermissionGranted =
            await requestManageExternalStoragePermission(context);
        if (!isPermissionGranted) {
          return AppStrings.permissionDenied.tr;
        }
      }

      String? path;

      if (Platform.isIOS) {
        final String? selectedDirectory =
            await FilePicker.platform.getDirectoryPath();

        if (selectedDirectory == null) {
          return AppStrings.userCancelled.tr;
        }

        final filePath = '$selectedDirectory/$filename.pdf';
        final file = File(filePath);
        await file.writeAsBytes(binaryData!);
        path = filePath;
      } else {
        path = await FileSaver.instance.saveAs(
          name: filename,
          bytes: binaryData!,
          ext: 'pdf',
          mimeType: MimeType.pdf,
        );
      }

      return AppStrings.fileSavedSuccess.tr;
    } catch (e) {
      return '${AppStrings.fileSaveError.tr} $e';
    }
  }

  Future<bool> requestManageExternalStoragePermission(
    BuildContext context,
  ) async {
    if (await checkAndroidVersion10orGreater()) {
      return true;
    } else {
      if (await Permission.storage.isGranted) {
        return true;
      }

      final shouldRequest = await showDialog<bool>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: Text(AppStrings.storagePermissionTitle.tr),
          content: Text(AppStrings.storagePermissionMessage.tr),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              style:
                  TextButton.styleFrom(foregroundColor: AppColors.lightCoral),
              child: Text(AppStrings.cancel.tr),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              style:
                  TextButton.styleFrom(foregroundColor: AppColors.lightCoral),
              child: Text(AppStrings.allow.tr),
            ),
          ],
        ),
      );

      if (shouldRequest == true) {
        final status = await Permission.storage.status;
        if (!status.isGranted) {
          final result = await Permission.storage.request();
          return result.isGranted == true;
        }
      }
    }

    return false;
  }

  Future<bool> checkAndroidVersion10orGreater() async {
    final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    final androidInfo = await deviceInfo.androidInfo;
    return androidInfo.version.sdkInt >= 29;
  }
}
