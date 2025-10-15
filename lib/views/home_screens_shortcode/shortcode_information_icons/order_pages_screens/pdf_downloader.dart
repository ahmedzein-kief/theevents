import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:event_app/core/constants/app_strings.dart';
import 'package:event_app/core/helper/extensions/app_localizations_extension.dart';
import 'package:event_app/core/styles/app_colors.dart';
import 'package:file_picker/file_picker.dart';
import 'package:file_saver/file_saver.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../../core/utils/app_utils.dart';

class PDFDownloader {
  Future<String?> saveFileInDownloads(
    BuildContext context,
    String content,
    String filename,
  ) async {
    try {
      if (Platform.isAndroid) {
        final bool isPermissionGranted = await requestManageExternalStoragePermission(context);
        if (!isPermissionGranted) {
          return AppStrings.permissionDenied.tr;
        }
      }

      final binaryData = Uint8List.fromList(content.codeUnits);

      // Use FileSaver for both platforms for consistent behavior
      await FileSaver.instance.saveAs(
        name: filename,
        bytes: binaryData,
        fileExtension: 'pdf',
        mimeType: MimeType.pdf,
      );

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
      if (binaryData == null) {
        AppUtils.showToast(AppStrings.fileSaveError.tr);
        return AppStrings.fileSaveError.tr;
      }

      if (Platform.isAndroid) {
        final bool isPermissionGranted = await requestManageExternalStoragePermission(context);
        if (!isPermissionGranted) {
          AppUtils.showToast(AppStrings.permissionDenied.tr);
          return AppStrings.permissionDenied.tr;
        }
      }

      final path = await FileSaver.instance.saveAs(
        name: filename,
        bytes: binaryData,
        fileExtension: 'pdf',
        mimeType: MimeType.pdf,
      );

      if (path != null) {
        AppUtils.showToast(AppStrings.fileSavedSuccess.tr, isSuccess: true);
        return AppStrings.fileSavedSuccess.tr;
      } else {
        AppUtils.showToast(AppStrings.fileSaveError.tr);
        return AppStrings.fileSaveError.tr;
      }
    } catch (e) {
      final errorMessage = '${AppStrings.fileSaveError.tr} $e';
      AppUtils.showToast(errorMessage);
      return errorMessage;
    }
  }

  // Alternative method that gives user choice on iOS
  Future<String?> saveFileInDownloadsUintWithChoice(
    BuildContext context,
    Uint8List? binaryData,
    String filename,
  ) async {
    try {
      if (binaryData == null) {
        return AppStrings.fileSaveError.tr;
      }

      if (Platform.isAndroid) {
        final bool isPermissionGranted = await requestManageExternalStoragePermission(context);
        if (!isPermissionGranted) {
          return AppStrings.permissionDenied.tr;
        }

        // Use FileSaver for Android
        final path = await FileSaver.instance.saveAs(
          name: filename,
          bytes: binaryData,
          fileExtension: 'pdf',
          mimeType: MimeType.pdf,
        );

        return path != null ? AppStrings.fileSavedSuccess.tr : AppStrings.fileSaveError.tr;
      } else {
        // iOS: Show dialog to let user choose save method
        final choice = await showDialog<String>(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            title: const Text('Save PDF'),
            content: const Text('How would you like to save the PDF?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop('files'),
                child: const Text('Choose Location'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop('download'),
                child: const Text('Quick Save'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop('cancel'),
                style: TextButton.styleFrom(foregroundColor: AppColors.lightCoral),
                child: Text(AppStrings.cancel.tr),
              ),
            ],
          ),
        );

        if (choice == 'cancel' || choice == null) {
          return AppStrings.userCancelled.tr;
        }

        if (choice == 'files') {
          // Use FilePicker for user to choose location
          final String? selectedDirectory = await FilePicker.platform.getDirectoryPath();
          if (selectedDirectory == null) {
            return AppStrings.userCancelled.tr;
          }

          final filePath = '$selectedDirectory/$filename.pdf';
          final file = File(filePath);
          await file.writeAsBytes(binaryData);
          return AppStrings.fileSavedSuccess.tr;
        } else {
          // Use FileSaver for quick save
          final path = await FileSaver.instance.saveAs(
            name: filename,
            bytes: binaryData,
            fileExtension: 'pdf',
            mimeType: MimeType.pdf,
          );
          return path != null ? AppStrings.fileSavedSuccess.tr : AppStrings.fileSaveError.tr;
        }
      }
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

      if (!context.mounted) return false;

      final shouldRequest = await showDialog<bool>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: Text(AppStrings.storagePermissionTitle.tr),
          content: Text(AppStrings.storagePermissionMessage.tr),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              style: TextButton.styleFrom(foregroundColor: AppColors.lightCoral),
              child: Text(AppStrings.cancel.tr),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: TextButton.styleFrom(foregroundColor: AppColors.lightCoral),
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
